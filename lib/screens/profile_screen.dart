import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:wallverse/screens/full_screen_wallpaper.dart';
import 'package:wallverse/screens/login_screen.dart';
import 'package:wallverse/screens/side_drawer.dart';
import 'package:wallverse/viewModels/profile_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileViewModel profileViewModel = ProfileViewModel();

  @override
  void initState() {
    super.initState();
    profileViewModel.addListener(profileListener);
    profileViewModel.getUserProfile();
  }

  void profileListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    profileViewModel.removeListener(profileListener);
    profileViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = profileViewModel.profile;
    if (profile == null || profileViewModel.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF080808),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    String userName = profile.name;
    String email = profile.email;
    int totalFavourites = profile.totalFavourites;
    int totalUploads = profile.totalUploads;
    final formattedDate = DateFormat('MMMM yyyy')
        .format(DateTime.parse(profile.memberSince));
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
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              profileViewModel.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF101010),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF292929)),
              ),
              child: Column(
                children: [
                  Container(
                    height: 82,
                    width: 82,
                    decoration: const BoxDecoration(
                      color: Color(0xFF7C4DFF),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        userName[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    userName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    email,
                    style: TextStyle(color: Color(0xFF999999), fontSize: 14),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Member since ${formattedDate}",
                    style: TextStyle(color: Color(0xFF666666), fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Stats
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    totalFavourites.toString(),
                    "Favourites",
                    Icons.favorite_border,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _statCard(
                    totalUploads.toString(),
                    "Uploads",
                    Icons.cloud_upload_outlined,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            const Text(
              "My Uploads",
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            if (profileViewModel.profile == null ||
                profileViewModel.profile!.userUploads.isEmpty)
              const Padding(
                padding: EdgeInsets.all(0),
                child: Text(
                  "No posts yet",
                  style: TextStyle(color: Colors.white),
                ),
              )
            else
              // Posts grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: profileViewModel.profile!.userUploads.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.68,
                ),
                itemBuilder: (context, index) {
                  final uploads = profile.userUploads[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF101010),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFF292929)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // Placeholder image
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreenWallpaper(
                                    imageUrl: uploads.imageUrl,
                                  ),
                                ),
                              );
                            },
                            child: Image.network(
                              uploads.imageUrl,
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

                        // Delete button
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  backgroundColor: const Color(0xFF18181B),
                                  title: const Text(
                                    'Are you sure?',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: const Text(
                                    'This action will remove the post from community contribution',
                                    style: TextStyle(color: Color(0xFFA1A1AA)),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Color(0xFFA855F7),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: profileViewModel.clickLoader
                                          ? null
                                          : () async {
                                              await profileViewModel.deletePost(
                                                uploads.id,
                                              );

                                              if (profileViewModel
                                                      .errorMessage ==
                                                  null) {
                                                profileViewModel
                                                    .deletePostLocally(
                                                      uploads.id,
                                                    );

                                                Fluttertoast.showToast(
                                                  msg: "Post deleted",
                                                );

                                                Navigator.pop(
                                                  context,
                                                ); // close dialog
                                              } else {
                                                Fluttertoast.showToast(
                                                  msg: profileViewModel
                                                      .errorMessage!,
                                                );
                                              }
                                            },
                                      child: profileViewModel.clickLoader
                                          ? const SizedBox(
                                              height: 22,
                                              width: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Text(
                                              'OK',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF3F3F46),
                                ),
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                                size: 17,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String count, String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF101010),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF292929)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF9C6BFF), size: 23),

          const SizedBox(height: 7),

          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            title,
            style: const TextStyle(color: Color(0xFF777777), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
