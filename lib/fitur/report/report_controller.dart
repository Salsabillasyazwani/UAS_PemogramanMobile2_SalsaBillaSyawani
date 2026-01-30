import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/report_model.dart';
import '../../data/services/report_service.dart';

class ReportController extends GetxController {
  final ReportService _reportService = ReportService();
  final SupabaseClient _supabase = Supabase.instance.client;

  var searchQuery = "".obs;
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  var periodLabel = "Hari ini".obs;
  var isLoading = false.obs;

  var allProduk = <ProductReport>[].obs;
  var allMutasi = <MutationReport>[].obs;
  var allTransaksi = <TransactionReport>[].obs;
  var allHpp = <HppReport>[].obs;

  String get _currentUserId => _supabase.auth.currentUser?.id ?? '';

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    startDate.value = DateTime(now.year, now.month, now.day, 0, 0, 0);
    endDate.value = DateTime(now.year, now.month, now.day, 23, 59, 59);
    loadAllReports();
  }

  void updateRange(DateTime start, DateTime end, String label) {
    startDate.value = DateTime(start.year, start.month, start.day, 0, 0, 0);
    endDate.value = DateTime(end.year, end.month, end.day, 23, 59, 59);
    periodLabel.value = label;
    loadAllReports();
  }

  Future<void> loadAllReports() async {
    if (_currentUserId.isEmpty) return;
    try {
      isLoading.value = true;
      await Future.wait([
        loadProductReport(),
        loadMutationReport(),
        loadTransactionReport(),
        loadHppReport(),
      ]);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat laporan');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadProductReport() async {
    try {
      final data = await _reportService.getProductReport(
        userId: _currentUserId,
      );
      allProduk.assignAll(
        data.map(
          (item) => ProductReport(
            id: item['id']?.toString() ?? '',
            userId: _currentUserId,
            nama: item['name'] ?? '',
            kategori: item['category'] ?? '',
            satuan: item['unit'] ?? '',
            harga: (item['price'] as num?)?.toInt() ?? 0,
            stok: (item['stock'] as num?)?.toInt() ?? 0,
            mfg: _formatDate(item['mfg_date']),
            exp: _formatDate(item['exp_date']),
          ),
        ),
      );
    } catch (e) {
      print('Error Product: $e');
    }
  }

  Future<void> loadMutationReport() async {
    try {
      final data = await _reportService.getMutationReport(
        userId: _currentUserId,
        startDate: startDate.value,
        endDate: endDate.value,
      );
      allMutasi.assignAll(
        data.map(
          (item) => MutationReport(
            tanggal: _formatDate(item['date']),
            userId: _currentUserId,
            idProduk: item['product_id']?.toString() ?? '',
            namaProduk: item['product_name'] ?? '',
            jenis: item['mutation_type'] == 'masuk' ? 'Masuk' : 'Keluar',
            jumlah: (item['quantity'] as num?)?.toInt() ?? 0,
          ),
        ),
      );
    } catch (e) {
      print('Error Mutation: $e');
    }
  }

  Future<void> loadTransactionReport() async {
    try {
      final data = await _reportService.getTransactionReport(
        userId: _currentUserId,
        startDate: startDate.value,
        endDate: endDate.value,
      );
      allTransaksi.assignAll(
        data.map(
          (item) => TransactionReport(
            id: item['transaction_code'] ?? '',
            userId: _currentUserId,
            tanggal: _formatDate(item['date']),
            metodeBayar: item['payment_method'] ?? 'Tunai',
            totalItem: (item['total_items'] as num?)?.toInt() ?? 0,
            totalHarga: (item['total_price'] as num?)?.toInt() ?? 0,
          ),
        ),
      );
    } catch (e) {
      print('Error Transaction: $e');
    }
  }

  Future<void> loadHppReport() async {
    try {
      final data = await _reportService.getHppReport(
        userId: _currentUserId,
        startDate: startDate.value,
        endDate: endDate.value,
      );
      allHpp.assignAll(
        data.map(
          (item) => HppReport(
            tanggal: item['tanggal'] ?? '-',
            userId: _currentUserId,
            productName: item['product_name'] ?? '-',
            totalHpp: (item['totalHpp'] as num?)?.toInt() ?? 0,
            perUnit: (item['perUnit'] as num?)?.toInt() ?? 0,
            jual: (item['jual'] as num?)?.toInt() ?? 0,
            jualPajak: (item['jualPajak'] as num?)?.toInt() ?? 0,
            margin: (item['margin'] as num?)?.toInt() ?? 0,
          ),
        ),
      );
    } catch (e) {
      print('Error HPP: $e');
    }
  }

  String _formatDate(dynamic dateStr) {
    if (dateStr == null) return '-';
    try {
      return DateFormat('dd/MM/yy').format(DateTime.parse(dateStr.toString()));
    } catch (e) {
      return '-';
    }
  }

  List<ProductReport> get filteredProduk => allProduk
      .where(
        (p) =>
            searchQuery.isEmpty ||
            p.nama.toLowerCase().contains(searchQuery.value.toLowerCase()),
      )
      .toList();

  List<MutationReport> get filteredMutasi => allMutasi
      .where(
        (m) =>
            searchQuery.isEmpty ||
            m.namaProduk.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            ),
      )
      .toList();

  List<TransactionReport> get filteredTransaksi => allTransaksi
      .where(
        (t) =>
            searchQuery.isEmpty ||
            t.id.toLowerCase().contains(searchQuery.value.toLowerCase()),
      )
      .toList();

  List<HppReport> get filteredHpp => allHpp
      .where(
        (h) =>
            searchQuery.isEmpty ||
            (h.productName?.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ??
                false),
      )
      .toList();
}
