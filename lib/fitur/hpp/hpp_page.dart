import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'hpp_controller.dart';
import 'widget/bahan_baku_card.dart';
import 'widget/tenaga_kerja_card.dart';
import 'widget/overhead_card.dart';

class HppPage extends StatefulWidget {
  const HppPage({Key? key}) : super(key: key);

  @override
  State<HppPage> createState() => _HppPageState();
}

class _HppPageState extends State<HppPage> {
  final HppController _controller = Get.put(HppController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B1515),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'HPP',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 26,
          ),
        ),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDataProdukSection(),
                const SizedBox(height: 16),
                BahanBakuCard(
                  controller: _controller,
                  onAdd: _showAddBahanBakuDialog,
                  onEdit: _showEditBahanBakuDialog,
                ),
                const SizedBox(height: 16),
                TenagaKerjaCard(
                  controller: _controller,
                  onAdd: _showAddTenagaKerjaDialog,
                  onEdit: _showEditTenagaKerjaDialog,
                ),
                const SizedBox(height: 16),
                OverheadCard(
                  controller: _controller,
                  onAdd: _showAddOverheadDialog,
                  onEdit: _showEditOverheadDialog,
                ),
                const SizedBox(height: 16),
                _buildBiayaTakTerdugaSection(),
                const SizedBox(height: 16),
                _buildPajakMarginSection(),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _controller.hitungHPP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B1515),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Hitung HPP Otomatis',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 16),
                if (_controller.isCalculated.value)
                  _buildHasilPerhitunganSection(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // --- UI SECTIONS ---

  Widget _buildDataProdukSection() {
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
          const Text(
            '1. Data Produk/Jasa',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _controller.namaProdukController,
            decoration: InputDecoration(
              labelText: 'Nama Produk/Jasa',
              labelStyle: const TextStyle(fontSize: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _controller.jumlahProduksiController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Jumlah Produksi (Qty)',
              labelStyle: const TextStyle(fontSize: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiayaTakTerdugaSection() {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '5. Persentase Biaya Tak Terduga(%) ',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Rp ${_controller.biayaTakTerduga.value.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B1515),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: _controller.useBiayaTakTerduga.value,
                  onChanged: (value) =>
                      _controller.useBiayaTakTerduga.value = value!,
                  activeColor: const Color(0xFF6B1515),
                ),
                const Text('Ya'),
                const SizedBox(width: 24),
                Radio<bool>(
                  value: false,
                  groupValue: _controller.useBiayaTakTerduga.value,
                  onChanged: (value) =>
                      _controller.useBiayaTakTerduga.value = value!,
                  activeColor: const Color(0xFF6B1515),
                ),
                const Text('Tidak'),
              ],
            ),
            if (_controller.useBiayaTakTerduga.value) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _controller.persentaseTakTerdugaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Contoh: 5 (untuk 5%)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPajakMarginSection() {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '6. Pajak & Margin',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _controller.pajakController,
              style: const TextStyle(fontSize: 12),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Pajak (%)',
                labelStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Radio<bool>(
                  value: false,
                  groupValue: _controller.marginInRupiah.value,
                  onChanged: (value) =>
                      _controller.marginInRupiah.value = value!,
                  activeColor: const Color(0xFF6B1515),
                ),
                const Text('%'),
                const SizedBox(width: 24),
                Radio<bool>(
                  value: true,
                  groupValue: _controller.marginInRupiah.value,
                  onChanged: (value) =>
                      _controller.marginInRupiah.value = value!,
                  activeColor: const Color(0xFF6B1515),
                ),
                const Text('Rp'),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _controller.marginController,
              style: const TextStyle(fontSize: 12),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: _controller.marginInRupiah.value
                    ? 'Margin Laba Per Unit'
                    : 'Margin Laba Per Unit (%)',
                labelStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHasilPerhitunganSection() {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFDC143C), width: 2),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '7. Hasil Perhitungan',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            _buildHasilItem(
              'Total HPP',
              _controller.totalHPP.value,
              'Total Biaya Bahan Baku, Tenaga Kerja, Overhead + Biaya Tak Terduga',
              const Color(0xFF6B1515),
            ),
            const SizedBox(height: 12),
            _buildHasilItem(
              'HPP per Unit',
              _controller.hppPerUnit.value,
              'Total HPP / Jumlah Produksi',
              const Color(0xFF6B1515),
            ),
            const SizedBox(height: 12),
            _buildHasilItem(
              'Harga Jual per Unit',
              _controller.hargaJualPerUnit.value,
              'HPP per Unit + Margin',
              Colors.green[700]!,
            ),
            const SizedBox(height: 12),
            _buildHasilItem(
              'Harga Jual + Pajak',
              _controller.hargaJualPajak.value,
              'Harga Jual per Unit + Pajak',
              Colors.blue[700]!,
            ),
            const SizedBox(height: 12),
            _buildHasilItem(
              'Margin Satuan dalam Rp',
              _controller.marginValue.value,
              '',
              Colors.teal[700]!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHasilItem(
    String title,
    double value,
    String subtitle,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
              Text(
                'Rp ${value.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _controller.reset(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF6B1515),
                  side: const BorderSide(color: Color(0xFF6B1515)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Reset',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: Obx(
                () => ElevatedButton(
                  onPressed: _controller.isCalculated.value
                      ? _simpanData
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B1515),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Simpan Produk',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- DIALOGS ---

  void _showAddBahanBakuDialog() {
    final namaController = TextEditingController();
    final hargaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Bahan Baku'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Item',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: hargaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Harga',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (namaController.text.isNotEmpty &&
                  hargaController.text.isNotEmpty) {
                _controller.addBahanBaku(
                  namaController.text,
                  double.tryParse(hargaController.text) ?? 0,
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B1515),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showEditBahanBakuDialog(int index) {
    final item = _controller.bahanBakuList[index];
    final namaController = TextEditingController(text: item.nama);
    final hargaController = TextEditingController(text: item.harga.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Bahan Baku'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Item',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: hargaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Harga',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (namaController.text.isNotEmpty &&
                  hargaController.text.isNotEmpty) {
                _controller.updateBahanBaku(
                  index,
                  namaController.text,
                  double.tryParse(hargaController.text) ?? 0,
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B1515),
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showAddTenagaKerjaDialog() {
    final namaController = TextEditingController();
    final hargaController = TextEditingController();
    String satuan = 'Per Hari';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Tambah Tenaga Kerja'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Item',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: satuan,
                decoration: const InputDecoration(
                  labelText: 'Satuan',
                  border: OutlineInputBorder(),
                ),
                items: ['Per Hari', 'Per Bulan', 'Per Jam']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) => setStateDialog(() => satuan = value!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (namaController.text.isNotEmpty &&
                    hargaController.text.isNotEmpty) {
                  _controller.addTenagaKerja(
                    namaController.text,
                    double.tryParse(hargaController.text) ?? 0,
                    satuan,
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B1515),
              ),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTenagaKerjaDialog(int index) {
    final item = _controller.tenagaKerjaList[index];
    final namaController = TextEditingController(text: item.nama);
    final hargaController = TextEditingController(text: item.harga.toString());
    String satuan = item.satuan;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Edit Tenaga Kerja'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Item',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: satuan,
                decoration: const InputDecoration(
                  labelText: 'Satuan',
                  border: OutlineInputBorder(),
                ),
                items: ['Per Hari', 'Per Bulan', 'Per Jam']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) => setStateDialog(() => satuan = value!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (namaController.text.isNotEmpty &&
                    hargaController.text.isNotEmpty) {
                  _controller.updateTenagaKerja(
                    index,
                    namaController.text,
                    double.tryParse(hargaController.text) ?? 0,
                    satuan,
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B1515),
              ),
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddOverheadDialog() {
    final namaController = TextEditingController();
    final hargaController = TextEditingController();
    String satuan = 'Per Hari';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Tambah Biaya Overhead'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Item',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: satuan,
                decoration: const InputDecoration(
                  labelText: 'Satuan',
                  border: OutlineInputBorder(),
                ),
                items: ['Per Hari', 'Per Bulan', 'Per Jam']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) => setStateDialog(() => satuan = value!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (namaController.text.isNotEmpty &&
                    hargaController.text.isNotEmpty) {
                  _controller.addOverhead(
                    namaController.text,
                    double.tryParse(hargaController.text) ?? 0,
                    satuan,
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B1515),
              ),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditOverheadDialog(int index) {
    final item = _controller.overheadList[index];
    final namaController = TextEditingController(text: item.nama);
    final hargaController = TextEditingController(text: item.harga.toString());
    String satuan = item.satuan;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Edit Biaya Overhead'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Item',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: satuan,
                decoration: const InputDecoration(
                  labelText: 'Satuan',
                  border: OutlineInputBorder(),
                ),
                items: ['Per Hari', 'Per Bulan', 'Per Jam']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) => setStateDialog(() => satuan = value!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (namaController.text.isNotEmpty &&
                    hargaController.text.isNotEmpty) {
                  _controller.updateOverhead(
                    index,
                    namaController.text,
                    double.tryParse(hargaController.text) ?? 0,
                    satuan,
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B1515),
              ),
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _simpanData() async {
    final success = await _controller.simpanData();
    if (success && mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Berhasil'),
          content: const Text('Data HPP berhasil disimpan!'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B1515),
              ),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
