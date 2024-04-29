import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mavin_global_assignment/core/build_context_extensions.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_strings.dart';
import '../../data/models/excel_function.dart';
import '../bloc/database/database_cubit.dart';
import '../bloc/formula/formula_cubit.dart';
import '../helper_functions/run_excel_function.dart';
import 'actionButtons.dart';
import 'filtered_formula_list.dart';
import 'formula_description.dart';
import 'formula_textfield.dart';

class ExcelSheetUI extends StatefulWidget {
  const ExcelSheetUI({super.key, required this.functionsList});

  final List<ExcelFunction> functionsList;

  @override
  State<ExcelSheetUI> createState() => _ExcelSheetUIState();
}

class _ExcelSheetUIState extends State<ExcelSheetUI> {
  List<String> data = [];
  TextEditingController controller = TextEditingController();

  Map<String, dynamic>? selectedFunction;

  void getFilteredFormulas(String value) {
    context
        .read<FormulaCubit>()
        .filterFormulas(widget.functionsList, value, true);
  }

  @override
  void didChangeDependencies() {
    getFilteredFormulas('');
    int rows = context.read<DatabaseCubit>().state;
    data = List.generate(rows, (index) => '');
    super.didChangeDependencies();
  }

  void onClear() {
    selectedFunction = null;
    controller.clear();
    getFilteredFormulas('');
    context.unFocus();
  }

  void onSubmit() {
    if (AppConstants.multiInputFormKey.currentState != null &&
        AppConstants.multiInputFormKey.currentState!.validate()) {
      try {
        dynamic output = callFunction(controller.text, true, data);

        controller.text = output.toString();
      } catch (e) {
        controller.text = AppStrings.error;
        context.unFocus();
      }
    }
  }

  void addRow() {
    context.read<DatabaseCubit>().addRow();
    data.add('');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatabaseCubit, int>(
      builder: (context, state) {
        return Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8, right: 8, top: 24, bottom: 0),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 20,right: 20,bottom: 30),
                            child: Text(
                              AppStrings.fyiFunction,
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
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            AppStrings.data,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        ListView.builder(
                          itemCount: state,
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 1),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: SizedBox(
                                      width: 25,
                                      child: Center(
                                        child: Text('A${index + 1}'),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: TextEditingController(
                                          text: data[index]),
                                      onChanged: (value) {
                                        data[index] = value;
                                      },
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.only(
                                            top: 2,
                                            bottom: 2,
                                            left: 12,
                                            right: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        splashRadius: 20,
                        onPressed: () {
                          addRow();
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 20, top: 30),
                              child: FormulaTextField(
                                formKey: AppConstants.multiInputFormKey,
                                controller: controller,
                                excelFunctions: widget.functionsList,
                                isDbFunction: true,
                              ),
                            ),
                            FilteredFormulaList(
                              controller: controller,
                              isDBFunction: true,
                              dbLength: state,
                            ),
                            FormulaDescription(controller: controller),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
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
        );
      },
    );
  }
}
