import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/state/user_session.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/shell/main_shell.dart';

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
  String _userName = '';
  String _userEmail = '';
  UserRole _userRole = UserRole.student;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _setUser(String name, String email, UserRole role) {
    setState(() {
      _userName = name;
      _userEmail = email;
      _userRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALU Opportunities Hub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: SplashScreen(onToggleTheme: _toggleTheme, onLogin: _setUser),
      routes: {
        '/login': (context) => LoginScreen(
              onToggleTheme: _toggleTheme,
              onLogin: _setUser,
            ),
        '/home': (context) => MainShell(
              onToggleTheme: _toggleTheme,
              userName: _userName,
              userEmail: _userEmail,
              userRole: _userRole,
            ),
      },
    );
  }
}
