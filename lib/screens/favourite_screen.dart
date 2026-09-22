import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallverse/screens/full_screen_wallpaper.dart';
import 'package:wallverse/screens/side_drawer.dart';
import 'package:wallverse/viewModels/favourites_view_model.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() {
    return _FavouriteScreenState();
  }
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final favouriteViewModel = FavouritesViewModel();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    favouriteViewModel.addListener(favouritesListener);
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 0.9) {
        await favouriteViewModel.loadMoreFavouriteWallpapers();
      }
    });
    favouriteViewModel.getFavouriteWallpaper();
  }

  void favouritesListener() {
    print(
      "SCREEN LIST LENGTH: ${favouriteViewModel.favouriteWallpapers.length}",
    );
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    favouriteViewModel.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),

      drawer: SideDrawer(
        onClose: () {
          Navigator.pop(context);
        },
      ),

      appBar: AppBar(
        backgroundColor: const Color(0xFF080808),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'My Favourites',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: favouriteViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : favouriteViewModel.favouriteWallpapers.isEmpty
          ? const Center(
              child: Text(
                "No Favourites yet",
                style: TextStyle(color: Colors.white),
              ),
            )
          : GridView.builder(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 14,
                childAspectRatio: 0.68,
              ),
              itemCount: favouriteViewModel.favouriteWallpapers.length,
              itemBuilder: (context, index) {
                final wallpaper = favouriteViewModel.favouriteWallpapers[index];
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF09090B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF27272A)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullScreenWallpaper(
                                        imageUrl: wallpaper.imageUrl,
                                      ),
                                    ),
                                  );
                                },
                                child: Image.network(
                                  wallpaper.imageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }

                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: Color(0xFFA855F7),
                                          ),
                                        );
                                      },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(
                                        Icons.broken_image_outlined,
                                        color: Color(0xFF71717A),
                                        size: 35,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: () async {
                                  await favouriteViewModel.removeFromFavourites(
                                    int.parse(wallpaper.wallpaperId),
                                  );
                                  if (favouriteViewModel.errorMessage == null) {
                                    Fluttertoast.showToast(
                                      msg: "Removed from favourites",
                                    );
                                    favouriteViewModel.removeWallpaperLocally(
                                      int.parse(wallpaper.wallpaperId),
                                    );
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: favouriteViewModel.errorMessage!,
                                    );
                                  }
                                },
                                child: Container(
                                  height: 38,
                                  width: 38,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.65),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF3F3F46),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
