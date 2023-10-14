import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'verse_state.dart';

class VerseCubit extends Cubit<VerseState> {
  VerseCubit() : super(VerseInitial());
}
