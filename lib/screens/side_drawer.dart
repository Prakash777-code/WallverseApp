import 'package:flutter/material.dart';
import 'package:wallverse/screens/ai_screen.dart';
import 'package:wallverse/screens/community_screen.dart';
import 'package:wallverse/screens/downloads_screen.dart';
import 'package:wallverse/screens/favourite_screen.dart';
import 'package:wallverse/screens/home_screen.dart';
import 'package:wallverse/screens/profile_screen.dart';
import 'package:wallverse/screens/upload_screen.dart';

class SideDrawer extends StatelessWidget {
  final VoidCallback onClose;

  const SideDrawer({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF080808),
      width: 290,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFF27272A))),
              ),
              child: Row(
                children: [
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9333EA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        '◈',
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'WallVerse',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onClose,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF18181B),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF3F3F46)),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 23,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'MENU',
                        style: TextStyle(
                          color: Color(0xFF52525B),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    _drawerItem(
                      context,
                      icon: Icons.home_outlined,
                      title: 'Home',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const HomeScreen();
                            },
                          ),
                        );
                      },
                    ),

                    _drawerItem(
                      context,
                      icon: Icons.favorite_border,
                      title: 'Favourites',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const FavouriteScreen();
                            },
                          ),
                        );
                      },
                    ),

                    _drawerItem(
                      context,
                      icon: Icons.auto_awesome,
                      title: 'AI Generated',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const AiScreen();
                            },
                          ),
                        );
                      },
                    ),
                    _drawerItem(
                      context,
                      icon: Icons.people_outline,
                      title: 'Community Wallpapers',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const CommunityScreen();
                            },
                          ),
                        );
                      },
                    ),

                    _drawerItem(
                      context,
                      icon: Icons.upload_outlined,
                      title: 'Upload Wallpaper',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const UploadWallpaperScreen();
                            },
                          ),
                        );
                      },
                    ),

                    _drawerItem(
                      context,
                      icon: Icons.person_outline,
                      title: 'Profile',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const ProfileScreen();
                            },
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF09090B),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF27272A)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              color: const Color(0x1A9333EA),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.workspace_premium_outlined,
                              color: Color(0xFFA855F7),
                              size: 22,
                            ),
                          ),

                          const SizedBox(height: 12),

                          const Text(
                            'Go Premium',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 4),

                          const Text(
                            'Unlock exclusive wallpapers and features.',
                            style: TextStyle(
                              color: Color(0xFF71717A),
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9333EA),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Upgrade Now',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFFA1A1AA), size: 21),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFA1A1AA),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
