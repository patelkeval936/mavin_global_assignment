import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/excel_function.dart';
import '../../../data/models/formula_model.dart';

class FormulaCubit extends Cubit<FormulaModel> {
  FormulaCubit() : super(FormulaModel([], null));

  void filterFormulas(
      List<ExcelFunction> excelFunctions, String value, bool isDBFunction) {
    List<ExcelFunction> filteredFunctions = [];

    if (value.startsWith('=')) {
      value = value.substring(1);
    }

    for (int i = 0; i < excelFunctions.length; i++) {
      ExcelFunction element = excelFunctions[i];
      if (element.name.toString().toLowerCase().contains(value.toLowerCase())) {
        if (element.isDbFunction == isDBFunction) {
          filteredFunctions.add(element);
        }
      }
    }

    emit(state.copyWith(formulas: filteredFunctions));
  }

  void changeSelectedFormula(ExcelFunction? function) {
    emit(state.copyWith(selectedFormula: function));
  }

}


