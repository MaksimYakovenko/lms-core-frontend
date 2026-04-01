String formatAdminLastLogin(String? lastLogin) {
  if (lastLogin == null) return 'Ніколи';
  try {
    final dt = DateTime.parse(lastLogin).toLocal();
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')}  '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  } catch (_) {
    return lastLogin;
  }
}

