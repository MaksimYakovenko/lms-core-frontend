import 'package:flutter/material.dart';
import 'package:lms_core_frontend/common/components/left_sidebar_component.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    _PagePlaceholder(title: 'Home'),
    _PagePlaceholder(title: 'Results'),
    _PagePlaceholder(title: 'Tests'),
    _PagePlaceholder(title: 'Resources'),
    _PagePlaceholder(title: 'Payment'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          LeftSidebarComponent(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              setState(() => _selectedIndex = index);
            },
            onLogout: () {
              debugPrint('Logout tapped');
            },
          ),

          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}

class _PagePlaceholder extends StatelessWidget {
  final String title;
  const _PagePlaceholder({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
    );
  }
}

