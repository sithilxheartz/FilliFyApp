import 'package:flutter/material.dart';

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
  final TextEditingController nightShiftPump1Controller =
      TextEditingController();
  final TextEditingController nightShiftPump3Controller =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    newDate = widget.selectedDate;
    dateController.text =
        "${newDate.year}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: newDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != newDate) {
      setState(() {
        newDate = picked;
        dateController.text =
            "${newDate.year}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}";
      });
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
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        backgroundColor: Colors.blue.shade900,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              "Date",
              dateController,
              onTap: () => _selectDate(context),
            ),
            _buildShiftLabel("Day Shift"),
            _buildTextField("Pump 01", dayShiftPump1Controller),
            _buildTextField("Pump 02", dayShiftPump2Controller),
            _buildTextField("Pump 03", dayShiftPump3Controller),
            _buildTextField("Pump 04", dayShiftPump4Controller),
            _buildShiftLabel("Night Shift"),
            _buildTextField("Pump 01 & Pump 02", nightShiftPump1Controller),
            _buildTextField("Pump 03 & Pump 04", nightShiftPump3Controller),
            SizedBox(height: 20),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        readOnly: onTap != null,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Make button full width
      child: ElevatedButton(
        onPressed: () {
          Map<String, List<String>> newShiftData = {
            "Day Shift": [
              "Pump 01 : ${dayShiftPump1Controller.text}",
              "Pump 02 : ${dayShiftPump2Controller.text}",
              "Pump 03 : ${dayShiftPump3Controller.text}",
              "Pump 04 : ${dayShiftPump4Controller.text}",
            ],
            "Night Shift": [
              "Pump 01 & 02 : ${nightShiftPump1Controller.text}",
              "Pump 03 & 04 : ${nightShiftPump3Controller.text}",
            ],
          };

          Navigator.pop(context, {"date": newDate, "shifts": newShiftData});
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade900, // Match theme color
          foregroundColor: Colors.white, // Text color
          padding: EdgeInsets.symmetric(vertical: 16), // Increase touch area
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
          elevation: 4, // Slight shadow for depth
        ),
        child: Text(
          "Submit",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

Widget _buildShiftLabel(String label) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade900,
      ),
    ),
  );
}
