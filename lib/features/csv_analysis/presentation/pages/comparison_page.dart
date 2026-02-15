import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../domain/entities/csv_diff_result.dart';
import '../cubit/comparison_cubit.dart';
import '../cubit/comparison_state.dart';

class ComparisonPage extends StatelessWidget {
  const ComparisonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ComparisonCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFF080B12),
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text("VERİ KIYASLAMA",
              style: TextStyle(color: Color(0xFF00F2FF), fontWeight: FontWeight.bold, letterSpacing: 2)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Color(0xFF00F2FF)),
        ),
        body: Stack(
          children: [
            Positioned(
              top: -100,
              left: -100,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF00F2FF).withValues(alpha: 0.1),
                  ),
                ),
              ),
            ),
            BlocConsumer<ComparisonCubit, ComparisonState>(
              listener: (context, state) {
                if (state is ComparisonError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: const Color(0xFFFF2E63).withValues(alpha: 0.8),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ComparisonLoading) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Color(0xFF00F2FF)),
                        SizedBox(height: 24),
                        Text("SİSTEM ANALİZ EDİLİYOR...",
                            style: TextStyle(color: Color(0xFF00F2FF), letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                }

                if (state is ComparisonSuccess) {
                  return _buildResultView(context, state.result);
                }

                return _buildInputView(context, state);
              },
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildInputView(BuildContext context, ComparisonState state) {
    String? oldName;
    String? newName;

    if (state is ComparisonFilesReady) {
      oldName = state.oldFileName;
      newName = state.newFileName;
    }

    bool isReady = oldName != null && newName != null;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.compare_arrows_rounded, size: 80, color: Color(0xFF00F2FF)),
            const SizedBox(height: 24),
            const Text(
              "DELTA ANALİZİ\nVeri setleri arasındaki farkları tespit edin.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white70, letterSpacing: 1),
            ),
            const SizedBox(height: 48),

            _buildGlassUploadCard(
              title: oldName ?? "ESKİ VERİ SETİ (V1)",
              subtitle: oldName != null ? "SİSTEME YÜKLENDİ" : "DOSYA SEÇİN",
              icon: oldName != null ? Icons.verified_user : Icons.history,
              color: oldName != null ? const Color(0xFF08F7AF) : Colors.white24,
              onTap: () => context.read<ComparisonCubit>().pickOldFile(),
            ),
            const SizedBox(height: 20),

            _buildGlassUploadCard(
              title: newName ?? "YENİ VERİ SETİ (V2)",
              subtitle: newName != null ? "SİSTEME YÜKLENDİ" : "DOSYA SEÇİN",
              icon: newName != null ? Icons.verified_user : Icons.fiber_new,
              color: newName != null ? const Color(0xFF08F7AF) : Colors.white24,
              onTap: () => context.read<ComparisonCubit>().pickNewFile(),
            ),
            const SizedBox(height: 48),

            _buildNeonButton(
              text: "KARŞILAŞTIRMAYI BAŞLAT",
              onPressed: isReady ? () => context.read<ComparisonCubit>().compareFiles() : null,
              color: const Color(0xFF00F2FF),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildResultView(BuildContext context, CsvDiffResult result) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSummaryCard("EKLENEN", result.addedRows.length, const Color(0xFF08F7AF)),
                    const SizedBox(width: 16),
                    _buildSummaryCard("SİLİNEN", result.deletedRows.length, const Color(0xFFFF2E63)),
                    const SizedBox(width: 16),
                    _buildSummaryCard("SABİT", result.commonRows.length, Colors.white60),
                  ],
                ),
              ),
            ),
          ),

          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            labelColor: const Color(0xFF00F2FF),
            unselectedLabelColor: Colors.white24,
            indicatorColor: const Color(0xFF00F2FF),
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: "EKLEMELER"),
              Tab(text: "SİLMELER"),
              Tab(text: "DEĞİŞMEYENLER"),
            ],
          ),

          Expanded(
            child: TabBarView(
              children: [
                _buildDiffTable(result.headers, result.addedRows, const Color(0xFF08F7AF)),
                _buildDiffTable(result.headers, result.deletedRows, const Color(0xFFFF2E63)),
                _buildDiffTable(result.headers, result.commonRows, Colors.white24),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildNeonButton(
              text: "YENİ ANALİZ BAŞLAT",
              onPressed: () => context.read<ComparisonCubit>().reset(),
              color: const Color(0xFF00F2FF),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSummaryCard(String label, int count, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Text(count.toString(),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color, letterSpacing: 1)),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color.withValues(alpha: 0.6), letterSpacing: 1.5)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassUploadCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14, letterSpacing: 1)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNeonButton({required String text, required VoidCallback? onPressed, required Color color}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          if (onPressed != null)
            BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 15, spreadRadius: 1),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          side: BorderSide(color: onPressed != null ? color : Colors.white10, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
      ),
    );
  }

  Widget _buildDiffTable(List<String> headers, List<List<dynamic>> rows, Color accentColor) {
    if (rows.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.data_array, size: 60, color: Colors.white10),
            const SizedBox(height: 16),
            const Text("HÜCRE BOŞ: VERİ TESPİT EDİLEMEDİ", style: TextStyle(color: Colors.white24, fontSize: 12, letterSpacing: 1)),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(accentColor.withValues(alpha: 0.1)),
            dataRowColor: WidgetStateProperty.all(Colors.white.withValues(alpha: 0.02)),
            columnSpacing: 24,
            columns: headers.map((h) => DataColumn(label: Text(h, style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 12)))).toList(),
            rows: rows.map((row) => DataRow(cells: row.map((cell) => DataCell(Text(cell.toString(), style: const TextStyle(color: Colors.white70, fontSize: 12)))).toList())).toList(),
          ),
        ),
      ),
    );
  }
}