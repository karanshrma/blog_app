import 'package:fpdart/fpdart.dart';
import 'package:offline_first/core/error/failures.dart';

import '../../../../core/common/entities/user.dart';


abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> loginUpWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure , User>> currentUser();
  Future<Either<Failure, void>> logout();


}
