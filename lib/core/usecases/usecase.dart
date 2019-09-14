import 'package:tdd_tutorial/core/error/failures.dart';
import 'package:tdd_tutorial/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<Type, Params>{
  Future<Either<Failure, NumberTrivia>> call(Params params);
}