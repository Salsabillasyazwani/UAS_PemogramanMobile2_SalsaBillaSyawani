import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/services/profile_service.dart';
import '../../data/services/auth_service.dart';
import '../../core/routes/app_routes.dart';

class ProfileController extends GetxController {
  final ProfileService profileService = Get.find<ProfileService>();
  final AuthService authService = Get.find<AuthService>();
  final isLoading = false.obs;
  final name = ''.obs;
  final username = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final avatarUrl = ''.obs;
  final Rx<File?> profileImage = Rx<File?>(null);
  final streetController = TextEditingController();
  final kecamatanController = TextEditingController();
  final kabupatenController = TextEditingController();
  final provinsiController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  @override
  void onReady() {
    super.onReady();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    isLoading.value = true;
    try {
      final userProfile = await profileService.getUserProfile();

      if (userProfile != null) {
        name.value = userProfile.name;
        username.value = userProfile.username;
        email.value = userProfile.email;
        phone.value = userProfile.phone;
        avatarUrl.value = userProfile.profileUrl ?? '';
        streetController.text = userProfile.street ?? '';
        kecamatanController.text = userProfile.kecamatan ?? '';
        kabupatenController.text = userProfile.kabupaten ?? '';
        provinsiController.text = userProfile.provinsi ?? '';

        print('User profile loaded successfully: ${userProfile.name}');
      } else {
        print('No user profile found in database');
      }
    } catch (e) {
      print('Error loading user profile: $e');
      _showErrorSnackbar('Gagal memuat data profil');
    } finally {
      isLoading.value = false;
    }
  }

  void showImageOptionsDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Ubah Foto Profil'),
        content: const Text('Pilih opsi untuk mengubah foto profil:'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              deleteProfilePicture();
            },
            child: const Text(
              'Hapus Foto',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              pickImageFromGallery();
            },
            child: const Text('Pilih dari Galeri'),
          ),
        ],
      ),
    );
  }

  Future<void> pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        profileImage.value = File(image.path);
        // Langsung upload ke server
        await uploadProfilePicture();
      }
    } catch (e) {
      _showErrorSnackbar('Gagal memilih gambar');
      print('Error picking image: $e');
    }
  }

  Future<void> uploadProfilePicture() async {
    if (profileImage.value == null) return;

    isLoading.value = true;
    try {
      final publicUrl = await profileService.uploadProfilePicture(
        profileImage.value!,
      );

      avatarUrl.value = publicUrl;
      profileImage.value = null;
      await _showSuccessDialog(
        title: 'Berhasil!',
        message: 'Foto profil berhasil diperbarui',
      );
      await loadUserProfile();
    } catch (e) {
      _showErrorSnackbar('Gagal mengupload foto');
      print(' Error uploading profile picture: $e');
      profileImage.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProfilePicture() async {
    isLoading.value = true;
    try {
      await profileService.deleteProfilePicture();
      avatarUrl.value = '';
      profileImage.value = null;
      await _showSuccessDialog(
        title: 'Berhasil!',
        message: 'Foto profil berhasil dihapus',
      );
      await loadUserProfile();
    } catch (e) {
      _showErrorSnackbar('Gagal menghapus foto');
      print('Error deleting profile picture: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile({
    required String newName,
    required String newUser,
    required String newEmail,
    required String newPhone,
  }) async {
    if (newName.isEmpty ||
        newUser.isEmpty ||
        newEmail.isEmpty ||
        newPhone.isEmpty) {
      _showErrorSnackbar('Semua kolom harus diisi');
      return;
    }
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi'),
        content: const Text(
          'Apakah Anda yakin ingin menyimpan perubahan profil?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF800000),
            ),
            child: const Text('Ya, Simpan'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      isLoading.value = true;
      try {
        await profileService.updateProfile(
          name: newName,
          username: newUser,
          email: newEmail,
          phone: newPhone,
        );
        name.value = newName;
        username.value = newUser;
        email.value = newEmail;
        phone.value = newPhone;
        await _showSuccessDialog(
          title: 'Berhasil!',
          message: 'Data profil Anda telah diperbarui',
        );
        Get.back();
      } catch (e) {
        _showErrorSnackbar('Gagal memperbarui profil');
        print('Error updating profile: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> updateAddress() async {
    if (streetController.text.isEmpty ||
        kecamatanController.text.isEmpty ||
        kabupatenController.text.isEmpty ||
        provinsiController.text.isEmpty) {
      _showErrorSnackbar('Semua kolom alamat harus diisi');
      return;
    }

    isLoading.value = true;
    try {
      await profileService.updateAddress(
        street: streetController.text,
        kecamatan: kecamatanController.text,
        kabupaten: kabupatenController.text,
        provinsi: provinsiController.text,
      );

      isLoading.value = false;
      await _showSuccessDialog(
        title: 'Berhasil!',
        message: 'Alamat toko berhasil disimpan',
      );

      Get.back();
    } catch (e) {
      isLoading.value = false;
      _showErrorSnackbar('Gagal memperbarui alamat');
      print('Error updating address: $e');
    }
  }

  Future<void> changePassword({
    required String oldPass,
    required String newPass,
    required String confirmPass,
  }) async {
    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      _showErrorSnackbar('Semua kolom password harus diisi');
      return;
    }

    if (newPass != confirmPass) {
      _showErrorSnackbar('Password baru dan konfirmasi tidak cocok');
      return;
    }

    if (newPass.length < 8) {
      _showErrorSnackbar('Password minimal 8 karakter');
      return;
    }

    isLoading.value = true;
    try {
      await profileService.changePassword(
        oldPassword: oldPass,
        newPassword: newPass,
      );

      _showSuccessSnackbar('Password berhasil diubah');
      Get.back();
    } catch (e) {
      if (e.toString().contains('wrong-password') ||
          e.toString().contains('invalid-credential')) {
        _showErrorSnackbar('Password lama salah');
      } else {
        _showErrorSnackbar('Gagal mengubah password');
      }
      print(' Error changing password: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // SIGN OUT
  Future<void> signOut() async {
    try {
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF800000),
              ),
              child: const Text('Ya, Keluar'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        await authService.signOut();
        name.value = '';
        username.value = '';
        email.value = '';
        phone.value = '';
        avatarUrl.value = '';
        profileImage.value = null;
        streetController.clear();
        kecamatanController.clear();
        kabupatenController.clear();
        provinsiController.clear();

        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e) {
      _showErrorSnackbar('Gagal logout');
      print(' Error signing out: $e');
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
    );
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Berhasil',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
    );
  }

  Future<void> _showSuccessDialog({
    required String title,
    required String message,
  }) async {
    return await Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Success
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
              ),
              const SizedBox(height: 20),
              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF800000),
                ),
              ),
              const SizedBox(height: 10),
              // Message
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              // Button OK
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    streetController.dispose();
    kecamatanController.dispose();
    kabupatenController.dispose();
    provinsiController.dispose();
    super.onClose();
  }
}
