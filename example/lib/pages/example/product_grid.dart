import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: wColor('gray', shade: 200),
      body: WFlexContainer(
        className:
        'flex-col md:flex-row gap-4 p-4',
        children: [
          collectionCard(
              imageUrl: 'https://picsum.photos/400/300',
              title: 'Desk and Office',
              description: 'Work from home accessories'),
          collectionCard(
              imageUrl: 'https://picsum.photos/400/300',
              title: 'Self-Improvement',
              description: 'Journals and note-taking'),
          collectionCard(
              imageUrl: 'https://picsum.photos/400/300',
              title: 'Travel',
              description: 'Daily commute essentials')
        ],
      ),
    );
  }

  Widget collectionCard({
    required String imageUrl,
    required String title,
    required String description,
  }) {
    return WFlexContainer(
      className: 'flex-1 flex-col gap-2',
      children: [
        WContainer(
          className: 'rounded-lg bg-white',
          child: Image.network(
            'https://picsum.photos/400/300',
            fit: BoxFit.cover,
          ),
        ),
        WText(title, className: 'text-base font-bold text-gray-900'),
        WText(description, className: 'text-sm text-gray-500'),
      ],
    );
  }
}
