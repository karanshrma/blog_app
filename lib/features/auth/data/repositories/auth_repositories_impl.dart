import 'package:fpdart/fpdart.dart';
import 'package:offline_first/core/error/exceptions.dart';
import 'package:offline_first/core/error/failures.dart';
import 'package:offline_first/core/network/network_checker.dart';
import 'package:offline_first/features/auth/data/datasources/auth_remote_data_sources.dart';
import 'package:offline_first/features/auth/data/models/user_model.dart';
import 'package:offline_first/features/auth/domain/repository/auth_repository.dart';
import '../../../../core/common/entities/user.dart' ;
import 'package:supabase_flutter/supabase_flutter.dart' as su;


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  AuthRepositoryImpl(this.remoteDataSource , this.connectionChecker);

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if(! await (connectionChecker.isConnected)){
        final session = remoteDataSource.currentUserSession;
        if(session == null){
          return left(Failure('User not logged in!'));
        }
        return right(UserModel(id: session.user.id, email: session.user.email ?? '', name: ''));
      }
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User not logged in!'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> loginUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      if(!await (connectionChecker.isConnected)){
        return left(Failure('No Internet Connection'));
      }

      final user = await fn();


      return right(user);
    } on ServerException catch (e) {
      print('❌ _getUser: ServerException caught - ${e.message}');
      return left(Failure(e.message));
    } catch (e) {
      print('🔥 _getUser: Unexpected exception - $e');
      return left(Failure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, su.User>> signInWithGoogle() async {
    print('🔹 signInWithGoogle called');
    try {
      if (!await connectionChecker.isConnected) {
        print('❌ No internet connection');
        return left(Failure('No Internet Connection'));
      }

      print('🌐 Internet connected, calling remoteDataSource.signInWithGoogle()');
      final googleUser = await remoteDataSource.signInWithGoogle();
      print('✅ Google sign-in successful: ${googleUser.id}, ${googleUser.email}');

      return Right(googleUser);
    } catch (e) {
      print('⚠️ Error in signInWithGoogle: $e');
      return Left(Failure(e.toString()));
    }
  }




}
