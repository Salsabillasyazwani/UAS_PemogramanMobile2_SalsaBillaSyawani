import 'package:supabase_flutter/supabase_flutter.dart';

class MutationService {
  final SupabaseClient _supabase = Supabase.instance.client;
  String? get _currentUserId => _supabase.auth.currentUser?.id;

  Future<bool> recordMutation({
    required String productId,
    required String productName,
    required String mutationType,
    required int quantity,
  }) async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }
      final response = await _supabase.from('product_mutations').insert({
        'user_id': _currentUserId,
        'product_id': productId,
        'product_name': productName,
        'mutation_type': mutationType,
        'quantity': quantity,
        'date': DateTime.now().toIso8601String(),
      }).select();

      print('Mutation recorded: $response');
      return response.isNotEmpty;
    } catch (e) {
      print('Error recording mutation: $e');
      return false;
    }
  }

  Future<bool> recordStockIn({
    required String productId,
    required String productName,
    required int quantity,
  }) async {
    return await recordMutation(
      productId: productId,
      productName: productName,
      mutationType: 'masuk',
      quantity: quantity,
    );
  }

  Future<bool> recordStockOut({
    required String productId,
    required String productName,
    required int quantity,
  }) async {
    return await recordMutation(
      productId: productId,
      productName: productName,
      mutationType: 'keluar',
      quantity: quantity,
    );
  }

  Future<List<Map<String, dynamic>>> getAllMutations() async {
    try {
      final response = await _supabase
          .from('product_mutations')
          .select()
          .order('date', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting mutations: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getMutationsByProduct(
    String productId,
  ) async {
    try {
      final response = await _supabase
          .from('product_mutations')
          .select()
          .eq('product_id', productId)
          .order('date', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting product mutations: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getMutationsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
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

      final response = await _supabase
          .from('product_mutations')
          .select()
          .gte('date', start.toIso8601String())
          .lte('date', end.toIso8601String())
          .order('date', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting mutations by date: $e');
      return [];
    }
  }
}
