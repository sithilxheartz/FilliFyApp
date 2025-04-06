import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserRoleManagement extends StatefulWidget {
  @override
  _UserRoleManagementState createState() => _UserRoleManagementState();
}

class _UserRoleManagementState extends State<UserRoleManagement> {
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final response = await http.get(Uri.parse("http://10.0.2.2:5000/users"));

    if (response.statusCode == 200) {
      setState(() {
        users = jsonDecode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to fetch users")));
    }
  }

  Future<void> _updateUserRole(int userId, String newRole) async {
    final response = await http.put(
      Uri.parse("http://10.0.2.2:5000/users/$userId/role"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"role": newRole}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User role updated successfully!")));
      _fetchUsers(); // Refresh the user list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update role")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage User Roles"), backgroundColor: Colors.blue.shade900),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          var user = users[index];
          return ListTile(
            title: Text(user["name"] ?? "No Name"),
            subtitle: Text(user["email"]),
            trailing: DropdownButton<String>(
              value: user["role"],
              items: ["admin", "user"].map((role) {
                return DropdownMenuItem(value: role, child: Text(role));
              }).toList(),
              onChanged: (newRole) {
                if (newRole != null) {
                  _updateUserRole(user["userID"], newRole);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
