import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  final Map<String, String> product;

  ProductDetails(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${product['name']}", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("Price: ${product['price']}", style: TextStyle(fontSize: 18)),
            Text("Brand: ${product['brand']}", style: TextStyle(fontSize: 18)),
            Text("Size: ${product['size']}", style: TextStyle(fontSize: 18)),
            Text("Stock: ${product['stock']}", style: TextStyle(fontSize: 18)),
            Text("Usage: ${product['specify']}", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
