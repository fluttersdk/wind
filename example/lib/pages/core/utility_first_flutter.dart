import 'package:flutter/material.dart';

class UtilityFirstFlutter extends StatelessWidget {
  const UtilityFirstFlutter({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      color: Colors.black,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '12',
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.5),
            ),
            const SizedBox(height: 4),
            const Text(
              'Active users on the website',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
