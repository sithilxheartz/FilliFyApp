import 'package:flutter/material.dart';

class FuelStock extends StatefulWidget {
  @override
  _FuelStockState createState() => _FuelStockState();
}

class _FuelStockState extends State<FuelStock> {
  List<double> fuelLevels = [0.1, 0.1, 0.1, 0.1, 0.1, 0.1];
  final double tankCapacity = 13000;

  void updateFuelLevels(List<double> newLevels) {
    setState(() {
      fuelLevels = newLevels;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fuel Stock", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Correct back navigation
          },
        ),
        backgroundColor: Colors.blue.shade900,
      ),
      body: HomePage(updateFuelLevels, fuelLevels, tankCapacity),
    );
  }
}

class HomePage extends StatelessWidget {
  final Function(List<double>) updateFuelLevels;
  final List<double> fuelLevels;
  final double tankCapacity;

  HomePage(this.updateFuelLevels, this.fuelLevels, this.tankCapacity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _buildMenuItem(
              context,
              Icons.local_gas_station,
              "View Fuel Stock",
              FuelStockPage(fuelLevels),
            ),
            _buildMenuItem(
              context,
              Icons.update,
              "Update Fuel Stock",
              UpdateStockPage(updateFuelLevels, fuelLevels, tankCapacity),
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
    Widget page,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
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
            Icon(icon, size: 50, color: Colors.blue.shade900),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class FuelStockPage extends StatelessWidget {
  final List<double> fuelLevels;

  FuelStockPage(this.fuelLevels);

  final List<String> tankNames = [
    "Tank 01 (Auto Diesel)",
    "Tank 02 (Auto Diesel)",
    "Tank 03 (Super Diesel)",
    "Tank 04 (Octane 92 Petrol)",
    "Tank 05 (Octane 92 Petrol)",
    "Tank 06 (Octane 95 Petrol)",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fuel Stock", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: fuelLevels.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.teal.shade300, width: 1),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tankNames[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 1),
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          FractionallySizedBox(
                            widthFactor: fuelLevels[index],
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green.shade400,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "${(fuelLevels[index] * 100).toStringAsFixed(1)}%                                  (Capacity: 13000)",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class UpdateStockPage extends StatefulWidget {
  final Function(List<double>) updateFuelLevels;
  final List<double> fuelLevels;
  final double tankCapacity;

  UpdateStockPage(this.updateFuelLevels, this.fuelLevels, this.tankCapacity);

  @override
  _UpdateStockPageState createState() => _UpdateStockPageState();
}

class _UpdateStockPageState extends State<UpdateStockPage> {
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      widget.fuelLevels.length,
      (index) => TextEditingController(
        text: (widget.fuelLevels[index] * widget.tankCapacity).toString(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fuel Stock", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Update Fuel Stock",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.fuelLevels.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.teal.shade300, width: 1),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tank 0${index + 1}:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            controller: controllers[index],
                            decoration: InputDecoration(
                              hintText: "Liters",
                              filled: true,
                              fillColor: Colors.grey.shade300,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 1),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                List<double> newLevels =
                    controllers.map((controller) {
                      double liters = double.tryParse(controller.text) ?? 0;
                      return (liters / widget.tankCapacity).clamp(0.0, 1.0);
                    }).toList();
                widget.updateFuelLevels(newLevels);
                Navigator.pop(context);
              },
              child: Text(
                "Update Stock",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900, // Corrected here
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
