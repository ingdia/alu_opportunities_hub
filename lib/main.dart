import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/chat/screens/chat_list_screen.dart';
import 'features/chat/screens/chat_screen.dart';
import 'features/chat/screens/announcements_screen.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/profile/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALU Opportunities Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF16A34A),
        ),
        textTheme: GoogleFonts.openSansTextTheme(),
        useMaterial3: true,
      ),
      initialRoute: '/chats',
      routes: {
        '/chats': (context) => const ChatListScreen(),
        '/chat': (context) => const ChatScreen(
          communityName: 'ALU Hackathon 2026',
          eventTag: 'Hackathon',
        ),
        '/announcements': (context) => const AnnouncementsScreen(),
      },
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: SplashScreen(onToggleTheme: _toggleTheme),
      routes: {
  '/profile': (context) => ProfileScreen(onToggleTheme: _toggleTheme),
},
    );
  }
}