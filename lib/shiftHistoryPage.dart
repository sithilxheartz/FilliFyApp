import 'package:flutter/material.dart';

class ShiftHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildPage(context, "Shift History");
  }
}

// --------------------- GENERIC PAGE TEMPLATE ---------------------
Widget _buildPage(BuildContext context, String title) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Shift History", style: TextStyle(color: Colors.white)),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context); // Navigate back to the previous screen
        },
      ),
      backgroundColor: Colors.blue.shade900,
    ),
    body: Center(
      child: Text(
        "Unavailable $title",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
