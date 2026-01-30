import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/product_service.dart';

class ProductController extends GetxController {
  final ProductService _productService = ProductService();

  var listProduk = <Map<String, dynamic>>[].obs;
  var searchQuery = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      final products = await _productService.getAllProducts();
      listProduk.value = products;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat produk: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> get filteredProduk {
    if (searchQuery.value.isEmpty) {
      return listProduk;
    } else {
      return listProduk.where((p) {
        final name = p['name'].toString().toLowerCase();
        final category = p['category'].toString().toLowerCase();
        final query = searchQuery.value.toLowerCase();
        return name.contains(query) || category.contains(query);
      }).toList();
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      isLoading.value = true;
      final success = await _productService.deleteProduct(id);

      if (success) {
        Get.snackbar(
          'Sukses',
          'Produk berhasil dihapus',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await loadProducts();
      } else {
        Get.snackbar(
          'Error',
          'Gagal menghapus produk',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProducts() async {
    await loadProducts();
  }

  Future<void> updateStock(String id, int newStock) async {
    try {
      final success = await _productService.updateStock(
        id: id,
        newStock: newStock,
      );

      if (success) {
        Get.snackbar(
          'Sukses',
          'Stock berhasil diupdate',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await loadProducts();
      } else {
        Get.snackbar(
          'Error',
          'Gagal update stock',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
