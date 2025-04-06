import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShiftRequestViewPage extends StatefulWidget {
  const ShiftRequestViewPage({super.key});

  @override
  State<ShiftRequestViewPage> createState() => _ShiftRequestViewPageState();
}

class _ShiftRequestViewPageState extends State<ShiftRequestViewPage> {
  List<Map<String, dynamic>> shiftRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchShiftRequests();
  }

  // Fetch shift requests from the backend
  Future<void> _fetchShiftRequests() async {
    final response = await http.get(Uri.parse("http://10.0.2.2:5000/shift-requests"));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        shiftRequests = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to load shift requests")));
    }
  }

  // Approve or decline a shift request
  Future<void> _updateShiftRequest(int requestId, String status) async {
    final apiUrl = status == "approved"
        ? "http://10.0.2.2:5000/shift-requests/$requestId/approve"
        : "http://10.0.2.2:5000/shift-requests/$requestId";

    try {
      http.Response response;

      if (status == "approved") {
        // Use PUT for approval
        response = await http.put(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"status": status}),
        );
      } else {
        // Use DELETE for decline
        response = await http.delete(Uri.parse(apiUrl));
      }

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Shift request $status successfully")));
        _fetchShiftRequests(); // Refresh the list after updating
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to $status shift request")));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shift Requests", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade900,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : shiftRequests.isEmpty
          ? Center(child: Text("No shift requests available"))
          : ListView.builder(
        itemCount: shiftRequests.length,
        itemBuilder: (context, index) {
          final request = shiftRequests[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Pumper Name: ${request['pumper_name']}", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text("Shift Type: ${request['shift_type']}", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text("Reason: ${request['description']}", style: TextStyle(fontSize: 14)),
                  SizedBox(height: 8),
                  Text("Date: ${request['date']}", style: TextStyle(fontSize: 14)),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => _updateShiftRequest(request['id'], "approved"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("Approve"),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _updateShiftRequest(request['id'], "declined"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("Decline"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}