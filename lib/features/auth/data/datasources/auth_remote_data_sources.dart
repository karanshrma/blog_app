import 'package:offline_first/core/error/exceptions.dart';
import 'package:offline_first/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;

  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw const ServerException('User is null');
      }
      return UserModel.fromJson(response.user!.toJson());

    } on AuthException catch (e) {
      print('❌ _getUser: AuthException caught - ${e.message}');
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      if (response.user == null) {
        throw const ServerException('User is null');
      }
      return UserModel.fromJson(response.user!.toJson());
    }  on AuthException catch (e) {
      print('❌ _getUser: AuthException caught - ${e.message}');
      throw ServerException(e.message);
    }catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      // Check if user is authenticated
      if (currentUserSession == null) {
        return null;
      }

      final userId = currentUserSession!.user.id;
      print('Fetching profile for user ID: $userId');

      final userData = await supabaseClient
          .from('profiles')
          .select()
          .eq('id', userId);

      // Check if any data was returned
      if (userData.isEmpty) {
        return null;
      }

      return UserModel.fromJson(
        userData.first,
      ).copyWith(email: currentUserSession!.user.email);
    } on PostgrestException catch (e) {
      print('Database error: ${e.message}');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw ServerException(e.toString());
    }
  }
  @override
  Future<void> logout() async {
    try {
      await supabaseClient.auth.signOut();
      print('User logged out successfully');
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

}
