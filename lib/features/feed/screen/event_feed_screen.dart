import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/state/rsvp_state.dart';
import '../../../core/theme/app_colors.dart';
import '../data/mock_events.dart';

const _categoryColors = {
  'Hackathon': Color(0xFF7C3AED),
  'Workshop': Color(0xFF0EA5E9),
  'Event': Color(0xFFF59E0B),
  'Program': Color(0xFF16A34A),
  'Talk': Color(0xFFEC4899),
};

class EventFeedScreen extends StatelessWidget {
  const EventFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textMuted = isDark
        ? AppColors.darkTextMuted
        : AppColors.lightTextMuted;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Row(
                children: [
                  Text(
                    'Opportunities',
                    style: GoogleFonts.openSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: mockEvents.length,
                itemBuilder: (context, index) {
                  final event = mockEvents[index];
                  return _EventCard(
                    event: event,
                    cardColor: cardColor,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Map<String, String> event;
  final Color cardColor, borderColor, textPrimary, textMuted;

  const _EventCard({
    required this.event,
    required this.cardColor,
    required this.borderColor,
    required this.textPrimary,
    required this.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    final rsvp = RsvpState.of(context);
    final status = rsvp.statusOf(event['id']!);
    final catColor = _categoryColors[event['category']] ?? AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category + organizer row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: catColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    event['category']!,
                    style: GoogleFonts.openSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: catColor,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  event['organizer']!,
                  style: GoogleFonts.openSans(fontSize: 11, color: textMuted),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Title
            Text(
              event['title']!,
              style: GoogleFonts.openSans(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 6),

            // Description
            Text(
              event['description']!,
              style: GoogleFonts.openSans(
                fontSize: 12,
                color: textMuted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 10),

            // Date / location / spots
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 13, color: textMuted),
                const SizedBox(width: 4),
                Text(
                  event['date']!,
                  style: GoogleFonts.openSans(fontSize: 11, color: textMuted),
                ),
                const SizedBox(width: 12),
                Icon(Icons.location_on_outlined, size: 13, color: textMuted),
                const SizedBox(width: 4),
                Text(
                  event['location']!,
                  style: GoogleFonts.openSans(fontSize: 11, color: textMuted),
                ),
                const Spacer(),
                Text(
                  event['spots']!,
                  style: GoogleFonts.openSans(
                    fontSize: 11,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // RSVP buttons
            Row(
              children: [
                _RsvpButton(
                  label: 'Going',
                  icon: Icons.check_circle_outline,
                  active: status == RsvpStatus.going,
                  activeColor: AppColors.primary,
                  onTap: () => rsvp.onUpdate(
                    event['id']!,
                    status == RsvpStatus.going
                        ? RsvpStatus.none
                        : RsvpStatus.going,
                  ),
                ),
                const SizedBox(width: 8),
                _RsvpButton(
                  label: 'Interested',
                  icon: Icons.star_border,
                  active: status == RsvpStatus.interested,
                  activeColor: const Color(0xFFF59E0B),
                  onTap: () => rsvp.onUpdate(
                    event['id']!,
                    status == RsvpStatus.interested
                        ? RsvpStatus.none
                        : RsvpStatus.interested,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RsvpButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final Color activeColor;
  final VoidCallback onTap;

  const _RsvpButton({
    required this.label,
    required this.icon,
    required this.active,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? activeColor : activeColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? activeColor : activeColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: active ? Colors.white : activeColor),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.openSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : activeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
