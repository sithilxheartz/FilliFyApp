import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // For date formatting

class ShiftSchedulePage extends StatefulWidget {
  @override
  _ShiftSchedulePageState createState() => _ShiftSchedulePageState();
}

class _ShiftSchedulePageState extends State<ShiftSchedulePage> {
  List<Map<String, dynamic>> shifts = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchShiftsByDate(selectedDate);
  }

  Future<void> _fetchShiftsByDate(DateTime date) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    final response = await http.get(
      Uri.parse("http://10.0.2.2:5000/get-shifts-by-date?date=$formattedDate"),
    );

    if (response.statusCode == 200) {
      setState(() {
        shifts = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to load shifts")));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
      _fetchShiftsByDate(selectedDate);
    }
  }

  String getShiftTime(bool isNightShift) {
    return isNightShift ? "8:00 PM - 8:00 AM" : "8:00 AM - 8:00 PM";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shift Schedule", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade900,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Shifts for ${DateFormat('yyyy-MM-dd').format(selectedDate)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            shifts.isEmpty
                ? Expanded(child: Center(child: Text("No shifts assigned for this date")))
                : Expanded(
              child: ListView.builder(
                itemCount: shifts.length,
                itemBuilder: (context, index) {
                  final shift = shifts[index];

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.blue.shade900, width: 1),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "👷 Employee: ${shift['employeeName'] ?? 'Not Assigned'}",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "⛽ Pump: Pump ${shift['pumpNumber']}",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "⏰ Time: ${getShiftTime(shift['nightShift'] == 1)}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
