import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_tutorial/core/util/input_converter.dart';
import 'package:tdd_tutorial/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:tdd_tutorial/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:tdd_tutorial/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:tdd_tutorial/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:tdd_tutorial/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_tutorial/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import 'features/number_trivia/domain/usecases/get_radom_number_trivia.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl()));

  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          localDataSource: sl(), remoteDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));
  sl.registerLazySingleton(() => InputConverter());

  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sl()));

  final preferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton(() => preferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
