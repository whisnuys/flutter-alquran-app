import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/api_service.dart';
import '../../data/models/surah_model.dart';

part 'surah_state.dart';

class SurahCubit extends Cubit<SurahState> {
  SurahCubit(this.apiService) : super(SurahInitial());
  final ApiService apiService;

  void getAllSurah() async {
    emit(SurahLoading());
    final result = await apiService.getAllSurah();
    result.fold(
      (l) => emit(SurahError(message: l)),
      (r) => emit(SurahLoaded(listSurah: r)),
    );
  }
}
