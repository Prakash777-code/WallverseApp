import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallverse/viewModels/full_screen_view_model.dart';

class FullScreenWallpaper extends StatefulWidget {
  final String imageUrl;

  const FullScreenWallpaper({super.key, required this.imageUrl});

  @override
  State<FullScreenWallpaper> createState() {
    return _FullScreenWallpaperState();
  }
}

class _FullScreenWallpaperState extends State<FullScreenWallpaper> {
  final viewModel = FullScreenViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.report, color: Colors.white),
          ),
          IconButton(
            onPressed: () async {
              await viewModel.downloadImage(widget.imageUrl);
              if (viewModel.errorMessage == null) {
                Fluttertoast.showToast(msg: "Downloaded");
              } else {
                Fluttertoast.showToast(msg: "Failed to download wallpaper");
              }
            },
            icon: const Icon(Icons.download, color: Colors.white),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(color: Color(0xFFA855F7)),
              ),
              errorWidget: (context, url, error) => const Center(
                child: Icon(
                  Icons.broken_image_outlined,
                  color: Color(0xFF71717A),
                  size: 35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
