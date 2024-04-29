import 'package:get_it/get_it.dart';
import 'features/excel/data/data_sources/local_json_service.dart';
import 'features/excel/data/repositories/data_fetch_repo_implementation.dart';
import 'features/excel/domain/repositories/data_fetch_repository.dart';
import 'features/excel/domain/usecases/get_excel_functions.dart';
import 'features/excel/presentation/bloc/functions_bloc/functions_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {

  // Dependencies
  sl.registerSingleton<LocalJsonFetchService>(LocalJsonFetchService());

  DataFetchRepository repo = sl.registerSingleton<DataFetchRepositoryImpl>(
      DataFetchRepositoryImpl(localJsonClient: sl()));

  //UseCases
  sl.registerSingleton<GetExcelFunctions>(GetExcelFunctions(repo));

  //Blocs
  sl.registerSingleton<FunctionsBloc>(FunctionsBloc(sl()));

}
