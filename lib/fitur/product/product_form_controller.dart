import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/services/product_service.dart';
import 'product_controller.dart';

class ProductFormController extends GetxController {
  final ProductService _productService = ProductService();
  final namaC = TextEditingController();
  final kategoriC = TextEditingController();
  final satuanC = TextEditingController();
  final hargaC = TextEditingController();
  final stockC = TextEditingController();

  // Tanggal
  var selectedMfgDate = DateTime.now().obs;
  var selectedExpDate = DateTime.now().obs;
  var isLoading = false.obs;

  //  format tanggal
  String get mfgText => DateFormat('dd/MM/yyyy').format(selectedMfgDate.value);
  String get expText => DateFormat('dd/MM/yyyy').format(selectedExpDate.value);

  Future<void> chooseDate(BuildContext context, bool isMfg) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isMfg ? selectedMfgDate.value : selectedExpDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF800000),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (isMfg) {
        selectedMfgDate.value = picked;
      } else {
        selectedExpDate.value = picked;
      }
    }
  }

  void fillForm(Map<String, dynamic> data) {
    namaC.text = data['name'] ?? '';
    kategoriC.text = data['category'] ?? '';
    satuanC.text = data['unit'] ?? '';
    hargaC.text = data['price'].toString();
    stockC.text = data['stock'].toString();

    try {
      if (data['mfg_date'] != null) {
        selectedMfgDate.value = DateTime.parse(data['mfg_date']);
      }
      if (data['exp_date'] != null) {
        selectedExpDate.value = DateTime.parse(data['exp_date']);
      }
    } catch (e) {
      print(" Error parsing date: $e");
    }
  }

  void clearForm() {
    namaC.clear();
    kategoriC.clear();
    satuanC.clear();
    hargaC.clear();
    stockC.clear();
    selectedMfgDate.value = DateTime.now();
    selectedExpDate.value = DateTime.now();
  }

  bool _validateForm() {
    if (namaC.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Nama produk harus diisi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    if (kategoriC.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Kategori harus diisi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    if (satuanC.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Satuan harus diisi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    if (hargaC.text.isEmpty || double.tryParse(hargaC.text) == null) {
      Get.snackbar(
        'Error',
        'Harga harus berupa angka',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    if (stockC.text.isEmpty || int.tryParse(stockC.text) == null) {
      Get.snackbar(
        'Error',
        'Stock harus berupa angka',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  Future<void> submitData({required bool isUpdate, String? id}) async {
    if (!_validateForm()) return;

    try {
      isLoading.value = true;

      if (isUpdate && id != null) {
        print('Updating product ID: $id');

        final success = await _productService.updateProduct(
          id: id,
          name: namaC.text,
          category: kategoriC.text,
          unit: satuanC.text,
          price: double.parse(hargaC.text),
          stock: int.parse(stockC.text),
          mfgDate: selectedMfgDate.value,
          expDate: selectedExpDate.value,
        );

        if (success) {
          Get.snackbar(
            'Sukses',
            'Produk berhasil diupdate',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.back();
          if (Get.isRegistered<ProductController>()) {
            final productController = Get.find<ProductController>();
            await productController.loadProducts();
          }
        } else {
          Get.snackbar(
            'Error',
            'Gagal update produk',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        // Create Product
        print('  CREATE PRODUCT START ');
        print('Name: ${namaC.text}');
        print('Category: ${kategoriC.text}');
        print('Unit: ${satuanC.text}');
        print('Price: ${hargaC.text}');
        print('Stock: ${stockC.text}');
        print('MFG Date: ${selectedMfgDate.value}');
        print('EXP Date: ${selectedExpDate.value}');

        final result = await _productService.createProduct(
          name: namaC.text,
          category: kategoriC.text,
          unit: satuanC.text,
          price: double.parse(hargaC.text),
          stock: int.parse(stockC.text),
          mfgDate: selectedMfgDate.value,
          expDate: selectedExpDate.value,
        );

        print('Create result: $result');

        if (result != null) {
          Get.snackbar(
            'Sukses',
            'Produk berhasil ditambahkan',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 2),
          );
          clearForm();

          if (Get.isRegistered<ProductController>()) {
            final productController = Get.find<ProductController>();
            await productController.loadProducts();
          }

          Get.back();
        } else {
          Get.snackbar(
            'Error',
            'Gagal menambahkan produk. Periksa console untuk detail.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );
        }
      }
    } catch (e) {
      print('Submit error: $e');
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    namaC.dispose();
    kategoriC.dispose();
    satuanC.dispose();
    hargaC.dispose();
    stockC.dispose();
    super.onClose();
  }
}
