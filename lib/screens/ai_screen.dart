import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallverse/screens/side_drawer.dart';
import 'package:wallverse/viewModels/ai_view_model.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiStudioScreenState();
}

class _AiStudioScreenState extends State<AiScreen> {
  final TextEditingController promptController = TextEditingController();
  final aiViewModel = AiViewModel();

  bool loading = false;
  String? imageUrl;
  bool imageLoaded = false;
  bool generating = false;

  final List<String> suggestions = [
    "Cyberpunk City",
    "Galaxy Space",
    "Dark Mountain",
    "Anime Wallpaper",
    "Ocean Sunset",
  ];

  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }

  Future<void> generateWallpaper() async {
    if (promptController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Prompt is required to generate image");
      return;
    }

    setState(() {
      loading = true;
      generating = true;
      imageUrl = null;
    });

    try {
      final url = await aiViewModel.generateWallpaper(
        promptController.text.trim(),
      );

      setState(() {
        imageUrl = url;
        generating = false;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    int id = now.millisecondsSinceEpoch;
    String photoGrapher = "Ai Generated";
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

              const SizedBox(height: 10),

              // Header
              const Text(
                "Create Something Unique",
                style: TextStyle(
                  color: Color(0xFF9C6BFF),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(text: "WallVerse "),
                    TextSpan(
                      text: "AI Studio",
                      style: TextStyle(color: Color(0xFF9C6BFF)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Generate unique wallpapers with your imagination.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),

              const SizedBox(height: 28),

              // Prompt Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF090909),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF292929)),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: promptController,
                      maxLines: 7,
                      maxLength: 500,
                      onChanged: (_) {
                        setState(() {});
                      },
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      decoration: InputDecoration(
                        hintText: "Example: A futuristic city with neon lights at night...",
                        hintStyle: const TextStyle(
                          color: Color(0xFF555555),
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: Colors.black,
                        counterText: "${promptController.text.length}/500",
                        counterStyle: const TextStyle(color: Color(0xFF555555)),
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFF292929),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFF292929),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFF7C4DFF),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Suggestions
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: suggestions.map((item) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                promptController.text = item;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF151515),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: const Color(0xFF292929),
                                ),
                              ),
                              child: Text(
                                item,
                                style: const TextStyle(
                                  color: Color(0xFFAAAAAA),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: loading ? null : generateWallpaper,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7C4DFF),
                          disabledBackgroundColor: const Color(0xFF3A3A3A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        child: loading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Generate Wallpaper ✨",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              if (generating || imageUrl != null) ...[
                const SizedBox(height: 35),

                const Text(
                  "Generated Wallpaper",
                  style: TextStyle(
                    color: Color(0xFF9C6BFF),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Your Creation",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    height: 500,
                    color: const Color(0xFF090909),
                    child: imageUrl == null
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF7C4DFF),
                            ),
                          )
                        : Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }

                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF7C4DFF),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Text(
                                  "Failed to load image",
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            },
                          ),
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await aiViewModel.addToFavourite(
                            id,
                            imageUrl!,
                            photoGrapher,
                          );

                          if (aiViewModel.errorMessage == null) {
                            Fluttertoast.showToast(msg: "Added to favourites");
                          } else {
                            Fluttertoast.showToast(
                              msg: aiViewModel.errorMessage!,
                            );
                          }
                        },
                        icon: const Icon(Icons.favorite_border, size: 19),
                        label: const Text("Favourite"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFF292929)),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Open image
                        },
                        icon: const Icon(Icons.open_in_new, size: 18),
                        label: const Text("Open Image"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFF292929)),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
