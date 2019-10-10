import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_tutorial/core/util/input_converter.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('string to unsigned int', ()  {
    test('should return an integer when a string represents an unsigned int',
        () async {
          final str  = '123';
          final res = inputConverter.stringToUnsignedInteger(str);
          expect(res, equals(Right(123)));
        });


    test('should return failure when number is not an integer', () async{
        final str = 'invalid  ;)';
        final res = inputConverter.stringToUnsignedInteger(str);
        expect(res, Left(InvalidInputFailure()));
    });

    test('should return failure when number isnegative', () async{
      final str = '-123';
      final res = inputConverter.stringToUnsignedInteger(str);
      expect(res, Left(InvalidInputFailure()));
    });
  });
}
