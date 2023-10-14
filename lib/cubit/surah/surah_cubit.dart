import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'surah_state.dart';

class SurahCubit extends Cubit<SurahState> {
  SurahCubit() : super(SurahInitial());
}
