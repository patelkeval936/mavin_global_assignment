import 'package:equatable/equatable.dart';

import '../../../data/models/excel_functions_model.dart';

abstract class FunctionsBlocState extends Equatable {
  final ExcelFunctionsModel? functionsModel;

  const FunctionsBlocState({this.functionsModel});

  @override
  List get props => [functionsModel];
}

class FunctionsLoading extends FunctionsBlocState {
  const FunctionsLoading();
}

class FunctionsSuccess extends FunctionsBlocState {
  const FunctionsSuccess(ExcelFunctionsModel? data)
      : super(functionsModel: data);
}

class FunctionsFailed extends FunctionsBlocState {
  final String message;

  const FunctionsFailed(this.message);

  @override
  List<Object> get props => [message];
}
