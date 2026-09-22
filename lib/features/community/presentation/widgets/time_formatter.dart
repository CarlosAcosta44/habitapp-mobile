String timeAgo(String dateString) {
  try {
    // Supabase returns dates as '2026-09-21' or '2026-09-21T14:30:00'
    // Appending 'Z' directly to a date-only string breaks parsing, so handle both cases.
    String parsedString;
    if (dateString.contains('T') || dateString.contains(' ')) {
      parsedString = dateString.endsWith('Z') ? dateString : '${dateString}Z';
    } else {
      // Date-only string like '2026-09-21' — treat as start of that day in UTC
      parsedString = '${dateString}T00:00:00Z';
    }
    final date = DateTime.parse(parsedString).toLocal();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Hace un momento';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} h';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} d';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Hace $weeks sem';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'Hace $months mes${months > 1 ? 'es' : ''}';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'Hace $years año${years > 1 ? 's' : ''}';
    }
  } catch (e) {
    return 'Hace poco';
  }
}
