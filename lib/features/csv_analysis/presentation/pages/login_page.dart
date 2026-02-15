import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080B12),
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00F2FF).withValues(alpha: 0.15),
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 140,
                    width: 140,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.3),
                      border: Border.all(
                        color: const Color(0xFF00F2FF).withValues(alpha: 0.6),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00F2FF).withValues(alpha: 0.25),
                          blurRadius: 50,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Lottie.asset(
                        'assets/animations/animation1.json',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.bar_chart_rounded, size: 80, color: Color(0xFF00F2FF));
                        },
                      ),
                    ),
                  ),


                  const SizedBox(height: 32),
                  const Text(
                    "CSV QUICK STATS",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          color: Color(0xFF00F2FF),
                          blurRadius: 15,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "VERİNİN GELECEĞİNE GİRİŞ YAP",
                    style: TextStyle(
                        color: const Color(0xFF00F2FF).withValues(alpha: 0.7),
                        fontSize: 12,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(height: 50),

                  _buildGlassInput(
                    label: "E-posta",
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 20),
                  _buildGlassInput(
                    label: "Şifre",
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),

                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                        );
                      },
                      child: const Text("Şifremi Unuttum", style: TextStyle(color: Color(0xFF00F2FF))),
                    ),
                  ),

                  const SizedBox(height: 30),

                  _buildNeonButton(
                    text: "GİRİŞ YAP",
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const QuickStatsRegister()),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: "Hesabın yok mu? ",
                        style: TextStyle(color: Colors.white60),
                        children: [
                          TextSpan(
                            text: "Kayıt Ol",
                            style: TextStyle(color: Color(0xFF00F2FF), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildGlassInput({required String label, required IconData icon, bool isPassword = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.5),
          ),
          child: TextFormField(
            obscureText: isPassword,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.white54),
              prefixIcon: Icon(icon, color: const Color(0xFF00F2FF)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNeonButton({required String text, required VoidCallback onPressed}) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00F2FF).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
        gradient: const LinearGradient(
          colors: [Color(0xFF00F2FF), Color(0xFF0066FF)],
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
    );
  }
}