import 'package:supabase_flutter/supabase_flutter.dart';
import 'mutation_service.dart';

class ProductService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final MutationService _mutationService = MutationService();

  String? get _currentUserId => _supabase.auth.currentUser?.id;

  Future<Map<String, dynamic>?> createProduct({
    required String name,
    required String category,
    required String unit,
    required double price,
    required int stock,
    required DateTime mfgDate,
    required DateTime expDate,
  }) async {
    try {
      if (_currentUserId == null) throw Exception('User tidak terautentikasi.');

      final response = await _supabase
          .from('products')
          .insert({
            'user_id': _currentUserId,
            'name': name,
            'category': category,
            'unit': unit,
            'price': price,
            'stock': stock,
            'mfg_date': mfgDate.toIso8601String(),
            'exp_date': expDate.toIso8601String(),
          })
          .select()
          .single();

      if (stock > 0) {
        await _mutationService.recordStockIn(
          productId: response['id'],
          productName: name,
          quantity: stock,
        );
      }
      return response;
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateProduct({
    required String id,
    required String name,
    required String category,
    required String unit,
    required double price,
    required int stock,
    required DateTime mfgDate,
    required DateTime expDate,
  }) async {
    try {
      if (_currentUserId == null) return false;

      final oldProduct = await _supabase
          .from('products')
          .select('stock')
          .eq('id', id)
          .eq('user_id', _currentUserId!)
          .single();

      final oldStock = oldProduct['stock'] as int;
      final stockDifference = stock - oldStock;

      final response = await _supabase
          .from('products')
          .update({
            'name': name,
            'category': category,
            'unit': unit,
            'price': price,
            'stock': stock,
            'mfg_date': mfgDate.toIso8601String(),
            'exp_date': expDate.toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id)
          .eq('user_id', _currentUserId!)
          .select();

      if (stockDifference != 0) {
        if (stockDifference > 0) {
          await _mutationService.recordStockIn(
            productId: id,
            productName: name,
            quantity: stockDifference,
          );
        } else {
          await _mutationService.recordStockOut(
            productId: id,
            productName: name,
            quantity: stockDifference.abs(),
          );
        }
      }
      return response.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      if (_currentUserId == null) return false;

      await _supabase
          .from('products')
          .delete()
          .eq('id', id)
          .eq('user_id', _currentUserId!);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      if (_currentUserId == null) return [];

      final response = await _supabase
          .from('products')
          .select()
          .eq('user_id', _currentUserId!)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> getProductById(String id) async {
    try {
      if (_currentUserId == null) return null;

      final response = await _supabase
          .from('products')
          .select()
          .eq('id', id)
          .eq('user_id', _currentUserId!)
          .single();

      return response;
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateStock({required String id, required int newStock}) async {
    try {
      if (_currentUserId == null) return false;

      final product = await getProductById(id);
      if (product == null) return false;

      final oldStock = product['stock'] as int;
      final stockDifference = newStock - oldStock;

      final response = await _supabase
          .from('products')
          .update({
            'stock': newStock,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id)
          .eq('user_id', _currentUserId!)
          .select();

      if (stockDifference != 0) {
        if (stockDifference > 0) {
          await _mutationService.recordStockIn(
            productId: id,
            productName: product['name'],
            quantity: stockDifference,
          );
        } else {
          await _mutationService.recordStockOut(
            productId: id,
            productName: product['name'],
            quantity: stockDifference.abs(),
          );
        }
      }
      return response.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
