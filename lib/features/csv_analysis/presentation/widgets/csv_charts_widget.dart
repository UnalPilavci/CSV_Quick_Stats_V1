import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/csv_stats.dart';
import '../../data/models/csv_stats_model.dart';
import 'stat_card.dart';

class CsvChartsWidget extends StatefulWidget {
  final CsvStats stats;

  const CsvChartsWidget({super.key, required this.stats});

  @override
  State<CsvChartsWidget> createState() => _CsvChartsWidgetState();
}

class _CsvChartsWidgetState extends State<CsvChartsWidget> {
  int? selectedColumnIndex;

  @override
  Widget build(BuildContext context) {
    final int total = widget.stats.totalCellCount;
    final int empty = widget.stats.nullCount;
    final int filled = total - empty;
    final double filledPercentage = (total > 0) ? (filled / total) * 100 : 0;
    Color mainColor = filledPercentage > 80
        ? const Color(0xFF08F7AF)
        : (filledPercentage > 50 ? Colors.amberAccent : const Color(
        0xFFFF2E63));

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _buildChartCard(filled, empty, filledPercentage, mainColor, total),
          const SizedBox(height: 24),
          _buildBarChartSection(),
          if (selectedColumnIndex != null) _buildColumnDetailCard(),

          const SizedBox(height: 32),
          const Text(
            "VERİ DAĞILIM TERMİNALİ",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00F2FF),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: [
              StatCard(
                title: "TOPLAM KAYIT",
                value: widget.stats.rowCount.toString(),
                icon: Icons.analytics_rounded,
                color: const Color(0xFF00F2FF),
              ),
              StatCard(
                title: "BOŞ HÜCRE",
                value: widget.stats.nullCount.toString(),
                icon: Icons.error_outline_rounded,
                color: const Color(0xFFFF2E63),
              ),
              StatCard(
                title: "YİNELENEN",
                value: widget.stats.duplicateRowCount.toString(),
                icon: Icons.content_copy_rounded,
                color: Colors.orangeAccent,
              ),
              StatCard(
                title: "BOŞ KOLON",
                value: widget.stats.emptyColumnCount.toString(),
                icon: Icons.view_column_outlined,
                color: Colors.white38,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildFileInfoBar(),
        ],
      ),
    );
  }

  Widget _buildBarChartSection() {
    final double maxY = widget.stats.columnNullCounts.isEmpty
        ? 10
        : (widget.stats.columnNullCounts.reduce((a, b) => a > b ? a : b) + 2)
        .toDouble();

    final double chartWidth = widget.stats.headers.length * 70.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 360,
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
              const Row(
                children: [
                  Icon(Icons.bar_chart_rounded, color: Color(0xFF00F2FF),
                      size: 18),
                  SizedBox(width: 8),
                  Text(
                    "SÜTUN BAZLI EKSİK VERİ ANALİZİ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00F2FF),
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: SizedBox(
                    width: chartWidth < 400 ? 400 : chartWidth,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: maxY,
                        barTouchData: BarTouchData(
                          handleBuiltInTouches: true,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: const Color(0xFF161B22).withValues(
                                alpha: 0.9),
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                "${rod.toY.toInt()} BOŞ HÜCRE",
                                const TextStyle(
                                  color: Color(0xFF00F2FF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                int index = value.toInt();
                                if (index < 0 ||
                                    index >= widget.stats.headers.length)
                                  return const SizedBox();
                                bool isSelected = selectedColumnIndex == index;

                                return GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    setState(() {
                                      selectedColumnIndex =
                                      isSelected ? null : index;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    child: Icon(
                                      isSelected ? Icons.visibility : Icons
                                          .visibility_off,
                                      color: isSelected ? const Color(
                                          0xFF00F2FF) : Colors.white24,
                                      size: 24,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 45,
                              getTitlesWidget: (value, meta) {
                                int index = value.toInt();
                                if (index < 0 ||
                                    index >= widget.stats.headers.length)
                                  return const SizedBox();
                                bool isSelected = selectedColumnIndex == index;
                                return Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Transform.rotate(
                                    angle: -0.4,
                                    child: Text(
                                      widget.stats.headers[index].length > 10
                                          ? "${widget.stats.headers[index]
                                          .substring(0, 8)}.."
                                          : widget.stats.headers[index],
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isSelected ? const Color(
                                            0xFF00F2FF) : Colors.white38,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(widget.stats.columnNullCounts
                            .length, (i) {
                          final double val = widget.stats.columnNullCounts[i]
                              .toDouble();
                          final bool isSelected = selectedColumnIndex == i;
                          final Color barColor = isSelected
                              ? const Color(0xFF00F2FF)
                              : (val > 0
                              ? const Color(0xFFFF2E63)
                              : const Color(0xFF08F7AF));

                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: val == 0 ? 0.2 : val,
                                color: barColor,
                                width: 22,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(6)),
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: maxY,
                                  color: Colors.white.withValues(alpha: 0.05),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildColumnDetailCard() {
    final profile = (widget.stats as CsvStatsModel).getColumnProfile(
        selectedColumnIndex!);
    final String colName = widget.stats.headers[selectedColumnIndex!];

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF00F2FF).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: const Color(0xFF00F2FF).withValues(alpha: 0.2),
                width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                          Icons.insights_rounded, color: Color(0xFF00F2FF),
                          size: 20),
                      const SizedBox(width: 10),
                      Text(colName.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2)),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                        Icons.close, size: 18, color: Colors.white38),
                    onPressed: () => setState(() => selectedColumnIndex = null),
                  )
                ],
              ),
              const Divider(height: 24, color: Colors.white10),
              Wrap(
                spacing: 24,
                runSpacing: 16,
                children: [
                  _detailItem("VERİ TİPİ", profile['type']),
                  _detailItem("BENZERSİZ", profile['unique'].toString()),
                  if (profile['type'] == 'Sayısal') ...[
                    _detailItem("ORTALAMA", profile['avg']),
                    _detailItem(
                        "ARALIK", "${profile['min']} - ${profile['max']}"),
                  ] else
                    ...[
                      _detailItem("EN SIK DEĞER", profile['mostCommon']),
                    ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10,
            color: Color(0xFF00F2FF),
            fontWeight: FontWeight.bold,
            letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
      ],
    );
  }
  Widget _buildChartCard(int filled, int empty, double percentage, Color color,
      int total) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              SizedBox(
                height: 140,
                width: 140,
                child: Stack(
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 6,
                        centerSpaceRadius: 45,
                        sections: [
                          PieChartSectionData(
                            value: filled.toDouble(),
                            title: "",
                            color: color,
                            radius: 18,
                            badgeWidget: _badgeGlow(color),
                            badgePositionPercentageOffset: 0.9,
                          ),
                          PieChartSectionData(
                            value: empty.toDouble(),
                            title: "",
                            color: Colors.white12,
                            radius: 14,
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "%${percentage.toStringAsFixed(0)}",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: color,
                                shadows: [
                                  Shadow(color: color.withValues(alpha: 0.5),
                                      blurRadius: 10)
                                ]
                            ),
                          ),
                          const Text("SİSTEM DURUMU", style: TextStyle(
                              fontSize: 8,
                              color: Colors.white38,
                              letterSpacing: 1)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("VERİ SAĞLIĞI",
                        style: TextStyle(fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5)),
                    const SizedBox(height: 16),
                    _indicator(color, "DOLU HÜCRE", "$filled"),
                    const SizedBox(height: 10),
                    _indicator(Colors.white12, "BOŞ HÜCRE", "$empty"),
                    const Divider(height: 32, color: Colors.white10),
                    Text(
                      "TOPLAM $total VERİ NOKTASI TARANDI",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 9, color: Colors.white24, letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badgeGlow(Color color) =>
      Container(
        width: 6, height: 6,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color,
            boxShadow: [
              BoxShadow(color: color, blurRadius: 10, spreadRadius: 2)
            ]),
      );

  Widget _indicator(Color color, String text, String value) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: Colors.white60, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
  Widget _buildFileInfoBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF00F2FF).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: const Color(0xFF00F2FF).withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            const Icon(
                Icons.terminal_rounded, size: 18, color: Color(0xFF00F2FF)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "${widget.stats.fileName.toUpperCase()} // ${widget.stats
                    .fileSize}",
                style: const TextStyle(fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white38,
                    letterSpacing: 1),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
