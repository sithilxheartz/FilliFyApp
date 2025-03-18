import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductDetails(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${product['productName']}", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("Price: ${product['price'] ?? 'N/A'}", style: TextStyle(fontSize: 18)),
            Text("Stock: ${product['stockQuantity']}", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
