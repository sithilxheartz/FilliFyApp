import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateShiftPage extends StatefulWidget {
  final DateTime selectedDate;
  final Map<String, List<String>> shiftData;

  const UpdateShiftPage({super.key, required this.selectedDate, required this.shiftData});

  @override
  _UpdateShiftPageState createState() => _UpdateShiftPageState();
}

class _UpdateShiftPageState extends State<UpdateShiftPage> {
  late DateTime newDate;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController dayShiftPump1Controller = TextEditingController();
  final TextEditingController dayShiftPump2Controller = TextEditingController();
  final TextEditingController dayShiftPump3Controller = TextEditingController();
  final TextEditingController dayShiftPump4Controller = TextEditingController();
  final TextEditingController nightShiftPump1Controller = TextEditingController();
  final TextEditingController nightShiftPump3Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    newDate = widget.selectedDate;
    dateController.text = "${newDate.year}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}";
  }

  Future<void> _updateShiftInDatabase() async {
    Map<String, dynamic> shiftData = {
      "date": dateController.text,
      "dayShift": [
        dayShiftPump1Controller.text,
        dayShiftPump2Controller.text,
        dayShiftPump3Controller.text,
        dayShiftPump4Controller.text
      ],
      "nightShift": [
        nightShiftPump1Controller.text,
        nightShiftPump3Controller.text
      ]
    };

    try {
      var response = await http.post(
        Uri.parse("http://10.0.2.2:5000/add-shift-history"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(shiftData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Shift history updated successfully!")),
        );
        Navigator.pop(context, {"date": newDate, "shifts": shiftData});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update shift history")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Shift", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blue.shade900,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Date", dateController),
            _buildShiftLabel("Day Shift"),
            _buildTextField("Pump 01", dayShiftPump1Controller),
            _buildTextField("Pump 02", dayShiftPump2Controller),
            _buildTextField("Pump 03", dayShiftPump3Controller),
            _buildTextField("Pump 04", dayShiftPump4Controller),
            _buildShiftLabel("Night Shift"),
            _buildTextField("Pump 01 & Pump 02", nightShiftPump1Controller),
            _buildTextField("Pump 03 & Pump 04", nightShiftPump3Controller),
            SizedBox(height: 20),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _updateShiftInDatabase,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade900,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 4,
        ),
        child: Text(
          "Submit",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
