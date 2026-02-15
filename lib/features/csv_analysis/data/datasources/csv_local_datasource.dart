import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import '../models/csv_stats_model.dart';

abstract class CsvLocalDataSource {
  Future<CsvStatsModel> pickAndParseCsv();
}

class CsvLocalDataSourceImpl implements CsvLocalDataSource {
  final FilePicker filePicker;

  CsvLocalDataSourceImpl({required this.filePicker});

  @override
  Future<CsvStatsModel> pickAndParseCsv() async {
    final result = await filePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'txt'],
      withData: true,
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final fileName = result.files.single.name;

      try {
        final file = File(path);
        final int fileSize = await file.length();
        final input = await file.readAsString();
        List<List<dynamic>> fields = const CsvToListConverter(
          shouldParseNumbers: false,
          allowInvalid: true,
        ).convert(input);
        if (fields.length <= 1 && input.contains(';')) {
          print("LOG: Virgül işe yaramadı, noktalı virgül deneniyor...");
          fields = const CsvToListConverter(
            shouldParseNumbers: false,
            fieldDelimiter: ';',
          ).convert(input);
        }
        print("LOG: Okunan Satır Sayısı: ${fields.length}");
        return CsvStatsModel.fromCsvData(fileName, fileSize, fields);

      } catch (e) {
        throw Exception("CSV Okuma Hatası: $e");
      }
    } else {
      throw Exception("Dosya seçilmedi");
    }
  }
}