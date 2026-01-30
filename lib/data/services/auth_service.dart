import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '693691321935-6fdimaptea36ke81pd10kcjh4sh86p47.apps.googleusercontent.com',
  );
  // REGISTER MANUAL
  Future<AuthResponse> signUpWithEmail(UserModel user, String password) async {
    try {
      final AuthResponse response = await _supabase.auth.signUp(
        email: user.email,
        password: password,
        data: {'full_name': user.name, 'username': user.username},
      );
      return response;
    } catch (e) {
      print('Error Supabase Register: $e');
      rethrow;
    }
  }

  // LOGIN MANUAL
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error Supabase Login: $e');
      rethrow;
    }
  }

  // LOGIN / REGISTER GOOGLE
  Future<AuthResponse?> signInWithGoogle() async {
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (idToken == null) throw 'ID Token tidak ditemukan.';
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      return response;
    } catch (e) {
      print('Error Supabase Google: $e');
      rethrow;
    }
  }

  // LOGOUT
  Future<void> signOut() async {
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
        await _googleSignIn.disconnect();
      }
      await _supabase.auth.signOut();
    } catch (e) {
      print('Error Logout: $e');
      rethrow;
    }
  }
}
