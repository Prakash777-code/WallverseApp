import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallverse/screens/full_screen_wallpaper.dart';
import 'package:wallverse/screens/login_screen.dart';
import 'package:wallverse/screens/profile_screen.dart';
import 'package:wallverse/screens/side_drawer.dart';
import 'package:wallverse/viewModels/auth_view_model.dart';
import 'package:wallverse/viewModels/home_viewModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  final homeViewModel = HomeViewmodel();
  final authViewModel = AuthViewmodel();
  final scrollController = ScrollController();

  void searchWallpapers() {
    String query = searchController.text.trim();
    if (query.isEmpty) {
      return;
    }
    print('Searching for: $query');
    homeViewModel.getWallpapers(query);
  }

  @override
  void initState() {
    super.initState();
    homeViewModel.addListener(wallpaperListener);
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 0.7) {
        homeViewModel.loadMoreWallpapers();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserAuthentication();
    });
  }

  void wallpaperListener() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> checkUserAuthentication() async {
    await authViewModel.checkAuthentication();
    if (!mounted) {
      return;
    }
    if (!authViewModel.isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const LoginScreen();
          },
        ),
      );
      return;
    }
    await homeViewModel.getWallpapers("nature");
  }

  Widget filterButton(String title) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ElevatedButton(
        onPressed: () {
          homeViewModel.getWallpapers(title.toString().trim());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF18181B),
          foregroundColor: const Color(0xFFA1A1AA),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF27272A)),
          ),
        ),
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      ),
    );
  }

  @override
  void dispose() {
    homeViewModel.removeListener(wallpaperListener);
    homeViewModel.dispose();
    searchController.dispose();
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
          'WallVerse',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            icon: const Icon(Icons.person_2_outlined),
          ),
        ],
      ),

      body: homeViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFF18181B),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFF27272A),
                              ),
                            ),
                            child: TextField(
                              controller: searchController,
                              style: const TextStyle(color: Colors.white),
                              cursorColor: const Color(0xFFA855F7),
                              decoration: const InputDecoration(
                                hintText: 'Search wallpapers...',
                                hintStyle: TextStyle(color: Color(0xFF71717A)),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Color(0xFF71717A),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              onSubmitted: (value) {
                                searchWallpapers();
                              },
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: searchWallpapers,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9333EA),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Search',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        filterButton('All'),
                        filterButton('Nature'),
                        filterButton('Cars'),
                        filterButton('Anime'),
                        filterButton('Abstract'),
                        filterButton('Space'),
                        filterButton('Animals'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      controller: scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.68,
                          ),
                      itemCount: homeViewModel.wallpapers.length,
                      itemBuilder: (context, index) {
                        final wallpaper = homeViewModel.wallpapers[index];

                        bool isFavourite = false;

                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF09090B),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF27272A)),
                          ),
                          clipBehavior: Clip.antiAlias,

                          // IMAGE NOW TAKES THE ENTIRE CARD
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FullScreenWallpaper(
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

                              // BOTTOM GRADIENT + PHOTOGRAPHER
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                    12,
                                    30,
                                    12,
                                    12,
                                  ),
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black87,
                                      ],
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.white70,
                                        size: 15,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          wallpaper.photographer,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // FAVOURITE BUTTON
                              Positioned(
                                top: 10,
                                right: 10,
                                child: GestureDetector(
                                  onTap: () async {
                                    await homeViewModel.addToFavourite(
                                      wallpaper.wallpaperId,
                                      wallpaper.imageUrl,
                                      wallpaper.photographer,
                                    );

                                    if (homeViewModel.errorMessage == null) {
                                      Fluttertoast.showToast(
                                        msg: "Added to favourites",
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: homeViewModel.errorMessage!,
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: 38,
                                    width: 38,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: 0.65,
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF3F3F46),
                                      ),
                                    ),
                                    child: Icon(
                                      isFavourite
                                          ? Icons.favorite
                                          : Icons.favorite,
                                      color: isFavourite
                                          ? const Color(0xFFA855F7)
                                          : Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
