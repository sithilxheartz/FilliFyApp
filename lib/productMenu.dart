import 'package:flutter/material.dart';
import 'ProductDetails.dart';



class ProductMenu extends StatelessWidget {
  final List<Map<String, String>> products;

  ProductMenu({required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Menu", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade900,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: Icon(
                  Icons.oil_barrel_rounded,
                  color: Colors.blue.shade900,
                  size: 28,
                ),
                title: Text(
                  products[index]['name']!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                subtitle: Text(
                  "Price: ${products[index]['price']!}",
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue.shade900,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetails(products[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
