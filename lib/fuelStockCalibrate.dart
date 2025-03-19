import 'package:flutter/material.dart';

class fuelStockCalibratePage extends StatefulWidget {
  @override
  _fuelStockCalibratePageState createState() => _fuelStockCalibratePageState();
}

class _fuelStockCalibratePageState extends State<fuelStockCalibratePage> {
  final TextEditingController _calibrateController = TextEditingController();

  void calibrateFuel() {

    double calibrationValue = double.tryParse(_calibrateController.text) ?? 0.0;

    if (calibrationValue > 0) {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Fuel stock calibrated!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid calibration value.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calibrate Fuel Stock", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _calibrateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Calibration Value',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calibrateFuel,
              child: Text("Calibrate Fuel Stock"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900, // Correct way to set background color
                foregroundColor: Colors.white, // Correct way to set text/icon color
              ),
            )
          ],
        ),
      ),
    );
  }
}
