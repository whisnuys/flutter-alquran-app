import 'package:equatable/equatable.dart';
import 'package:flutter_ahlul_quran_app/data/api_service.dart';
import 'package:flutter_ahlul_quran_app/data/models/surah_detail_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'verse_state.dart';

class VerseCubit extends Cubit<VerseState> {
  VerseCubit(this.apiService) : super(VerseInitial());
  final ApiService apiService;

  void getDetailSurah(int surahNumber) async {
    emit(VerseLoading());
    final result = await apiService.getDetailSurah(surahNumber);
    result.fold(
      (l) => emit(VerseError(message: l)),
      (r) => emit(VerseLoaded(detail: r)),
    );
  }
}
