import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/state/rsvp_state.dart';
import '../../../core/state/event_feed_state.dart';
import '../../../core/state/user_session.dart';
import '../../../core/theme/app_colors.dart';
import '../../feed/screens/event_detail_screen.dart';
import '../../feed/screens/event_feed_screen.dart' show categoryColors, eventCoverImage;
import '../../feed/screens/post_event_screen.dart';
import '../../chat/screens/announcements_screen.dart';

// Unsplash images mapped per category
const _categoryImages = {
  'Hackathon': 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=600&q=80',
  'Workshop': 'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=600&q=80',
  'Event': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=600&q=80',
  'Program': 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=600&q=80',
  'Talk': 'https://images.unsplash.com/photo-1475721027785-f74eccf877e2?w=600&q=80',
  'Internship': 'https://images.unsplash.com/photo-1521737852567-6949f3f9f2b5?w=600&q=80',
};

class HomeScreen extends StatelessWidget {
  final void Function(int) onNavigate;
  const HomeScreen({super.key, required this.onNavigate});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _firstName(String name) =>
      name.isEmpty ? 'there' : name.split(' ').first;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final session = UserSession.of(context);
    final rsvpState = RsvpState.of(context);
    final feedState = EventFeedState.of(context);
    final rsvpMap = rsvpState.all;
    final bookmarks = rsvpState.allBookmarks;

    final rsvpCount = rsvpMap.values.where((s) => s != RsvpStatus.none).length;
    final savedCount = bookmarks.length;

    final upcomingEvents = feedState.events
        .where((e) => rsvpMap[e['id']] == RsvpStatus.going)
        .take(3)
        .toList();

    final trendingEvents = feedState.events
        .where((e) => e['trending'] == 'true')
        .take(5)
        .toList();

    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Photo Hero Banner ─────────────────────────────────────
            SizedBox(
              height: 220,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=900&q=80',
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, p) => p == null
                        ? child
                        : Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.primaryDark, AppColors.primary],
                              ),
                            ),
                          ),
                    errorBuilder: (_, __, ___) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primaryDark, AppColors.primary],
                        ),
                      ),
                    ),
                  ),
                  // Dark gradient overlay
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black54, Colors.black26],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  // Content
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top row: avatar + role badge
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: AppColors.primary,
                                child: Text(
                                  _firstName(session.name).isNotEmpty
                                      ? _firstName(session.name)[0].toUpperCase()
                                      : '?',
                                  style: GoogleFonts.openSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  session.email,
                                  style: GoogleFonts.openSans(
                                      fontSize: 12, color: Colors.white70),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  session.isOrganizer ? 'Organizer' : 'Student',
                                  style: GoogleFonts.openSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Greeting
                          Text(
                            '${_greeting()},',
                            style: GoogleFonts.openSans(
                                fontSize: 14, color: Colors.white70),
                          ),
                          Text(
                            _firstName(session.name),
                            style: GoogleFonts.openSans(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 14),
                          // Stats pills
                          Row(
                            children: [
                              _statPill(
                                session.isOrganizer
                                    ? feedState.events
                                        .where((e) => e['postedBy'] == session.email)
                                        .length
                                        .toString()
                                    : rsvpCount.toString(),
                                session.isOrganizer ? 'Posted' : 'RSVPs',
                              ),
                              const SizedBox(width: 8),
                              _statPill(savedCount.toString(), 'Saved'),
                              const SizedBox(width: 8),
                              _statPill(
                                  feedState.events.length.toString(), 'Events'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Quick Actions ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
              child: Text('Quick Actions',
                  style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textPrimary)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _QuickAction(
                    icon: Icons.explore_outlined,
                    label: 'Browse',
                    color: AppColors.primary,
                    onTap: () => onNavigate(1),
                  ),
                  const SizedBox(width: 10),
                  _QuickAction(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Chats',
                    color: const Color(0xFF0EA5E9),
                    onTap: () => onNavigate(2),
                  ),
                  const SizedBox(width: 10),
                  if (session.isOrganizer)
                    _QuickAction(
                      icon: Icons.add_circle_outline_rounded,
                      label: 'Post Event',
                      color: AppColors.primaryDark,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PostEventScreen())),
                    )
                  else
                    _QuickAction(
                      icon: Icons.campaign_outlined,
                      label: 'Updates',
                      color: const Color(0xFFF59E0B),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AnnouncementsScreen())),
                    ),
                  const SizedBox(width: 10),
                  _QuickAction(
                    icon: Icons.person_outline_rounded,
                    label: 'Profile',
                    color: AppColors.primary,
                    onTap: () => onNavigate(3),
                  ),
                ],
              ),
            ),

            // ── Trending Now ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.local_fire_department,
                          color: Colors.orange, size: 16),
                    ),
                    const SizedBox(width: 8),
                    Text('Trending Now',
                        style: GoogleFonts.openSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textPrimary)),
                  ]),
                  GestureDetector(
                    onTap: () => onNavigate(1),
                    child: Text('See all',
                        style: GoogleFonts.openSans(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 200,
              child: trendingEvents.isEmpty
                  ? Center(
                      child: Text('No trending events',
                          style:
                              GoogleFonts.openSans(color: textMuted)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: trendingEvents.length,
                      itemBuilder: (_, i) => _TrendingCard(
                        event: trendingEvents[i],
                        spots: feedState.spotsFor(trendingEvents[i]['id']!),
                      ),
                    ),
            ),

            // ── Upcoming RSVPs ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.event_available_outlined,
                          color: AppColors.primary, size: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                        session.isOrganizer
                            ? 'Your Posted Events'
                            : 'My Upcoming RSVPs',
                        style: GoogleFonts.openSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textPrimary)),
                  ]),
                  GestureDetector(
                    onTap: () => onNavigate(3),
                    child: Text('See all',
                        style: GoogleFonts.openSans(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),

            if (upcomingEvents.isEmpty && !session.isOrganizer)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: _EmptyCard(
                  icon: Icons.event_outlined,
                  message:
                      'No upcoming events yet.\nRSVP to events in the Feed!',
                  actionLabel: 'Browse Feed',
                  onAction: () => onNavigate(1),
                  cardColor: cardColor,
                  borderColor: borderColor,
                  textMuted: textMuted,
                ),
              )
            else
              ...upcomingEvents.map((e) => Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                    child: _UpcomingEventCard(
                      event: e,
                      rsvpStatus: rsvpMap[e['id']] ?? RsvpStatus.none,
                      cardColor: cardColor,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      textMuted: textMuted,
                    ),
                  )),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _statPill(String value, String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value,
                style: GoogleFonts.openSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(width: 5),
            Text(label,
                style:
                    GoogleFonts.openSans(fontSize: 11, color: Colors.white70)),
          ],
        ),
      );
}

// ── Quick Action ─────────────────────────────────────────────────────────────
class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Trending Card with photo ─────────────────────────────────────────────────
class _TrendingCard extends StatelessWidget {
  final Map<String, String> event;
  final int spots;

  const _TrendingCard({required this.event, required this.spots});

  @override
  Widget build(BuildContext context) {
    final catColor = categoryColors[event['category']] ?? AppColors.primary;
    final imgUrl = _categoryImages[event['category']] ??
        'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=600&q=80';

    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => EventDetailScreen(event: event))),
      child: Container(
        width: 210,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: catColor.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Photo
              eventCoverImage(
                localPath: event['localImagePath'],
                networkUrl: imgUrl,
              ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black87, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top badges
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: catColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(event['category']!,
                              style: GoogleFonts.openSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.local_fire_department,
                              color: Colors.white, size: 12),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Title
                    Text(event['title']!,
                        style: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Row(children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 11, color: Colors.white70),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(event['date']!,
                            style: GoogleFonts.openSans(
                                fontSize: 11, color: Colors.white70),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ]),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.people_outline,
                          size: 11, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text('$spots spots left',
                          style: GoogleFonts.openSans(
                              fontSize: 11,
                              color: spots < 10
                                  ? Colors.orangeAccent
                                  : Colors.white70,
                              fontWeight: spots < 10
                                  ? FontWeight.w600
                                  : FontWeight.normal)),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Upcoming Event Card ───────────────────────────────────────────────────────
class _UpcomingEventCard extends StatelessWidget {
  final Map<String, String> event;
  final RsvpStatus rsvpStatus;
  final Color cardColor, borderColor, textPrimary, textMuted;

  const _UpcomingEventCard({
    required this.event,
    required this.rsvpStatus,
    required this.cardColor,
    required this.borderColor,
    required this.textPrimary,
    required this.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    final imgUrl = _categoryImages[event['category']] ??
        'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=600&q=80';
    final isGoing = rsvpStatus == RsvpStatus.going;

    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => EventDetailScreen(event: event))),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        clipBehavior: Clip.hardEdge,
        child: Row(
          children: [
            // Left image strip
            SizedBox(
              width: 80,
              height: 88,
              child: eventCoverImage(
                localPath: event['localImagePath'],
                networkUrl: imgUrl,
              ),
            ),
            // Right content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
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
                    Row(children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 11, color: textMuted),
                      const SizedBox(width: 3),
                      Text(event['date']!,
                          style: GoogleFonts.openSans(
                              fontSize: 11, color: textMuted)),
                    ]),
                    const SizedBox(height: 4),
                    Row(children: [
                      Icon(Icons.location_on_outlined,
                          size: 11, color: textMuted),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(event['location']!,
                            style: GoogleFonts.openSans(
                                fontSize: 11, color: textMuted),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isGoing
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isGoing
                        ? AppColors.primary.withValues(alpha: 0.4)
                        : Colors.orange.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  isGoing ? 'Going' : 'Interested',
                  style: GoogleFonts.openSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isGoing ? AppColors.primary : Colors.orange),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty Card ───────────────────────────────────────────────────────────────
class _EmptyCard extends StatelessWidget {
  final IconData icon;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;
  final Color cardColor, borderColor, textMuted;

  const _EmptyCard({
    required this.icon,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    required this.cardColor,
    required this.borderColor,
    required this.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          Text(message,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                  fontSize: 13, color: textMuted, height: 1.6)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: Text(actionLabel,
                style: GoogleFonts.openSans(
                    fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
