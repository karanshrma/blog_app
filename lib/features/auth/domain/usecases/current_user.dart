import 'package:offline_first/core/error/failures.dart';
import 'package:offline_first/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:offline_first/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/common/entities/user.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;

  CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    try {
      final result = await authRepository.currentUser();

      result.fold((failure) {}, (user) {});

      return result;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
