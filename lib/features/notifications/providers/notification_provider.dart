import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/notification_service.dart';

/// Exposes [NotificationService] as a lazily-created singleton.
/// All presentation-layer code must use this provider instead of
/// instantiating [NotificationService] directly.
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
