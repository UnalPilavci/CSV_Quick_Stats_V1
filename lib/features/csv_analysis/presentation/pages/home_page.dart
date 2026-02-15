import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/di/injection.dart';
import '../cubit/home_cubit.dart';
import '../widgets/csv_charts_widget.dart';
import '../widgets/csv_table_widget.dart';
import '../../../../core/widgets/app_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeCubit>(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: const Color(0xFF080B12),
          drawer: const AppDrawer(),
          appBar: AppBar(
            title: const Text(
              "VERİ TERMİNALİ",
              style: TextStyle(
                color: Color(0xFF00F2FF),
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Color(0xFF00F2FF)),
            bottom: TabBar(
              indicatorColor: const Color(0xFF00F2FF),
              labelColor: const Color(0xFF00F2FF),
              unselectedLabelColor: Colors.white24,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: const [
                Tab(icon: Icon(Icons.dashboard_rounded), text: "ÖZET"),
                Tab(icon: Icon(Icons.table_chart_rounded), text: "TABLO"),
              ],
            ),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.upload_file, color: Color(0xFF00F2FF)),
                  tooltip: "Yeni Dosya Yükle",
                  onPressed: () => context.read<HomeCubit>().pickCsvFile(),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              Positioned(
                bottom: -100,
                right: -100,
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

              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFF00F2FF)),
                    );
                  }

                  if (state is HomeError) {
                    return Center(
                      child: _buildGlassContainer(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline, size: 48, color: Color(0xFFFF2E63)),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 16),
                            _buildNeonButton(
                              text: "Tekrar Dene",
                              onPressed: () => context.read<HomeCubit>().reset(),
                              color: const Color(0xFFFF2E63),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is HomeLoaded) {
                    return TabBarView(
                      children: [
                        CsvChartsWidget(stats: state.stats),
                        CsvTableWidget(headers: state.stats.headers, rows: state.stats.rows),
                      ],
                    );
                  }
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: _buildGlassContainer(
                        onTap: () => context.read<HomeCubit>().pickCsvFile(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.analytics_outlined, size: 80, color: Color(0xFF00F2FF)),
                            const SizedBox(height: 24),
                            const Text(
                              "ANALİZ İÇİN VERİ SETİ SEÇİN",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildNeonButton(
                              text: "CSV YÜKLE",
                              onPressed: () => context.read<HomeCubit>().pickCsvFile(),
                              color: const Color(0xFF00F2FF),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildGlassContainer({required Widget child, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF00F2FF).withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
  Widget _buildNeonButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          side: BorderSide(color: color, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
    );
  }
}