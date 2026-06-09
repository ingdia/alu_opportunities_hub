import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock chat rooms
  final List<Map<String, dynamic>> _chatRooms = [
    {
      'name': 'ALU Hackathon 2026',
      'lastMessage': 'David: Don\'t forget to bring your laptop!',
      'time': '10:30 AM',
      'unread': 3,
      'avatar': 'AH',
      'tag': 'Hackathon',
      'members': 48,
    },
    {
      'name': 'Entrepreneurship Club',
      'lastMessage': 'Fatima: Shared a file 📎',
      'time': '9:45 AM',
      'unread': 2,
      'avatar': 'EC',
      'tag': 'Club',
      'members': 250,
    },
    {
      'name': 'Campus Leaders',
      'lastMessage': 'Jean: See you there!',
      'time': 'Yesterday',
      'unread': 0,
      'avatar': 'CL',
      'tag': 'Leadership',
      'members': 32,
    },
    {
      'name': 'Travel Buddies',
      'lastMessage': 'Sarah: Any updates?',
      'time': 'Yesterday',
      'unread': 0,
      'avatar': 'TB',
      'tag': 'Community',
      'members': 15,
    },
    {
      'name': 'ALU Debate Society',
      'lastMessage': 'Emmanuel: Great job everyone!',
      'time': '2 days ago',
      'unread': 0,
      'avatar': 'DS',
      'tag': 'Club',
      'members': 124,
    },
    {
      'name': 'Tech & Innovation Hub',
      'lastMessage': 'Aline: New workshop this Friday!',
      'time': '2 days ago',
      'unread': 1,
      'avatar': 'TI',
      'tag': 'Tech',
      'members': 210,
    },
  ];

  List<Map<String, dynamic>> get _filteredChats {
    if (_searchQuery.isEmpty) return _chatRooms;
    return _chatRooms
        .where((chat) => chat['name']
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Chats',
          style: GoogleFonts.openSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF16A34A)),
            tooltip: 'New Chat',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('New chat coming soon')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: GoogleFonts.openSans(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search chats...',
                hintStyle:
                GoogleFonts.openSans(color: Colors.grey, fontSize: 14),
                prefixIcon:
                const Icon(Icons.search, color: Colors.grey, size: 20),
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Chat list
          Expanded(
            child: _filteredChats.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off,
                      size: 60, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(
                    'No chats found.',
                    style: GoogleFonts.openSans(
                        fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
                : ListView.separated(
              itemCount: _filteredChats.length,
              separatorBuilder: (_, __) => const Divider(
                  height: 1, indent: 72, color: Color(0xFFE2E8F0)),
              itemBuilder: (context, index) {
                final chat = _filteredChats[index];
                return _ChatTile(
                  chat: chat,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          communityName: chat['name'],
                          eventTag: chat['tag'],
                        ),
                      ),
                    );
                  },
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
  final VoidCallback onTap;

  const _ChatTile({required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasUnread = chat['unread'] > 0;

    return ListTile(
      onTap: onTap,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: const Color(0xFF16A34A),
        child: Text(
          chat['avatar'],
          style: GoogleFonts.openSans(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              chat['name'],
              style: GoogleFonts.openSans(
                fontSize: 15,
                fontWeight:
                hasUnread ? FontWeight.bold : FontWeight.normal,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            chat['time'],
            style: GoogleFonts.openSans(
              fontSize: 11,
              color: hasUnread
                  ? const Color(0xFF16A34A)
                  : Colors.grey,
            ),
          ),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              chat['lastMessage'],
              style: GoogleFonts.openSans(
                fontSize: 13,
                color: hasUnread ? Colors.black54 : Colors.grey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (hasUnread)
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFF16A34A),
                shape: BoxShape.circle,
              ),
              child: Text(
                chat['unread'].toString(),
                style: GoogleFonts.openSans(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}