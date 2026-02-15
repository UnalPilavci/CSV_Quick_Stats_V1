import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ColumnQualityChart extends StatelessWidget {
  final List<String> headers;
  final List<int> nullCounts;

  const ColumnQualityChart({super.key, required this.headers, required this.nullCounts});

  @override
  Widget build(BuildContext context) {
    final double maxVal = nullCounts.isEmpty
        ? 10
        : (nullCounts.reduce((a, b) => a > b ? a : b) + 1).toDouble();

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 300,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFF00F2FF).withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.analytics_outlined, color: Color(0xFF00F2FF), size: 20),
                  const SizedBox(width: 10),
                  const Text(
                    "SÜTUN BAZLI HATA ANALİZİ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00F2FF),
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxVal,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: const Color(0xFF161B22).withValues(alpha: 0.9),
                        tooltipRoundedRadius: 8,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            "${headers[group.x.toInt()]}\n",
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: "${rod.toY.toInt()} Hatalı Hücre",
                                style: const TextStyle(color: Color(0xFF00F2FF)),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index < 0 || index >= headers.length) return const SizedBox();
                            return Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Transform.rotate(
                                angle: -0.4,
                                child: Text(
                                  headers[index],
                                  style: const TextStyle(fontSize: 10, color: Colors.white38, fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          },
                          reservedSize: 45,
                        ),
                      ),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(nullCounts.length, (i) {
                      final Color barColor = nullCounts[i] > 0
                          ? const Color(0xFFFF2E63)
                          : const Color(0xFF08F7AF);

                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: nullCounts[i].toDouble(),
                            color: barColor,
                            width: 14,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: maxVal,
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                            gradient: LinearGradient(
                              colors: [barColor, barColor.withValues(alpha: 0.7)],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}