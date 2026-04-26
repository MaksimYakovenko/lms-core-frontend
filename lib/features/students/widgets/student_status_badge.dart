import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

const _kGreen700 = Color(0xFF15803D);
const _kYellow700 = Color(0xFFA16207);

enum StudentStatus {
  invited,
  active;

  factory StudentStatus.fromString(String value) {
    switch (value.toUpperCase()) {
      case 'INVITED':
        return StudentStatus.invited;
      case 'ACTIVE':
        return StudentStatus.active;
      default:
        throw ArgumentError('Invalid status: $value');
    }
  }
}

class StudentStatusBadge extends StatelessWidget {
  const StudentStatusBadge({super.key, required this.status});

  final StudentStatus status;

  IconData get _icon => switch (status) {
    StudentStatus.invited => LucideIcons.clock,
    StudentStatus.active => LucideIcons.circleCheck,
  };

  Color get _color => switch (status) {
    StudentStatus.invited => _kYellow700,
    StudentStatus.active => _kGreen700,
  };

  String get _label => switch (status) {
    StudentStatus.invited => 'Запрошений',
    StudentStatus.active => 'Активний',
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(_icon, size: 15, color: _color),
        const SizedBox(width: 5),
        Text(_label,
            style: TextStyle(
                fontSize: 13, color: _color, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
