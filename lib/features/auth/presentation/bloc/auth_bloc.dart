import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first/core/common/app_user/app_user_cubit.dart';
import 'package:offline_first/core/usecase/usecase.dart';
import 'package:offline_first/features/auth/domain/usecases/current_user.dart';
import 'package:offline_first/features/auth/domain/usecases/user_login.dart';
import 'package:offline_first/features/auth/domain/usecases/user_logout.dart';
import 'package:offline_first/features/auth/domain/usecases/user_sign_up.dart';

import '../../../../core/common/entities/user.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final UserLogout _userLogout;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserLogin userLogin,
    required UserSignUp usersignup,
    required CurrentUser currentuser,
    required AppUserCubit appUserCubit,
    required UserLogout userlogout,
  }) : _userSignUp = usersignup,
       _userLogin = userLogin,
       _currentUser = currentuser,
       _userLogout = userlogout,
       _appUserCubit = appUserCubit,

       super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignup);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<LogoutRequested>(_logoutUser);
  }

  void _logoutUser(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await _userLogout();
    response.fold((failure) {
      emit(AuthFailure(failure.message));
    }, (_) => emit(AuthLoggedOut()));
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final response = await _userLogin(
      UserLoginParams(email: event.email, password: event.password),
    );

    response.fold(
      (failure) {
        emit(AuthFailure(failure.message));
      },
      (user) {
        _emitAuthSuccess(user, emit);
      },
    );
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final response = await _currentUser(NoParams());

      response.fold(
        (failure) {
          emit(AuthFailure(failure.message));
        },
        (user) {
          _emitAuthSuccess(user, emit);
        },
      );
    } catch (e) {
      emit(AuthFailure('Unexpected error: $e'));
    }
  }

  void _onAuthSignup(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );
    response.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);

    emit(AuthSuccess(user));
  }
}
