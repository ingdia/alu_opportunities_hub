import 'package:flutter/material.dart';

enum UserRole { student, organizer }

class UserSession extends InheritedWidget {
  final String name;
  final String email;
  final UserRole role;

  const UserSession({
    super.key,
    required this.name,
    required this.email,
    required this.role,
    required super.child,
  });

  static UserSession of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserSession>()!;
  }

  bool get isOrganizer => role == UserRole.organizer;

  @override
  bool updateShouldNotify(UserSession oldWidget) =>
      oldWidget.role != role || oldWidget.name != name;
}
