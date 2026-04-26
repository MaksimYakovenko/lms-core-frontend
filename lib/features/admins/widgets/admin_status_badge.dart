import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

const _kGreen700 = Color(0xFF15803D);
const _kYellow700 = Color(0xFFA16207);

enum AdminStatus {
  invited,
  active;

  factory AdminStatus.fromString(String value) {
    switch (value.toUpperCase()) {
      case 'INVITED':
        return AdminStatus.invited;
      case 'ACTIVE':
        return AdminStatus.active;
      default:
        throw ArgumentError('Invalid status: $value');
    }
  }
}

class AdminStatusBadge extends StatelessWidget {
  const AdminStatusBadge({super.key, required this.status});

  final AdminStatus status;

  IconData get _icon => switch (status) {
    AdminStatus.invited => LucideIcons.clock,
    AdminStatus.active => LucideIcons.circleCheck,
  };

  Color get _color => switch (status) {
    AdminStatus.invited => _kYellow700,
    AdminStatus.active => _kGreen700,
  };

  String get _label => switch (status) {
    AdminStatus.invited => 'Запрошений',
    AdminStatus.active => 'Активний',
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
