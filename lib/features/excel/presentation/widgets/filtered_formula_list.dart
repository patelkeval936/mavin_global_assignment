import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/formula_model.dart';
import '../bloc/formula/formula_cubit.dart';

class FilteredFormulaList extends StatelessWidget {
  const FilteredFormulaList({
    super.key,
    required this.controller,
    required this.isDBFunction,
    required this.dbLength,
  });

  final TextEditingController controller;
  final bool isDBFunction;
  final int dbLength;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormulaCubit, FormulaModel>(
      builder: (context, state) {
        return Column(
          children: [
            state.formulas.isEmpty
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.formulas.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          String functionName = state.formulas[index].name;
                          return Padding(
                            padding: index == 0
                                ? const EdgeInsets.only(
                                    left: 16, right: 8, top: 8, bottom: 8)
                                : index == state.formulas.length - 1
                                    ? const EdgeInsets.only(
                                        left: 8, right: 18, top: 8, bottom: 8)
                                    : const EdgeInsets.symmetric(horizontal: 8),
                            child: InputChip(
                              label: Text(functionName),
                              onPressed: () {
                                context
                                    .read<FormulaCubit>()
                                    .changeSelectedFormula(
                                        state.formulas[index]);

                                if (isDBFunction) {
                                  controller.text = '=$functionName(DATA,)';
                                  controller.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: controller.text.length - 1));
                                } else {
                                  controller.text = "=$functionName()";
                                  controller.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                        offset: controller.text.length - 1),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}
