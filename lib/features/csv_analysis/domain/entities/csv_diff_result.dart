class CsvDiffResult {
  final String oldFileName;
  final String newFileName;
  final List<String> headers;
  final List<List<dynamic>> addedRows;
  final List<List<dynamic>> deletedRows;
  final List<List<dynamic>> commonRows;

  CsvDiffResult({
    required this.oldFileName,
    required this.newFileName,
    required this.headers,
    required this.addedRows,
    required this.deletedRows,
    required this.commonRows,
  });
  int get totalChanges => addedRows.length + deletedRows.length;
}