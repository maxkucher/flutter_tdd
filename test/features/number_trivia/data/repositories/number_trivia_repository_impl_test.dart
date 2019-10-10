import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_tutorial/core/error/exceptions.dart';
import 'package:tdd_tutorial/core/error/failures.dart';
import 'package:tdd_tutorial/core/platform/network_info.dart';
import 'package:tdd_tutorial/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:tdd_tutorial/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:tdd_tutorial/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_tutorial/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:tdd_tutorial/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  void runTestsOnline(Function body){
    group('device is online', ()
    {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });

  }

  void runTextsOffline(Function body){
    group('device is online', ()
    {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });

  }



  group('getConcreteNumberTrivia', ()
  {
    final tNumber = 1;
    final tNumberTriviaModel =
    NumberTriviaModel(number: tNumber, text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repository.getConcreteNumberTrivia(tNumber);

      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('should retunrn remote data when the call is successful', () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        final number = await repository.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(number, equals(Right(tNumberTrivia)));
      });
    });

    test('should cache the data locally when the call to remote is successful',
            () async {
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);

          await repository.getConcreteNumberTrivia(tNumber);

          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        });

    test(
        'should return failure when the call to the remote datasource is not successful',
            () async {
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());

          final number = await repository.getConcreteNumberTrivia(tNumber);

          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(number, equals(Left(ServerFailure())));
        });

    runTextsOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
              () async {
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);

            final result = await repository.getConcreteNumberTrivia(tNumber);

            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia()).called(1);
            expect(result, equals(Right(tNumberTrivia)));
          });

      test('should return last locally cached data when no cache data present',
              () async {
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());

            final result = await repository.getConcreteNumberTrivia(tNumber);

            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia()).called(1);
            expect(result, equals(Left(CacheFailure())));
          });
    });
  });





  group('getRandomNumberTrivia', ()
  {
    final tNumberTriviaModel =
    NumberTriviaModel(number: 123, text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check if device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repository.getRandomNumberTrivia();

      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('should retunrn remote data when the call is successful', () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final number = await repository.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(number, equals(Right(tNumberTrivia)));
      });
    });

    test('should cache the data locally when the call to remote is successful',
            () async {
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);

          await repository.getRandomNumberTrivia();

          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        });

    test(
        'should return failure when the call to the remote datasource is not successful',
            () async {
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());

          final number = await repository.getRandomNumberTrivia();

          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(number, equals(Left(ServerFailure())));
        });

    runTextsOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
              () async {
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);

            final result = await repository.getRandomNumberTrivia();

            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia()).called(1);
            expect(result, equals(Right(tNumberTrivia)));
          });

      test('should return last locally cached data when no cache data present',
              () async {
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());

            final result = await repository.getRandomNumberTrivia();

            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia()).called(1);
            expect(result, equals(Left(CacheFailure())));
          });
    });
  });
}

