import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import 'package:path/path.dart' as p;

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<UserModel?> getUserProfile() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return null;

    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', uid)
        .maybeSingle();

    if (response == null) return null;
    return UserModel.fromJson(response);
  }

  Future<void> updateProfile({
    required String name,
    required String username,
    required String email,
    required String phone,
  }) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) throw Exception('User not authenticated');

    await _supabase
        .from('profiles')
        .update({
          'name': name,
          'username': username,
          'email': email,
          'phone_number': phone,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', uid);
  }

  // UPDATE ADDRESS
  Future<void> updateAddress({
    required String street,
    required String kecamatan,
    required String kabupaten,
    required String provinsi,
  }) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) throw Exception('User not authenticated');

    await _supabase
        .from('profiles')
        .update({
          'street': street,
          'kecamatan': kecamatan,
          'kabupaten': kabupaten,
          'provinsi': provinsi,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', uid);
  }

  // UPLOAD PROFILE
  Future<String> uploadProfilePicture(File imageFile) async {
    try {
      final uid = _supabase.auth.currentUser?.id;
      if (uid == null) throw Exception('User tidak terautentikasi');
      final String extension = p.extension(imageFile.path).replaceAll('.', '');
      final fileName = 'profile_$uid.$extension';
      final path = 'profiles/$fileName';
      await _supabase.storage
          .from('avatars')
          .upload(
            path,
            imageFile,
            fileOptions: FileOptions(
              upsert: true,
              contentType: 'image/$extension',
            ),
          );

      final String publicUrl = _supabase.storage
          .from('avatars')
          .getPublicUrl(path);
      await _supabase
          .from('profiles')
          .update({'profile_url': publicUrl})
          .eq('id', uid);

      return publicUrl;
    } catch (e) {
      print(' Error saat memproses ekstensi/upload: $e');
      rethrow;
    }
  }

  Future<void> deleteProfilePicture() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) throw Exception('User tidak terautentikasi');

    await _supabase
        .from('profiles')
        .update({'profile_url': null})
        .eq('id', uid);
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final isGoogleUser =
        user.identities?.any((i) => i.provider == 'google') ?? false;

    if (isGoogleUser) {
      throw Exception(
        'Akun Google tidak bisa mengganti password. Gunakan reset password.',
      );
    }

    try {
      await _supabase.auth.signInWithPassword(
        email: user.email!,
        password: oldPassword,
      );

      // Update password
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));
    } on AuthException catch (e) {
      if (e.message.toLowerCase().contains('invalid login')) {
        throw Exception('Password lama salah');
      }
      rethrow;
    }
  }
}
