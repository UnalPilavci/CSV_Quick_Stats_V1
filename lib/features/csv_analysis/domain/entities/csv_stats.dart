import 'package:equatable/equatable.dart';

class CsvStats extends Equatable {
  final String fileName;
  final String fileSize;
  final int rowCount;
  final int columnCount;
  final int nullCount;
  final int totalCellCount;
  final int duplicateRowCount;
  final int emptyColumnCount;
  final List<String> headers;
  final List<List<dynamic>> rows;
  final List<int> columnNullCounts;
  const CsvStats({
    required this.fileName,
    required this.fileSize,
    required this.rowCount,
    required this.columnCount,
    required this.nullCount,
    required this.totalCellCount,
    required this.duplicateRowCount,
    required this.emptyColumnCount,
    required this.headers,
    required this.rows,
    required this.columnNullCounts,
  });

  @override
  List<Object?> get props => [
    fileName,
    fileSize,
    rowCount,
    columnCount,
    nullCount,
    totalCellCount,
    duplicateRowCount,
    emptyColumnCount,
    columnNullCounts,
  ];
}