import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../utils/app_strings.dart';
import '../bloc/database/database_cubit.dart';
import '../bloc/formula/formula_cubit.dart';
import '../bloc/functions_bloc/functions_bloc.dart';
import '../bloc/functions_bloc/functions_bloc_state.dart';
import '../widgets/multi_input_form.dart';
import '../widgets/single_input_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FunctionsBloc, FunctionsBlocState>(
      builder: (context, state) {
        if (state is FunctionsLoading) {
          return const CircularProgressIndicator();
        }
        if (state is FunctionsFailed) {
          return Text(
            state.message,
            style: const TextStyle(color: Colors.red),
          );
        }

        return DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              centerTitle: true,
              title: const Text(AppStrings.appName),
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.rectangle_outlined)),
                  Tab(icon: Icon(Icons.border_all_rounded)),
                ],
              ),
            ),
            body: TabBarView(children: [
              BlocProvider(
                create: (context) => FormulaCubit(),
                child: MultiInputForm(
                    functionsList: state.functionsModel?.functions ?? []),
              ),
              MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => FormulaCubit(),
                    ),
                    BlocProvider(
                      create: (context) => DatabaseCubit(),
                    ),
                  ],
                  child: ExcelSheetUI(
                      functionsList: state.functionsModel?.functions ?? []))
            ]),
          ),
        );
      },
    );
  }
}
