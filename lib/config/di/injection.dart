import 'package:get_it/get_it.dart';
import 'package:file_picker/file_picker.dart';
import '../../features/csv_analysis/data/datasources/csv_local_datasource.dart';
import '../../features/csv_analysis/data/repositories/csv_repository_impl.dart';
import '../../features/csv_analysis/domain/repositories/csv_repository.dart';
import '../../features/csv_analysis/domain/usecases/pick_and_analyze_csv.dart';
import '../../features/csv_analysis/presentation/cubit/home_cubit.dart';
final sl = GetIt.instance;
Future<void> init() async {
  sl.registerFactory(() => HomeCubit(pickAndAnalyzeCsv: sl()));
  sl.registerLazySingleton(() => PickAndAnalyzeCsv(sl()));
  sl.registerLazySingleton<CsvRepository>(
        () => CsvRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<CsvLocalDataSource>(
        () => CsvLocalDataSourceImpl(filePicker: sl()),
  );
  sl.registerLazySingleton(() => FilePicker.platform);
}