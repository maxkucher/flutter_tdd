import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_tutorial/core/error/exceptions.dart';
import 'package:tdd_tutorial/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:tdd_tutorial/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSource dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
      'should return NumberTrivi from Shared Preferences whn there is one in the cahce',
      () async {
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('trivia_cached.json'));
        final result = await dataSource.getLastNumberTrivia();
        verify(mockSharedPreferences.getString('CACHED_NUMBER_TRIVIA'));
        expect(result, equals(tNumberTriviaModel));
      },
    );
    test(
      'should throw cache exception',
      () async {
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        final call =  dataSource.getLastNumberTrivia;
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });


  group('cacheNumberTrivia', (){
    final tNumberTriviaModel = NumberTriviaModel(text: 'test trivia', number: 1);
    test('should call shared prefs to cache the data', (){
      dataSource.cacheNumberTrivia(tNumberTriviaModel);

      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString('CACHED_NUMBER_TRIVIA', expectedJsonString));

    });
  });
}
