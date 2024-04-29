import 'excel_function.dart';

class ExcelFunctionsModel {
  List<ExcelFunction> functions;

  ExcelFunctionsModel({required this.functions});

  factory ExcelFunctionsModel.fromJson(Map<String, dynamic> json) {
    return ExcelFunctionsModel(
      functions: List<ExcelFunction>.from(
        json["functions"].map((x) => ExcelFunction.fromJson(x)),
      ),
    );
  }
}
