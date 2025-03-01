import 'package:flutter/material.dart';
import 'dashboard.dart';

void main() {
  runApp(FillingStationApp());
}

class FillingStationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage());
  }
}

// --------------------- LOGIN PAGE ---------------------
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blue.shade500],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_gas_station, size: 80, color: Colors.white),
                  SizedBox(height: 20),
                  Text(
                    "Filling Station Management",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),

                  _buildTextField(
                    hintText: "Email",
                    icon: Icons.email,
                    isPassword: false,
                  ),
                  SizedBox(height: 15),
                  _buildTextField(
                    hintText: "Password",
                    icon: Icons.lock,
                    isPassword: true,
                  ),
                  SizedBox(height: 25),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue.shade900,
                      padding: EdgeInsets.symmetric(
                        horizontal: 100,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    required bool isPassword,
  }) {
    return TextField(
      obscureText: isPassword ? _obscureText : false,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
                : null,
      ),
    );
  }
}
