import 'package:flutter/material.dart';

class UpdateStockPage extends StatelessWidget {
  final Function(int, String) updateStock;
  final int productId;

  UpdateStockPage({required this.updateStock, required this.productId});

  final TextEditingController stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Product Stock", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: EdgeInsets.all(11.0),
        child: Column(
          children: [
            TextField(
              controller: stockController,
              decoration: InputDecoration(labelText: "New Stock"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 13, horizontal: 90),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 4,
              ),
              onPressed: () {
                String newStock = stockController.text;
                if (newStock.isNotEmpty) {
                  updateStock(productId, newStock);
                  Navigator.pop(context);
                }
              },
              child: Text("Update Stock", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
