import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/state/user_session.dart';

const _tagColors = {
  'Hackathon': Color(0xFF7C3AED),
  'Club': Color(0xFF0EA5E9),
  'Leadership': Color(0xFF16A34A),
  'Community': Color(0xFFF59E0B),
  'Tech': Color(0xFFEC4899),
};

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _chatRooms = [
    {
      'name': 'ALU Hackathon 2026',
      'lastMessage': 'Kwame: This is going to be epic! 💪',
      'time': '10:30 AM',
      'unread': 3,
      'avatar': 'AH',
      'tag': 'Hackathon',
      'members': 48,
      'online': 12,
      'managed': true,
    },
    {
      'name': 'Entrepreneurship Club',
      'lastMessage': 'Fatima: Shared a file 📎',
      'time': '9:45 AM',
      'unread': 2,
      'avatar': 'EC',
      'tag': 'Club',
      'members': 250,
      'online': 34,
      'managed': false,
    },
    {
      'name': 'Campus Leaders',
      'lastMessage': 'Jean: See you at the workshop! 🎯',
      'time': 'Yesterday',
      'unread': 0,
      'avatar': 'CL',
      'tag': 'Leadership',
      'members': 32,
      'online': 5,
      'managed': true,
    },
    {
      'name': 'Travel Buddies',
      'lastMessage': 'Kwame: I\'ll check with Student Affairs 👍',
      'time': 'Yesterday',
      'unread': 0,
      'avatar': 'TB',
      'tag': 'Community',
      'members': 15,
      'online': 3,
      'managed': false,
    },
    {
      'name': 'ALU Debate Society',
      'lastMessage': 'Emmanuel: Can\'t wait for the next motion! 💪',
      'time': '2 days ago',
      'unread': 0,
      'avatar': 'DS',
      'tag': 'Club',
      'members': 124,
      'online': 8,
      'managed': false,
    },
    {
      'name': 'Tech & Innovation Hub',
      'lastMessage': 'Aline: New workshop this Friday!',
      'time': '2 days ago',
      'unread': 1,
      'avatar': 'TI',
      'tag': 'Tech',
      'members': 210,
      'online': 22,
      'managed': true,
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_searchQuery.isEmpty) return _chatRooms;
    return _chatRooms
        .where((c) => c['name']
            .toString()
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCreateCommunity(BuildContext context) {
    final nameCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create Community',
                style: GoogleFonts.openSans(
                    fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Community name...',
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
                  if (nameCtrl.text.trim().isEmpty) return;
                  setState(() {
                    _chatRooms.insert(0, {
                      'name': nameCtrl.text.trim(),
                      'lastMessage': 'Community created',
                      'time': 'Now',
                      'unread': 0,
                      'avatar': nameCtrl.text.trim().substring(0, 2).toUpperCase(),
                      'tag': 'Community',
                      'members': 1,
                      'online': 1,
                      'managed': true,
                    });
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Community "${nameCtrl.text.trim()}" created!',
                        style: GoogleFonts.openSans()),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                  ));
                },
                child: Text('Create',
                    style: GoogleFonts.openSans(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final cardColor = isDark ? AppColors.darkCard : Colors.white;
    final session = UserSession.of(context);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 1,
        title: Text('Community Chats',
            style: GoogleFonts.openSans(
                fontSize: 20, fontWeight: FontWeight.bold, color: textPrimary)),
        actions: [
          if (session.isOrganizer)
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
              tooltip: 'Create Community',
              onPressed: () => _showCreateCommunity(context),
            )
          else
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.primary),
              tooltip: 'Search',
              onPressed: () {},
            ),
        ],
      ),
      body: Column(
        children: [
          // Role banner
          Container(
            color: cardColor,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              children: [
                if (session.isOrganizer)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.admin_panel_settings_outlined,
                            size: 14, color: Color(0xFF7C3AED)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Organizer mode — pin messages, send announcements & manage communities.',
                            style: GoogleFonts.openSans(
                                fontSize: 11, color: const Color(0xFF7C3AED)),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                // Search bar
                TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: GoogleFonts.openSans(fontSize: 14, color: textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search communities...',
                    hintStyle: GoogleFonts.openSans(color: textMuted, fontSize: 13),
                    prefixIcon: Icon(Icons.search, color: textMuted, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: textMuted, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDark ? AppColors.darkBackground : const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none),
                  ),
                ),
              ],
            ),
          ),

          // Chat list
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 60,
                            color: textMuted.withValues(alpha: 0.4)),
                        const SizedBox(height: 12),
                        Text('No communities found',
                            style: GoogleFonts.openSans(
                                fontSize: 15, color: textMuted)),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => Divider(
                        height: 1,
                        indent: 76,
                        color: isDark
                            ? AppColors.darkBorder
                            : const Color(0xFFE2E8F0)),
                    itemBuilder: (context, index) {
                      final chat = _filtered[index];
                      return _ChatTile(
                        chat: chat,
                        isOrganizer: session.isOrganizer,
                        isDark: isDark,
                        textPrimary: textPrimary,
                        textMuted: textMuted,
                        cardColor: cardColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              communityName: chat['name'],
                              eventTag: chat['tag'],
                              members: chat['members'],
                              online: chat['online'],
                              isManaged: chat['managed'] == true && session.isOrganizer,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  final Map<String, dynamic> chat;
  final bool isOrganizer, isDark;
  final Color textPrimary, textMuted, cardColor;
  final VoidCallback onTap;

  const _ChatTile({
    required this.chat,
    required this.isOrganizer,
    required this.isDark,
    required this.textPrimary,
    required this.textMuted,
    required this.cardColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasUnread = (chat['unread'] as int) > 0;
    final tagColor = _tagColors[chat['tag']] ?? AppColors.primary;
    final isManaged = chat['managed'] == true && isOrganizer;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: tagColor.withValues(alpha: 0.15),
            child: Text(chat['avatar'],
                style: GoogleFonts.openSans(
                    fontSize: 13,
                    color: tagColor,
                    fontWeight: FontWeight.bold)),
          ),
          // Online dot
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: cardColor, width: 2),
              ),
            ),
          ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(chat['name'],
                style: GoogleFonts.openSans(
                    fontSize: 14,
                    fontWeight: hasUnread ? FontWeight.bold : FontWeight.w500,
                    color: textPrimary),
                overflow: TextOverflow.ellipsis),
          ),
          if (isManaged)
            Container(
              margin: const EdgeInsets.only(left: 6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Admin',
                  style: GoogleFonts.openSans(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF7C3AED))),
            ),
          const SizedBox(width: 6),
          Text(chat['time'],
              style: GoogleFonts.openSans(
                  fontSize: 11,
                  color: hasUnread ? AppColors.primary : textMuted)),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(chat['lastMessage'],
                style: GoogleFonts.openSans(
                    fontSize: 12,
                    color: hasUnread ? textPrimary : textMuted),
                overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 8),
          Text('${chat['online']} online',
              style: GoogleFonts.openSans(fontSize: 10, color: Colors.green)),
          if (hasUnread) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  color: AppColors.primary, shape: BoxShape.circle),
              child: Text(chat['unread'].toString(),
                  style: GoogleFonts.openSans(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
    );
  }
}
