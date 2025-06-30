import 'package:alquran_app/data/repositories/quran_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/surah_detail_model.dart';

part 'verse_state.dart';

class VerseCubit extends Cubit<VerseState> {
  VerseCubit(this.repository) : super(VerseInitial());
  final QuranRepository repository;

  void getDetailSurah(int surahNumber) async {
    emit(VerseLoading());
    final result = await repository.getDetailSurah(surahNumber);
    result.fold(
      (l) => emit(VerseError(message: l)),
      (r) => emit(VerseLoaded(detail: r)),
    );
  }
}
