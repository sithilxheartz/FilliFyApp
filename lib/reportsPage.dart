import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportsPage extends StatelessWidget {
  final List<Map<String, String>> reports = [
    {"name": "Sales Report", "endpoint": "sales"},
    {"name": "Fuel Stock Report", "endpoint": "fuelstock"},
    {"name": "Employee Work Report", "endpoint": "employees"},
  ];

  Future<void> _downloadReport(String reportType) async {
    final Uri url = Uri.parse("http://10.0.2.2:5000/reports/$reportType");

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw "Could not launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reports"), backgroundColor: Colors.blue.shade900),
      body: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(reports[index]["name"]!),
            trailing: IconButton(
              icon: Icon(Icons.download),
              onPressed: () => _downloadReport(reports[index]["endpoint"]!),
            ),
          );
        },
      ),
    );
  }
}
