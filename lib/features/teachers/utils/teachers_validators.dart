String? validateTeacherName(String? value) {
  if (value == null || value.trim().isEmpty) return 'Ім\'я є обов\'язковим';
  return null;
}

String? validateTeacherEmail(String? value) {
  if (value == null || value.trim().isEmpty) return 'Email є обов\'язковим';
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value.trim())) {
    return 'Введіть коректну email-адресу';
  }
  return null;
}

