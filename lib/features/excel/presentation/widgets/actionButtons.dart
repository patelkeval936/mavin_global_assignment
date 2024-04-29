import 'package:flutter/material.dart';

import '../../../../utils/app_strings.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    super.key,
    required this.controller,
    required this.onClear,
    required this.onSubmit,
  });

  final TextEditingController controller;

  final Function onClear;
  final Function onSubmit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.grey.shade700),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  onClear();
                },
                child: const Text(AppStrings.clear),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, left: 8),
              child: ElevatedButton(
                onPressed: () {
                  onSubmit();
                },
                child: const Text(AppStrings.go),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
