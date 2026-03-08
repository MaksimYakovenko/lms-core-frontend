import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class LeftSidebarComponent extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int>? onItemSelected;
  final VoidCallback? onLogout;
  final VoidCallback? onSignIn;
  final bool isAuthenticated;
  final String? userName;
  final String? userRole;

  const LeftSidebarComponent({
    super.key,
    this.selectedIndex = 0,
    this.onItemSelected,
    this.onLogout,
    this.onSignIn,
    this.isAuthenticated = false,
    this.userName,
    this.userRole,
  });

  @override
  State<LeftSidebarComponent> createState() => _LeftSidebarComponentState();
}

class _LeftSidebarComponentState extends State<LeftSidebarComponent> {
  late int _selectedIndex;

  static const _bgColor = Color(0xFF0F172A);
  static const _activeColor = Color(0xFF1E293B);
  static const _borderColor = Color(0xFF334155);
  static const _textColor = Colors.white;
  static const _textMutedColor = Color(0xFFCBD5E1);
  static const _subtitleColor = Color(0xFF94A3B8);

  final List<_NavItem> _navItems = [
    const _NavItem(icon: LucideIcons.house, label: 'Home'),
    const _NavItem(icon: LucideIcons.fileText, label: 'Results'),
    const _NavItem(icon: LucideIcons.clipboardList, label: 'Tests'),
    const _NavItem(icon: LucideIcons.bookOpen, label: 'Resources'),
    const _NavItem(icon: LucideIcons.creditCard, label: 'Payment'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256,
      color: _bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Logo / Brand ─────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(24), // p-6
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: _borderColor, width: 1), // border-b border-slate-700
              ),
            ),
            child: Row(
              children: [
                // White circle with icon
                Container(
                  width: 32,  // w-8
                  height: 32, // h-8
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      LucideIcons.monitor,
                      color: _bgColor, // text-slate-900
                      size: 16,        // w-4 h-4
                    ),
                  ),
                ),
                const SizedBox(width: 12), // gap-3
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'EduPortal',
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Teacher Dashboard',
                      style: TextStyle(
                        color: _subtitleColor, // text-slate-400
                        fontSize: 14,          // text-sm
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Navigation ────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16), // p-4
              child: Column(
                children: List.generate(_navItems.length, (index) {
                  final item = _navItems[index];
                  final isActive = _selectedIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8), // space-y-2
                    child: _NavTile(
                      icon: item.icon,
                      label: item.label,
                      isActive: isActive,
                      activeColor: _activeColor,
                      textColor: _textColor,
                      textMutedColor: _textMutedColor,
                      onTap: () {
                        setState(() => _selectedIndex = index);
                        widget.onItemSelected?.call(index);
                      },
                    ),
                  );
                }),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16), // p-4
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: _borderColor, width: 1),
              ),
            ),
            child: Column(
              children: [

                if (widget.isAuthenticated) ...[
                  Row(
                    children: [
                      // Avatar circle
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: _borderColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            _getInitials(widget.userName),
                            style: const TextStyle(
                              color: _textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.userName ?? 'User',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: _textColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              widget.userRole ?? '',
                              style: const TextStyle(
                                color: _subtitleColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Logout button
                  _NavTile(
                    icon: LucideIcons.logOut,
                    label: 'Logout',
                    isActive: false,
                    activeColor: _activeColor,
                    textColor: _textColor,
                    textMutedColor: _textMutedColor,
                    onTap: widget.onLogout ?? () {},
                  ),
                ] else ...[
                  // Sign In button — для неавторизованих
                  _NavTile(
                    icon: LucideIcons.logIn,
                    label: 'Sign In',
                    isActive: false,
                    activeColor: _activeColor,
                    textColor: _textColor,
                    textMutedColor: _textMutedColor,
                    onTap: widget.onSignIn ?? () {},
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class _NavTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final Color textColor;
  final Color textMutedColor;
  final VoidCallback onTap;

  const _NavTile({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.textColor,
    required this.textMutedColor,
    required this.onTap,
  });

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool highlighted = widget.isActive || _hovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 40, // h-10
          decoration: BoxDecoration(
            color: highlighted ? widget.activeColor : Colors.transparent, // hover:bg-slate-800
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12), // justify-start
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 16, // w-4 h-4
                color: highlighted ? widget.textColor : widget.textMutedColor,
                // active/hover → white, default → slate-300
              ),
              const SizedBox(width: 12), // gap-3
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 15,
                  color: highlighted ? widget.textColor : widget.textMutedColor,
                  fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
