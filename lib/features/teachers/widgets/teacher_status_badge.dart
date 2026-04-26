import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

const _kGreen700 = Color(0xFF15803D);
const _kYellow700 = Color(0xFFA16207);

enum TeacherStatus {
  invited,
  active;

  factory TeacherStatus.fromString(String value) {
    switch (value.toUpperCase()) {
      case 'INVITED':
        return TeacherStatus.invited;
      case 'ACTIVE':
        return TeacherStatus.active;
      default:
        throw ArgumentError('Invalid status: $value');
    }
  }
}

class TeacherStatusBadge extends StatelessWidget {
  const TeacherStatusBadge({super.key, required this.status});

  final TeacherStatus status;

  IconData get _icon => switch (status) {
        TeacherStatus.invited => LucideIcons.clock,
        TeacherStatus.active => LucideIcons.circleCheck,
      };

  Color get _color => switch (status) {
        TeacherStatus.invited => _kYellow700,
        TeacherStatus.active => _kGreen700,
      };

  String get _label => switch (status) {
        TeacherStatus.invited => 'Запрошений',
        TeacherStatus.active => 'Активний',
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
