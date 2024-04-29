import '../../../../core/result_state_implementation.dart';
import '../../../../core/usecase.dart';
import '../repositories/data_fetch_repository.dart';

class GetExcelFunctions implements UseCase<ResultState, Params> {
  final DataFetchRepository _dataFetchRepo;

  GetExcelFunctions(this._dataFetchRepo);

  @override
  Future<ResultState> call(Params params) {
    return _dataFetchRepo.getExcelFunctions(params.src);
  }

}

