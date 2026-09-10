import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../profile/providers/profile_provider.dart';
import '../../../core/network/dio_client.dart';

final reportSummaryProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final userProfile = await ref.watch(profileProvider.future);
  final dio = ref.watch(dioClientProvider);

  if (userProfile == null) throw Exception('No user profile found');

  final response = await dio.get('/reports/user/\${userProfile.id}');
  
  if (response.statusCode == 200) {
    return response.data as Map<String, dynamic>;
  } else {
    throw Exception('Failed to load user summary');
  }
});
