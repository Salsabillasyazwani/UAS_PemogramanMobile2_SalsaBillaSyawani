import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../hpp_controller.dart';

class BahanBakuCard extends StatelessWidget {
  final HppController controller;
  final VoidCallback onAdd;
  final Function(int) onEdit;

  const BahanBakuCard({
    Key? key,
    required this.controller,
    required this.onAdd,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '2. Biaya Variabel - Bahan Baku',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Rp ${controller.totalBahanBaku.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B1515),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => controller.bahanBakuList.isEmpty
                ? Text(
                    'Biaya bahan baku kosong. Harap klik tambah untuk menambahkan.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B1515),
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          Obx(
            () => controller.bahanBakuList.isNotEmpty
                ? Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.bahanBakuList.length,
                        itemBuilder: (context, index) {
                          final item = controller.bahanBakuList[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF5F5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFFFCDD2),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.nama,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Rp ${item.harga.toStringAsFixed(0)}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Tombol Edit
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    color: Color(0xFF6B1515),
                                    size: 18,
                                  ),
                                  onPressed: () => onEdit(index),
                                ),
                                // Tombol Delete
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Color(0xFF6B1515),
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    controller.removeBahanBaku(index);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  )
                : const SizedBox.shrink(),
          ),

          // Button Tambah
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Tambah Bahan Baku'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF6B1515),
                side: const BorderSide(color: Color(0xFF6B1515)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
