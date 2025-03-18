void updateStock() async {
  List<double> newLevels = List.generate(widget.fuelLevels.length, (index) {
    double removedFuel = double.tryParse(controllers[index].text) ?? 0;
    return ((widget.fuelLevels[index] * widget.tankCapacity - removedFuel) / widget.tankCapacity)
        .clamp(0.0, 1.0);
  });

  List<double> salesData = List.generate(widget.fuelLevels.length, (index) {
    return double.tryParse(controllers[index].text) ?? 0;
  });

  try {
    var response = await http.post(
      Uri.parse("http://10.0.2.2:5000/update-fuel-stock"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"sales": salesData}),
    );

    if (response.statusCode == 200) {
      widget.updateFuelLevels(newLevels);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Fuel stock updated!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update stock")));
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
  }
}
