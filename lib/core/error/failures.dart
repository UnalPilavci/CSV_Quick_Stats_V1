abstract class Failure {
  final String message;
  const Failure(this.message);
}

class CsvReadingFailure extends Failure {
  const CsvReadingFailure(super.message);
}

class FilePickerFailure extends Failure {
  const FilePickerFailure(super.message);
}