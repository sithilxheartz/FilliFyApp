import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Add http package
import 'dart:convert'; // To parse the response
import 'main.dart'; // Import LoginPage
import 'shiftsViewPage.dart'; // ShiftSchedulePage
import 'managementMenu.dart'; // ManagementMenu
import 'fuelStockPage.dart'; // FuelStock

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  // Function to fetch user profile from backend
  Future<void> _fetchUserProfile() async {
    final token =
        await _getTokenFromStorage(); // Replace with your method to get the token

    if (token != null) {
      final response = await http.get(
        Uri.parse(
          'http://10.16.142.141:5000/profile',
        ), // Change to your API URL
        headers: {
          'Authorization': 'Bearer $token', // Include the JWT token in header
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userName = data['user']['email']; // Adjust based on your API response
          userEmail =
              data['user']['email']; // Adjust based on your API response
        });
      } else {
        // Handle failure
        print('Failed to fetch user profile');
      }
    }
  }

  // Dummy method to get the token. Replace with your actual method.
  Future<String?> _getTokenFromStorage() async {
    // For example, using SharedPreferences, SecureStorage, etc.
    // Here we return a dummy token for illustration purposes.
    return 'your-jwt-token';
  }

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
        child: Column(
          children: [
            // Displaying user profile if available
            if (userName != null && userEmail != null)
              Column(
                children: [
                  Text(
                    'Welcome, $userName!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Email: $userEmail',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            // Grid of menu items
            Expanded(
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
                  _buildMenuItem(
                    context,
                    Icons.bar_chart,
                    "Reports",
                    ReportsPage(),
                  ),
                  _buildMenuItem(context, Icons.logout, "Logout", LoginPage()),
                ],
              ),
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
