
import 'excel_function.dart';

class FormulaModel {
  List<ExcelFunction> formulas;
  ExcelFunction? selectedFormula;

  FormulaModel(this.formulas, this.selectedFormula);

  FormulaModel copyWith({
    List<ExcelFunction>? formulas,
    ExcelFunction? selectedFormula,
  }) {
    return FormulaModel(
      formulas ?? this.formulas,
      selectedFormula ?? this.selectedFormula,
    );
  }
}