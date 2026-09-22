import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wallverse/screens/side_drawer.dart';
import 'package:wallverse/viewModels/upload_view_model.dart';

class UploadWallpaperScreen extends StatefulWidget {
  const UploadWallpaperScreen({super.key});

  @override
  State<UploadWallpaperScreen> createState() => _UploadWallpaperScreenState();
}

class _UploadWallpaperScreenState extends State<UploadWallpaperScreen> {
  File? selectedImage;

  final TextEditingController titleController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  final uploadViewModel = UploadViewModel();

  bool loading = false;

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    setState(() {
      selectedImage = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      drawer: SideDrawer(
        onClose: () {
          Navigator.pop(context);
        },
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Menu button
              Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                  );
                },
              ),

              const SizedBox(height: 15),

              // Header
              const Text(
                "Share Your Creation",
                style: TextStyle(
                  color: Color(0xFF9C6BFF),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Upload Wallpaper",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Share your favorite wallpapers with the WallVerse community.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),

              const SizedBox(height: 28),

              // Image picker area
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  width: double.infinity,
                  height: 360,
                  decoration: BoxDecoration(
                    color: const Color(0xFF090909),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFF292929)),
                  ),
                  child: selectedImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: const Color(0xFF151515),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Icon(
                                Icons.cloud_upload_outlined,
                                color: Color(0xFF9C6BFF),
                                size: 42,
                              ),
                            ),

                            const SizedBox(height: 18),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              "Tap to choose an image from your device",
                              style: TextStyle(
                                color: Color(0xFF777777),
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 14),

                            const Text(
                              "JPG, PNG • Max 5 MB",
                              style: TextStyle(
                                color: Color(0xFF555555),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.file(
                            selectedImage!,
                            width: double.infinity,
                            height: 360,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 22),

              if (selectedImage != null) ...[
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: loading
                        ? null
                        : () {
                            setState(() {
                              selectedImage = null;
                            });
                          },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF292929)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
              ],

              // Title
              const Text(
                "Wallpaper Title",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: InputDecoration(
                  hintText: "Enter a title for your wallpaper",
                  hintStyle: const TextStyle(
                    color: Color(0xFF555555),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF090909),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF292929)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF292929)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF7C4DFF)),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Upload button
              ListenableBuilder(
                listenable: uploadViewModel,
                builder: (context, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: uploadViewModel.isLoading
                          ? null
                          : () async {
                              if (selectedImage != null &&
                                  titleController.text.isNotEmpty) {
                                await uploadViewModel.uploadWallpaper(
                                  selectedImage!,
                                  titleController.text.trim(),
                                );

                                if (uploadViewModel.errorMessage == null) {
                                  setState(() {
                                    selectedImage = null;
                                  });
                                  titleController.clear();
                                  Fluttertoast.showToast(msg: "Uploaded");
                                } else {
                                  Fluttertoast.showToast(
                                    msg: uploadViewModel.errorMessage!,
                                  );
                                }
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Please select an image and enter a title",
                                );
                              }
                            },
                      icon: uploadViewModel.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.upload,
                              color: Colors.white,
                              size: 20,
                            ),
                      label: uploadViewModel.isLoading
                          ? const Text(
                              "Uploading...",
                              style: TextStyle(color: Colors.white),
                            )
                          : const Text(
                              "Upload Wallpaper",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C4DFF),
                        disabledBackgroundColor: const Color(0xFF3A3A3A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),

              const Center(
                child: Text(
                  "Make sure you have permission to share this image.",
                  style: TextStyle(color: Color(0xFF555555), fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
