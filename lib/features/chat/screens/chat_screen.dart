import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/message_model.dart';
import '../data/mock_messages.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input_bar.dart';
import '../../../core/state/user_session.dart';
import '../../../core/theme/app_colors.dart';

class ChatScreen extends StatefulWidget {
  final String communityName;
  final String eventTag;
  final int members;
  final int online;
  final bool isManaged;

  const ChatScreen({
    super.key,
    required this.communityName,
    required this.eventTag,
    this.members = 0,
    this.online = 0,
    this.isManaged = false,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<Message> _messages;
  String? _pinnedMessageId;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messages = List.from(getMessagesForRoom(widget.communityName));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _myName(BuildContext context) {
    try {
      final s = UserSession.of(context);
      return s.name.isEmpty ? 'You' : s.name;
    } catch (_) {
      return 'You';
    }
  }

  String _myInitials(BuildContext context) {
    try {
      final s = UserSession.of(context);
      if (s.name.isEmpty) return 'ME';
      return s.name
          .split(' ')
          .map((e) => e.isNotEmpty ? e[0] : '')
          .take(2)
          .join()
          .toUpperCase();
    } catch (_) {
      return 'ME';
    }
  }

  void _sendMessage(String text) {
    setState(() {
      _messages.add(Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderName: _myName(context),
        senderAvatar: _myInitials(context),
        text: text,
        timestamp: DateTime.now(),
        isMe: true,
      ));
    });
    _scrollToBottom();
  }

  void _sendAnnouncement(String text) {
    setState(() {
      _messages.add(Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderName: _myName(context),
        senderAvatar: 'AN',
        text: text,
        timestamp: DateTime.now(),
        isMe: false,
        isAnnouncement: true,
      ));
    });
    _scrollToBottom();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Announcement sent to all members', style: GoogleFonts.openSans()),
      backgroundColor: AppColors.primary,
      behavior: SnackBarBehavior.floating,
    ));
  }

  void _deleteMessage(String id) {
    setState(() => _messages.removeWhere((m) => m.id == id));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Message deleted', style: GoogleFonts.openSans()),
      behavior: SnackBarBehavior.floating,
    ));
  }

  void _pinMessage(String id) {
    setState(() => _pinnedMessageId = _pinnedMessageId == id ? null : id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          _pinnedMessageId == id ? 'Message pinned' : 'Message unpinned',
          style: GoogleFonts.openSans()),
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.primary,
    ));
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showAnnouncementDialog() {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.campaign, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('Send Announcement',
                  style: GoogleFonts.openSans(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 4),
            Text('Sent to all ${widget.members} members',
                style: GoogleFonts.openSans(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              maxLines: 3,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Type your announcement...',
                hintStyle: GoogleFonts.openSans(color: Colors.grey),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary, width: 2)),
              ),
              style: GoogleFonts.openSans(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.send, size: 16, color: Colors.white),
                label: Text('Send Announcement',
                    style: GoogleFonts.openSans(
                        color: Colors.white, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (ctrl.text.trim().isEmpty) return;
                  Navigator.pop(ctx);
                  _sendAnnouncement(ctrl.text.trim());
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showMembersPanel() {
    final mockMembers = [
      {'name': 'Amara Diallo', 'initials': 'AD', 'online': true},
      {'name': 'Kwame Asante', 'initials': 'KA', 'online': true},
      {'name': 'Fatima Nour', 'initials': 'FN', 'online': false},
      {'name': 'Jean-Pierre M.', 'initials': 'JP', 'online': true},
      {'name': 'Aisha Kamara', 'initials': 'AK', 'online': true},
      {'name': 'Blessing Eze', 'initials': 'BE', 'online': false},
      {'name': 'Samuel Osei', 'initials': 'SO', 'online': true},
      {'name': 'Diane Uwase', 'initials': 'DU', 'online': false},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(
        children: [
          const SizedBox(height: 12),
          Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Text('Members',
                  style: GoogleFonts.openSans(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${widget.online} online',
                    style: GoogleFonts.openSans(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: mockMembers.length,
              itemBuilder: (_, i) {
                final m = mockMembers[i];
                final isOnline = m['online'] as bool;
                return ListTile(
                  leading: Stack(children: [
                    CircleAvatar(
                      backgroundColor:
                          AppColors.primary.withValues(alpha: 0.15),
                      child: Text(m['initials']! as String,
                          style: GoogleFonts.openSans(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary)),
                    ),
                    if (isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                      ),
                  ]),
                  title: Text(m['name']! as String,
                      style: GoogleFonts.openSans(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                  subtitle: Text(isOnline ? 'Online' : 'Offline',
                      style: GoogleFonts.openSans(
                          fontSize: 11,
                          color: isOnline ? Colors.green : Colors.grey)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC);
    final appBarColor = isDark ? AppColors.darkCard : Colors.white;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : Colors.black87;

    final pinnedMessage = _pinnedMessageId != null
        ? _messages.where((m) => m.id == _pinnedMessageId).firstOrNull
        : null;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: isDark ? AppColors.darkTextPrimary : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: GestureDetector(
          onTap: _showMembersPanel,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.communityName,
                  style: GoogleFonts.openSans(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textPrimary)),
              Row(children: [
                Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                        color: Colors.green, shape: BoxShape.circle)),
                const SizedBox(width: 4),
                Text('${widget.online} online · ${widget.members} members',
                    style:
                        GoogleFonts.openSans(fontSize: 10, color: Colors.green)),
              ]),
            ],
          ),
        ),
        actions: [
          if (widget.isManaged)
            IconButton(
              icon: const Icon(Icons.campaign_outlined,
                  color: AppColors.primary),
              tooltip: 'Send Announcement',
              onPressed: _showAnnouncementDialog,
            ),
          IconButton(
            icon: Icon(Icons.people_outline,
                color: isDark ? AppColors.darkTextMuted : Colors.black54),
            tooltip: 'Members',
            onPressed: _showMembersPanel,
          ),
        ],
      ),
      body: Column(
        children: [
          // Community info banner
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.primary.withValues(alpha: 0.08),
            child: Row(children: [
              const Icon(Icons.chat_bubble_outline,
                  size: 13, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                    '${widget.communityName} · ${widget.eventTag}',
                    style: GoogleFonts.openSans(
                        fontSize: 11, color: AppColors.primary)),
              ),
              if (widget.isManaged)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('Admin',
                      style: GoogleFonts.openSans(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark)),
                ),
            ]),
          ),

          // Pinned message
          if (pinnedMessage != null)
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFF59E0B).withValues(alpha: 0.08),
              child: Row(children: [
                const Icon(Icons.push_pin,
                    size: 13, color: Color(0xFFF59E0B)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(pinnedMessage.text,
                      style: GoogleFonts.openSans(
                          fontSize: 11, color: const Color(0xFFF59E0B)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                if (widget.isManaged)
                  GestureDetector(
                    onTap: () =>
                        setState(() => _pinnedMessageId = null),
                    child: const Icon(Icons.close,
                        size: 14, color: Color(0xFFF59E0B)),
                  ),
              ]),
            ),

          // Messages list
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline,
                            size: 60,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : Colors.grey),
                        const SizedBox(height: 12),
                        Text('No messages yet.',
                            style: GoogleFonts.openSans(
                                fontSize: 16, color: Colors.grey)),
                        Text('Be the first to start the conversation!',
                            style: GoogleFonts.openSans(
                                fontSize: 13, color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return MessageBubble(
                        message: msg,
                        isPinned: msg.id == _pinnedMessageId,
                        canManage: widget.isManaged,
                        onPin: () => _pinMessage(msg.id),
                        onDelete: () => _deleteMessage(msg.id),
                      );
                    },
                  ),
          ),

          ChatInputBar(onSend: _sendMessage),
        ],
      ),
    );
  }
}
