import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/csv_stats.dart';
import '../repositories/csv_repository.dart';

class PickAndAnalyzeCsv implements UseCase<CsvStats, NoParams> {
  final CsvRepository repository;

  PickAndAnalyzeCsv(this.repository);

  @override
  Future<Either<Failure, CsvStats>> call(NoParams params) async {
    return await repository.pickAndAnalyzeCsv();
  }
}