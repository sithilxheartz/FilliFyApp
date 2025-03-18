import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmployeePage extends StatefulWidget {
  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  String? selectedPosition = 'Diesel_Pumper';

  Future<void> _addEmployee() async {
    if (!_formKey.currentState!.validate()) return;

    final response = await http.post(
      Uri.parse("http://10.0.2.2:5000/add-employee"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nameController.text,
        "position": selectedPosition,
        "contactNumber": contactController.text,
        "salary": salaryController.text,
      }),
    );

    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Employee Added Successfully")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${responseData["message"]}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add New Pumper"), backgroundColor: Colors.blue.shade900),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: nameController, decoration: InputDecoration(labelText: "Name"), validator: (value) => value!.isEmpty ? "Required" : null),
              DropdownButtonFormField<String>(
                value: selectedPosition,
                items: ["Diesel_Pumper", "Petrol_Pumper", "Manager"].map((String category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (newValue) => setState(() => selectedPosition = newValue),
                decoration: InputDecoration(labelText: "Position"),
              ),
              TextFormField(controller: contactController, decoration: InputDecoration(labelText: "Contact Number"), validator: (value) => value!.isEmpty ? "Required" : null),
              TextFormField(controller: salaryController, decoration: InputDecoration(labelText: "Salary"), keyboardType: TextInputType.number, validator: (value) => value!.isEmpty ? "Required" : null),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _addEmployee, child: Text("Add Pumper")),
            ],
          ),
        ),
      ),
    );
  }
}
