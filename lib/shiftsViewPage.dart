import 'package:flutter/material.dart';
import 'shiftsUpdatePage.dart';
import 'shiftHistoryPage.dart';
import 'shiftRequestPage.dart';

class ShiftSchedulePage extends StatefulWidget {
  const ShiftSchedulePage({super.key});

  @override
  _ShiftSchedulePageState createState() => _ShiftSchedulePageState();
}

class _ShiftSchedulePageState extends State<ShiftSchedulePage> {
  DateTime selectedDate = DateTime(2025, 1, 23);

  Map<String, List<String>> shiftData = {
    "Day Shift": [
      "Pump 01 : Suneth Kumara",
      "Pump 02 : Ananda Kumara",
      "Pump 03 : Lalith Kumara",
      "Pump 04 : Sadun Kumara",
    ],
    "Night Shift": [
      "Pump 01 & 02 : Nimesh Kumara",
      "Pump 03 & 04 : Kasun Kumara",
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shift Schedule", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade900,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: () {
                      setState(() {
                        selectedDate = selectedDate.subtract(Duration(days: 1));
                      });
                    },
                  ),
                  Text(
                    "${selectedDate.year} - ${selectedDate.month.toString().padLeft(2, '0')} - ${selectedDate.day.toString().padLeft(2, '0')}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: () {
                      setState(() {
                        selectedDate = selectedDate.add(Duration(days: 1));
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            _buildShiftSection(
              "Day Shift",
              "(8:00 AM - 8:00 PM)",
              shiftData["Day Shift"]!,
            ),
            SizedBox(height: 20),
            _buildShiftSection(
              "Night Shift",
              "(8:00 PM - 8:00 AM)",
              shiftData["Night Shift"]!,
            ),
            SizedBox(height: 18),
            _buildButton("Update New Shifts", context, () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => UpdateShiftPage(
                        selectedDate: selectedDate,
                        shiftData: shiftData,
                      ),
                ),
              );

              if (result != null) {
                setState(() {
                  selectedDate = result["date"];
                  shiftData = result["shifts"];
                });
              }
            }),
            SizedBox(height: 10),
            _buildButton("Request a Shift Change", context, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RequestShiftChangePage(),
                ),
              );
            }),
            SizedBox(height: 10),
            _buildButton("View Shift History", context, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShiftHistoryPage()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftSection(String title, String time, List<String> shifts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          color: Colors.blue.shade900,
          child: Text(
            "$title   $time",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        ...shifts.map(
          (shift) => Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.shade900),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(shift),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
    String text,
    BuildContext context,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade900,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 4,
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
