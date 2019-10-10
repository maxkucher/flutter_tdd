import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tdd_tutorial/features/number_trivia/domain/entities/number_trivia.dart';

@immutable
abstract class NumberTriviaState extends Equatable {
  NumberTriviaState([List props = const []]) : super(props);
}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;

  Loaded(this.trivia) : super([trivia]);
}

class Error extends NumberTriviaState {
  final String message;

  Error(this.message) : super([message]);
}
