import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class AppNotification {
  final String id;
  final String title;
  final String body;
  final IconData icon;
  final Color color;
  final DateTime time;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.icon,
    required this.color,
    required this.time,
    this.isRead = false,
  });
}

final _mockNotifications = [
  AppNotification(
    id: 'n1',
    title: 'RSVP Confirmed 🎉',
    body: 'You\'re registered for ALU Hackathon 2026. See you there!',
    icon: Icons.check_circle_outline,
    color: AppColors.primary,
    time: DateTime.now().subtract(const Duration(minutes: 10)),
  ),
  AppNotification(
    id: 'n2',
    title: 'New Announcement',
    body: 'ALU Hackathon 2026: All teams must submit project ideas by 11am.',
    icon: Icons.campaign_outlined,
    color: Color(0xFF7C3AED),
    time: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  AppNotification(
    id: 'n3',
    title: 'Spot Running Out ⚠️',
    body: 'Only 3 spots left for Entrepreneurship Pitch Night. Register now!',
    icon: Icons.event_seat_outlined,
    color: Colors.orange,
    time: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  AppNotification(
    id: 'n4',
    title: 'New Event Posted',
    body: 'Tech & Innovation Hub posted "Flutter for Beginners" workshop.',
    icon: Icons.add_circle_outline,
    color: Color(0xFF0EA5E9),
    time: DateTime.now().subtract(const Duration(days: 1)),
  ),
  AppNotification(
    id: 'n5',
    title: 'Event Reminder 📅',
    body: 'Campus Leaders Workshop is tomorrow at 10am — Block A, Room 204.',
    icon: Icons.notifications_active_outlined,
    color: Color(0xFFF59E0B),
    time: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
  ),
  AppNotification(
    id: 'n6',
    title: 'Community Message',
    body: 'Kwame replied in ALU Hackathon 2026: "This is going to be epic! 💪"',
    icon: Icons.chat_bubble_outline,
    color: Color(0xFF16A34A),
    time: DateTime.now().subtract(const Duration(days: 2)),
  ),
];

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<AppNotification> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = List.from(_mockNotifications);
  }

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
  }

  void _markRead(String id) {
    setState(() {
      _notifications.firstWhere((n) => n.id == id).isRead = true;
    });
  }

  void _delete(String id) {
    setState(() => _notifications.removeWhere((n) => n.id == id));
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notifications',
                style: GoogleFonts.openSans(
                    fontSize: 17, fontWeight: FontWeight.bold, color: textPrimary)),
            if (unreadCount > 0)
              Text('$unreadCount unread',
                  style: GoogleFonts.openSans(fontSize: 11, color: AppColors.primary)),
          ],
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: Text('Mark all read',
                  style: GoogleFonts.openSans(
                      fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none_outlined,
                      size: 64, color: textMuted.withValues(alpha: 0.4)),
                  const SizedBox(height: 12),
                  Text('No notifications yet',
                      style: GoogleFonts.openSans(
                          fontSize: 15, fontWeight: FontWeight.w600, color: textMuted)),
                  const SizedBox(height: 6),
                  Text('You\'re all caught up!',
                      style: GoogleFonts.openSans(fontSize: 13, color: textMuted)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _notifications.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: borderColor, indent: 72),
              itemBuilder: (context, index) {
                final n = _notifications[index];
                return Dismissible(
                  key: Key(n.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.redAccent,
                    child: const Icon(Icons.delete_outline, color: Colors.white, size: 24),
                  ),
                  onDismissed: (_) => _delete(n.id),
                  child: GestureDetector(
                    onTap: () => _markRead(n.id),
                    child: Container(
                      color: n.isRead
                          ? Colors.transparent
                          : AppColors.primary.withValues(alpha: isDark ? 0.06 : 0.04),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: n.color.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(n.icon, color: n.color, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(n.title,
                                          style: GoogleFonts.openSans(
                                              fontSize: 13,
                                              fontWeight: n.isRead
                                                  ? FontWeight.w500
                                                  : FontWeight.bold,
                                              color: textPrimary)),
                                    ),
                                    Text(_timeAgo(n.time),
                                        style: GoogleFonts.openSans(
                                            fontSize: 10, color: textMuted)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(n.body,
                                    style: GoogleFonts.openSans(
                                        fontSize: 12, color: textMuted, height: 1.4),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          if (!n.isRead) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
