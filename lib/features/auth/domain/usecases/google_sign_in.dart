import 'package:supabase_flutter/supabase_flutter.dart' as su;
import 'package:offline_first/core/error/failures.dart';
import 'package:offline_first/core/usecase/usecase.dart';
import 'package:offline_first/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class GoogleSignInUseCase implements UseCase<su.User, NoParams> {
  final AuthRepository authRepository;
  GoogleSignInUseCase(this.authRepository);

  @override
  Future<Either<Failure, su.User>> call(NoParams params) async {
    print('🔹 GoogleSignInUseCase called');
    final result = await authRepository.signInWithGoogle();
    result.fold(
          (failure) => print('❌ UseCase failure: ${failure.message}'),
          (user) => print('✅ UseCase success: ${user.id}, ${user.email}'),
    );
    return result;
  }
}