import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/state/rsvp_state.dart';
import '../../../core/state/event_feed_state.dart';
import '../../../core/state/user_session.dart';
import '../../../core/theme/app_colors.dart';
import '../../feed/screens/event_feed_screen.dart' show categoryColors, eventCoverImage;

const _categoryImages = {
  'Hackathon': 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=800&q=80',
  'Workshop':  'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=800&q=80',
  'Event':     'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&q=80',
  'Program':   'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=800&q=80',
  'Talk':      'https://images.unsplash.com/photo-1475721027785-f74eccf877e2?w=800&q=80',
  'Internship':'https://images.unsplash.com/photo-1521737852567-6949f3f9f2b5?w=800&q=80',
};

class EventDetailScreen extends StatefulWidget {
  final Map<String, String> event;
  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {

  bool _requiresForm(String? cat) =>
      cat == 'Hackathon' || cat == 'Program' || cat == 'Internship';

  // ── Apply / Register form dialog ─────────────────────────────────
  void _showRegisterForm(Color catColor) {
    final noteCtrl = TextEditingController();
    final session = UserSession.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Register for ${widget.event['title']}',
          style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Registering as',
                  style: GoogleFonts.openSans(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: catColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(children: [
                  Icon(Icons.person_outline, size: 16, color: catColor),
                  const SizedBox(width: 8),
                  Text(session.name.isEmpty ? 'You' : session.name,
                      style: GoogleFonts.openSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: catColor)),
                ]),
              ),
              const SizedBox(height: 14),
              Text('Why do you want to join? (optional)',
                  style: GoogleFonts.openSans(
                      fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
              const SizedBox(height: 6),
              TextField(
                controller: noteCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Brief motivation...',
                  hintStyle: GoogleFonts.openSans(fontSize: 12, color: Colors.grey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: catColor, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
                style: GoogleFonts.openSans(fontSize: 13),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.openSans(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: catColor,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              // Apply the RSVP after dialog closes
              _doRsvp(RsvpStatus.going);
            },
            child: Text('Submit Registration',
                style: GoogleFonts.openSans(
                    color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  // ── Confirm Going / Interested dialog ────────────────────────────
  void _showConfirmDialog(RsvpStatus newStatus) {
    final isGoing = newStatus == RsvpStatus.going;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isGoing ? 'Confirm Registration' : 'Mark as Interested',
          style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isGoing ? 'You are about to register for:' : 'Mark interest in:',
              style: GoogleFonts.openSans(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(widget.event['title']!,
                style: GoogleFonts.openSans(
                    fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              '${widget.event['date']} · ${widget.event['location']}',
              style: GoogleFonts.openSans(fontSize: 12, color: Colors.grey),
            ),
            if (isGoing) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'A spot will be reserved for you\nYou can cancel anytime',
                  style: GoogleFonts.openSans(
                      fontSize: 12, color: AppColors.primary, height: 1.6),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: GoogleFonts.openSans(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isGoing ? AppColors.primary : const Color(0xFFF59E0B),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _doRsvp(newStatus);
            },
            child: Text(
              isGoing ? 'Register Now' : 'Mark Interested',
              style: GoogleFonts.openSans(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ── Cancel RSVP dialog ───────────────────────────────────────────
  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Cancel RSVP',
            style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
        content: Text(
          'Cancel your RSVP for "${widget.event['title']}"?',
          style: GoogleFonts.openSans(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Keep it', style: GoogleFonts.openSans()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _doCancelRsvp();
            },
            child: Text('Yes, cancel',
                style: GoogleFonts.openSans(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  // ── State mutations ──────────────────────────────────────────────
  void _doRsvp(RsvpStatus newStatus) {
    final rsvp = RsvpState.of(context);
    final feedState = EventFeedState.of(context);
    final oldStatus = rsvp.statusOf(widget.event['id']!);

    if (newStatus == RsvpStatus.going && oldStatus != RsvpStatus.going) {
      feedState.onSpotChange(widget.event['id']!, -1);
    }
    if (newStatus != RsvpStatus.going && oldStatus == RsvpStatus.going) {
      feedState.onSpotChange(widget.event['id']!, 1);
    }
    rsvp.onUpdate(widget.event['id']!, newStatus);

    final isGoing = newStatus == RsvpStatus.going;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.check_circle, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            isGoing
                ? 'Registered for ${widget.event['title']}!'
                : 'Marked as Interested!',
            style: GoogleFonts.openSans(color: Colors.white),
          ),
        ),
      ]),
      backgroundColor: isGoing ? AppColors.primary : const Color(0xFFF59E0B),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  void _doCancelRsvp() {
    final rsvp = RsvpState.of(context);
    final feedState = EventFeedState.of(context);
    final current = rsvp.statusOf(widget.event['id']!);
    if (current == RsvpStatus.going) {
      feedState.onSpotChange(widget.event['id']!, 1);
    }
    rsvp.onUpdate(widget.event['id']!, RsvpStatus.none);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('RSVP cancelled', style: GoogleFonts.openSans()),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final rsvp = RsvpState.of(context);
    final feedState = EventFeedState.of(context);
    final session = UserSession.of(context);

    final status = rsvp.statusOf(widget.event['id']!);
    final isBookmarked = rsvp.isBookmarked(widget.event['id']!);
    final spots = feedState.spotsFor(widget.event['id']!);
    final catColor = categoryColors[widget.event['category']] ?? AppColors.primary;
    final tags = (widget.event['tags'] ?? '')
        .split(',')
        .where((t) => t.isNotEmpty)
        .toList();
    final isTrending = widget.event['trending'] == 'true';
    final isGoing = status == RsvpStatus.going;
    final isInterested = status == RsvpStatus.interested;
    final isFullyBooked = spots <= 0 && !isGoing;
    final isMyEvent = widget.event['postedBy'] == session.email && session.isOrganizer;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          // ── Hero SliverAppBar ──────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: catColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                ),
                onPressed: () =>
                    rsvp.onBookmark(widget.event['id']!, !isBookmarked),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  eventCoverImage(
                    localPath: widget.event['localImagePath'],
                    networkUrl: _categoryImages[widget.event['category']] ??
                        'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&q=80',
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.72),
                          Colors.black.withValues(alpha: 0.15),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(children: [
                          _badge(widget.event['category']!, catColor),
                          if (isTrending) ...[
                            const SizedBox(width: 8),
                            _badge('Trending', Colors.orange,
                                icon: Icons.local_fire_department),
                          ],
                        ]),
                        const SizedBox(height: 10),
                        Text(widget.event['title']!,
                            style: GoogleFonts.openSans(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Body ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Organizer row
                  Row(children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: catColor.withValues(alpha: 0.15),
                      child: Text(widget.event['organizerAvatar'] ?? '?',
                          style: GoogleFonts.openSans(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: catColor)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Organized by',
                            style: GoogleFonts.openSans(
                                fontSize: 11, color: textMuted)),
                        Text(widget.event['organizer']!,
                            style: GoogleFonts.openSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: textPrimary)),
                      ],
                    ),
                  ]),
                  const SizedBox(height: 20),

                  // Info cards
                  Row(children: [
                    Expanded(
                        child: _infoCard(
                            Icons.calendar_today_outlined,
                            'Date',
                            widget.event['date']!,
                            cardColor, borderColor, textPrimary, textMuted, catColor)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _infoCard(
                            Icons.location_on_outlined,
                            'Location',
                            widget.event['location']!,
                            cardColor, borderColor, textPrimary, textMuted, catColor)),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                        child: _infoCard(
                            Icons.timer_outlined,
                            'Deadline',
                            widget.event['deadline'] ?? 'Open',
                            cardColor, borderColor, textPrimary, textMuted,
                            Colors.redAccent)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _infoCard(
                            Icons.people_outline,
                            'Spots left',
                            '$spots',
                            cardColor, borderColor, textPrimary, textMuted,
                            spots < 10 ? Colors.redAccent : AppColors.primary)),
                  ]),
                  const SizedBox(height: 24),

                  // Description
                  Text('About this event',
                      style: GoogleFonts.openSans(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: textPrimary)),
                  const SizedBox(height: 8),
                  Text(widget.event['description']!,
                      style: GoogleFonts.openSans(
                          fontSize: 14, color: textMuted, height: 1.6)),
                  const SizedBox(height: 20),

                  // Tags
                  if (tags.isNotEmpty) ...[
                    Text('Tags',
                        style: GoogleFonts.openSans(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: textPrimary)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tags
                          .map((tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: catColor.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: catColor.withValues(alpha: 0.3)),
                                ),
                                child: Text('#$tag',
                                    style: GoogleFonts.openSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: catColor)),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Current status banner
                  if (status != RsvpStatus.none)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: isGoing
                            ? AppColors.primary.withValues(alpha: 0.08)
                            : Colors.orange.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isGoing
                              ? AppColors.primary.withValues(alpha: 0.3)
                              : Colors.orange.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(children: [
                        Icon(
                          isGoing ? Icons.check_circle : Icons.star,
                          color: isGoing ? AppColors.primary : Colors.orange,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isGoing
                                ? 'You are registered! See you there.'
                                : 'You marked yourself as Interested.',
                            style: GoogleFonts.openSans(
                                fontSize: 13,
                                color: isGoing
                                    ? AppColors.primary
                                    : Colors.orange,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        TextButton(
                          onPressed: _showCancelDialog,
                          child: Text('Cancel',
                              style: GoogleFonts.openSans(
                                  fontSize: 12, color: Colors.redAccent)),
                        ),
                      ]),
                    ),

                  // Action buttons
                  if (!isMyEvent) ...[
                    if (isFullyBooked)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.redAccent.withValues(alpha: 0.3)),
                        ),
                        child: Text('This event is fully booked.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.openSans(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w600)),
                      )
                    else if (_requiresForm(widget.event['category'])) ...[
                      // Apply / Register button
                      if (isGoing)
                        Row(children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: catColor.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: catColor.withValues(alpha: 0.3)),
                              ),
                              child: Center(
                                child: Text('Registered',
                                    style: GoogleFonts.openSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: catColor)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: _showCancelDialog,
                            child: Text('Cancel',
                                style: GoogleFonts.openSans(
                                    fontSize: 13, color: Colors.redAccent)),
                          ),
                        ])
                      else
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.app_registration_outlined,
                                size: 18, color: Colors.white),
                            label: Text('Apply / Register',
                                style: GoogleFonts.openSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: catColor,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: () => _showRegisterForm(catColor),
                          ),
                        ),
                    ] else ...[
                      // Going + Interested row
                      Row(children: [
                        Expanded(
                          child: _ActionBtn(
                            label: isGoing ? 'Going' : 'Going',
                            icon: isGoing
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            active: isGoing,
                            color: AppColors.primary,
                            onTap: () => isGoing
                                ? _showCancelDialog()
                                : _showConfirmDialog(RsvpStatus.going),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionBtn(
                            label: isInterested ? 'Interested' : 'Interested',
                            icon: isInterested ? Icons.star : Icons.star_border,
                            active: isInterested,
                            color: const Color(0xFFF59E0B),
                            onTap: () => isInterested
                                ? _showCancelDialog()
                                : _showConfirmDialog(RsvpStatus.interested),
                          ),
                        ),
                      ]),
                    ],
                  ],
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color, {IconData? icon}) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: icon != null ? color : Colors.white.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: Colors.white),
            const SizedBox(width: 3),
          ],
          Text(text,
              style: GoogleFonts.openSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
        ]),
      );

  Widget _infoCard(
    IconData icon,
    String label,
    String value,
    Color cardColor,
    Color borderColor,
    Color textPrimary,
    Color textMuted,
    Color iconColor,
  ) =>
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.openSans(fontSize: 10, color: textMuted)),
                Text(value,
                    style: GoogleFonts.openSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textPrimary),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ]),
      );
}

// ── Action button (Going / Interested) ───────────────────────────────────────
class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.active,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: active ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 17, color: active ? Colors.white : color),
            const SizedBox(width: 6),
            Text(
              active ? '$label  ✓' : label,
              style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: active ? Colors.white : color),
            ),
          ],
        ),
      ),
    );
  }
}
