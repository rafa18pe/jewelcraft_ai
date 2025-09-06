import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
      body: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'JewelCraft AI',
          style: TextStyle(fontSize: 32, color: Colors.white),
        ),
        SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AiTextToJewelryScreen(),
              ),
            );
          },
          child: Text('Texto → Joya'),
        ),
      ],
    ),
  ),
  backgroundColor: Colors.black,
),
