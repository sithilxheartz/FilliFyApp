require("dotenv").config();
const express = require("express");
const mysql = require("mysql2");
const cors = require("cors");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const fs = require("fs");
const { Parser } = require("json2csv");

const app = express();
const PORT = process.env.PORT || 5000;

app.use(express.json());
app.use(cors());

// Database Connection
const db = mysql.createConnection({
  host: process.env.DB_HOST || "localhost",
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASS || "",
  database: process.env.DB_NAME || "FillingStationDB",
});

db.connect((err) => {
  if (err) {
    console.error("Database connection failed:", err);
  } else {
    console.log("Connected to MySQL database");
  }
});

// Secret Key for JWT
const SECRET_KEY = "fillify";


// ==================== USER AUTHENTICATION ====================

// Register User
app.post("/register", async (req, res) => {
  const { name, email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: "All fields are required" });
  }

  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    db.query(
      "INSERT INTO Users (name, email, password) VALUES (?, ?, ?)",
      [name, email, hashedPassword],
      (err, result) => {
        if (err) {
          return res.status(500).json({ message: "User already exists" });
        }
        res.status(201).json({ message: "User registered successfully" });
      }
    );
  } catch (error) {
    res.status(500).json({ message: "Error registering user" });
  }
});

// User Login
app.post("/login", (req, res) => {
  const { email, password } = req.body;

  db.query("SELECT * FROM Users WHERE email = ?", [email], async (err, results) => {
    if (err || results.length === 0) {
      return res.status(401).json({ message: "User not found" });
    }

    const user = results[0];
    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    // Generate JWT token including role
    const token = jwt.sign(
      { id: user.userID, email: user.email, role: user.role }, 
      SECRET_KEY, 
      { expiresIn: "1h" }
    );

    res.json({ message: "Login successful", token, role: user.role });
  });
});


// Get User Profile (Protected)
app.get("/profile", (req, res) => {
  const token = req.headers.authorization?.split(" ")[1];

  if (!token) {
    return res.status(401).json({ message: "Unauthorized" });
  }

  jwt.verify(token, SECRET_KEY, (err, decoded) => {
    if (err) {
      return res.status(403).json({ message: "Invalid token" });
    }
    db.query("SELECT name, email FROM Users WHERE userID = ?", [decoded.id], (err, result) => {
      if (err || result.length === 0) {
        return res.status(404).json({ message: "User not found" });
      }
      res.json({ message: "Profile fetched", user: result[0] });
    });
  });
});

// ==================== CRUD OPERATIONS ====================

// Get All Inventory
app.get("/inventory", (req, res) => {
  db.query("SELECT * FROM Inventory", (err, result) => {
    if (err) return res.status(500).json({ message: "Error fetching inventory" });
    res.json(result);
  });
});
//get fuel stock data
app.get("/fuel-stock", (req, res) => {
  const { date } = req.query;  // Get date from query parameter (optional)

  let query = `
    SELECT a.date, t.tankID, t.fueltype, t.capacity, 
           COALESCE(a.liters_in_tank_1, 0) AS liters_in_tank_1,
           COALESCE(a.liters_in_tank_2, 0) AS liters_in_tank_2,
           COALESCE(a.liters_in_tank_3, 0) AS liters_in_tank_3,
           COALESCE(a.liters_in_tank_4, 0) AS liters_in_tank_4,
           COALESCE(a.liters_in_tank_5, 0) AS liters_in_tank_5,
           COALESCE(a.liters_in_tank_6, 0) AS liters_in_tank_6
    FROM fueltank t 
    LEFT JOIN (
      SELECT * FROM fuelavailability 
      WHERE ${date ? `DATE(date) = '${date}'` : `1=1`}
      ORDER BY date DESC LIMIT 1
    ) a 
    ON 1=1
  `;

  db.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ message: "Error fetching fuel stock", error: err });
    }

    if (results.length === 0 || !results[0].date) {
      // Fetch the LATEST available fuel data instead
      db.query(`
        SELECT a.date, t.tankID, t.fueltype, t.capacity, 
               COALESCE(a.liters_in_tank_1, 0) AS liters_in_tank_1,
               COALESCE(a.liters_in_tank_2, 0) AS liters_in_tank_2,
               COALESCE(a.liters_in_tank_3, 0) AS liters_in_tank_3,
               COALESCE(a.liters_in_tank_4, 0) AS liters_in_tank_4,
               COALESCE(a.liters_in_tank_5, 0) AS liters_in_tank_5,
               COALESCE(a.liters_in_tank_6, 0) AS liters_in_tank_6
        FROM fueltank t 
        LEFT JOIN (SELECT * FROM fuelavailability ORDER BY date DESC LIMIT 1) a 
        ON 1=1
      `, (err, latestResults) => {
        if (err) {
          return res.status(500).json({ message: "Error fetching latest fuel stock", error: err });
        }

        if (latestResults.length === 0) {
          return res.json({ message: "No fuel data available" });
        }

        const latestDate = latestResults[0].date;  // Store the latest date
        const latestFuelStock = latestResults.map((row, index) => ({
          date: latestDate,
          tankID: row.tankID,
          fuelType: row.fueltype,
          capacity: row.capacity,
          availableLiters: row[`liters_in_tank_${index + 1}`] || 0,  // Default to 0 if no fuel data
        }));

        res.json(latestFuelStock);
      });
    } else {
      // Return the originally fetched data
      const dateAvailable = results[0].date;  // Get the latest date from DB
      const fuelStock = results.map((row, index) => ({
        date: dateAvailable,
        tankID: row.tankID,
        fuelType: row.fueltype,
        capacity: row.capacity,
        availableLiters: row[`liters_in_tank_${index + 1}`] || 0,  // Default to 0 if no fuel data
      }));

      res.json(fuelStock);
    }
  });
});

// update fuel stocks
app.post("/update-fuel-stock", (req, res) => {
  const { sales } = req.body; // Expecting an array of sales per tank

  if (!sales || !Array.isArray(sales)) {
    return res.status(400).json({ message: "Invalid sales data" });
  }

  const updateQueries = sales.map((sale, index) => {
    return new Promise((resolve, reject) => {
      db.query(
        `UPDATE fuelavailability 
         SET liters_in_tank_${index + 1} = GREATEST(liters_in_tank_${index + 1} - ?, 0)
         ORDER BY stockID DESC LIMIT 1`,
        [sale],
        (err, result) => {
          if (err) reject(err);
          else resolve(result);
        }
      );
    });
  });

  Promise.all(updateQueries)
    .then(() => res.json({ message: "Fuel stock updated successfully" }))
    .catch((err) => res.status(500).json({ message: "Error updating fuel stock", error: err }));
});



// Add New Product to Inventory
app.post("/inventory", (req, res) => {
  const { productName, stockQuantity, price } = req.body;
  db.query(
    "INSERT INTO Inventory (productName, stockQuantity, price) VALUES (?, ?, ?)",
    [productName, stockQuantity, price],
    (err, result) => {
      if (err) return res.status(500).json({ message: "Error adding product" });
      res.status(201).json({ message: "Product added successfully", id: result.insertId });
    }
  );
});

// Update Inventory
app.put("/inventory/:id", (req, res) => {
  const { stockQuantity } = req.body;
  db.query(
    "UPDATE Inventory SET stockQuantity = ? WHERE productID = ?",
    [stockQuantity, req.params.id],
    (err, result) => {
      if (err) return res.status(500).json({ message: "Error updating inventory" });
      res.json({ message: "Inventory updated successfully" });
    }
  );
});

// Delete Inventory Item
app.delete("/inventory/:id", (req, res) => {
  db.query("DELETE FROM Inventory WHERE productID = ?", [req.params.id], (err, result) => {
    if (err) return res.status(500).json({ message: "Error deleting inventory item" });
    res.json({ message: "Inventory item deleted successfully" });
  });
});

//update shifts
app.post("/update-shift", (req, res) => {
  const { shiftID, nightShift, shiftType } = req.body;

  if (!shiftID || !shiftType) {
    return res.status(400).json({ message: "Missing shift details" });
  }

  db.query(
    "UPDATE shift SET nightShift = ?, shiftType = ? WHERE shiftID = ?",
    [nightShift, shiftType, shiftID],
    (err, result) => {
      if (err) {
        return res.status(500).json({ message: "Error updating shift", error: err });
      }
      res.json({ message: "Shift updated successfully" });
    }
  );
});

//add shift history
app.post("/add-shift-history", (req, res) => {
  const { date, dayShift, nightShift } = req.body;

  if (!date || !dayShift || !nightShift) {
    return res.status(400).json({ message: "Missing shift history details" });
  }

  db.query(
    `INSERT INTO shifthistory (date, day_pumper_pump_1, day_pumper_pump_2, day_pumper_pump_3, day_pumper_pump_4, night_pumper_pump_1, night_pumper_pump_2) 
     VALUES (?, ?, ?, ?, ?, ?, ?)`,
    [date, dayShift[0], dayShift[1], dayShift[2], dayShift[3], nightShift[0], nightShift[1]],
    (err, result) => {
      if (err) {
        return res.status(500).json({ message: "Error adding shift history", error: err });
      }
      res.json({ message: "Shift history added successfully" });
    }
  );
});

//shift change requests
app.post("/request-shift-change", (req, res) => {
  const { shiftID, fuelStockID } = req.body;

  if (!shiftID || !fuelStockID) {
    return res.status(400).json({ message: "Missing request details" });
  }

  db.query(
    "INSERT INTO request (shiftID, fuelStockID) VALUES (?, ?)",
    [shiftID, fuelStockID],
    (err, result) => {
      if (err) {
        return res.status(500).json({ message: "Error creating shift change request", error: err });
      }
      res.json({ message: "Shift change request submitted successfully" });
    }
  );
});

//add employee
app.post("/add-employee", (req, res) => {
  const { name, position, contactNumber, salary } = req.body;

  if (!name || !position || !contactNumber || !salary) {
    return res.status(400).json({ message: "All fields are required" });
  }

  db.query(
    "INSERT INTO employee (name, position, contactNumber, salary) VALUES (?, ?, ?, ?)",
    [name, position, contactNumber, salary],
    (err, result) => {
      if (err) {
        return res.status(500).json({ message: "Error adding employee", error: err });
      }
      res.json({ message: "Employee added successfully", employeeID: result.insertId });
    }
  );
});

//get employee
app.get("/get-employees", (req, res) => {
  db.query("SELECT * FROM employee", (err, result) => {
    if (err) {
      return res.status(500).json({ message: "Error fetching employees", error: err });
    }
    res.json(result);
  });
});

//assign shifts
app.post("/assign-shift", (req, res) => {
  const { date, employeeID, shiftType, nightShift, pumpNumber } = req.body;

  if (!date || !employeeID || !shiftType || nightShift === undefined || !pumpNumber) {
    return res.status(400).json({ message: "All fields are required" });
  }

  const query1 = `
    INSERT INTO shift (date, shiftType, nightShift, employeeID, pumpNumber)
    VALUES (?, ?, ?, ?, ?)
  `;

  db.query(query1, [date, shiftType, nightShift, employeeID, pumpNumber], (err, result) => {
    if (err) {
      return res.status(500).json({ message: "Error assigning shift", error: err });
    }

    const shiftID = result.insertId; // Get the shift ID

    const query2 = `
      INSERT INTO shifthistory (shiftID, date, employeeID, pumpNumber, shiftType, nightShift)
      VALUES (?, ?, ?, ?, ?, ?)
    `;

    db.query(query2, [shiftID, date, employeeID, pumpNumber, shiftType, nightShift], (err) => {
      if (err) {
        return res.status(500).json({ message: "Error updating shift history", error: err });
      }
      res.status(201).json({ message: "Shift assigned successfully & history updated" });
    });
  });
});



//get assigned shifts
app.get("/get-shifts-by-date", (req, res) => {
  const { date } = req.query;

  if (!date) {
    return res.status(400).json({ message: "Date is required" });
  }

  const query = `
    SELECT s.date, s.shiftType, s.nightShift, s.pumpNumber, e.name AS employeeName
    FROM shift s
    LEFT JOIN employee e ON s.employeeID = e.employeeID
    WHERE s.date = ?
    ORDER BY s.nightShift ASC, s.pumpNumber ASC;
  `;

  db.query(query, [date], (err, result) => {
    if (err) {
      return res.status(500).json({ message: "Error fetching shifts", error: err });
    }
    res.json(result);
  });
});

//add fuelstock
app.post("/add-fuel-stock", async (req, res) => {
  const { fuelType, newLiters } = req.body; // Receive fuel type and amount
  const currentDate = new Date().toISOString().slice(0, 19).replace("T", " "); // Format: YYYY-MM-DD HH:MM:SS

  if (!fuelType || newLiters === undefined) {
      return res.status(400).json({ message: "Fuel type and liters are required" });
  }

  try {
      // Fetch latest fuel availability entry
      db.query(
          "SELECT * FROM fuelavailability ORDER BY date DESC LIMIT 1",
          async (err, fuelAvailability) => {
              if (err) return res.status(500).json({ message: "Error fetching fuel availability", error: err });

              // Initialize new stock record
              let newStockEntry = {
                  date: currentDate,
                  liters_in_tank_1: 0,
                  liters_in_tank_2: 0,
                  liters_in_tank_3: 0,
                  liters_in_tank_4: 0,
                  liters_in_tank_5: 0,
                  liters_in_tank_6: 0,
              };

              if (fuelAvailability.length > 0) {
                  newStockEntry = { ...fuelAvailability[0] }; // Copy previous values
                  delete newStockEntry.stockID; // Remove stockID for insertion
                  newStockEntry.date = currentDate;
              }

              // Fetch tank details
              db.query(
                  "SELECT * FROM fueltank WHERE fueltype = ?",
                  [fuelType],
                  async (err, tanks) => {
                      if (err) return res.status(500).json({ message: "Error fetching tanks", error: err });

                      if (tanks.length === 0) {
                          return res.status(404).json({ message: "No tanks found for this fuel type" });
                      }

                      let remainingLiters = newLiters;

                      for (let i = 0; i < tanks.length; i++) {
                          let tank = tanks[i];
                          let tankIndex = `liters_in_tank_${tank.tankID}`; // Column name
                          let currentLiters = newStockEntry[tankIndex] || 0;
                          let maxCapacity = tank.capacity;
                          let availableSpace = maxCapacity - currentLiters;

                          if (remainingLiters > 0) {
                              let litersToAdd = Math.min(remainingLiters, availableSpace);
                              remainingLiters -= litersToAdd;
                              newStockEntry[tankIndex] += litersToAdd;
                          }
                      }

                      // Insert new row into fuelavailability
                      db.query(
                          "INSERT INTO fuelavailability SET ?",
                          newStockEntry,
                          (err, result) => {
                              if (err) return res.status(500).json({ message: "Error updating fuel availability", error: err });

                              // Insert into fuelstock table
                              db.query(
                                  "INSERT INTO fuelstock (fuelType, quantity) VALUES (?, ?)",
                                  [fuelType, newLiters - remainingLiters], // Only the added liters
                                  (err, result) => {
                                      if (err) return res.status(500).json({ message: "Error inserting into fuelstock", error: err });
                                      return res.json({ message: "Fuel stock added successfully", date: currentDate });
                                  }
                              );
                          }
                      );
                  }
              );
          }
      );
  } catch (error) {
      return res.status(500).json({ message: "Server error", error });
  }
});

// Get All Users
app.get("/users", (req, res) => {
  db.query("SELECT userID, name, email, role FROM users", (err, result) => {
    if (err) return res.status(500).json({ message: "Error fetching users", error: err });
    res.json(result);
  });
});

// Update User Role
app.put("/users/:id/role", (req, res) => {
  const { role } = req.body;
  const { id } = req.params;

  if (!role || (role !== "admin" && role !== "user")) {
    return res.status(400).json({ message: "Invalid role" });
  }

  db.query("UPDATE users SET role = ? WHERE userID = ?", [role, id], (err, result) => {
    if (err) return res.status(500).json({ message: "Error updating role", error: err });
    res.json({ message: "User role updated successfully" });
  });
});

// Generate Sales Report (CSV)
app.get("/reports/sales", (req, res) => {
  db.query("SELECT * FROM orders", (err, results) => {
    if (err) return res.status(500).json({ message: "Error fetching sales data" });

    const fields = ["orderID", "userID", "totalAmount", "paymentID"];
    const json2csvParser = new Parser({ fields });
    const csv = json2csvParser.parse(results);

    fs.writeFileSync("sales_report.csv", csv);
    res.download("sales_report.csv");
  });
});

// Generate Fuel Stock Report (CSV)
app.get("/reports/fuelstock", (req, res) => {
  db.query("SELECT * FROM fuelavailability", (err, results) => {
    if (err) return res.status(500).json({ message: "Error fetching fuel stock data" });

    const fields = ["stockID", "date", "liters_in_tank_1", "liters_in_tank_2", "liters_in_tank_3", "liters_in_tank_4", "liters_in_tank_5", "liters_in_tank_6"];
    const json2csvParser = new Parser({ fields })
    const csv = json2csvParser.parse(results);

    fs.writeFileSync("fuel_stock_report.csv", csv);
    res.download("fuel_stock_report.csv");
  });
});

// Generate Employee Work Hours Report (CSV)
app.get("/reports/employees", (req, res) => {
  db.query("SELECT * FROM shifthistory", (err, results) => {
    if (err) return res.status(500).json({ message: "Error fetching employee work data" });

    const fields = ["shiftID", "date", "day_pumper_pump_1", "day_pumper_pump_2"];
    const json2csvParser = new Parser({ fields });
    const csv = json2csvParser.parse(results);

    fs.writeFileSync("employee_report.csv", csv);
    res.download("employee_report.csv");
  });
});



// ==================== SERVER LISTENING ====================
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
