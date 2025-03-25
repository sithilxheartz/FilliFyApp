import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddFuelStockPage extends StatefulWidget {
  @override
  _AddFuelStockPageState createState() => _AddFuelStockPageState();
}

class _AddFuelStockPageState extends State<AddFuelStockPage> {
  final TextEditingController litersController = TextEditingController();
  String selectedFuelType = "Auto Diesel";
  bool isLoading = false;

  List<String> fuelTypes = [
    "Auto Diesel",
    "Super Diesel",
    "Octane 92 Petrol",
    "Octane 95 Petrol"
  ];

  Future<void> _addFuelStock() async {
    if (litersController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter liters")));
      return;
    }

    double liters = double.tryParse(litersController.text) ?? 0;
    if (liters <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid liters amount")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:5000/add-fuel-stock"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"fuelType": selectedFuelType, "newLiters": liters}),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Fuel stock added successfully on ${data['date']}")),
        );
        litersController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data["message"])));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error adding fuel stock: $e")));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Fuel Stock", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Fuel Type", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedFuelType,
              items: fuelTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedFuelType = value!;
                });
              },
            ),
            SizedBox(height: 20),
            Text("Enter Liters", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: litersController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Liters",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : _addFuelStock,
              child: isLoading ? CircularProgressIndicator() : Text("Add Stock"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
