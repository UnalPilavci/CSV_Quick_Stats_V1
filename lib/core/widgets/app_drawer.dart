import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../features/csv_analysis/presentation/pages/about_page.dart';
import '../../features/csv_analysis/presentation/pages/comparison_page.dart';
import '../../features/csv_analysis/presentation/pages/home_page.dart';
import '../../features/csv_analysis/presentation/pages/login_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    double drawerWidth = MediaQuery.of(context).size.width * 0.70;

    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        backgroundColor: const Color(0xFF080B12).withValues(alpha: 0.98),
        child: Column(
          children: [
            Container(
              height: 250,
              padding: const EdgeInsets.only(top: 50, bottom: 20),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFF00F2FF), width: 0.3)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF080B12),
                    Color(0xFF10141C),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withValues(alpha: 0.3),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00F2FF).withValues(alpha: 0.15),
                            blurRadius: 20,
                            spreadRadius: 1,
                          )
                        ],
                        border: Border.all(color: const Color(0xFF00F2FF).withValues(alpha: 0.5), width: 1),
                      ),
                      child: ClipOval(
                        child: Lottie.asset(
                          'assets/animations/animation2.json',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.analytics_rounded, color: Color(0xFF00F2FF), size: 40);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "QUICK STATS",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 3,
                        shadows: [
                          Shadow(color: Color(0xFF00F2FF), blurRadius: 15)
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "SYSTEM ONLINE",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF08F7AF).withValues(alpha: 0.8),
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                children: [
                  _buildSideAlignedItem(
                    context: context,
                    icon: Icons.home_rounded,
                    title: "ANASAYFA",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildSideAlignedItem(
                    context: context,
                    icon: Icons.compare_arrows_rounded,
                    title: "KARŞILAŞTIRMA",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ComparisonPage()));
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildSideAlignedItem(
                    context: context,
                    icon: Icons.info_outline_rounded,
                    title: "HAKKINDA",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage()));
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 0.5, color: Colors.white10),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
              child: _buildSideAlignedItem(
                context: context,
                icon: Icons.logout_rounded,
                title: "ÇIKIŞ YAP",
                isExit: true,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildSideAlignedItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isExit = false,
  }) {
    Color themeColor = isExit ? const Color(0xFFFF2E63) : const Color(0xFF00F2FF);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 52,
        padding: const EdgeInsets.only(left: 20, right: 10),
        decoration: BoxDecoration(
          color: themeColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: themeColor.withValues(alpha: 0.15), width: 0.8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: themeColor, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: isExit ? themeColor : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}