import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});

  final controller = Get.find<ProfileController>();

  final nameC = TextEditingController();
  final userC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameC.text = controller.name.value;
    userC.text = controller.username.value;
    emailC.text = controller.email.value;
    phoneC.text = controller.phone.value;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF800000)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  // FOTO PROFIL
                  Obx(
                    () => CircleAvatar(
                      key: ValueKey(controller.avatarUrl.value),
                      radius: 55,
                      backgroundColor: const Color(0xFF800000),
                      child: CircleAvatar(
                        radius: 52,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: controller.profileImage.value != null
                            ? FileImage(controller.profileImage.value!)
                            : (controller.avatarUrl.value.isNotEmpty
                                  ? NetworkImage(
                                      '${controller.avatarUrl.value}?t=${DateTime.now().millisecondsSinceEpoch}',
                                    )
                                  : null),
                        child:
                            (controller.profileImage.value == null &&
                                controller.avatarUrl.value.isEmpty)
                            ? const Icon(
                                Icons.person,
                                size: 55,
                                color: Color(0xFF800000),
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => controller.showImageOptionsDialog(),
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      size: 18,
                      color: Colors.blue,
                    ),
                    label: const Text(
                      "Ubah Foto",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _buildField("Nama Lengkap", nameC, Icons.badge_outlined),
            _buildField("Username", userC, Icons.alternate_email),
            _buildField("Email", emailC, Icons.email_outlined),
            _buildField("No. HP", phoneC, Icons.phone_android_outlined),

            const SizedBox(height: 40),

            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.updateProfile(
                          newName: nameC.text,
                          newUser: userC.text,
                          newEmail: emailC.text,
                          newPhone: phoneC.text,
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF800000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "SIMPAN PERUBAHAN",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController textC, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: textC,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF800000),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
