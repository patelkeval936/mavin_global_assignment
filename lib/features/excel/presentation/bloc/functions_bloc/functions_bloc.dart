import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecase.dart';
import '../../../../../utils/app_assets.dart';
import '../../../../../utils/app_strings.dart';
import '../../../domain/usecases/get_excel_functions.dart';
import 'functions_bloc_event.dart';
import 'functions_bloc_state.dart';

class FunctionsBloc extends Bloc<FunctionsBlocEvents, FunctionsBlocState> {
  final GetExcelFunctions getExcelFunctions;

  FunctionsBloc(
    this.getExcelFunctions,
  ) : super(const FunctionsLoading()) {
    on<GetFunctions>(onGetFunctionsData);
  }

  void onGetFunctionsData(
      FunctionsBlocEvents event, Emitter<FunctionsBlocState> emit) async {
    final user = await getExcelFunctions(const Params(AppAssets.functionsJson));
    if (user.error == null) {
      emit(FunctionsSuccess(user.data));
    } else {
      emit(FunctionsFailed(
          user.error?.message ?? AppStrings.somethingWentWrong));
    }
  }
}
