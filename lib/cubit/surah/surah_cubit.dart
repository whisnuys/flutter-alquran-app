import 'package:alquran_app/data/repositories/quran_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/surah_model.dart';

part 'surah_state.dart';

class SurahCubit extends Cubit<SurahState> {
  SurahCubit(this.repository) : super(SurahInitial());
  final QuranRepository repository;

  void getAllSurah() async {
    emit(SurahLoading());
    final result = await repository.getAllSurah();
    result.fold(
      (l) => emit(SurahError(message: l)),
      (r) => emit(SurahLoaded(listSurah: r)),
    );
  }
}
