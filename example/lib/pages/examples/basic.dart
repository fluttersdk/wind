import 'package:flutter/material.dart';

class BasicExamplePage extends StatelessWidget {
  const BasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basic Example'),
      ),
      body: Center(
        child: Text('This is a basic example page.'),
      ),
    );
  }
}