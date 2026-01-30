import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/hpp_service.dart';

class BahanBaku {
  String nama;
  double harga;

  BahanBaku({required this.nama, required this.harga});

  Map<String, dynamic> toJson() => {'nama': nama, 'harga': harga};

  factory BahanBaku.fromJson(Map<String, dynamic> json) {
    return BahanBaku(
      nama: json['nama'] ?? '',
      harga: (json['harga'] ?? 0).toDouble(),
    );
  }
}

class TenagaKerja {
  String nama;
  double harga;
  String satuan;

  TenagaKerja({required this.nama, required this.harga, required this.satuan});

  Map<String, dynamic> toJson() => {
    'nama': nama,
    'harga': harga,
    'satuan': satuan,
  };

  factory TenagaKerja.fromJson(Map<String, dynamic> json) {
    return TenagaKerja(
      nama: json['nama'] ?? '',
      harga: (json['harga'] ?? 0).toDouble(),
      satuan: json['satuan'] ?? '',
    );
  }
}

class Overhead {
  String nama;
  double harga;
  String satuan;

  Overhead({required this.nama, required this.harga, required this.satuan});

  Map<String, dynamic> toJson() => {
    'nama': nama,
    'harga': harga,
    'satuan': satuan,
  };

  factory Overhead.fromJson(Map<String, dynamic> json) {
    return Overhead(
      nama: json['nama'] ?? '',
      harga: (json['harga'] ?? 0).toDouble(),
      satuan: json['satuan'] ?? '',
    );
  }
}

class HppController extends GetxController {
  final HppService _hppService = HppService();

  final TextEditingController namaProdukController = TextEditingController();
  final TextEditingController jumlahProduksiController =
      TextEditingController();
  final TextEditingController persentaseTakTerdugaController =
      TextEditingController();
  final TextEditingController pajakController = TextEditingController();
  final TextEditingController marginController = TextEditingController();

  var bahanBakuList = <BahanBaku>[].obs;
  var tenagaKerjaList = <TenagaKerja>[].obs;
  var overheadList = <Overhead>[].obs;
  var useBiayaTakTerduga = false.obs;
  var marginInRupiah = false.obs;
  var isCalculated = false.obs;
  var isLoading = false.obs;

  // Hasil Perhitungan
  var totalHPP = 0.0.obs;
  var hppPerUnit = 0.0.obs;
  var hargaJualPerUnit = 0.0.obs;
  var hargaJualPajak = 0.0.obs;
  var marginValue = 0.0.obs;
  var biayaTakTerduga = 0.0.obs;

  double get totalBahanBaku =>
      bahanBakuList.fold(0, (sum, item) => sum + item.harga);

  double get totalTenagaKerja {
    return tenagaKerjaList.fold(0, (sum, item) {
      double hargaPerHari = item.harga;
      if (item.satuan == 'Per Bulan')
        hargaPerHari = item.harga / 30;
      else if (item.satuan == 'Per Jam')
        hargaPerHari = item.harga * 8;
      return sum + hargaPerHari;
    });
  }

  double get totalOverhead {
    return overheadList.fold(0, (sum, item) {
      double hargaPerHari = item.harga;
      if (item.satuan == 'Per Bulan')
        hargaPerHari = item.harga / 30;
      else if (item.satuan == 'Per Jam')
        hargaPerHari = item.harga * 8;
      return sum + hargaPerHari;
    });
  }

  void addBahanBaku(String nama, double harga) =>
      bahanBakuList.add(BahanBaku(nama: nama, harga: harga));
  void removeBahanBaku(int index) => bahanBakuList.removeAt(index);
  void updateBahanBaku(int index, String nama, double harga) =>
      bahanBakuList[index] = BahanBaku(nama: nama, harga: harga);

  void addTenagaKerja(String nama, double harga, String satuan) =>
      tenagaKerjaList.add(
        TenagaKerja(nama: nama, harga: harga, satuan: satuan),
      );
  void removeTenagaKerja(int index) => tenagaKerjaList.removeAt(index);
  void updateTenagaKerja(int index, String nama, double harga, String satuan) =>
      tenagaKerjaList[index] = TenagaKerja(
        nama: nama,
        harga: harga,
        satuan: satuan,
      );

  void addOverhead(String nama, double harga, String satuan) =>
      overheadList.add(Overhead(nama: nama, harga: harga, satuan: satuan));
  void removeOverhead(int index) => overheadList.removeAt(index);
  void updateOverhead(int index, String nama, double harga, String satuan) =>
      overheadList[index] = Overhead(nama: nama, harga: harga, satuan: satuan);

  bool _validateBeforeCalculate() {
    if (namaProdukController.text.trim().isEmpty)
      return _error('Nama Produk harus diisi');
    if (jumlahProduksiController.text.trim().isEmpty)
      return _error('Jumlah Produksi harus diisi');

    double? qty = double.tryParse(jumlahProduksiController.text);
    if (qty == null || qty <= 0) return _error('Jumlah Produksi harus > 0');
    if (bahanBakuList.isEmpty) return _error('Minimal 1 Bahan Baku');
    if (tenagaKerjaList.isEmpty) return _error('Minimal 1 Tenaga Kerja');
    if (overheadList.isEmpty) return _error('Minimal 1 Overhead');

    return true;
  }

  bool _error(String msg) {
    Get.snackbar(
      'Error',
      msg,
      backgroundColor: const Color(0xFF6B1515),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
    return false;
  }

  void hitungHPP() {
    if (!_validateBeforeCalculate()) return;

    biayaTakTerduga.value = 0;
    if (useBiayaTakTerduga.value) {
      double persentase =
          double.tryParse(persentaseTakTerdugaController.text) ?? 0;
      biayaTakTerduga.value =
          (totalTenagaKerja + totalOverhead) * (persentase / 100);
    }

    totalHPP.value =
        totalBahanBaku +
        totalTenagaKerja +
        totalOverhead +
        biayaTakTerduga.value;
    double qty = double.tryParse(jumlahProduksiController.text) ?? 1;
    hppPerUnit.value = totalHPP.value / (qty > 0 ? qty : 1);

    double margin = double.tryParse(marginController.text) ?? 0;
    marginValue.value = marginInRupiah.value
        ? margin
        : hppPerUnit.value * (margin / 100);
    hargaJualPerUnit.value = hppPerUnit.value + marginValue.value;

    double pajak = double.tryParse(pajakController.text) ?? 0;
    hargaJualPajak.value =
        hargaJualPerUnit.value + (hargaJualPerUnit.value * (pajak / 100));

    isCalculated.value = true;
    Get.snackbar(
      'Berhasil',
      'HPP berhasil dihitung!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<bool> simpanData() async {
    if (!isCalculated.value) return _error('Harap hitung HPP terlebih dahulu');

    try {
      isLoading.value = true;
      final result = await _hppService.saveHppCalculation(
        productName: namaProdukController.text,
        quantityProduction: double.tryParse(jumlahProduksiController.text) ?? 0,
        bahanBaku: bahanBakuList.map((e) => e.toJson()).toList(),
        tenagaKerja: tenagaKerjaList.map((e) => e.toJson()).toList(),
        overhead: overheadList.map((e) => e.toJson()).toList(),
        totalBahanBaku: totalBahanBaku,
        totalTenagaKerja: totalTenagaKerja,
        totalOverhead: totalOverhead,
        biayaTakTerduga: biayaTakTerduga.value,
        persentaseTakTerduga:
            double.tryParse(persentaseTakTerdugaController.text) ?? 0,
        totalHpp: totalHPP.value,
        hppPerUnit: hppPerUnit.value,
        hargaJualPerUnit: hargaJualPerUnit.value,
        hargaJualPajak: hargaJualPajak.value,
        marginValue: marginValue.value,
        pajak: double.tryParse(pajakController.text) ?? 0,
        margin: double.tryParse(marginController.text) ?? 0,
        marginInRupiah: marginInRupiah.value,
        useBiayaTakTerduga: useBiayaTakTerduga.value,
      );

      if (result != null) {
        Get.snackbar(
          'Sukses',
          'Data HPP berhasil disimpan',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
        reset();
        return true;
      }
      return false;
    } catch (e) {
      return _error('Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void reset() {
    namaProdukController.clear();
    jumlahProduksiController.clear();
    persentaseTakTerdugaController.clear();
    pajakController.clear();
    marginController.clear();
    bahanBakuList.clear();
    tenagaKerjaList.clear();
    overheadList.clear();
    useBiayaTakTerduga.value = false;
    marginInRupiah.value = false;
    isCalculated.value = false;
    totalHPP.value = 0;
    hppPerUnit.value = 0;
    marginValue.value = 0;
    biayaTakTerduga.value = 0;
  }

  @override
  void onClose() {
    namaProdukController.dispose();
    jumlahProduksiController.dispose();
    persentaseTakTerdugaController.dispose();
    pajakController.dispose();
    marginController.dispose();
    super.onClose();
  }
}
