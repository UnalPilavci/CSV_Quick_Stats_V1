import '../../domain/entities/csv_diff_result.dart';
abstract class ComparisonState {}
class ComparisonInitial extends ComparisonState {}
class ComparisonLoading extends ComparisonState {}
class ComparisonFilesReady extends ComparisonState {
  final String? oldFilePath;
  final String? oldFileName;
  final String? newFilePath;
  final String? newFileName;

  ComparisonFilesReady({
    this.oldFilePath,
    this.oldFileName,
    this.newFilePath,
    this.newFileName,
  });
  ComparisonFilesReady copyWith({
    String? oldFilePath,
    String? oldFileName,
    String? newFilePath,
    String? newFileName,
  }) {
    return ComparisonFilesReady(
      oldFilePath: oldFilePath ?? this.oldFilePath,
      oldFileName: oldFileName ?? this.oldFileName,
      newFilePath: newFilePath ?? this.newFilePath,
      newFileName: newFileName ?? this.newFileName,
    );
  }
}

class ComparisonSuccess extends ComparisonState {
  final CsvDiffResult result;
  ComparisonSuccess(this.result);
}

class ComparisonError extends ComparisonState {
  final String message;
  ComparisonError(this.message);
}