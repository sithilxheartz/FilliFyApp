import 'package:flutter/material.dart';

class AddStockPage extends StatefulWidget {
  final Function(List<double>) updateFuelLevels;
  final List<double> fuelLevels;
  final double tankCapacity;

  AddStockPage(this.updateFuelLevels, this.fuelLevels, this.tankCapacity);

  @override
  _AddStockPageState createState() => _AddStockPageState();
}

class _AddStockPageState extends State<AddStockPage> {
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      widget.fuelLevels.length,
      (index) => TextEditingController(text: "0"),
    );
  }

  void updateStock() {
    List<double> newLevels = List.generate(widget.fuelLevels.length, (index) {
      double addedFuel = double.tryParse(controllers[index].text) ?? 0;
      return ((widget.fuelLevels[index] * widget.tankCapacity + addedFuel) /
              widget.tankCapacity)
          .clamp(0.0, 1.0);
    });
    widget.updateFuelLevels(newLevels);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Fuel Stock", style: TextStyle(color: Colors.white)),
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
              "Add Fuel Stock",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
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
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: updateStock,
              child: Text("Add Stock", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
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
