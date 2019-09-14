import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_tutorial/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_tutorial/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test('should be subclass of NumberTrivia entity', () async {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return a valid model for integer', () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, equals(tNumberTriviaModel));
    });
    test('should return a valid model for double', () async {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, equals(tNumberTriviaModel));
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      final result = tNumberTriviaModel.toJson();

      final expectedMap = {"text": "Test Text", "number": 1};

      expect(result, expectedMap);


    });
  });
}
