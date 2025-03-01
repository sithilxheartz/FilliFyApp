import 'package:flutter/material.dart';
import 'main.dart';
import 'shiftsViewPage.dart';
import 'managementMenu.dart';
import 'fuelStockPage.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard", style: TextStyle(color: Colors.white)),
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
              FuelStock(),
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
