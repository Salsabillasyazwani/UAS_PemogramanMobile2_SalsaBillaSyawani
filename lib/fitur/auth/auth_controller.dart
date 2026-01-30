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

  // --- REGISTER MANUAL ---
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

    final confirmed = await _showConfirmationDialog(
      title: 'Konfirmasi',
      message: 'Apakah Anda yakin ingin mendaftar?',
    );

    if (confirmed != true) return;

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
      if (response.user != null) {
        final String uid = response.user!.id;

        await _supabase.from('profiles').upsert({
          'id': uid,
          'name': nameController.text,
          'username': emailController.text.split('@')[0],
          'email': emailController.text,
          'phone_number': phoneController.text,
        });

        _showSuccessSnackbar('Akun berhasil dibuat!');
        Get.offAllNamed(AppRoutes.dashboard);
      }
    } catch (e) {
      _showErrorSnackbar('Pendaftaran Gagal: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // --- SIGN IN MANUAL ---
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
      _showSuccessSnackbar('Selamat Datang Kembali!');
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      _showErrorSnackbar('Login Gagal: Email atau Password salah');
    } finally {
      isLoading.value = false;
    }
  }

  // --- LOGIN & DAFTAR GOOGLE ---
  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    try {
      final result = await authService.signInWithGoogle();

      if (result != null && result.user != null) {
        await _supabase.from('profiles').upsert({
          'id': result.user!.id,
          'name': result.user!.userMetadata?['full_name'] ?? 'User Google',
          'email': result.user!.email,
          'username': result.user!.email!.split('@')[0],
        });

        _showSuccessSnackbar('Berhasil masuk dengan Google');
        Get.offAllNamed(AppRoutes.dashboard);
      }
    } catch (e) {
      _showErrorSnackbar('Google Sign-In Gagal: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // --- LOGOUT ---
  Future<void> signOut() async {
    try {
      await authService.signOut();
      clearFields();
      Get.deleteAll(force: true);

      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      _showErrorSnackbar('Gagal Logout');
    }
  }

  // --- HELPER UI (Tetap Sesuai Logika Kamu) ---
  Future<bool?> _showConfirmationDialog({
    required String title,
    required String message,
  }) async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B1515),
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Lanjut'),
          ),
        ],
      ),
    );
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
      backgroundColor: const Color.fromARGB(255, 54, 224, 60),
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
