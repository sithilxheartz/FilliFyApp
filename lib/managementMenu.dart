import 'package:flutter/material.dart';

class ManagementMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Management Dashboard"),
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
            _buildMenuItem(context, Icons.list, "Products", ManagementPage()),
            _buildMenuItem(
              context,
              Icons.local_gas_station,
              "Stocks",
              ManagementPage(),
            ),
            _buildMenuItem(
              context,
              Icons.timelapse,
              "Shifts",
              ManagementPage(),
            ),
            _buildMenuItem(context, Icons.people, "Pumpers", ManagementPage()),
            _buildMenuItem(
              context,
              Icons.bar_chart,
              "Requests",
              ManagementPage(),
            ),
            _buildMenuItem(
              context,
              Icons.shopping_cart,
              "Orders",
              ManagementPage(),
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

class ManagementPage extends StatelessWidget {
  const ManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPage(context, "Management");
  }
}

Widget _buildPage(BuildContext context, String title) {
  return Scaffold(
    appBar: AppBar(title: Text(title), backgroundColor: Colors.black),
    body: Center(
      child: Text(
        "Welcome to $title",
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ),
  );
}
