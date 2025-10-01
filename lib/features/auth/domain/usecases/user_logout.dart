
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../repository/auth_repository.dart';

class UserLogout {
  final AuthRepository repository;

  UserLogout(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}