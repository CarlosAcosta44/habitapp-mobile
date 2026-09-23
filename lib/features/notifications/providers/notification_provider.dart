import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/notification_repository.dart';

/// Exposes [NotificationRepository] as a lazily-created singleton.
/// All presentation-layer code must use this provider instead of
/// instantiating [NotificationRepository] directly.
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});
