import 'dart:developer';
import '../../../../core/result_state_implementation.dart';
import '../../domain/repositories/data_fetch_repository.dart';
import '../data_sources/local_json_service.dart';
import '../models/excel_functions_model.dart';

class DataFetchRepositoryImpl implements DataFetchRepository {
  final LocalJsonFetchService _localJsonService;

  DataFetchRepositoryImpl({
    required LocalJsonFetchService localJsonClient,
  }) : _localJsonService = localJsonClient;

  @override
  Future<ResultState> getExcelFunctions(String src) async {
    try {
      final jsonResult = await _localJsonService.getLocalData(src);

      ExcelFunctionsModel excelFunctionModel =
          ExcelFunctionsModel.fromJson(jsonResult);
      return Success<ExcelFunctionsModel>(excelFunctionModel);
    } catch (e, s) {
      log('error is $e');
      log('$s');
      return Failure(ApiException(message: e.toString()));
    }
  }
}
