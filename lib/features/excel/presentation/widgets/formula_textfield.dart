import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../utils/app_strings.dart';
import '../../data/models/excel_function.dart';
import '../bloc/formula/formula_cubit.dart';

class FormulaTextField extends StatelessWidget {
  const FormulaTextField({
    super.key,
    required this.formKey,
    required this.controller,
    required this.excelFunctions,
    required this.isDbFunction,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final List<ExcelFunction> excelFunctions;
  final bool isDbFunction;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.trim() == '') {
            return AppStrings.enterValidInput;
          }
          return null;
        },
        controller: controller,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.go,
        decoration: InputDecoration(
          labelText: AppStrings.formula,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (value) {
          context
              .read<FormulaCubit>()
              .filterFormulas(excelFunctions, value, isDbFunction);
        },
      ),
    );
  }
}
