import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'product_controller.dart';
import 'update_produk_page.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A0505),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Daftar produk',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4),
                ],
              ),
              child: TextField(
                onChanged: (value) => controller.searchQuery.value = value,
                decoration: const InputDecoration(
                  hintText: 'Search produk',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          // List Item
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: Color(0xFF800000)),
                );
              }

              if (controller.filteredProduk.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.searchQuery.value.isNotEmpty
                            ? 'Produk "${controller.searchQuery.value}"\ntidak ditemukan'
                            : 'Belum ada produk',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.loadProducts(),
                color: Color(0xFF800000),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.filteredProduk.length,
                  itemBuilder: (context, index) {
                    final p = controller.filteredProduk[index];
                    return _itemProduk(p, controller);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _itemProduk(Map<String, dynamic> p, ProductController controller) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp.',
      decimalDigits: 0,
    );

    final mfgDate = DateTime.parse(p['mfg_date']);
    final expDate = DateTime.parse(p['exp_date']);
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  formatter.format(p['price']),
                  style: const TextStyle(
                    color: Color(0xFF800000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Stock: ${p['stock'] > 0 ? p['stock'] : "Habis"}',
                  style: TextStyle(
                    color: p['stock'] > 0 ? Colors.grey : Colors.red,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'MFG: ${dateFormat.format(mfgDate)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  'EXP: ${dateFormat.format(expDate)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            children: [
              _btnAction(
                'Update',
                const Color(0xFF4A0505),
                () => Get.to(() => UpdateProdukPage(productData: p)),
              ),
              const SizedBox(height: 8),
              _btnAction(
                'Delete',
                const Color(0xFF800000),
                () => _showDeleteDialog(controller, p['id'], p['name']),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(ProductController controller, String id, String name) {
    Get.dialog(
      AlertDialog(
        title: Text('Hapus Produk'),
        content: Text('Yakin ingin menghapus "$name"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Batal')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteProduct(id);
            },
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _btnAction(String label, Color color, VoidCallback onTap) {
    return SizedBox(
      width: 65,
      height: 28,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 11),
        ),
      ),
    );
  }
}
