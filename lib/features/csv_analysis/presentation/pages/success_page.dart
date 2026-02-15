import 'dart:ui';
import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080B12),
      body: Stack(
        children: [
          Positioned(
            top: 200,
            right: -50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF08F7AF).withValues(alpha: 0.1),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF08F7AF).withValues(alpha: 0.5), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF08F7AF).withValues(alpha: 0.2),
                        blurRadius: 40,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check_circle_outline_rounded, size: 80, color: Color(0xFF08F7AF)),
                ),
                const SizedBox(height: 40),

                const Text(
                  "Talimat Gönderildi!",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Şifre sıfırlama talimatları e-posta adresine başarıyla iletildi. Lütfen gelen kutunu kontrol et.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white60, fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 60),
                _buildOutlineButton(
                  text: "Giriş Ekranına Dön",
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlineButton({required String text, required VoidCallback onPressed}) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF00F2FF),
        side: const BorderSide(color: Color(0xFF00F2FF), width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}