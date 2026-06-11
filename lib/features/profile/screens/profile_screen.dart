import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/state/rsvp_state.dart';
import '../../../core/state/event_feed_state.dart';
import '../../../core/state/user_session.dart';
import '../../feed/screens/event_detail_screen.dart';
import '../../feed/screens/event_feed_screen.dart' show eventCoverImage;

class ProfileScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;
  const ProfileScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;

    final session = UserSession.of(context);
    final rsvpState = RsvpState.of(context);
    final rsvpMap = rsvpState.all;
    final bookmarks = rsvpState.allBookmarks;
    final allEvents = EventFeedState.of(context).events;

    final initials = session.name.isEmpty
        ? '?'
        : session.name
            .split(' ')
            .map((e) => e.isNotEmpty ? e[0] : '')
            .take(2)
            .join()
            .toUpperCase();

    final myRsvps = allEvents
        .where((e) => rsvpMap[e['id']] != null && rsvpMap[e['id']] != RsvpStatus.none)
        .toList();
    final myBookmarks = allEvents.where((e) => bookmarks.contains(e['id'])).toList();
    final myPostedEvents = allEvents.where((e) => e['postedBy'] == session.email).toList();

    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        child: Column(
          children: [

            // ── Cover photo + avatar ──────────────────────────────────
            SizedBox(
              height: 200,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Cover image
                  Positioned.fill(
                    child: Image.network(
                      'https://images.unsplash.com/photo-1517486808906-6ca8b3f04846?w=900&q=80',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.primaryDark, AppColors.primary],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Overlay
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black54, Colors.black12],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                  // Top bar
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Profile',
                              style: GoogleFonts.openSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          IconButton(
                            icon: Icon(
                              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                              color: Colors.white,
                            ),
                            onPressed: onToggleTheme,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Profile card (floats over cover) ─────────────────────
            Transform.translate(
              offset: const Offset(0, -40),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Avatar with network photo overlay
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.network(
                                session.isOrganizer
                                    ? 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=200&q=80'
                                    : 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=200&q=80',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: AppColors.primary,
                                  child: Center(
                                    child: Text(initials,
                                        style: GoogleFonts.openSans(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Initials fallback overlay (hidden when image loads)
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        session.name.isEmpty ? 'User' : session.name,
                        style: GoogleFonts.openSans(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Text(session.email,
                          style: GoogleFonts.openSans(
                              fontSize: 13, color: textMuted)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          session.isOrganizer
                              ? 'Organizer · ALU'
                              : 'Student · ALU',
                          style: GoogleFonts.openSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Stats row
                      Row(
                        children: [
                          if (session.isOrganizer) ...[
                            _statItem(myPostedEvents.length.toString(),
                                'Posted', textPrimary, textMuted),
                            _divider(borderColor),
                            _statItem('12', 'Total RSVPs', textPrimary, textMuted),
                            _divider(borderColor),
                            _statItem('3', 'Active', textPrimary, textMuted),
                          ] else ...[
                            _statItem(myRsvps.length.toString(), 'RSVPs',
                                textPrimary, textMuted),
                            _divider(borderColor),
                            _statItem(myBookmarks.length.toString(), 'Saved',
                                textPrimary, textMuted),
                            _divider(borderColor),
                            _statItem('24', 'Connections', textPrimary, textMuted),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Activity section ──────────────────────────────────────
            Transform.translate(
              offset: const Offset(0, -24),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeader(
                      icon: Icons.event_note_outlined,
                      title: session.isOrganizer ? 'My Posted Events' : 'My RSVPs',
                      textPrimary: textPrimary,
                    ),
                    const SizedBox(height: 12),
                    if (session.isOrganizer) ...[
                      if (myPostedEvents.isEmpty)
                        _emptyBox(
                            'No events posted yet.',
                            cardColor,
                            borderColor,
                            textMuted)
                      else
                        ...myPostedEvents.map((e) => _EventRow(
                              event: e,
                              cardColor: cardColor,
                              borderColor: borderColor,
                              textPrimary: textPrimary,
                              textMuted: textMuted,
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(e['category']!,
                                    style: GoogleFonts.openSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary)),
                              ),
                            )),
                    ] else ...[
                      if (myRsvps.isEmpty && myBookmarks.isEmpty)
                        _emptyBox('No RSVPs yet. Browse the Feed!', cardColor,
                            borderColor, textMuted)
                      else ...[
                        if (myRsvps.isNotEmpty) ...[
                          _subLabel('RSVPs', textMuted),
                          const SizedBox(height: 8),
                          ...myRsvps.map((e) {
                            final isGoing = rsvpMap[e['id']] == RsvpStatus.going;
                            return _EventRow(
                              event: e,
                              cardColor: cardColor,
                              borderColor: borderColor,
                              textPrimary: textPrimary,
                              textMuted: textMuted,
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isGoing
                                      ? AppColors.primary.withValues(alpha: 0.1)
                                      : Colors.orange.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  isGoing ? 'Going' : 'Interested',
                                  style: GoogleFonts.openSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isGoing
                                          ? AppColors.primary
                                          : Colors.orange),
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 16),
                        ],
                        if (myBookmarks.isNotEmpty) ...[
                          _subLabel('Saved', textMuted),
                          const SizedBox(height: 8),
                          ...myBookmarks.map((e) => _EventRow(
                                event: e,
                                cardColor: cardColor,
                                borderColor: borderColor,
                                textPrimary: textPrimary,
                                textMuted: textMuted,
                                trailing: const Icon(Icons.bookmark,
                                    color: Color(0xFFF59E0B), size: 18),
                              )),
                        ],
                      ],
                    ],
                    const SizedBox(height: 28),

                    // Settings
                    _sectionHeader(
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      textPrimary: textPrimary,
                    ),
                    const SizedBox(height: 12),
                    _SettingsTile(
                      icon: isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                      label: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                      iconColor: AppColors.primary,
                      cardColor: cardColor,
                      borderColor: borderColor,
                      textColor: textPrimary,
                      onTap: onToggleTheme,
                    ),
                    _SettingsTile(
                      icon: Icons.notifications_outlined,
                      label: 'Notifications',
                      iconColor: AppColors.primary,
                      cardColor: cardColor,
                      borderColor: borderColor,
                      textColor: textPrimary,
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Notifications coming soon',
                                style: GoogleFonts.openSans()),
                            behavior: SnackBarBehavior.floating),
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.help_outline_rounded,
                      label: 'Help & Support',
                      iconColor: AppColors.primary,
                      cardColor: cardColor,
                      borderColor: borderColor,
                      textColor: textPrimary,
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.logout_rounded,
                      label: 'Log Out',
                      iconColor: Colors.redAccent,
                      cardColor: cardColor,
                      borderColor: borderColor,
                      textColor: Colors.redAccent,
                      onTap: () => Navigator.of(context)
                          .pushNamedAndRemoveUntil('/login', (_) => false),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String v, String l, Color tp, Color tm) => Expanded(
        child: Column(children: [
          Text(v,
              style: GoogleFonts.openSans(
                  fontSize: 20, fontWeight: FontWeight.bold, color: tp)),
          const SizedBox(height: 2),
          Text(l, style: GoogleFonts.openSans(fontSize: 12, color: tm)),
        ]),
      );

  Widget _divider(Color c) =>
      Container(width: 1, height: 36, color: c, margin: const EdgeInsets.symmetric(horizontal: 4));

  Widget _sectionHeader({required IconData icon, required String title, required Color textPrimary}) =>
      Row(children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 16),
        ),
        const SizedBox(width: 10),
        Text(title,
            style: GoogleFonts.openSans(
                fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary)),
      ]);

  Widget _subLabel(String t, Color c) => Text(t,
      style: GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.w600, color: c));

  Widget _emptyBox(String msg, Color card, Color border, Color muted) =>
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Text(msg,
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(fontSize: 13, color: muted)),
      );
}

// ── Event row with image thumb ────────────────────────────────────────────────
class _EventRow extends StatelessWidget {
  final Map<String, String> event;
  final Color cardColor, borderColor, textPrimary, textMuted;
  final Widget trailing;

  const _EventRow({
    required this.event,
    required this.cardColor,
    required this.borderColor,
    required this.textPrimary,
    required this.textMuted,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    const imgMap = {
      'Hackathon': 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=200&q=70',
      'Workshop': 'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=200&q=70',
      'Event': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=200&q=70',
      'Program': 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=200&q=70',
      'Talk': 'https://images.unsplash.com/photo-1475721027785-f74eccf877e2?w=200&q=70',
      'Internship': 'https://images.unsplash.com/photo-1521737852567-6949f3f9f2b5?w=200&q=70',
    };

    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => EventDetailScreen(event: event))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        clipBehavior: Clip.hardEdge,
        child: Row(
          children: [
            SizedBox(
              width: 72,
              height: 80,
              child: eventCoverImage(
                localPath: event['localImagePath'],
                networkUrl: imgMap[event['category']] ??
                    'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=200&q=70',
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event['title']!,
                        style: GoogleFonts.openSans(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text('${event['date']}',
                        style: GoogleFonts.openSans(
                            fontSize: 11, color: textMuted)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: trailing,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Settings Tile ─────────────────────────────────────────────────────────────
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor, cardColor, borderColor, textColor;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.cardColor,
    required this.borderColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: GoogleFonts.openSans(fontSize: 14, color: textColor)),
            ),
            Icon(Icons.chevron_right_rounded, color: textColor.withValues(alpha: 0.5), size: 20),
          ],
        ),
      ),
    );
  }
}
