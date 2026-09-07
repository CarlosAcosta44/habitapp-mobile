import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';

final retosProvider = FutureProvider<List<dynamic>>((ref) async {
  final dio = ref.watch(dioClientProvider);
  try {
    final response = await dio.get('/community/retos');
    return response.data as List<dynamic>;
  } catch (e) {
    debugPrint('Error fetching retos: $e');
    return [];
  }
});
