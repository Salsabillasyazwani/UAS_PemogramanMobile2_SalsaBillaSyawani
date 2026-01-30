import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'report_controller.dart';
import 'report_detail_page.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ReportController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Laporan",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF6B1515),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Laporan Daftar Produk
          _menuTile(
            "Laporan daftar produk",
            () => Get.to(
              () => Obx(
                () => ReportDetailPage(
                  title: "Laporan Daftar Produk",
                  headers: const [
                    "ID",
                    "Nama",
                    "Kategori",
                    "Satuan",
                    "Harga",
                    "Stok",
                    "MFG",
                    "EXP",
                  ],
                  rows: ctrl.filteredProduk
                      .map(
                        (p) => DataRow(
                          cells: [
                            DataCell(Text(p.id)),
                            DataCell(Text(p.nama)),
                            DataCell(Text(p.kategori)),
                            DataCell(Text(p.satuan)),
                            DataCell(Text("Rp ${p.harga}")),
                            DataCell(Text(p.stok.toString())),
                            DataCell(Text(p.mfg)),
                            DataCell(Text(p.exp)),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
          _menuTile(
            "Laporan mutasi produk",
            () => Get.to(
              () => Obx(
                () => ReportDetailPage(
                  title: "Laporan Mutasi Produk",
                  headers: const [
                    "Tanggal",
                    "ID Produk",
                    "Nama Produk",
                    "Jenis",
                    "Jumlah",
                  ],
                  rows: ctrl.filteredMutasi
                      .map(
                        (m) => DataRow(
                          cells: [
                            DataCell(Text(m.tanggal)),
                            DataCell(Text(m.idProduk)),
                            DataCell(Text(m.namaProduk)),
                            DataCell(
                              Text(
                                m.jenis,
                                style: TextStyle(
                                  color: m.jenis == "Masuk"
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataCell(Text(m.jumlah.toString())),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),

          _menuTile(
            "Laporan transaksi",
            () => Get.to(
              () => Obx(
                () => ReportDetailPage(
                  title: "Laporan Transaksi",
                  headers: const [
                    "ID Transaksi",
                    "Tanggal",
                    "Item",
                    "Total",
                    "Metode",
                  ],
                  rows: ctrl.filteredTransaksi
                      .map(
                        (t) => DataRow(
                          cells: [
                            DataCell(Text(t.id)),
                            DataCell(Text(t.tanggal)),
                            DataCell(Text(t.totalItem.toString())),
                            DataCell(Text("Rp ${t.totalHarga}")),
                            DataCell(Text(t.metodeBayar)),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),

          // Riwayat HPP
          _menuTile(
            "Riwayat HPP",
            () => Get.to(
              () => Obx(
                () => ReportDetailPage(
                  title: "Riwayat HPP",
                  headers: const [
                    "Tanggal",
                    "Produk",
                    "Total HPP",
                    "HPP/Unit",
                    "Jual",
                    "Jual+Pajak",
                    "Margin",
                  ],
                  rows: ctrl.filteredHpp
                      .map(
                        (h) => DataRow(
                          cells: [
                            DataCell(Text(h.tanggal)),
                            DataCell(Text(h.productName ?? '-')),
                            DataCell(Text("Rp ${h.totalHpp}")),
                            DataCell(Text("Rp ${h.perUnit}")),
                            DataCell(Text("Rp ${h.jual}")),
                            DataCell(Text("Rp ${h.jualPajak}")),
                            DataCell(Text("Rp ${h.margin}")),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuTile(String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF6B1515)),
        onTap: onTap,
      ),
    );
  }
}
