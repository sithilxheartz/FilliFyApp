require("dotenv").config();
const express = require("express");
const mysql = require("mysql2");
const cors = require("cors");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

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

// Add New Product to Inventory
app.post("/inventory", (req, res) => {
  const { productName, stockQuantity, speedType } = req.body;
  db.query(
    "INSERT INTO Inventory (productName, stockQuantity, speedType) VALUES (?, ?, ?)",
    [productName, stockQuantity, speedType],
    (err, result) => {
      if (err) return res.status(500).json({ message: "Error adding product" });
      res.json({ message: "Product added successfully" });
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

// ==================== SERVER LISTENING ====================
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
