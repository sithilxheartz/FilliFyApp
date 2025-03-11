import 'package:flutter/material.dart';

class AddNewProduct extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController specifyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Product", style: TextStyle(color: Colors.white)),
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
              controller: priceController,
              decoration: InputDecoration(labelText: "Price"),
            ),
            TextField(
              controller: brandController,
              decoration: InputDecoration(labelText: "Brand"),
            ),
            TextField(
              controller: sizeController,
              decoration: InputDecoration(labelText: "Size"),
            ),
            TextField(
              controller: stockController,
              decoration: InputDecoration(labelText: "Stock"),
            ),
            TextField(
              controller: specifyController,
              decoration: InputDecoration(labelText: "Specify For"),
            ),
            SizedBox(height: 30),
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
                Navigator.pop(context, {
                  "name": nameController.text,
                  "price": priceController.text,
                  "brand": brandController.text,
                  "size": sizeController.text,
                  "stock": stockController.text,
                  "specify": specifyController.text,
                });
              },
              child: Text(
                "Submit",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
