import 'package:fpdart/fpdart.dart';
import 'package:offline_first/core/error/failures.dart';

import '../../../../core/common/entities/user.dart' as u;
import 'package:supabase_flutter/supabase_flutter.dart' as su;


abstract interface class AuthRepository {
  Future<Either<Failure, u.User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, u.User>> loginUpWithEmailPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, su.User>> signInWithGoogle();


  Future<Either<Failure , u.User>> currentUser();
  Future<Either<Failure, void>> logout();




}
