import '../../domain/entities/csv_stats.dart';

class CsvStatsModel extends CsvStats {
  const CsvStatsModel({
    required super.fileName,
    required super.fileSize,
    required super.rowCount,
    required super.columnCount,
    required super.nullCount,
    required super.totalCellCount,
    required super.duplicateRowCount,
    required super.emptyColumnCount,
    required super.headers,
    required super.rows,
    required super.columnNullCounts,
  });

  factory CsvStatsModel.fromCsvData(String name, int fileSizeBytes, List<List<dynamic>> rawData) {
    String sizeStr = "";
    if (fileSizeBytes < 1024) {
      sizeStr = "$fileSizeBytes B";
    } else if (fileSizeBytes < 1024 * 1024) {
      sizeStr = "${(fileSizeBytes / 1024).toStringAsFixed(1)} KB";
    } else {
      sizeStr = "${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(2)} MB";
    }

    if (rawData.isEmpty) {
      return CsvStatsModel(
        fileName: name,
        fileSize: sizeStr,
        rowCount: 0,
        columnCount: 0,
        nullCount: 0,
        totalCellCount: 0,
        duplicateRowCount: 0,
        emptyColumnCount: 0,
        headers: [],
        rows: [],
        columnNullCounts: [],
      );
    }

    final headerRow = rawData.first;
    final int standardColCount = headerRow.length;
    final List<String> headers = headerRow.map((e) => e.toString()).toList();

    final List<List<dynamic>> cleanData = rawData.where((row) {
      if (row.isEmpty) return false;
      return !row.every((cell) => cell == null || cell.toString().trim().isEmpty);
    }).toList();

    int totalRows = cleanData.length;
    int emptyCells = 0;
    int totalCellsExpected = totalRows * standardColCount;
    int duplicates = 0;
    final Set<String> uniqueRows = {};
    List<bool> isEmptyColumn = List.filled(standardColCount, true);
    List<int> columnNullCounts = List.filled(standardColCount, 0);
    for (int rowIndex = 0; rowIndex < totalRows; rowIndex++) {
      var row = cleanData[rowIndex];

      String rowHash = row.join('|||');
      if (uniqueRows.contains(rowHash)) {
        duplicates++;
      } else {
        uniqueRows.add(rowHash);
      }

      for (int colIndex = 0; colIndex < standardColCount; colIndex++) {
        if (colIndex >= row.length) {
          emptyCells++;
          if (rowIndex > 0) columnNullCounts[colIndex]++;
          continue;
        }

        var cell = row[colIndex];
        bool isCellEmpty = (cell == null || cell.toString().trim().isEmpty);

        if (isCellEmpty) {
          emptyCells++;
          if (rowIndex > 0) columnNullCounts[colIndex]++;
        } else {
          if (rowIndex > 0) {
            isEmptyColumn[colIndex] = false;
          }
        }
      }
    }

    int emptyColsCount = (totalRows > 1)
        ? isEmptyColumn.where((element) => element == true).length
        : standardColCount;

    List<List<dynamic>> dataRowsOnly = (cleanData.length > 1) ? cleanData.sublist(1) : [];

    return CsvStatsModel(
      fileName: name,
      fileSize: sizeStr,
      rowCount: totalRows,
      columnCount: standardColCount,
      nullCount: emptyCells,
      totalCellCount: totalCellsExpected,
      duplicateRowCount: duplicates,
      emptyColumnCount: emptyColsCount,
      headers: headers,
      rows: dataRowsOnly,
      columnNullCounts: columnNullCounts,
    );
  }
  Map<String, dynamic> getColumnProfile(int colIndex) {
    List<dynamic> colData = rows.map((r) => r[colIndex]).where((e) => e != null && e.toString().isNotEmpty).toList();
    int uniqueCount = colData.toSet().length;
    List<double> numericValues = colData
        .map((e) => double.tryParse(e.toString().replaceAll(RegExp(r'[^0-9.]'), '')))
        .whereType<double>()
        .toList();

    bool isNumeric = numericValues.length == colData.length && colData.isNotEmpty;

    if (isNumeric) {
      double sum = numericValues.reduce((a, b) => a + b);
      numericValues.sort();
      return {
        'type': 'Sayısal',
        'unique': uniqueCount,
        'min': numericValues.first,
        'max': numericValues.last,
        'avg': (sum / numericValues.length).toStringAsFixed(2),
      };
    } else {
      Map<String, int> freq = {};
      for (var e in colData) {
        String s = e.toString();
        freq[s] = (freq[s] ?? 0) + 1;
      }
      var sortedFreq = freq.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

      return {
        'type': 'Metin',
        'unique': uniqueCount,
        'mostCommon': sortedFreq.isNotEmpty ? sortedFreq.first.key : "Yok",
      };
    }
  }
}