import 'dart:convert';

import 'package:matcher/matcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:tdd_tutorial/core/error/exceptions.dart';
import 'package:tdd_tutorial/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:tdd_tutorial/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSource dataSource;
  MockHttpClient mockHttpClient;
  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''should perform a GET request with number being an endopint 
    with header application/json}''', () async {


      dataSource.getConcreteNumberTrivia(tNumber);

      verify(mockHttpClient.get('http://numbersapi.com/$tNumber',
          headers: {'COntent-Type': 'application/json'}));
    });
    test('''should return number trivia''', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));


      final result = await dataSource.getConcreteNumberTrivia(tNumber);


      expect(result, equals(tNumberTriviaModel));
    });

    test('''should throw exception''', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));

        final call =  dataSource.getConcreteNumberTrivia;


      expect(() =>  call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
