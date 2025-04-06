import 'package:firebase_auth_tutorials/models/pumper_model.dart';
import 'package:firebase_auth_tutorials/services/pumper_service.dart';
import 'package:firebase_auth_tutorials/widgets/custom_button.dart';
import 'package:firebase_auth_tutorials/widgets/custom_input.dart';
import 'package:firebase_auth_tutorials/models/shift_request_model.dart';
import 'package:firebase_auth_tutorials/services/shift_request_service.dart';
import 'package:firebase_auth_tutorials/utils/colors.dart';
import 'package:firebase_auth_tutorials/utils/snack_bar.dart';
import 'package:flutter/material.dart';

class ShiftRequestPage extends StatefulWidget {
  const ShiftRequestPage({super.key});

  @override
  State<ShiftRequestPage> createState() => _ShiftRequestPageState();
}

class _ShiftRequestPageState extends State<ShiftRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _shiftType = TextEditingController();
  final TextEditingController _description = TextEditingController();
  String? _selectedShiftType;
  String? selectedPumper;
  final ValueNotifier<DateTime> _selectedDate = ValueNotifier<DateTime>(
    DateTime.now(),
  );

  Future<void> _selectDate(BuildContext ctx) async {
    final DateTime? picked = await showDatePicker(
      context: ctx,
      firstDate: DateTime(2025),
      lastDate: DateTime(2027),
      initialDate: _selectedDate.value,
    );

    if (picked != null) {
      _selectedDate.value = picked;
    }
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate() && selectedPumper != null) {
      try {
        final ShiftRequest shiftRequest = ShiftRequest(
          id: '',
          pumperName: selectedPumper!,
          shiftType: _shiftType.text,
          description: _description.text,
          date: DateTime(
            _selectedDate.value.year,
            _selectedDate.value.month,
            _selectedDate.value.day,
          ),
        );
        _description.clear();
        await ShiftRequestService().createNewShiftRequest(shiftRequest);
        showSnackBar(context, "Successfully sent shift request");
      } catch (error) {
        showSnackBar(context, "Failed to sent shift request");
      }
    } else {
      showSnackBar(context, "Please fill all fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.pending_actions_outlined,
                      color: mainColor,
                      size: 35,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Requst a Shift Change",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  "Fill in the details below to request a shift schedule change.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                Divider(),
                ValueListenableBuilder<DateTime>(
                  valueListenable: _selectedDate,
                  builder: (context, date, child) {
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Select Assigned Date: ${date.toLocal().toString().split(" ")[0]}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _selectDate(context),
                          icon: Icon(Icons.calendar_today),
                        ),
                      ],
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: StreamBuilder<List<Pumper>>(
                    stream: PumperService().pumpers,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      List<String> pumperNames =
                          snapshot.data!.map((p) => p.name).toList();
                      return DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          labelText: "Select Your Name",
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        value: selectedPumper,
                        items:
                            pumperNames
                                .map(
                                  (name) => DropdownMenuItem(
                                    value: name,
                                    child: Text(name),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedPumper = value;
                          });
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      labelText: "Select Assigned Shift Type",
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    value: _selectedShiftType,
                    items:
                        [
                              'Day Shift (7.30 AM - 7.30 PM) 🌞',
                              'Night Shift (7.30 PM - 7.30 AM) 🌙',
                            ]
                            .map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedShiftType = newValue;
                        _shiftType.text = newValue ?? "";
                      });
                    },
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "What did you want to change your shift?",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 5),
                CustomInput(
                  controller: _description,
                  labelText: "Enter the reason",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a reason';
                    } else if (value.length < 10) {
                      // Use '>' instead of '>=' to allow exactly 10 characters
                      return 'Minimum 10 characters required';
                    }
                    return null;
                  },
                ),

                CustomButton(
                  labelText: "Send Request",
                  onPressed: () => _submitForm(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
