import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/csv_stats.dart';

abstract class CsvRepository {
  Future<Either<Failure, CsvStats>> pickAndAnalyzeCsv();
}