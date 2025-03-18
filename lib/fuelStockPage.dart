import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dashboard.dart';
import 'package:intl/intl.dart';  // For formatting dates

class FuelStock extends StatefulWidget {
  @override
  _FuelStockState createState() => _FuelStockState();
}

class _FuelStockState extends State<FuelStock> {
  List<Map<String, dynamic>> fuelData = [];
  bool isLoading = true;
  DateTime selectedDate = DateTime.now();  // Default to today
  String? lastUpdatedDate;  // Stores the latest available date from API

  @override
  void initState() {
    super.initState();
    _fetchFuelStock();
  }

  Future<void> _fetchFuelStock({DateTime? date}) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date ?? selectedDate);
    print("Fetching data for: $formattedDate");  // Debugging

    try {
      var response = await http.get(Uri.parse("http://10.0.2.2:5000/fuel-stock?date=$formattedDate"));
      print("API Response: ${response.body}");  // Debugging

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        if (data.isEmpty || data[0].containsKey("message")) {
          print("No fuel data available for $formattedDate. Fetching latest data.");
          _fetchFuelStock(date: null);  // Fetch latest available data
          return;
        }

        List<Map<String, dynamic>> updatedFuelData = data.map((tank) {
          double percentage = (tank["availableLiters"] / tank["capacity"]).clamp(0.0, 1.0);
          return {
            "tankID": tank["tankID"],
            "fuelType": tank["fuelType"],
            "capacity": tank["capacity"],
            "fuelLevel": percentage,
          };
        }).toList();

        setState(() {
          fuelData = updatedFuelData;
          lastUpdatedDate = data[0]["date"];
          isLoading = false;
        });

      } else {
        throw Exception("Failed to load fuel stock");
      }
    } catch (e) {
      print("Error fetching fuel stock: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        isLoading = true;
      });
      _fetchFuelStock(date: picked);
    }
  }

  Widget _buildFuelCard(Map<String, dynamic> tank) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.teal.shade300, width: 1),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tank ${tank["tankID"]} (${tank["fuelType"]})",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Stack(
              children: [
                Container(height: 20, color: Colors.grey.shade300),
                FractionallySizedBox(
                  widthFactor: tank["fuelLevel"],
                  child: Container(height: 20, color: tank["fuelLevel"] > 0 ? Colors.green : Colors.red),
                ),
              ],
            ),
            Text(
              "${(tank["fuelLevel"] * 100).toStringAsFixed(1)}%  (Capacity: ${tank["capacity"]} L)",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fuel Stock", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade900,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardPage()));
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Data for: ${DateFormat('yyyy-MM-dd').format(selectedDate)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            lastUpdatedDate != null
                ? Text(
              "Last Updated: $lastUpdatedDate",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            )
                : SizedBox.shrink(),
            const SizedBox(height: 10),
            Expanded(
              child: fuelData.isEmpty
                  ? Center(
                child: Text(
                  "No fuel data found for the selected date.\nShowing latest available data.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
                  : ListView.builder(
                itemCount: fuelData.length,
                itemBuilder: (context, index) {
                  return _buildFuelCard(fuelData[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
