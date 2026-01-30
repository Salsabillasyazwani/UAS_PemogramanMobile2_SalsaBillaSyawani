import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../hpp_controller.dart';

class OverheadCard extends StatelessWidget {
  final HppController controller;
  final VoidCallback onAdd;
  final Function(int) onEdit;

  const OverheadCard({
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
                  '4. Biaya Tetap - Overhead',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Rp ${controller.totalOverhead.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B1515),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => controller.overheadList.isEmpty
                ? Text(
                    'Biaya overhead kosong. Harap klik tambah untuk menambahkan.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B1515),
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 4),
          Text(
            'Asumsi 1 bulan = 30 hari, 1 hari = 8 jam kerja',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),

          // List Overhead
          Obx(
            () => controller.overheadList.isNotEmpty
                ? Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.overheadList.length,
                        itemBuilder: (context, index) {
                          final item = controller.overheadList[index];
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
                                      Row(
                                        children: [
                                          Text(
                                            'Rp ${item.harga.toStringAsFixed(0)}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: const Color(
                                                  0xFF6B1515,
                                                ).withOpacity(0.3),
                                              ),
                                            ),
                                            child: Text(
                                              item.satuan,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Color(0xFF6B1515),
                                              ),
                                            ),
                                          ),
                                        ],
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
                                    controller.removeOverhead(index);
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
              label: const Text('Tambah Biaya Overhead'),
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
