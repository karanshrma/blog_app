import 'package:offline_first/core/error/exceptions.dart';
import 'package:offline_first/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<User> signInWithGoogle();

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

  @override
  Future<User> signInWithGoogle() async {

    try {
      const webClientId = '1054557196365-o27lfcrrf2sr3bdl9coag4j21ggm7cur.apps.googleusercontent.com';
      final scopes = ['email', 'profile'];
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        serverClientId: webClientId,
      );
      final googleUser = await googleSignIn.attemptLightweightAuthentication();
      if (googleUser == null) {
        throw AuthException('Failed to sign in with Google.');
      }
      final authorization =
          await googleUser.authorizationClient.authorizationForScopes(scopes) ??
              await googleUser.authorizationClient.authorizeScopes(scopes);
      final idToken = googleUser.authentication.idToken;
      if (idToken == null) {
        throw AuthException('No ID Token found.');
      }
      await supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: authorization.accessToken,
      );

      return User(id: googleUser.id,
          appMetadata: <String, dynamic>{},
          userMetadata: <String, dynamic>{},
          aud: '',
          createdAt: DateTime.now().toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }


}
