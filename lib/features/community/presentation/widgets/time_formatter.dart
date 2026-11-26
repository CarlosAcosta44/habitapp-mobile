String _normalizeIsoDateString(String dateString) {
  if (dateString.contains('T') || dateString.contains(' ')) {
    return dateString.endsWith('Z') ? dateString : '${dateString}Z';
  }
  return '${dateString}T00:00:00Z';
}

String _formatDifference(Duration difference) {
  if (difference.inSeconds < 60) return 'Hace un momento';
  if (difference.inMinutes < 60) return 'Hace ${difference.inMinutes} min';
  if (difference.inHours < 24) return 'Hace ${difference.inHours} h';
  if (difference.inDays < 7) return 'Hace ${difference.inDays} d';
  if (difference.inDays < 30) {
    return 'Hace ${(difference.inDays / 7).floor()} sem';
  }
  if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return 'Hace $months mes${months > 1 ? 'es' : ''}';
  }
  final years = (difference.inDays / 365).floor();
  return 'Hace $years año${years > 1 ? 's' : ''}';
}

String timeAgo(String dateString) {
  try {
    final parsedString = _normalizeIsoDateString(dateString);
    final date = DateTime.parse(parsedString).toLocal();
    return _formatDifference(DateTime.now().difference(date));
  } catch (e) {
    return 'Hace poco';
  }
}
