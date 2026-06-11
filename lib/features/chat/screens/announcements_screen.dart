import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/state/user_session.dart';

class _Announcement {
  final String id;
  final String community;
  final String author;
  final String text;
  final DateTime time;
  final bool isPinned;

  _Announcement({
    required this.id,
    required this.community,
    required this.author,
    required this.text,
    required this.time,
    this.isPinned = false,
  });
}

final _mockAnnouncements = [
  _Announcement(
    id: 'a1',
    community: 'ALU Hackathon 2026',
    author: 'Tech & Innovation Hub',
    text: '📢 Welcome to ALU Hackathon 2026! Check in at the registration desk by 8:45am. Teams must submit project ideas by 11am.',
    time: DateTime.now().subtract(const Duration(hours: 2)),
    isPinned: true,
  ),
  _Announcement(
    id: 'a2',
    community: 'Entrepreneurship Club',
    author: 'Entrepreneurship Club',
    text: '🏆 Pitch Night registration closes tonight at midnight. Only 5 spots left — register now on the Feed!',
    time: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  _Announcement(
    id: 'a3',
    community: 'Campus Leaders',
    author: 'Student Affairs',
    text: '📅 Leadership Workshop rescheduled to June 22. Same venue, same time. Apologies for the short notice.',
    time: DateTime.now().subtract(const Duration(days: 1)),
  ),
  _Announcement(
    id: 'a4',
    community: 'ALU Hackathon 2026',
    author: 'Tech & Innovation Hub',
    text: '⚠️ Reminder: All teams must have a minimum of 2 members. Solo participants must join a team by 10am tomorrow.',
    time: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
  ),
  _Announcement(
    id: 'a5',
    community: 'Campus Leaders',
    author: 'Student Affairs',
    text: '🎉 Congratulations to all participants of the May Leadership Bootcamp. Certificates will be emailed within 3 business days.',
    time: DateTime.now().subtract(const Duration(days: 3)),
  ),
];

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  late List<_Announcement> _announcements;
  String _selectedCommunity = 'All';

  final _communities = ['All', 'ALU Hackathon 2026', 'Entrepreneurship Club', 'Campus Leaders'];

  @override
  void initState() {
    super.initState();
    _announcements = List.from(_mockAnnouncements);
  }

  List<_Announcement> get _filtered {
    if (_selectedCommunity == 'All') return _announcements;
    return _announcements
        .where((a) => a.community == _selectedCommunity)
        .toList();
  }

  void _postAnnouncement(String text, String community) {
    final session = UserSession.of(context);
    setState(() {
      _announcements.insert(
        0,
        _Announcement(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          community: community,
          author: session.name,
          text: text,
          time: DateTime.now(),
        ),
      );
    });
  }

  void _showPostDialog() {
    final textCtrl = TextEditingController();
    String selectedCommunity = _communities[1];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setModal) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 24, right: 24, top: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Post Announcement',
                    style: GoogleFonts.openSans(
                        fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCommunity,
                  decoration: InputDecoration(
                    labelText: 'Community',
                    labelStyle: GoogleFonts.openSans(),
                    border: const OutlineInputBorder(),
                  ),
                  items: _communities
                      .where((c) => c != 'All')
                      .map((c) => DropdownMenuItem(value: c, child: Text(c, style: GoogleFonts.openSans())))
                      .toList(),
                  onChanged: (v) => setModal(() => selectedCommunity = v!),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: textCtrl,
                  maxLines: 4,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Write your announcement...',
                    hintStyle: GoogleFonts.openSans(color: Colors.grey),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary, width: 2)),
                  ),
                  style: GoogleFonts.openSans(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (textCtrl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Announcement cannot be empty',
                              style: GoogleFonts.openSans()),
                          backgroundColor: Colors.redAccent,
                        ));
                        return;
                      }
                      _postAnnouncement(textCtrl.text.trim(), selectedCommunity);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Announcement posted!',
                            style: GoogleFonts.openSans()),
                        backgroundColor: AppColors.primary,
                      ));
                    },
                    child: Text('Post',
                        style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        });
      },
    );
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
    final bgColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final session = UserSession.of(context);
    final list = _filtered;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Announcements',
                          style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textPrimary)),
                      Text('Community updates',
                          style: GoogleFonts.openSans(
                              fontSize: 11, color: textMuted)),
                    ],
                  ),
                  const Spacer(),
                  if (session.isOrganizer)
                    IconButton(
                      onPressed: _showPostDialog,
                      icon: const Icon(Icons.add_circle_outline,
                          color: AppColors.primary, size: 26),
                      tooltip: 'Post Announcement',
                    ),
                ],
              ),
            ),

            // Community filter chips
            SizedBox(
              height: 36,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: _communities.map((c) {
                  final isSelected = _selectedCommunity == c;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCommunity = c),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Text(c,
                          style: GoogleFonts.openSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.primary)),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // List
            Expanded(
              child: list.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.campaign_outlined,
                              size: 60,
                              color: textMuted.withValues(alpha: 0.4)),
                          const SizedBox(height: 12),
                          Text('No announcements yet',
                              style: GoogleFonts.openSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: textMuted)),
                          const SizedBox(height: 6),
                          Text('Check back later for updates',
                              style: GoogleFonts.openSans(
                                  fontSize: 13, color: textMuted)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final a = list[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: a.isPinned
                                  ? AppColors.primary.withValues(alpha: 0.4)
                                  : borderColor,
                              width: a.isPinned ? 1.5 : 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: Icon(Icons.campaign,
                                            size: 18,
                                            color: AppColors.primary),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(a.author,
                                              style: GoogleFonts.openSans(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: textPrimary)),
                                          Text(a.community,
                                              style: GoogleFonts.openSans(
                                                  fontSize: 11,
                                                  color: AppColors.primary)),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(_timeAgo(a.time),
                                            style: GoogleFonts.openSans(
                                                fontSize: 10, color: textMuted)),
                                        if (a.isPinned)
                                          const Icon(Icons.push_pin,
                                              size: 13,
                                              color: AppColors.primary),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(a.text,
                                    style: GoogleFonts.openSans(
                                        fontSize: 13,
                                        color: textPrimary,
                                        height: 1.5)),
                              ],
                            ),
                          ),
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
