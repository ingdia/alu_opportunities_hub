import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const ProfileScreen({super.key, required this.onToggleTheme});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock user data
  final String _name = 'Amara Diallo';
  final String _email = 'amara@alustudent.com';
  final String _role = 'Student';
  final String _campus = 'Kigali Campus';
  final int _eventsJoined = 5;
  final int _clubs = 3;
  final int _connections = 24;

  final List<Map<String, String>> _joinedEvents = [
    {
      'title': 'ALU Hackathon 2026',
      'date': 'June 15, 2026',
      'category': 'Hackathon',
      'status': 'Going',
    },
    {
      'title': 'Design Thinking Workshop',
      'date': 'June 20, 2026',
      'category': 'Workshop',
      'status': 'Going',
    },
    {
      'title': 'Entrepreneurship Pitch Night',
      'date': 'June 25, 2026',
      'category': 'Event',
      'status': 'Interested',
    },
    {
      'title': 'Campus Ambassador Program',
      'date': 'July 1, 2026',
      'category': 'Program',
      'status': 'Going',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textMuted =
        isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final bgColor =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Profile',
                      style: GoogleFonts.openSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.settings, color: textMuted),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Avatar + info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Avatar circle
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _name
                              .split(' ')
                              .map((e) => e[0])
                              .take(2)
                              .join(),
                          style: GoogleFonts.openSans(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Name
                    Text(
                      _name,
                      style: GoogleFonts.openSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Campus
                    Text(
                      _campus,
                      style: GoogleFonts.openSans(
                        fontSize: 13,
                        color: textMuted,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Role badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _role,
                        style: GoogleFonts.openSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Stats row
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _statItem(_eventsJoined.toString(), 'Events',
                              textPrimary, textMuted),
                          Container(
                              width: 0.5, height: 40, color: borderColor),
                          _statItem(_clubs.toString(), 'Clubs', textPrimary,
                              textMuted),
                          Container(
                              width: 0.5, height: 40, color: borderColor),
                          _statItem(_connections.toString(), 'Connections',
                              textPrimary, textMuted),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),

              // My RSVPs section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My RSVPs',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._joinedEvents.map(
                      (event) => _eventCard(
                          event, cardColor, borderColor, textPrimary,
                          textMuted),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),

              // Settings section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _settingsItem(
                      icon: isDark ? Icons.light_mode : Icons.dark_mode,
                      label: isDark ? 'Light Mode' : 'Dark Mode',
                      cardColor: cardColor,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      onTap: widget.onToggleTheme,
                    ),
                    _settingsItem(
                      icon: Icons.person_outline,
                      label: 'Edit Profile',
                      cardColor: cardColor,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      onTap: () {},
                    ),
                    _settingsItem(
                      icon: Icons.notifications_outlined,
                      label: 'Notifications',
                      cardColor: cardColor,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      onTap: () {},
                    ),
                    _settingsItem(
                      icon: Icons.help_outline,
                      label: 'Help & Support',
                      cardColor: cardColor,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      onTap: () {},
                    ),
                    _settingsItem(
                      icon: Icons.logout,
                      label: 'Log Out',
                      cardColor: cardColor,
                      borderColor: borderColor,
                      textPrimary: Colors.redAccent,
                      onTap: () {},
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(
      String value, String label, Color textPrimary, Color textMuted) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.openSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 12,
            color: textMuted,
          ),
        ),
      ],
    );
  }

  Widget _eventCard(Map<String, String> event, Color cardColor,
      Color borderColor, Color textPrimary, Color textMuted) {
    final isGoing = event['status'] == 'Going';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          // Category dot
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                Icons.event,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Event info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title']!,
                  style: GoogleFonts.openSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  event['date']!,
                  style: GoogleFonts.openSans(
                    fontSize: 11,
                    color: textMuted,
                  ),
                ),
              ],
            ),
          ),
          // Status badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isGoing
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              event['status']!,
              style: GoogleFonts.openSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isGoing ? AppColors.primary : Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsItem({
    required IconData icon,
    required String label,
    required Color cardColor,
    required Color borderColor,
    required Color textPrimary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, color: textPrimary, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  color: textPrimary,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: textPrimary, size: 18),
          ],
        ),
      ),
    );
  }
}