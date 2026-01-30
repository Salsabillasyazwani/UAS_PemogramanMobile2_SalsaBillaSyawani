import 'package:supabase_flutter/supabase_flutter.dart';
import 'product_service.dart';
import 'mutation_service.dart';

class TransaksiService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final ProductService _productService = ProductService();
  final MutationService _mutationService = MutationService();

  String? get _currentUserId => _supabase.auth.currentUser?.id;

  Future<Map<String, dynamic>> createTransaction({
    required List<Map<String, dynamic>> items,
    required String paymentMethod,
  }) async {
    try {
      if (_currentUserId == null) {
        return {'success': false, 'message': 'User not authenticated'};
      }

      if (items.isEmpty) {
        return {'success': false, 'message': 'Tidak ada item yang dipilih'};
      }

      final now = DateTime.now();
      final code = 'TRX-${now.millisecondsSinceEpoch}';

      int totalItems = 0;
      double totalPrice = 0;

      for (var item in items) {
        final quantity = item['quantity'] as int;
        final price = (item['price'] as num).toDouble();
        totalItems += quantity;
        totalPrice += quantity * price;
      }

      final transaction = await _supabase
          .from('transactions')
          .insert({
            'user_id': _currentUserId,
            'transaction_code': code,
            'date': now.toIso8601String(),
            'total_items': totalItems,
            'total_price': totalPrice,
            'payment_method': paymentMethod,
          })
          .select()
          .single();

      final transactionId = transaction['id'];

      for (var item in items) {
        final productId = item['product_id'];
        final productName = item['product_name'];
        final quantity = item['quantity'] as int;
        final price = (item['price'] as num).toDouble();
        final subtotal = quantity * price;

        await _supabase.from('transaction_items').insert({
          'user_id': _currentUserId,
          'transaction_id': transactionId,
          'product_id': productId,
          'product_name': productName,
          'quantity': quantity,
          'price': price,
          'subtotal': subtotal,
        });

        final product = await _productService.getProductById(productId);
        if (product == null) {
          return {
            'success': false,
            'message': 'Produk $productName tidak ditemukan',
          };
        }

        final currentStock = product['stock'] as int;

        if (currentStock < quantity) {
          return {
            'success': false,
            'message':
                'Stock $productName tidak cukup (tersedia: $currentStock)',
          };
        }

        final newStock = currentStock - quantity;
        final stockUpdated = await _productService.updateStock(
          id: productId,
          newStock: newStock,
        );

        if (!stockUpdated) {
          return {
            'success': false,
            'message': 'Gagal update stock untuk $productName',
          };
        }

        await _mutationService.recordStockOut(
          productId: productId,
          productName: productName,
          quantity: quantity,
        );
      }

      return {
        'success': true,
        'message': 'Transaksi berhasil',
        'transaction': transaction,
      };
    } catch (e) {
      print('Error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  Future<List<Map<String, dynamic>>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      if (_currentUserId == null) return [];

      var query = _supabase
          .from('transactions')
          .select()
          .eq('user_id', _currentUserId!);

      if (startDate != null && endDate != null) {
        final start = DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
          0,
          0,
          0,
        );
        final end = DateTime(
          endDate.year,
          endDate.month,
          endDate.day,
          23,
          59,
          59,
        );

        query = query
            .gte('date', start.toIso8601String())
            .lte('date', end.toIso8601String());
      }

      final response = await query.order('date', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> getTransactionDetail(
    String transactionId,
  ) async {
    try {
      if (_currentUserId == null) return null;

      final transaction = await _supabase
          .from('transactions')
          .select()
          .eq('id', transactionId)
          .eq('user_id', _currentUserId!)
          .single();

      final items = await _supabase
          .from('transaction_items')
          .select()
          .eq('transaction_id', transactionId)
          .eq('user_id', _currentUserId!);

      transaction['items'] = items;
      return transaction;
    } catch (e) {
      return null;
    }
  }

  Future<int> getTotalSalesToday() async {
    try {
      if (_currentUserId == null) return 0;
      final today = DateTime.now();
      final startOfDay = DateTime(
        today.year,
        today.month,
        today.day,
      ).toIso8601String();
      final endOfDay = DateTime(
        today.year,
        today.month,
        today.day,
        23,
        59,
        59,
      ).toIso8601String();

      final response = await _supabase
          .from('transactions')
          .select('total_items')
          .eq('user_id', _currentUserId!)
          .gte('date', startOfDay)
          .lte('date', endOfDay);

      int total = 0;
      for (var item in response) {
        total += (item['total_items'] as int);
      }
      return total;
    } catch (e) {
      return 0;
    }
  }

  Future<double> getRevenueToday() async {
    try {
      if (_currentUserId == null) return 0.0;
      final today = DateTime.now();
      final startOfDay = DateTime(
        today.year,
        today.month,
        today.day,
      ).toIso8601String();
      final endOfDay = DateTime(
        today.year,
        today.month,
        today.day,
        23,
        59,
        59,
      ).toIso8601String();

      final response = await _supabase
          .from('transactions')
          .select('total_price')
          .eq('user_id', _currentUserId!)
          .gte('date', startOfDay)
          .lte('date', endOfDay);

      double total = 0;
      for (var item in response) {
        total += (item['total_price'] as num).toDouble();
      }
      return total;
    } catch (e) {
      return 0.0;
    }
  }

  Future<int> getTotalSalesThisMonth() async {
    try {
      if (_currentUserId == null) return 0;
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1).toIso8601String();
      final endOfMonth = DateTime(
        now.year,
        now.month + 1,
        0,
        23,
        59,
        59,
      ).toIso8601String();

      final response = await _supabase
          .from('transactions')
          .select('total_items')
          .eq('user_id', _currentUserId!)
          .gte('date', startOfMonth)
          .lte('date', endOfMonth);

      int total = 0;
      for (var item in response) {
        total += (item['total_items'] as int);
      }
      return total;
    } catch (e) {
      return 0;
    }
  }

  Future<double> getRevenueThisMonth() async {
    try {
      if (_currentUserId == null) return 0.0;
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1).toIso8601String();
      final endOfMonth = DateTime(
        now.year,
        now.month + 1,
        0,
        23,
        59,
        59,
      ).toIso8601String();

      final response = await _supabase
          .from('transactions')
          .select('total_price')
          .eq('user_id', _currentUserId!)
          .gte('date', startOfMonth)
          .lte('date', endOfMonth);

      double total = 0;
      for (var item in response) {
        total += (item['total_price'] as num).toDouble();
      }
      return total;
    } catch (e) {
      return 0.0;
    }
  }
}
