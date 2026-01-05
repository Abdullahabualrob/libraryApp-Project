import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Library App"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [

            const Icon(
              Icons.local_library,
              size: 100,
              color: Colors.red,
            ),

            const SizedBox(height: 20),

            const Text(
              "Library Management App",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            const Text(
              "This app allows users to browse books, borrow them, "
                  "and manage borrowed books easily using Flutter and Firebase.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            const Text(
              "Developed by:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Abdullah AbuAlrob — Computer Engineering Student",
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),

            const Text(
              "Version 1.0",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
