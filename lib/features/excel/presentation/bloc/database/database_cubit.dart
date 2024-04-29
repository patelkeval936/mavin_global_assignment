
import 'package:bloc/bloc.dart';

class DatabaseCubit extends Cubit<int> {
  DatabaseCubit() : super(5);

  void addRow() => emit(state + 1);

}