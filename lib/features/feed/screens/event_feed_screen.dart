import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/state/rsvp_state.dart';
import '../../../core/state/event_feed_state.dart';
import '../../../core/state/user_session.dart';
import '../../../core/theme/app_colors.dart';
import 'event_detail_screen.dart';

/// Returns a Widget that shows a local file image if [localPath] is set,
/// otherwise falls back to the Unsplash [networkUrl].
Widget eventCoverImage({
  String? localPath,
  required String networkUrl,
  BoxFit fit = BoxFit.cover,
}) {
  if (localPath != null && localPath.isNotEmpty) {
    return Image.file(File(localPath), fit: fit);
  }
  return Image.network(
    networkUrl,
    fit: fit,
    errorBuilder: (_, __, ___) => Container(color: const Color(0xFF10B981)),
  );
}

const categoryColors = {
  'All': Color(0xFF64748B),
  'Hackathon': Color(0xFF7C3AED),
  'Workshop': Color(0xFF0EA5E9),
  'Event': Color(0xFFF59E0B),
  'Program': Color(0xFF16A34A),
  'Talk': Color(0xFFEC4899),
  'Internship': Color(0xFF0891B2),
};

const _categoryImages = {
  'Hackathon': 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=600&q=70',
  'Workshop': 'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=600&q=70',
  'Event': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=600&q=70',
  'Program': 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=600&q=70',
  'Talk': 'https://images.unsplash.com/photo-1475721027785-f74eccf877e2?w=600&q=70',
  'Internship': 'https://images.unsplash.com/photo-1521737852567-6949f3f9f2b5?w=600&q=70',
};

const _formalCategories = {'Hackathon', 'Program', 'Internship'};

class EventFeedScreen extends StatefulWidget {
  const EventFeedScreen({super.key});

  @override
  State<EventFeedScreen> createState() => _EventFeedScreenState();
}

class _EventFeedScreenState extends State<EventFeedScreen> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final session = UserSession.of(context);
    final feedState = EventFeedState.of(context);

    final filtered = feedState.events.where((e) {
      final matchesSearch = _searchQuery.isEmpty ||
          e['title']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e['description']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e['organizer']!.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'All' || e['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Opportunities',
                          style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textPrimary)),
                      Text('${filtered.length} events found',
                          style: GoogleFonts.openSans(fontSize: 11, color: textMuted)),
                    ],
                  ),
                  const Spacer(),

                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _searchQuery = v),
                style: GoogleFonts.openSans(fontSize: 14, color: textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search events, clubs, programs...',
                  hintStyle: GoogleFonts.openSans(color: textMuted, fontSize: 13),
                  prefixIcon: Icon(Icons.search, color: textMuted, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: textMuted, size: 18),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: cardColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: borderColor)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: borderColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                ),
              ),
            ),

            // Category filter chips
            SizedBox(
              height: 38,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: categoryColors.keys.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  final color = categoryColors[cat]!;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? color : color.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: isSelected ? color : color.withValues(alpha: 0.3)),
                      ),
                      child: Text(cat,
                          style: GoogleFonts.openSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : color)),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),

            if (session.isOrganizer)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 14, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('Organizer view — post events and manage your listings.',
                            style: GoogleFonts.openSans(fontSize: 11, color: AppColors.primary)),
                      ),
                    ],
                  ),
                ),
              ),

            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded,
                              size: 64, color: textMuted.withValues(alpha: 0.4)),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'No results for "$_searchQuery"'
                                : 'No $_selectedCategory events yet',
                            style: GoogleFonts.openSans(
                                fontSize: 15, fontWeight: FontWeight.w600, color: textMuted),
                          ),
                          const SizedBox(height: 8),
                          Text('Try a different search or category',
                              style: GoogleFonts.openSans(fontSize: 13, color: textMuted)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) => _EventCard(
                        event: filtered[index],
                        cardColor: cardColor,
                        borderColor: borderColor,
                        textPrimary: textPrimary,
                        textMuted: textMuted,
                      ),
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
    final session = UserSession.of(context);
    final rsvp = RsvpState.of(context);
    final feedState = EventFeedState.of(context);
    final status = rsvp.statusOf(event['id']!);
    final isBookmarked = rsvp.isBookmarked(event['id']!);
    final spots = feedState.spotsFor(event['id']!);
    final catColor = categoryColors[event['category']] ?? AppColors.primary;
    final isMyEvent = event['postedBy'] == session.email;
    final isTrending = event['trending'] == 'true';

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => EventDetailScreen(event: event)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isMyEvent && session.isOrganizer
                ? AppColors.primary.withValues(alpha: 0.4)
                : borderColor,
            width: isMyEvent && session.isOrganizer ? 1.5 : 1,
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo banner
            SizedBox(
              height: 130,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  eventCoverImage(
                    localPath: event['localImagePath'],
                    networkUrl: _categoryImages[event['category']] ??
                        'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=600&q=70',
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black54, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  // Badges on photo
                  Positioned(
                    top: 10,
                    left: 12,
                    child: Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: catColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(event['category']!,
                            style: GoogleFonts.openSans(
                                fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                      if (isTrending) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.local_fire_department, size: 11, color: Colors.white),
                            const SizedBox(width: 3),
                            Text('Trending',
                                style: GoogleFonts.openSans(
                                    fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white)),
                          ]),
                        ),
                      ],
                    ]),
                  ),
                  // Bookmark on photo
                  Positioned(
                    top: 6,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => rsvp.onBookmark(event['id']!, !isBookmarked),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          size: 18,
                          color: isBookmarked ? const Color(0xFFF59E0B) : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Card body
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event['organizer']!,
                      style: GoogleFonts.openSans(fontSize: 11, color: textMuted)),
                  const SizedBox(height: 6),
                  Text(event['title']!,
                      style: GoogleFonts.openSans(
                          fontSize: 15, fontWeight: FontWeight.bold, color: textPrimary)),
                  const SizedBox(height: 6),
                  Text(event['description']!,
                      style: GoogleFonts.openSans(fontSize: 12, color: textMuted, height: 1.5),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 13, color: textMuted),
                      const SizedBox(width: 4),
                      Text(event['date']!,
                          style: GoogleFonts.openSans(fontSize: 11, color: textMuted)),
                      const SizedBox(width: 12),
                      Icon(Icons.location_on_outlined, size: 13, color: textMuted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(event['location']!,
                            style: GoogleFonts.openSans(fontSize: 11, color: textMuted),
                            overflow: TextOverflow.ellipsis),
                      ),
                      Text('$spots spots left',
                          style: GoogleFonts.openSans(
                              fontSize: 11,
                              color: spots < 10 ? Colors.redAccent : AppColors.primary,
                              fontWeight: spots < 10 ? FontWeight.w600 : FontWeight.normal)),
                    ],
                  ),
                  const SizedBox(height: 14),

                      if (session.isOrganizer && isMyEvent)
                    Row(
                      children: [
                        _ActionButton(
                          label: 'Edit',
                          icon: Icons.edit_outlined,
                          color: const Color(0xFF0EA5E9),
                          onTap: () => _showEditDialog(context, event, feedState),
                        ),
                        const SizedBox(width: 8),
                        _ActionButton(
                          label: 'Delete',
                          icon: Icons.delete_outline,
                          color: Colors.redAccent,
                          onTap: () => _confirmDelete(context, event, feedState),
                        ),
                        const SizedBox(width: 8),
                        _ActionButton(
                          label: 'RSVPs',
                          icon: Icons.people_outline,
                          color: const Color(0xFF7C3AED),
                          onTap: () => _showRsvpCount(context, rsvp, feedState),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        if (_formalCategories.contains(event['category']))
                          _RsvpButton(
                            label: status == RsvpStatus.going ? 'Registered ✓' : 'Apply / Register',
                            icon: status == RsvpStatus.going
                                ? Icons.check_circle
                                : Icons.app_registration_outlined,
                            active: status == RsvpStatus.going,
                            activeColor: catColor,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EventDetailScreen(event: event)),
                            ),
                          )
                        else ...[
                          _RsvpButton(
                            label: status == RsvpStatus.going ? 'Going ✓' : 'Going',
                            icon: Icons.check_circle_outline,
                            active: status == RsvpStatus.going,
                            activeColor: AppColors.primary,
                            onTap: () {
                              final newStatus = status == RsvpStatus.going
                                  ? RsvpStatus.none
                                  : RsvpStatus.going;
                              if (newStatus == RsvpStatus.going) {
                                feedState.onSpotChange(event['id']!, -1);
                              }
                              if (status == RsvpStatus.going) {
                                feedState.onSpotChange(event['id']!, 1);
                              }
                              rsvp.onUpdate(event['id']!, newStatus);
                              if (newStatus == RsvpStatus.going) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Row(children: [
                                    const Icon(Icons.check_circle, color: Colors.white, size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text("You're registered for ${event['title']}!",
                                          style: GoogleFonts.openSans(
                                              color: Colors.white, fontSize: 13)),
                                    ),
                                  ]),
                                  backgroundColor: AppColors.primary,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ));
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          _RsvpButton(
                            label: status == RsvpStatus.interested ? 'Interested ✓' : 'Interested',
                            icon: Icons.star_border,
                            active: status == RsvpStatus.interested,
                            activeColor: const Color(0xFFF59E0B),
                            onTap: () {
                              final newStatus = status == RsvpStatus.interested
                                  ? RsvpStatus.none
                                  : RsvpStatus.interested;
                              if (status == RsvpStatus.going) {
                                feedState.onSpotChange(event['id']!, 1);
                              }
                              rsvp.onUpdate(event['id']!, newStatus);
                            },
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Map<String, String> event,
      EventFeedState feedState) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Event',
            style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
        content: Text('Delete "${event['title']}"? This cannot be undone.',
            style: GoogleFonts.openSans()),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.openSans(color: Colors.grey))),
          TextButton(
            onPressed: () {
              feedState.onDelete(event['id']!);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Event deleted', style: GoogleFonts.openSans()),
                backgroundColor: Colors.redAccent,
              ));
            },
            child: Text('Delete', style: GoogleFonts.openSans(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, String> event,
      EventFeedState feedState) {
    final ctrl = TextEditingController(text: event['title']);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Title',
            style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: 'Event title'),
          style: GoogleFonts.openSans(),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.openSans())),
          TextButton(
            onPressed: () {
              if (ctrl.text.trim().isEmpty) return;
              final updated = Map<String, String>.from(event)
                ..['title'] = ctrl.text.trim();
              feedState.onDelete(event['id']!);
              feedState.onAdd(updated);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Event updated', style: GoogleFonts.openSans()),
                backgroundColor: AppColors.primary,
              ));
            },
            child: Text('Save', style: GoogleFonts.openSans(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showRsvpCount(BuildContext context, RsvpState rsvp, EventFeedState feedState) {
    final going = rsvp.all.values.where((s) => s == RsvpStatus.going).length;
    final interested = rsvp.all.values.where((s) => s == RsvpStatus.interested).length;
    final spotsLeft = feedState.spotsFor(event['id']!);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('RSVP Summary',
            style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          _rsvpRow('Going', '$going student${going == 1 ? '' : 's'}',
              Icons.check_circle, AppColors.primary),
          const SizedBox(height: 8),
          _rsvpRow('Interested', '$interested student${interested == 1 ? '' : 's'}',
              Icons.star, const Color(0xFFF59E0B)),
          const SizedBox(height: 8),
          _rsvpRow('Spots remaining', '$spotsLeft',
              Icons.event_seat_outlined, Colors.grey),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close', style: GoogleFonts.openSans())),
        ],
      ),
    );
  }

  Widget _rsvpRow(String label, String value, IconData icon, Color color) =>
      Row(children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text('$label: ', style: GoogleFonts.openSans(fontWeight: FontWeight.w600)),
        Text(value, style: GoogleFonts.openSans()),
      ]);
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton(
      {required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: GoogleFonts.openSans(
                  fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ]),
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

  const _RsvpButton(
      {required this.label,
      required this.icon,
      required this.active,
      required this.activeColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? activeColor : activeColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: active ? activeColor : activeColor.withValues(alpha: 0.3)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 14, color: active ? Colors.white : activeColor),
          const SizedBox(width: 5),
          Text(label,
              style: GoogleFonts.openSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.white : activeColor)),
        ]),
      ),
    );
  }
}
