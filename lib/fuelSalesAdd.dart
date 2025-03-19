import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddSalesPage extends StatefulWidget {
  final Function(List<double>) updateFuelLevels;
  final List<double> fuelLevels;
  final double tankCapacity;

  AddSalesPage(this.updateFuelLevels, this.fuelLevels, this.tankCapacity);

  @override
  _AddSalesPageState createState() => _AddSalesPageState();
}

class _AddSalesPageState extends State<AddSalesPage> {
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      widget.fuelLevels.length,
          (index) => TextEditingController(text: "0"),
    );
  }

  void updateStock() async {
    List<double> newLevels = List.generate(widget.fuelLevels.length, (index) {
      double removedFuel = double.tryParse(controllers[index].text) ?? 0.0;
      return ((widget.fuelLevels[index] * widget.tankCapacity - removedFuel) /
          widget.tankCapacity)
          .clamp(0.0, 1.0);
    });

    List<double> salesData = List.generate(widget.fuelLevels.length, (index) {
      return double.tryParse(controllers[index].text) ?? 0.0;
    });

    // Send the sales data to the backend for updating the database
    try {
      var response = await http.post(
        Uri.parse("http://10.0.2.2:5000/update-fuel-stock"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"sales": salesData}),
      );

      if (response.statusCode == 200) {
        // If the server responds successfully, update the local fuel levels
        widget.updateFuelLevels(newLevels);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Fuel stock updated!")));
      } else {
        // If the server responds with something other than 200
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update stock. Server error.")));
      }
    } catch (e) {
      // Handle any error, such as network issues or exceptions
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Fuel Sales", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.fuelLevels.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.blue.shade900, width: 1),
                    ),
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tank ${index + 1}:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 5),
                          TextField(
                            controller: controllers[index],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade300,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: updateStock, // Trigger updateStock when the button is pressed
                child: Text("Add Sales"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
