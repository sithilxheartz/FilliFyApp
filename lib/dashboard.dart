import 'package:flutter/material.dart';
import 'main.dart';
import 'shiftsViewPage.dart';
import 'managementMenu.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _buildMenuItem(
              context,
              Icons.oil_barrel_rounded,
              "Oil Shop",
              SalesPage(),
            ),
            _buildMenuItem(
              context,
              Icons.local_gas_station,
              "Fuel Stock",
              FuelStockPage(),
            ),
            _buildMenuItem(
              context,
              Icons.timelapse,
              "Shifts",
              ShiftSchedulePage(),
            ),
            _buildMenuItem(
              context,
              Icons.settings,
              "Management",
              ManagementMenu(),
            ),
            _buildMenuItem(context, Icons.bar_chart, "Reports", ReportsPage()),
            _buildMenuItem(context, Icons.shopping_cart, "Sales", SalesPage()),

            _buildMenuItem(context, Icons.people, "Employees", EmployeePage()),

            _buildMenuItem(context, Icons.logout, "Logout", LoginPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String label,
    Widget page,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.blue.shade900),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------- FUEL STOCK PAGE ---------------------
class FuelStockPage extends StatelessWidget {
  const FuelStockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPage(context, "Fuel Stock");
  }
}

// --------------------- SALES PAGE ---------------------
class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPage(context, "Sales");
  }
}

// --------------------- REPORTS PAGE ---------------------
class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPage(context, "Reports");
  }
}

// --------------------- EMPLOYEE MANAGEMENT PAGE ---------------------
class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final _formKey = GlobalKey<FormState>();

  String name = "";
  String position = "";
  String contact = "";
  String salary = "";

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      print("New Employee Added:");
      print("Name: $name");
      print("Position: $position");
      print("Contact: $contact");
      print("Salary: $salary");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Employee Added Successfully!")));

      // You can replace this with code to save data in a database.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Employee"),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                "Employee Name",
                Icons.person,
                (value) => name = value!,
              ),
              SizedBox(height: 15),
              _buildTextField(
                "Position",
                Icons.work,
                (value) => position = value!,
              ),
              SizedBox(height: 15),
              _buildTextField(
                "Contact Number",
                Icons.phone,
                (value) => contact = value!,
              ),
              SizedBox(height: 15),
              _buildTextField(
                "Salary",
                Icons.monetization_on,
                (value) => salary = value!,
                isNumber: true,
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    IconData icon,
    Function(String?) onSaved, {
    bool isNumber = false,
  }) {
    return TextFormField(
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blue.shade900),
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.blue.shade50,
      ),
      validator: (value) => value!.isEmpty ? "This field is required" : null,
      onSaved: onSaved,
    );
  }
}

// --------------------- SETTINGS PAGE ---------------------
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPage(context, "Settings");
  }
}

// --------------------- GENERIC PAGE TEMPLATE ---------------------
Widget _buildPage(BuildContext context, String title) {
  return Scaffold(
    appBar: AppBar(title: Text(title), backgroundColor: Colors.blue.shade900),
    body: Center(
      child: Text(
        "Welcome to $title Page",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
