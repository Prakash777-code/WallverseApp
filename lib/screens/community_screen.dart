import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallverse/screens/full_screen_wallpaper.dart';
import 'package:wallverse/screens/side_drawer.dart';
import 'package:wallverse/viewModels/community_view_model.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() {
    return _CommunityScreenState();
  }
}

class _CommunityScreenState extends State<CommunityScreen> {
  final communityViewModel = CommunityViewModel();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    communityViewModel.addListener(communityListener);
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 0.9) {
        await communityViewModel.loadNextPage();
      }
    });
    communityViewModel.getCommunityWallpapers();
  }

  void communityListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    communityViewModel.removeListener(communityListener);
    communityViewModel.dispose();
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
          'Community Wallpapers',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: communityViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              controller: scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 14,
                childAspectRatio: 0.55,
              ),

              itemCount: communityViewModel.communityWallpapers.length,

              itemBuilder: (context, index) {
                final wallpaper = communityViewModel.communityWallpapers[index];
                final isLiked = communityViewModel.likedIds.contains(
                  wallpaper.id,
                );
                final isFavourite = communityViewModel.favouriteIds.contains(
                  wallpaper.id,
                );
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF09090B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF27272A)),
                  ),
                  clipBehavior: Clip.antiAlias,

                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            // Full-size image
                            Positioned.fill(
                              child: GestureDetector(
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Download Image'),
                                        content: const Text(
                                          'Do you want to download this image?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              communityViewModel.downloadImage(
                                                wallpaper.imageUrl,
                                              );
                                              Navigator.pop(context);
                                              if (communityViewModel
                                                      .errorMessage ==
                                                  null) {
                                                Fluttertoast.showToast(
                                                  msg: "Downloaded",
                                                );
                                              } else {
                                                Fluttertoast.showToast(
                                                  msg: communityViewModel
                                                      .errorMessage!,
                                                );
                                              }
                                            },
                                            child: const Text('Download'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                onDoubleTap: () async {
                                  if (!isLiked) {
                                    await communityViewModel.likePost(
                                      wallpaper.id,
                                    );
                                    if (communityViewModel.errorMessage !=
                                        null) {
                                      Fluttertoast.showToast(
                                        msg: communityViewModel.errorMessage!,
                                      );
                                      return;
                                    }
                                    wallpaper.likes++;
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "Post was already liked",
                                    );
                                  }
                                },
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

                            // Dark gradient at bottom
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              height: 80,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.85),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Bookmark
                            Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: () async {
                                  if (isFavourite) {
                                    await communityViewModel
                                        .removeFromFavourites(wallpaper.id);
                                    if (communityViewModel.errorMessage !=
                                        null) {
                                      Fluttertoast.showToast(
                                        msg: communityViewModel.errorMessage!,
                                      );
                                    }
                                  } else {
                                    await communityViewModel.addToFavourite(
                                      wallpaper.id,
                                      wallpaper.imageUrl,
                                      wallpaper.userName,
                                    );
                                    if (communityViewModel.errorMessage !=
                                        null) {
                                      Fluttertoast.showToast(
                                        msg: communityViewModel.errorMessage!,
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  height: 38,
                                  width: 38,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.65),
                                    shape: BoxShape.circle,
                                  ),

                                  child: Icon(
                                    isFavourite
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: isFavourite
                                        ? const Color(0xFFA855F7)
                                        : Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),

                            Positioned(
                              left: 10,
                              right: 10,
                              bottom: 8,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      wallpaper.userName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: communityViewModel.isLiking
                                            ? null
                                            : () async {
                                                if (isLiked) {
                                                  await communityViewModel
                                                      .unlikePost(wallpaper.id);
                                                  if (communityViewModel
                                                          .errorMessage !=
                                                      null) {
                                                    Fluttertoast.showToast(
                                                      msg: communityViewModel
                                                          .errorMessage!,
                                                    );
                                                    return;
                                                  }
                                                  if (wallpaper.likes > 0) {
                                                    wallpaper.likes--;
                                                  }
                                                } else {
                                                  await communityViewModel
                                                      .likePost(wallpaper.id);
                                                  if (communityViewModel
                                                          .errorMessage !=
                                                      null) {
                                                    Fluttertoast.showToast(
                                                      msg: communityViewModel
                                                          .errorMessage!,
                                                    );
                                                    return;
                                                  }
                                                  wallpaper.likes++;
                                                }
                                              },
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(
                                          minWidth: 30,
                                          minHeight: 35,
                                        ),
                                        icon: Icon(
                                          isLiked
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: isLiked
                                              ? Colors.red
                                              : Colors.white,
                                          size: 22,
                                        ),
                                      ),
                                      Text(
                                        wallpaper.likes.toString(),
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
