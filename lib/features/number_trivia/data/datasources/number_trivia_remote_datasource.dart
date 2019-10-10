import 'dart:convert';

import 'package:tdd_tutorial/core/error/exceptions.dart';
import 'package:tdd_tutorial/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_tutorial/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTrivia> getConcreteNumberTrivia(int number);

  Future<NumberTrivia> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({@required this.client});

  @override
  Future<NumberTrivia> getConcreteNumberTrivia(int number) async {
    return await _getTriviaFromUrl('http://numbersapi.com/$number');
  }

  @override
  Future<NumberTrivia> getRandomNumberTrivia() async {
    return await _getTriviaFromUrl('http://numbersapi.com/random');
  }

  Future<NumberTrivia> _getTriviaFromUrl(String url) async {
    final res =
        await client.get(url, headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(res.body));
    } else
      throw ServerException();
  }
}
