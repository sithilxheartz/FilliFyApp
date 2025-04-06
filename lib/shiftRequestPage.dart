import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ShiftRequestPage extends StatefulWidget {
  const ShiftRequestPage({super.key});

  @override
  _ShiftRequestPageState createState() => _ShiftRequestPageState();
}

class _ShiftRequestPageState extends State<ShiftRequestPage> {
  List<Map<String, dynamic>> employees = [];
  String? selectedEmployee;
  String? selectedShiftType;
  DateTime selectedDate = DateTime.now();

  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
  }

  Future<void> _fetchEmployees() async {
    final response = await http.get(Uri.parse("http://10.0.2.2:5000/get-employees"));

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> employeeList = List<Map<String, dynamic>>.from(json.decode(response.body));
      setState(() {
        employees = employeeList;
        if (employees.isNotEmpty) {
          selectedEmployee = employees.first['name']; // Set default employee
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to load employees")));
    }
  }

  Future<void> _submitForm() async {
    if (selectedEmployee == null || selectedShiftType == null || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }

    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    final response = await http.post(
      Uri.parse("http://10.0.2.2:5000/shift-requests"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "pumper_name": selectedEmployee,
        "shift_type": selectedShiftType,
        "description": _descriptionController.text,
        "date": formattedDate,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Shift request submitted successfully!")));
      _descriptionController.clear(); // Clear the description field
      Navigator.pop(context); // Navigate back after submission
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to submit shift request")));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Shift Change", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade900,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Picker
              ListTile(
                title: Text("Select Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}"),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),

              // Employee Dropdown
              if (employees.isEmpty)
                Center(child: CircularProgressIndicator())
              else
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Select Employee"),
                  value: selectedEmployee,
                  items: employees.map((e) {
                    return DropdownMenuItem<String>(
                      value: e['name'],
                      child: Text(e['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedEmployee = value;
                    });
                  },
                  validator: (value) => value == null ? 'Please select an employee' : null,
                ),

              // Shift Type Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Select Shift Type"),
                value: selectedShiftType,
                items: [
                  "Day Shift (7.30 AM - 7.30 PM) 🌞",
                  "Night Shift (7.30 PM - 7.30 AM) 🌙",
                ].map((String shift) {
                  return DropdownMenuItem<String>(
                    value: shift,
                    child: Text(shift),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedShiftType = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a shift type' : null,
              ),

              // Reason Input Field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Reason for Change"),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a reason';
                  } else if (value.length < 10) {
                    return 'Minimum 10 characters required';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Submit Request"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}