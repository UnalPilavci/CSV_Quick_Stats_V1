import 'dart:ui';
import 'package:flutter/material.dart';

class QuickStatsRegister extends StatefulWidget {
  const QuickStatsRegister({super.key});

  @override
  State<QuickStatsRegister> createState() => _QuickStatsRegisterState();
}

class _QuickStatsRegisterState extends State<QuickStatsRegister> {
  String _usagePurpose = 'Bireysel';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080B12),
      appBar: AppBar(
        title: const Text("Analist Profili Oluştur", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: -50,
            left: -50,
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
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Kişisel Bilgiler"),
                const SizedBox(height: 16),
                _buildGlassField("Tam Adınız", Icons.person_outline),
                _buildGlassField("E-posta Adresi", Icons.email_outlined),
                _buildGlassField("Telefon", Icons.phone_android_outlined),

                const SizedBox(height: 24),
                _buildSectionTitle("Profesyonel Bilgiler"),
                const SizedBox(height: 16),
                _buildGlassField("Şirket / Kurum Adı", Icons.business_outlined),
                _buildGlassField("Meslek / Rol (Örn: Data Analyst)", Icons.work_outline),

                const SizedBox(height: 16),
                const Text("Kullanım Amacı", style: TextStyle(fontSize: 14, color: Colors.white60)),
                const SizedBox(height: 8),
                _buildGlassDropdown(),

                const SizedBox(height: 24),
                _buildSectionTitle("Güvenlik"),
                const SizedBox(height: 16),
                _buildGlassField("Şifre", Icons.lock_outline, isPassword: true),
                _buildGlassField("Şifre Tekrar", Icons.lock_reset_outlined, isPassword: true),

                const SizedBox(height: 40),
                _buildNeonButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00F2FF), letterSpacing: 1),
    );
  }

  Widget _buildGlassField(String label, IconData icon, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.2),
            ),
            child: TextFormField(
              obscureText: isPassword,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(color: Colors.white54, fontSize: 14),
                prefixIcon: Icon(icon, color: const Color(0xFF00F2FF), size: 22),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassDropdown() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.2),
          ),
          child: DropdownButtonFormField<String>(
            dropdownColor: const Color(0xFF161B22),
            initialValue: _usagePurpose,
            style: const TextStyle(color: Colors.white),
            items: ['Bireysel', 'Akademik', 'Ticari'].map((e) =>
                DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) => setState(() => _usagePurpose = val!),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNeonButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00F2FF).withValues(alpha: 0.3),
            blurRadius: 15,
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
        onPressed: () {},
        child: const Text(
          "Hesabı Oluştur ve Başla",
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}