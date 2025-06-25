import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/surah_remote_datasource.dart';
import '../../data/models/surah_detail_model.dart';

part 'verse_state.dart';

class VerseCubit extends Cubit<VerseState> {
  VerseCubit(this.apiService) : super(VerseInitial());
  final SurahRemoteDatasource apiService;

  void getDetailSurah(int surahNumber) async {
    emit(VerseLoading());
    final result = await apiService.getDetailSurah(surahNumber);
    result.fold(
      (l) => emit(VerseError(message: l)),
      (r) => emit(VerseLoaded(detail: r)),
    );
  }
}
