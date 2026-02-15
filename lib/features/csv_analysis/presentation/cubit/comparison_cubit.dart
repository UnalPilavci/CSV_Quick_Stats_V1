import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:csv/csv.dart';
import '../../domain/entities/csv_diff_result.dart';
import 'comparison_state.dart';

class ComparisonCubit extends Cubit<ComparisonState> {
  ComparisonCubit() : super(ComparisonInitial());
  String? _oldPath;
  String? _oldName;
  String? _newPath;
  String? _newName;
  Future<void> pickOldFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      _oldPath = result.files.single.path;
      _oldName = result.files.single.name;
      emit(ComparisonFilesReady(
          oldFilePath: _oldPath,
          oldFileName: _oldName,
          newFilePath: _newPath,
          newFileName: _newName
      ));
    }
  }
  Future<void> pickNewFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      _newPath = result.files.single.path;
      _newName = result.files.single.name;
      emit(ComparisonFilesReady(
          oldFilePath: _oldPath,
          oldFileName: _oldName,
          newFilePath: _newPath,
          newFileName: _newName
      ));
    }
  }
  void reset() {
    _oldPath = null;
    _oldName = null;
    _newPath = null;
    _newName = null;
    emit(ComparisonInitial());
  }
  Future<void> compareFiles() async {
    if (_oldPath == null || _newPath == null) {
      emit(ComparisonError("Lütfen her iki dosyayı da seçiniz."));
      return;
    }

    try {
      emit(ComparisonLoading());
      final oldFile = File(_oldPath!);
      final newFile = File(_newPath!);
      final oldString = await oldFile.readAsString();
      final newString = await newFile.readAsString();
      List<List<dynamic>> oldRows = const CsvToListConverter().convert(oldString, eol: '\n');
      List<List<dynamic>> newRows = const CsvToListConverter().convert(newString, eol: '\n');
      if (oldRows.isEmpty || newRows.isEmpty) {
        emit(ComparisonError("Dosyalardan biri boş veya hatalı formatta."));
        return;
      }
      List<String> headers = oldRows.first.map((e) => e.toString()).toList();
      List<String> newHeaders = newRows.first.map((e) => e.toString()).toList();
      if (headers.join(',') != newHeaders.join(',')) {
        emit(ComparisonError("Hata: Dosyaların sütun başlıkları birbirinden farklı. Karşılaştırma yapılamaz."));
        return;
      }
      oldRows.removeAt(0);
      newRows.removeAt(0);
      Set<String> oldSet = oldRows.map((row) => row.join('|')).toSet();
      Set<String> newSet = newRows.map((row) => row.join('|')).toSet();
      List<List<dynamic>> deleted = oldRows
          .where((row) => !newSet.contains(row.join('|')))
          .toList();
      List<List<dynamic>> added = newRows
          .where((row) => !oldSet.contains(row.join('|')))
          .toList();
      List<List<dynamic>> common = newRows
          .where((row) => oldSet.contains(row.join('|')))
          .toList();

      emit(ComparisonSuccess(CsvDiffResult(
        oldFileName: _oldName!,
        newFileName: _newName!,
        headers: headers,
        addedRows: added,
        deletedRows: deleted,
        commonRows: common,
      )));

    } catch (e) {
      emit(ComparisonError("Karşılaştırma sırasında hata oluştu: $e"));
    }
  }
}