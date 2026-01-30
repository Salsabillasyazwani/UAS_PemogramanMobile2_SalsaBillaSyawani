import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Obx(() {
        if (controller.isLoading.value && controller.name.value.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF800000)),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadUserProfile(),
          color: const Color(0xFF800000),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFF800000),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 60,
                      child: Text(
                        "Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // FOTO PROFIL
                    Positioned(
                      bottom: -50,
                      child: Obx(
                        () => CircleAvatar(
                          key: ValueKey(controller.avatarUrl.value),
                          radius: 65,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.grey[300],
                            backgroundImage:
                                controller.profileImage.value != null
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
                                    size: 50,
                                    color: Color(0xFF800000),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                Column(
                  children: [
                    Text(
                      controller.name.value.isEmpty
                          ? "Nama Pengguna"
                          : controller.name.value,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          (controller.streetController.text.isEmpty &&
                                  controller.kabupatenController.text.isEmpty)
                              ? "Alamat belum diatur"
                              : "${controller.streetController.text}, ${controller.kabupatenController.text}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Account",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildMenuTile(
                        title: "Edit Profile",
                        icon: Icons.person_outline,
                        onTap: () => Get.toNamed('/edit-profile'),
                      ),
                      _buildMenuTile(
                        title: "Alamat Toko (Struk)",
                        icon: Icons.storefront_outlined,
                        onTap: () => Get.toNamed('/edit-address'),
                      ),
                      _buildMenuTile(
                        title: "Ganti Password",
                        icon: Icons.lock_outline,
                        onTap: () => Get.toNamed('/change-password'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () => controller.signOut(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF800000),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: Colors.white, size: 20),
                        SizedBox(width: 10),
                        Text(
                          "Sign Out",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMenuTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF800000)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
