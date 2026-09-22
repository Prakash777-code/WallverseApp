import 'package:flutter/material.dart';

class FullScreenWallpaper extends StatelessWidget {
  final String imageUrl;

  const FullScreenWallpaper({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            top: 40,
            left: 15,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}
