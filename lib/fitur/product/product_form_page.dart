import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'product_form_controller.dart';

class ProductFormPage extends StatelessWidget {
  const ProductFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formC = Get.put(ProductFormController());
    print('Current user: ${Supabase.instance.client.auth.currentUser?.id}');
    print('User email: ${Supabase.instance.client.auth.currentUser?.email}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      formC.clearForm();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A0505),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Input Produk',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      ),
      body: Obx(() {
        if (formC.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFF800000)),
                SizedBox(height: 16),
                Text('Menyimpan produk...'),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _fieldTgl(context, "Tanggal Produksi (MFG)", true),
              _input(formC.namaC, 'Nama produk'),
              _input(formC.kategoriC, 'Kategori produk'),
              _input(formC.satuanC, 'Satuan'),
              _input(formC.hargaC, 'Harga', isNumber: true),
              _input(formC.stockC, 'Stock', isNumber: true),
              _fieldTgl(context, "Tanggal Kadaluarsa (EXP)", false),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => formC.submitData(isUpdate: false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF800000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text(
                    'Input',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _input(TextEditingController c, String hint, {bool isNumber = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: TextField(
        controller: c,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _fieldTgl(BuildContext context, String label, bool isMfg) {
    final formC = Get.find<ProductFormController>();
    return Obx(
      () => InkWell(
        onTap: () => formC.chooseDate(context, isMfg),
        child: Container(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_month, color: Color(0xFF800000)),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  Text(
                    isMfg ? formC.mfgText : formC.expText,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
