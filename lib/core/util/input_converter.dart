import 'package:dartz/dartz.dart';
import 'package:tdd_tutorial/core/error/failures.dart';

  class InputConverter {
  Either<Failure,int> stringToUnsignedInteger(String str){
    try{
      int res = int.parse(str);
      if (res < 0)
        throw FormatException();
      return Right(int.parse(str));
    } on FormatException{
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure{

}