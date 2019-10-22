import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:tdd_tutorial/core/error/failures.dart';
import 'package:tdd_tutorial/core/util/input_converter.dart';
import 'package:tdd_tutorial/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_tutorial/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_tutorial/features/number_trivia/domain/usecases/get_radom_number_trivia.dart';
import 'package:tdd_tutorial/features/number_trivia/presentation/bloc/bloc.dart';

const String SERVER_FAILURE_MESSAGE = 'Server failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {@required this.getConcreteNumberTrivia,
      @required this.getRandomNumberTrivia,
      @required this.inputConverter})
      : assert(getRandomNumberTrivia != null),
        assert(getConcreteNumberTrivia != null),
        assert(inputConverter != null);

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);
      yield* inputEither.fold((failure) async* {
        yield Error(INVALID_INPUT_FAILURE_MESSAGE);
      }, (res) async* {
        yield Loading();
        final result = await getConcreteNumberTrivia(Params(number: res));
        yield* _eitherLoadedrErrorState(result);
      });
    } else if (event is GetTriviaForRandomNumber) {
      yield Loading();
      final result = await getRandomNumberTrivia(NoParams());
      yield* _eitherLoadedrErrorState(result);
    }
  }

  Stream<NumberTriviaState> _eitherLoadedrErrorState(
      Either<Failure, NumberTrivia> result) async* {
    yield result.fold((failure) => Error(_mapFailureToMessage(failure)),
        (result) => Loaded(result));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
