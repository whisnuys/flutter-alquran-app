part of 'verse_cubit.dart';

sealed class VerseState extends Equatable {
  const VerseState();

  @override
  List<Object> get props => [];
}

final class VerseInitial extends VerseState {}

final class VerseLoading extends VerseState {}

final class VerseLoaded extends VerseState {
  final SurahDetailModel detail;

  const VerseLoaded({required this.detail});

  @override
  List<Object> get props => [detail];
}

final class VerseError extends VerseState {
  final String message;

  const VerseError({required this.message});

  @override
  List<Object> get props => [message];
}
