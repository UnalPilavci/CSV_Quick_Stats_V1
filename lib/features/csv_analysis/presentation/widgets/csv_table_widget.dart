import 'dart:ui';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/home_cubit.dart';

class CsvTableWidget extends StatefulWidget {
  final List<String> headers;
  final List<List<dynamic>> rows;

  const CsvTableWidget({
    super.key,
    required this.headers,
    required this.rows,
  });

  @override
  State<CsvTableWidget> createState() => _CsvTableWidgetState();
}

class _CsvTableWidgetState extends State<CsvTableWidget> {
  bool showEmptyHighlights = true;
  bool showDuplicateHighlights = false;
  Set<int> duplicateRowIndices = {};

  @override
  void initState() {
    super.initState();
    _findDuplicates();
  }

  @override
  void didUpdateWidget(CsvTableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _findDuplicates();
  }

  void _findDuplicates() {
    duplicateRowIndices.clear();
    final Set<String> seen = {};
    for (int i = 0; i < widget.rows.length; i++) {
      final String rowString = widget.rows[i].join('|||');
      if (seen.contains(rowString)) {
        duplicateRowIndices.add(i);
      } else {
        seen.add(rowString);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.headers.isEmpty) {
      return const Center(
        child: Text(
          "GÖSTERİLECEK VERİ YOK // NULL_DATA",
          style: TextStyle(color: Colors.white24, letterSpacing: 2, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            children: [
              _buildSiberChip(
                label: "BOŞ HÜCRELER",
                isSelected: showEmptyHighlights,
                color: const Color(0xFFFF2E63),
                icon: Icons.error_outline,
                onSelected: (val) => setState(() => showEmptyHighlights = val),
              ),
              const SizedBox(width: 10),
              _buildSiberChip(
                label: "YİNELENENLER",
                isSelected: showDuplicateHighlights,
                color: Colors.orangeAccent,
                icon: Icons.copy_all,
                onSelected: (val) => setState(() => showDuplicateHighlights = val),
              ),

              const SizedBox(width: 24),
              Container(width: 1, height: 24, color: Colors.white10),
              const SizedBox(width: 24),

              _buildSiberActionButton(
                label: "KOPYALARI TEMİZLE",
                icon: Icons.cleaning_services_rounded,
                color: Colors.orangeAccent,
                onPressed: () => _confirmAction(
                  context: context,
                  title: "KOPYALARI TEMİZLE",
                  content: "Tüm yinelenen satırlar kalıcı olarak silinecek. Emin misiniz?",
                  confirmText: "TEMİZLE",
                  confirmColor: Colors.orange,
                  onConfirm: () => context.read<HomeCubit>().removeDuplicates(),
                ),
              ),
              const SizedBox(width: 10),
              _buildSiberActionButton(
                label: "CSV DIŞARI AKTAR",
                icon: Icons.download_for_offline_rounded,
                color: const Color(0xFF08F7AF),
                onPressed: () => _confirmAction(
                  context: context,
                  title: "DIŞARI AKTAR",
                  content: "Düzenlenmiş veriler CSV dosyası olarak kaydedilecek. Devam edilsin mi?",
                  confirmText: "İNDİR",
                  confirmColor: const Color(0xFF08F7AF),
                  onConfirm: () => context.read<HomeCubit>().exportCsv(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.02),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1.5),
                  ),
                  child: DataTable2(
                    columnSpacing: 15,
                    horizontalMargin: 12,
                    minWidth: 1500,
                    fixedTopRows: 1,
                    headingRowHeight: 56,
                    dataRowHeight: 48,
                    headingRowColor: WidgetStateProperty.all(const Color(0xFF161B22).withValues(alpha: 0.8)),
                    headingTextStyle: const TextStyle(
                      color: Color(0xFF00F2FF),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                    columns: [
                      const DataColumn2(
                          fixedWidth: 60,
                          label: Text("#", style: TextStyle(color: Color(0xFF00F2FF))),
                          size: ColumnSize.S
                      ),
                      ...widget.headers.asMap().entries.map((entry) {
                        final int colIndex = entry.key;
                        final String headerTitle = entry.value;

                        return DataColumn2(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Text(
                                  headerTitle.toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(fontSize: 12, letterSpacing: 0.5),
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(Icons.close_rounded, size: 16, color: Color(0xFFFF2E63)),
                                onPressed: () => _confirmAction(
                                  context: context,
                                  title: "SÜTUNU SİL",
                                  content: "'$headerTitle' sütunu kalıcı olarak silinecek. Emin misiniz?",
                                  confirmText: "SİL",
                                  confirmColor: const Color(0xFFFF2E63),
                                  onConfirm: () => context.read<HomeCubit>().deleteColumn(colIndex),
                                ),
                              ),
                            ],
                          ),
                          size: ColumnSize.L,
                        );
                      }).toList(),
                      const DataColumn2(
                          fixedWidth: 50,
                          label: Icon(Icons.delete_sweep_rounded, color: Color(0xFFFF2E63), size: 20),
                          size: ColumnSize.S
                      ),
                    ],
                    rows: List.generate(widget.rows.length, (index) {
                      final row = widget.rows[index];
                      final isDuplicate = duplicateRowIndices.contains(index);

                      return DataRow(
                        color: WidgetStateProperty.resolveWith((states) {
                          if (showDuplicateHighlights && isDuplicate) {
                            return Colors.orangeAccent.withValues(alpha: 0.15);
                          }
                          return index.isEven ? Colors.white.withValues(alpha: 0.01) : Colors.transparent;
                        }),
                        cells: [
                          DataCell(Text("${index + 1}",
                              style: const TextStyle(color: Colors.white24, fontSize: 11, fontWeight: FontWeight.bold))),
                          ..._buildCells(row, index),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Color(0xFFFF2E63)),
                              onPressed: () => _confirmAction(
                                context: context,
                                title: "SATIRI SİL",
                                content: "${index + 1}. satır kalıcı olarak silinecek. Emin misiniz?",
                                confirmText: "SİL",
                                confirmColor: const Color(0xFFFF2E63),
                                onConfirm: () => context.read<HomeCubit>().deleteRow(index),
                              ),
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
        ),
      ],
    );
  }
  List<DataCell> _buildCells(List<dynamic> row, int rowIndex) {
    List<dynamic> normalizedRow = List.from(row);
    while (normalizedRow.length < widget.headers.length) {
      normalizedRow.add("");
    }

    return List.generate(normalizedRow.length, (colIndex) {
      final cellValue = normalizedRow[colIndex];
      final String text = cellValue?.toString() ?? "";
      final bool isEmpty = text.trim().isEmpty;

      return DataCell(
        onTap: () => _showEditDialog(rowIndex, colIndex, text),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: (showEmptyHighlights && isEmpty)
                ? const Color(0xFFFF2E63).withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: (showEmptyHighlights && isEmpty)
                ? Border.all(color: const Color(0xFFFF2E63).withValues(alpha: 0.3), width: 1)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showEmptyHighlights && isEmpty)
                const Icon(Icons.add_box_outlined, size: 14, color: Color(0xFFFF2E63)),
              if (showEmptyHighlights && isEmpty) const SizedBox(width: 6),
              Expanded(
                child: Text(
                  isEmpty ? (showEmptyHighlights ? "EKLE" : "-") : text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isEmpty ? const Color(0xFFFF2E63) : Colors.white70,
                    fontWeight: isEmpty ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
  void _confirmAction({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmText,
    required Color confirmColor,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: const Color(0xFF161B22).withValues(alpha: 0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: confirmColor.withValues(alpha: 0.5), width: 1.5),
          ),
          title: Text(title.toUpperCase(),
              style: TextStyle(color: confirmColor, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          content: Text(content, style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("VAZGEÇ", style: TextStyle(color: Colors.white24, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: confirmColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                onConfirm();
                Navigator.pop(dialogContext);
              },
              child: Text(confirmText.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
  void _showEditDialog(int rowIndex, int colIndex, String currentValue) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (dialogContext) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: const Color(0xFF161B22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: const Color(0xFF00F2FF).withValues(alpha: 0.3), width: 1.5),
          ),
          title: Text(
            "${widget.headers[colIndex].toUpperCase()} DÜZENLE",
            style: const TextStyle(color: Color(0xFF00F2FF), fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              hintText: "YENİ DEĞER...",
              hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("İPTAL", style: TextStyle(color: Colors.white24)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00F2FF),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                context.read<HomeCubit>().updateCell(rowIndex, colIndex, controller.text);
                Navigator.pop(dialogContext);
              },
              child: const Text("GÜNCELLE", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildSiberChip({
    required String label,
    required bool isSelected,
    required Color color,
    required IconData icon,
    required Function(bool) onSelected
  }) {
    return FilterChip(
      label: Text(label, style: TextStyle(
          color: isSelected ? Colors.black : color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1
      )),
      selected: isSelected,
      onSelected: onSelected,
      avatar: Icon(icon, size: 14, color: isSelected ? Colors.black : color),
      backgroundColor: Colors.transparent,
      selectedColor: color,
      side: BorderSide(color: color.withValues(alpha: 0.4), width: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      showCheckmark: false,
    );
  }

  Widget _buildSiberActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 14, color: color),
      label: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color.withValues(alpha: 0.4)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: color.withValues(alpha: 0.05),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}