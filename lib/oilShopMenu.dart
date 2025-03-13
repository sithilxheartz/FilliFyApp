import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import 'productMenu.dart';
import 'productUpdateStock.dart';
import 'productAddNew.dart';

class OilShopApp extends StatefulWidget {
  @override
  _OilShopAppState createState() => _OilShopAppState();
}

class _OilShopAppState extends State<OilShopApp> {
  String? userRole; // Store user role
  List<Map<String, String>> products = [
    {
      "name": "Engine Oil 5L",
      "price": "Rs.5400.00",
      "brand": "Caltex",
      "size": "5L",
      "stock": "12",
      "specify": "Petrol Cars",
    },
    {
      "name": "Supra Oil 1L",
      "price": "Rs.2700.00",
      "brand": "Supreme",
      "size": "1L",
      "stock": "20",
      "specify": "Diesel Cars",
    },
  ];

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('role') ?? "user"; // Default to "user"
    });
  }

  void addProduct(Map<String, String> product) {
    setState(() {
      products.add(product);
    });
  }

  void updateStock(String productName, String newStock) {
    setState(() {
      for (var product in products) {
        if (product["name"] == productName) {
          product["stock"] = newStock;
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainMenu(
        products: products,
        addProduct: addProduct,
        updateStock: updateStock,
        userRole: userRole, // Pass role
      ),
    );
  }
}

class MainMenu extends StatefulWidget {
  final List<Map<String, String>> products;
  final Function(Map<String, String>) addProduct;
  final Function(String, String) updateStock;
  final String? userRole;

  MainMenu({
    required this.products,
    required this.addProduct,
    required this.updateStock,
    required this.userRole,
  });

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Oil Shop", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade900,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardPage()),
            );
          },
        ),
      ),
      backgroundColor: Color(0xFFF8F3F7),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: _buildMenuItems(),
        ),
      ),
    );
  }

  List<Widget> _buildMenuItems() {
    List<Widget> menuItems = [
      _buildMenuItem(context, Icons.store, "Product Menu", ProductMenu(products: widget.products)),
    ];

    // Show only for admins
    if (widget.userRole == "admin") {
      menuItems.add(_buildMenuItem(context, Icons.add_circle_outline, "Add Product", null));
      menuItems.add(_buildMenuItem(context, Icons.update, "Update Stock", UpdateStockPage(updateStock: widget.updateStock)));
    }

    return menuItems;
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String label, Widget? page) {
    return GestureDetector(
      onTap: () async {
        if (label == "Add Product") {
          final newProduct = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNewProduct()),
          );

          if (newProduct != null) {
            setState(() {
              widget.addProduct(newProduct);
            });
          }
        } else if (page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFD9ECFB),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Color(0xFF0A4DA2)),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ],
        ),
      ),
    );
  }
}
