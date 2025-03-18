import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddNewProduct extends StatefulWidget {
  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  Future<void> _addProduct() async {
    String name = nameController.text.trim();
    String stock = stockController.text.trim();
    String price = priceController.text.trim();

    if (name.isEmpty || stock.isEmpty || price.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required")));
      return;
    }

    try {
      var response = await http.post(
        Uri.parse("http://10.0.2.2:5000/inventory"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "productName": name,
          "stockQuantity": int.parse(stock),
          "price": double.parse(price),
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product added successfully!")));

        // Send `true` when navigating back
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to add product")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Product"), backgroundColor: Colors.blue.shade900),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Product Name")),
            TextField(controller: stockController, decoration: InputDecoration(labelText: "Stock Quantity"), keyboardType: TextInputType.number),
            TextField(controller: priceController, decoration: InputDecoration(labelText: "Price"), keyboardType: TextInputType.number),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addProduct,
              child: Text("Add Product"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade900, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
