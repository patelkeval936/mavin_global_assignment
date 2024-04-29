import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mavin_global_assignment/core/build_context_extensions.dart';
import '../../data/models/formula_model.dart';
import '../bloc/formula/formula_cubit.dart';

class FormulaDescription extends StatefulWidget {

  const FormulaDescription({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<FormulaDescription> createState() => _FormulaDescriptionState();
}

class _FormulaDescriptionState extends State<FormulaDescription> {

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<FormulaCubit, FormulaModel>(builder: (context, state) {
      return state.selectedFormula != null && widget.controller.text.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 12, bottom: 40, top: 8),
              child: SizedBox(
                width: context.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.selectedFormula?.definition ?? '',
                      style: const TextStyle(
                          height: 1.4,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.start,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        state.selectedFormula?.output ?? '',
                        style: const TextStyle(height: 1.4, fontSize: 14),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Text(
                      state.selectedFormula?.description ?? '',
                      style: const TextStyle(
                        height: 1.4,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox();
    });
  }
}
