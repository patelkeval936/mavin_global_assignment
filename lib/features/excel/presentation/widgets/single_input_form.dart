import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mavin_global_assignment/core/build_context_extensions.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_strings.dart';
import '../../data/models/excel_function.dart';
import '../bloc/formula/formula_cubit.dart';
import '../helper_functions/run_excel_function.dart';
import 'actionButtons.dart';
import 'filtered_formula_list.dart';
import 'formula_description.dart';
import 'formula_textfield.dart';

class MultiInputForm extends StatefulWidget {
  const MultiInputForm({super.key, required this.functionsList});

  final List<ExcelFunction> functionsList;

  @override
  State<MultiInputForm> createState() => _MultiInputFormState();
}

class _MultiInputFormState extends State<MultiInputForm> {
  TextEditingController controller = TextEditingController();

  Map<String, dynamic>? selectedFunction;

  void getFilteredFormulas(String value) {
    context
        .read<FormulaCubit>()
        .filterFormulas(widget.functionsList, value, false);
  }

  @override
  void didChangeDependencies() {
    getFilteredFormulas('');
    super.didChangeDependencies();
  }

  void onClear() {
    selectedFunction = null;
    controller.clear();
    getFilteredFormulas('');
    context.unFocus();
  }

  void onSubmit() {
    if (AppConstants.singleInputFormKey.currentState != null &&
        AppConstants.singleInputFormKey.currentState!.validate()) {
      try {

        dynamic output = callFunction(controller.text, false, []);

        controller.text = output.toString();
      } catch (e) {
        controller.text = AppStrings.error;
        context.unFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return SizedBox(
        height: context.height,
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 20,right: 20,top: 24),
                          child: Text(
                            AppStrings.fyiParameter,
                            style: TextStyle(
                              height: 1.6,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 20, top: 36),
                        child: FormulaTextField(
                          formKey: AppConstants.singleInputFormKey,
                          controller: controller,
                          excelFunctions: widget.functionsList,
                          isDbFunction: false,
                        ),
                      ),
                      FilteredFormulaList(
                        controller: controller,
                        isDBFunction: false,
                        dbLength: 0,
                      ),
                      FormulaDescription(controller: controller),
                      const SizedBox(height: 50,)
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  height: 72,
                  width: context.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ActionButtons(
                      controller: controller,
                      onClear: onClear,
                      onSubmit: onSubmit,
                    ),
                  ),
                ))
          ],
        ),
      );
    });
  }
}
