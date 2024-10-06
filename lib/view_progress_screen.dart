import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'week_provider.dart';
import 'week_data_model.dart'; // Import the WeekData model

class ViewProgressScreen extends StatelessWidget {
  const ViewProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the WeekData object passed from HomeScreen
    final WeekData? selectedWeekData = ModalRoute.of(context)?.settings.arguments as WeekData?;

    if (selectedWeekData == null) {
      return const Scaffold(
        body: Center(
          child: Text("No week selected"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        centerTitle: true,
        backgroundColor: Colors.pink.shade50,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.pink.shade50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/${selectedWeekData.fruit.toLowerCase()}.png',
                      height: 150, // Adjust the size as needed
                      width: 150, // Adjust the size as needed
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 100),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoCard('Size', selectedWeekData.size, Colors.orange.shade100),
                      _buildInfoCard('Fruit', selectedWeekData.fruit, Colors.blue.shade100),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSection('Baby Growth', selectedWeekData.babyGrowth, Colors.pink.shade100),
              _buildSection('Mother\'s Symptoms', selectedWeekData.motherSymptoms, Colors.blue.shade100),
              // Remove the "Next Week" button
              // If you want to add other buttons or features, you can add them here.
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, Color color) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        '$title: $content',
        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSection(String title, String content, Color color) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(content, style: const TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }
}
