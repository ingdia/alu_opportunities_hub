import 'package:flutter/material.dart';
import '../chat/screens/chat_list_screen.dart';
import '../chat/screens/announcements_screen.dart';
import '../profile/screens/profile_screen.dart';

class MainShell extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const MainShell({super.key, required this.onToggleTheme});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const ChatListScreen(),
      const AnnouncementsScreen(),
      ProfileScreen(onToggleTheme: widget.onToggleTheme),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFF16A34A),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign_outlined), label: 'Announcements'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
