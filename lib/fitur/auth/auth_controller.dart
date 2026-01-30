import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/routes/app_routes.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/user_model.dart';

class AuthController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final SupabaseClient _supabase = Supabase.instance.client;

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  void clearFields() {
    nameController.clear();
    usernameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  bool _isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return regex.hasMatch(password);
  }

  Future<void> signUp() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty) {
      _showErrorSnackbar('Harap isi semua kolom');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showErrorSnackbar('Password tidak cocok');
      return;
    }

    if (!_isValidPassword(passwordController.text)) {
      _showErrorSnackbar('Password minimal 8 karakter (huruf & angka)');
      return;
    }

    isLoading.value = true;
    try {
      final userModel = UserModel(
        id: '',
        name: nameController.text,
        username: emailController.text.split('@')[0],
        email: emailController.text,
        phone: phoneController.text,
      );

      final response = await authService.signUpWithEmail(
        userModel,
        passwordController.text,
      );

      final user = response.user;
      if (user == null) return;

      await _supabase.from('profiles').upsert({
        'id': user.id,
        'name': userModel.name,
        'username': userModel.username,
        'email': userModel.email,
        'phone_number': userModel.phone,
      });

      _showSuccessSnackbar('Akun berhasil dibuat!');
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      _showErrorSnackbar('Pendaftaran Gagal: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showErrorSnackbar('Email dan Password wajib diisi');
      return;
    }

    isLoading.value = true;
    try {
      await authService.signInWithEmail(
        emailController.text,
        passwordController.text,
      );

      Get.offAllNamed(AppRoutes.dashboard);
      _showSuccessSnackbar('Selamat Datang Kembali!');
    } catch (e) {
      _showErrorSnackbar('Login Gagal');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    try {
      await authService.signInWithGoogle();

      final user = _supabase.auth.currentUser;
      if (user == null) return;

      await _supabase.from('profiles').upsert({
        'id': user.id,
        'name': user.userMetadata?['full_name'] ?? 'User Google',
        'email': user.email,
        'username': user.email!.split('@')[0],
      });

      _showSuccessSnackbar('Berhasil masuk dengan Google');
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      _showErrorSnackbar('Google Sign-In Gagal: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await authService.signOut();
    clearFields();
    Get.offAllNamed(AppRoutes.login);
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Berhasil',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
