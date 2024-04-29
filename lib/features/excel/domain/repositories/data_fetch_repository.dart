import '../../../../core/result_state_implementation.dart';

abstract class DataFetchRepository {
  Future<ResultState> getExcelFunctions(String src);
}
