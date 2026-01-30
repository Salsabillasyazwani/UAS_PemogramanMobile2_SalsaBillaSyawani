import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class ReportService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getProductReport({
    required String userId,
  }) async {
    try {
      final response = await _supabase
          .from('products')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getMutationReport({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = _supabase
          .from('product_mutations')
          .select()
          .eq('user_id', userId);

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
      print('Error Mutation Service: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTransactionReport({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = _supabase.from('transactions').select().eq('user_id', userId);

      if (startDate != null && endDate != null) {
        query = query
            .gte('date', startDate.toIso8601String())
            .lte('date', endDate.toIso8601String());
      }

      final response = await query.order('date', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getHppReport({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = _supabase
          .from('hpp_calculations')
          .select()
          .eq('user_id', userId);

      if (startDate != null && endDate != null) {
        query = query
            .gte('created_at', startDate.toIso8601String())
            .lte('created_at', endDate.toIso8601String());
      }

      final response = await query.order('created_at', ascending: false);

      return response.map((item) {
        final date = DateTime.parse(item['created_at']);
        return {
          'tanggal': DateFormat('dd/MM/yy').format(date),
          'product_name': item['product_name'] ?? '-',
          'totalHpp': (item['total_hpp'] as num?)?.toInt() ?? 0,
          'perUnit': (item['hpp_per_unit'] as num?)?.toInt() ?? 0,
          'jual': (item['harga_jual_per_unit'] as num?)?.toInt() ?? 0,
          'jualPajak': (item['harga_jual_pajak'] as num?)?.toInt() ?? 0,
          'margin': (item['margin_value'] as num?)?.toInt() ?? 0,
          'qty': (item['quantity_production'] as num?)?.toInt() ?? 0,
        };
      }).toList();
    } catch (e) {
      print('Error HPP Report: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getBestSellingProducts({
    required String userId,
    int limit = 10,
  }) async {
    try {
      final response = await _supabase
          .from('transaction_items')
          .select('product_id, product_name, quantity, price')
          .eq('user_id', userId);

      Map<String, Map<String, dynamic>> productSales = {};

      for (var item in response) {
        final productId = item['product_id'].toString();
        final productName = item['product_name'] ?? 'Tanpa Nama';
        final quantity = (item['quantity'] as num?)?.toInt() ?? 0;
        final price = (item['price'] as num?)?.toDouble() ?? 0.0;

        if (productSales.containsKey(productId)) {
          productSales[productId]!['totalQuantity'] += quantity;
        } else {
          productSales[productId] = {
            'nama': productName,
            'harga': 'Rp.${price.toStringAsFixed(0)}',
            'totalQuantity': quantity,
          };
        }
      }

      List<Map<String, dynamic>> result = productSales.values.toList();
      result.sort(
        (a, b) =>
            (b['totalQuantity'] as int).compareTo(a['totalQuantity'] as int),
      );

      return result.take(limit).map((e) {
        return {
          'nama': e['nama'],
          'harga': e['harga'],
          'terjual': '${e['totalQuantity']} pcs',
        };
      }).toList();
    } catch (e) {
      print('Error Best Selling: $e');
      return [];
    }
  }
}
