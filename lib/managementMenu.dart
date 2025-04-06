import 'package:fillifyapp/UserRoleManagement.dart';
import 'package:fillifyapp/fuelStockCalibrate.dart';
import 'package:flutter/material.dart';
import 'EmployeePage.dart';
import 'assignShifts.dart';
import 'addfuelstock.dart';
import 'shiftRequestPage.dart';

class ManagementMenu extends StatelessWidget {
  const ManagementMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Management Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Correct back navigation
          },
        ),
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
              Icons.people,
              "Add Pumpers",
              EmployeePage(),
            ),
            _buildMenuItem(
              context,
              Icons.assignment,
              "Assign Shifts",
              AssignShiftPage(),
            ),
            _buildMenuItem(
              context,
              Icons.add,
              "Add Fuel Stock",
              AddFuelStockPage(),
            ),
            _buildMenuItem(
              context,
              Icons.compass_calibration,
              "Calibrate Fuel Stock",
              fuelStockCalibratePage(),
            ),
            _buildMenuItem(
              context,
              Icons.admin_panel_settings,
              "Manage Users",
              UserRoleManagement(),
            ),
            _buildMenuItem(
              context,
              Icons.manage_accounts,
              "req shift",
              RequestShiftChangePage(),
            ),
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
