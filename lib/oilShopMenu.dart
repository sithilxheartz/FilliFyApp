import 'package:flutter/material.dart';
import 'package:hiiitest/dashboard.dart';
import 'productMenu.dart';
import 'productUpdateStock.dart';
import 'productAddNew.dart';

class OilShopApp extends StatefulWidget {
  @override
  _OilShopAppState createState() => _OilShopAppState();
}

class _OilShopAppState extends State<OilShopApp> {
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
      ),
    );
  }
}

class MainMenu extends StatefulWidget {
  final List<Map<String, String>> products;
  final Function(Map<String, String>) addProduct;
  final Function(String, String) updateStock;

  MainMenu({
    required this.products,
    required this.addProduct,
    required this.updateStock,
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
      backgroundColor: Color(0xFFF8F3F7), // Light Pink Background
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2, // Two buttons per row
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [
            _buildMenuItem(
              context,
              Icons.store,
              "Product Menu",
              ProductMenu(products: widget.products),
            ),
            _buildMenuItem(
              context,
              Icons.add_circle_outline,
              "Add Product",
              null, // Special case for async
            ),
            _buildMenuItem(
              context,
              Icons.update,
              "Update Stock",
              UpdateStockPage(updateStock: widget.updateStock),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String label,
    Widget? page,
  ) {
    return GestureDetector(
      onTap: () async {
        if (label == "Add Product") {
          final newProduct = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNewProduct()),
          );

          if (newProduct != null) {
            setState(() {
              widget.addProduct(newProduct); // Update product list
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
          color: Color(0xFFD9ECFB), // Light Blue Button Background
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
            Icon(icon, size: 50, color: Color(0xFF0A4DA2)), // Dark Blue Icon
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0), // Dark Blue Text
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetails extends StatelessWidget {
  final Map<String, String> product;

  ProductDetails(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade900,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage(),
              SizedBox(height: 20),
              _buildProductTitle(),
              SizedBox(height: 10),
              _buildProductInfo(),
              SizedBox(height: 30),
              _buildPurchaseButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for displaying the product image
  Widget _buildProductImage() {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          Icons.oil_barrel_outlined,
          size: 120,
          color: Colors.blue.shade900,
        ),
      ),
    );
  }

  // Widget for displaying the product name with elegant styling
  Widget _buildProductTitle() {
    return Center(
      child: Text(
        product['name']!,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade900,
        ),
      ),
    );
  }

  // Widget for displaying product information with elegant spacing
  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProductDetail("Price", product['price']!),
        _buildProductDetail("Brand", product['brand']!),
        _buildProductDetail("Size", product['size']!),
        _buildProductDetail("In Stock", product['stock']!),
        _buildProductDetail("Specify For", product['specify']!),
      ],
    );
  }

  // Helper function to display each product detail with styling
  Widget _buildProductDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        "$label: $value",
        style: TextStyle(
          fontSize: 18,
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Widget for the purchase button with modern design
  Widget _buildPurchaseButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PurchasePage(product)),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade900, // Match theme color
          foregroundColor: Colors.white, // Text color
          padding: EdgeInsets.symmetric(
            vertical: 13,
            horizontal: 90,
          ), // Increase touch area
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
          elevation: 4, // Slight shadow for depth
        ),
        child: Text(
          "Purchase",
          style: TextStyle(
            backgroundColor: Colors.blue.shade900,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class PurchasePage extends StatelessWidget {
  final Map<String, String> product;

  PurchasePage(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Purchasing Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Product: ${product['name']}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(decoration: InputDecoration(labelText: "Quantity")),
            TextField(decoration: InputDecoration(labelText: "Card Number")),
            TextField(decoration: InputDecoration(labelText: "Name on Card")),
            TextField(decoration: InputDecoration(labelText: "Expiry Date")),
            TextField(decoration: InputDecoration(labelText: "CVV")),
            TextField(decoration: InputDecoration(labelText: "Mobile Number")),
            TextField(decoration: InputDecoration(labelText: "Address")),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900, // Match theme color
                foregroundColor: Colors.white, // Text color
                padding: EdgeInsets.symmetric(
                  vertical: 13,
                  horizontal: 90,
                ), // Increase touch area
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
                elevation: 4, // Slight shadow for depth
              ),
              onPressed: () {},
              child: Text("Confirm", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
