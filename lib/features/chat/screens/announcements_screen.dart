import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../data/mock_messages.dart';
import '../widgets/message_bubble.dart';
import '../../../core/theme/app_colors.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  late List<Message> _announcements;

  @override
  void initState() {
    super.initState();
    _announcements = List.from(mockAnnouncements);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const BackButton(color: Colors.black87),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Announcements',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              'From organizers',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      body: _announcements.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.campaign_outlined,
                size: 60, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'No announcements yet.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              'Check back later for updates.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _announcements.length,
        itemBuilder: (context, index) =>
            MessageBubble(message: _announcements[index]),
      ),
    );
  }
}