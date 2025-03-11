import 'package:flutter/material.dart';

class UpdateStockPage extends StatelessWidget {
  final Function(String, String) updateStock;

  UpdateStockPage({required this.updateStock});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Product Stock",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(11.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Product Name"),
            ),
            TextField(
              controller: stockController,
              decoration: InputDecoration(labelText: "New Stock"),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900, // Match theme color
                foregroundColor: Colors.white, // Text color
                padding: EdgeInsets.symmetric(
                  vertical: 13,
                  horizontal: 90,
                ), // Increase touch area
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
                elevation: 4, // Slight shadow for depth
              ),
              onPressed: () {
                updateStock(nameController.text, stockController.text);
                Navigator.pop(context);
              },
              child: Text(
                "Update Stock",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
