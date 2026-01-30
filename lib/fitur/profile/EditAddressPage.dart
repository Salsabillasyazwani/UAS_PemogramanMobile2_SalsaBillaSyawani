import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';
import '../../core/widgets/custom_input.dart';
import '../../core/widgets/custom_button.dart';

class EditAddressPage extends StatelessWidget {
  const EditAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Alamat Toko",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Detail alamat ini akan tercetak otomatis pada header struk belanja.",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 25),
            CustomInput(
              hint: 'Nama Jalan / No ',
              controller: controller.streetController,
              prefixIcon: const Icon(Icons.location_on_outlined),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CustomInput(
                    hint: 'Kecamatan',
                    controller: controller.kecamatanController,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomInput(
                    hint: 'Kabupaten/Kota',
                    controller: controller.kabupatenController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CustomInput(
              hint: 'Provinsi',
              controller: controller.provinsiController,
            ),

            const SizedBox(height: 40),
            Obx(
              () => CustomButton(
                text: 'Simpan Alamat Struk',
                isLoading: controller.isLoading.value,
                onPressed: () => controller.updateAddress(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
