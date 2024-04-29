import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mavin_global_assignment/theme/app_theme.dart';
import 'package:mavin_global_assignment/utils/app_strings.dart';
import 'features/excel/presentation/bloc/functions_bloc/functions_bloc.dart';
import 'features/excel/presentation/bloc/functions_bloc/functions_bloc_event.dart';
import 'features/excel/presentation/pages/home_page.dart';
import 'injection_container.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void _setSystemProperties() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ));
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {

    _setSystemProperties();

    return  BlocProvider(
      create: (_) => sl<FunctionsBloc>()..add(const GetFunctions()),
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        themeMode: ThemeMode.dark,
        home: const HomePage(),
      ),
    );
  }
}


