import 'dart:ui';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080B12),
      appBar: AppBar(
        title: const Text(
          "TERMİNAL BİLGİSİ",
          style: TextStyle(color: Color(0xFF00F2FF), fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00F2FF).withValues(alpha: 0.1),
                ),
              ),
            ),
          ),

          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00F2FF).withValues(alpha: 0.3),
                              blurRadius: 40,
                            )
                          ],
                        ),
                        child: const Icon(Icons.bar_chart_rounded, size: 100, color: Color(0xFF00F2FF)),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "CSV Quick Stats",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const Text(
                        "Versiyon 1.0.0",
                        style: TextStyle(color: Colors.white38, letterSpacing: 1),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Geliştirici"),
                      const SizedBox(height: 12),
                      _buildGlassCard(
                        child: const ListTile(
                          leading: Icon(Icons.code_rounded, color: Color(0xFF00F2FF)),
                          title: Text("Ünal", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            "Flutter Developer",
                            style: TextStyle(color: Colors.white60),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),
                      _buildSectionTitle("Kullanılan Teknolojiler"),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _buildTechChip("Flutter"),
                          _buildTechChip("Dart"),
                          _buildTechChip("Clean Architecture"),
                          _buildTechChip("Cubit / BLoC"),
                          _buildTechChip("CSV Engine"),
                        ],
                      ),

                      const SizedBox(height: 32),
                      _buildSectionTitle("Sistem Amacı"),
                      const SizedBox(height: 12),
                      _buildGlassCard(
                        padding: const EdgeInsets.all(16),
                        child: const Text(
                          "CSV Quick Stats, karmaşık veri setlerini saniyeler içinde analiz etmeniz, temel istatistikleri çıkarmanız ve veriler arası karşılaştırmalar yapmanız için geliştirilmiştir.",
                          style: TextStyle(fontSize: 15, height: 1.6, color: Colors.white70),
                        ),
                      ),

                      const SizedBox(height: 60),
                      const Center(
                        child: Column(
                          children: [
                            Text(
                              "<---->",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white24,
                                letterSpacing: 2,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "EST. 2026",
                              style: TextStyle(color: Colors.white12, fontSize: 12),
                            ),
                          ],
                        ),
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
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF00F2FF),
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildGlassCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildTechChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF00F2FF).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF00F2FF).withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF00F2FF),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}