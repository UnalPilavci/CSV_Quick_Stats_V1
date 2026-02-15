import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/csv_stats.dart';
import '../../domain/repositories/csv_repository.dart';
import '../datasources/csv_local_datasource.dart';

class CsvRepositoryImpl implements CsvRepository {
  final CsvLocalDataSource dataSource;

  CsvRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, CsvStats>> pickAndAnalyzeCsv() async {
    try {
      final result = await dataSource.pickAndParseCsv();
      return Right(result);
    } catch (e) {
      return Left(CsvReadingFailure(e.toString()));
    }
  }
}