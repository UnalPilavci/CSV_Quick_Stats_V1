import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/csv_stats.dart';
import '../../domain/usecases/pick_and_analyze_csv.dart';
import '../../data/models/csv_stats_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final PickAndAnalyzeCsv pickAndAnalyzeCsv;

  HomeCubit({required this.pickAndAnalyzeCsv}) : super(HomeInitial());

  Future<void> pickCsvFile() async {
    emit(HomeLoading());

    final result = await pickAndAnalyzeCsv(NoParams());

    result.fold(
          (failure) => emit(HomeError(failure.message)),
          (stats) => emit(HomeLoaded(stats)),
    );
  }

  void reset() {
    emit(HomeInitial());
  }
  void updateCell(int rowIndex, int colIndex, String newValue) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      List<List<dynamic>> updatedRows = List.from(
        currentState.stats.rows.map((row) => List.from(row)),
      );
      updatedRows[rowIndex][colIndex] = newValue;
      final newStats = CsvStatsModel.fromCsvData(
        currentState.stats.fileName,
        0,
        [currentState.stats.headers, ...updatedRows],
      );

      emit(HomeLoaded(newStats));
    }
  }
  void removeDuplicates() {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final Set<String> seen = {};
      final List<List<dynamic>> uniqueRows = [];

      for (var row in currentState.stats.rows) {
        String rowHash = row.join('|||');
        if (!seen.contains(rowHash)) {
          seen.add(rowHash);
          uniqueRows.add(row);
        }
      }

      final newStats = CsvStatsModel.fromCsvData(
        "Cleaned_${currentState.stats.fileName}",
        0,
        [currentState.stats.headers, ...uniqueRows],
      );

      emit(HomeLoaded(newStats));
    }
  }
  void deleteRow(int rowIndex) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      List<List<dynamic>> updatedRows = List.from(currentState.stats.rows);

      updatedRows.removeAt(rowIndex);

      final newStats = CsvStatsModel.fromCsvData(
        currentState.stats.fileName,
        0,
        [currentState.stats.headers, ...updatedRows],
      );
      emit(HomeLoaded(newStats));
    }
  }
  void deleteColumn(int colIndex) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      List<String> updatedHeaders = List.from(currentState.stats.headers);
      updatedHeaders.removeAt(colIndex);
      List<List<dynamic>> updatedRows = currentState.stats.rows.map((row) {
        List<dynamic> newRow = List.from(row);
        if (colIndex < newRow.length) {
          newRow.removeAt(colIndex);
        }
        return newRow;
      }).toList();

      final newStats = CsvStatsModel.fromCsvData(
        currentState.stats.fileName,
        0,
        [updatedHeaders, ...updatedRows],
      );
      emit(HomeLoaded(newStats));
    }
  }
  Future<void> exportCsv() async {
    if (state is HomeLoaded) {
      final stats = (state as HomeLoaded).stats;
      String csvContent = stats.headers.join(',') + '\n';
      for (var row in stats.rows) {
        csvContent += row.join(',') + '\n';
      }

      try {
        final directory = await getTemporaryDirectory();
        final file = File('${directory.path}/cleaned_${stats.fileName}');
        await file.writeAsString(csvContent);
        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Analiz Edilmiş ve Temizlenmiş CSV Raporu',
        );
      } catch (e) {
        emit(HomeError("Dışarı aktarma hatası: $e"));
      }
    }
  }
}