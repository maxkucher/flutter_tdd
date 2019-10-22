import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_tutorial/core/error/failures.dart';
import 'package:tdd_tutorial/core/util/input_converter.dart';
import 'package:tdd_tutorial/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_tutorial/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_tutorial/features/number_trivia/domain/usecases/get_radom_number_trivia.dart';
import 'package:tdd_tutorial/features/number_trivia/presentation/bloc/bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  GetConcreteNumberTrivia getConcreteNumberTrivia;
  GetRandomNumberTrivia getRandomNumberTrivia;
  InputConverter inputConverter;
  setUp(() {
    getConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    getRandomNumberTrivia = MockGetRandomNumberTrivia();
    inputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: getConcreteNumberTrivia,
        getRandomNumberTrivia: getRandomNumberTrivia,
        inputConverter: inputConverter);
  });
  test('initial state to be empty', () {
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpInputConverterSuccess() {
      when(inputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
    }

    test('should call input converter and convert string to unsigned integer',
        () async {
      setUpInputConverterSuccess();

      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));

      await untilCalled(inputConverter.stringToUnsignedInteger(any));

      verify(inputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit error', () async {
      when(inputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));
      final expected = [Empty(), Error(INVALID_INPUT_FAILURE_MESSAGE)];
      expectLater(bloc.state, emitsInOrder(expected));
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should get data from the concrete use case', () async {
      setUpInputConverterSuccess();
      when(getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));

      await untilCalled(getConcreteNumberTrivia(any));

      verify(getConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test('should emit [Loading,Loaded] when data is received successfuly',
        () async {
      setUpInputConverterSuccess();
      when(getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      final expected = [Empty(), Loading(), Loaded(tNumberTrivia)];
      expectLater(bloc.state, emitsInOrder(expected));

      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading,Error] when data is received successfuly',
        () async {
      setUpInputConverterSuccess();
      when(getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
        final expected = [Empty(), Loading(), Error(SERVER_FAILURE_MESSAGE)];
      expectLater(bloc.state, emitsInOrder(expected));

      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });
  });
}
