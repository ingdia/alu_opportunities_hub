import '../models/message_model.dart';

// Mock community chat messages for "ALU Hackathon 2026" event
final List<Message> mockCommunityMessages = [
  Message(
    id: '1',
    senderName: 'Amara Diallo',
    senderAvatar: 'AD',
    text: 'Hey everyone! Is the hackathon still on for Saturday?',
    timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    isMe: false,
  ),
  Message(
    id: '2',
    senderName: 'You',
    senderAvatar: 'CA',
    text: 'Yes! Confirmed. Room 3B at 9am.',
    timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
    isMe: true,
  ),
  Message(
    id: '3',
    senderName: 'Kwame Asante',
    senderAvatar: 'KA',
    text: 'Do we need to bring laptops?',
    timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
    isMe: false,
  ),
  Message(
    id: '4',
    senderName: 'Fatima Nour',
    senderAvatar: 'FN',
    text: 'Yes laptops are required. Also bring your student ID.',
    timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
    isMe: false,
  ),
  Message(
    id: '5',
    senderName: 'You',
    senderAvatar: 'CA',
    text: 'Thanks Fatima! See everyone there 🔥',
    timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    isMe: true,
  ),
];

// Mock announcements from organizer
final List<Message> mockAnnouncements = [
  Message(
    id: 'a1',
    senderName: 'ALU Events Team',
    senderAvatar: 'AE',
    text: '📢 Welcome to ALU Hackathon 2026! Please check in at the registration desk by 8:45am.',
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    isMe: false,
    isAnnouncement: true,
  ),
  Message(
    id: 'a2',
    senderName: 'ALU Events Team',
    senderAvatar: 'AE',
    text: '⚠️ Reminder: Teams must submit their project ideas by 11am. Late submissions will not be accepted.',
    timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    isMe: false,
    isAnnouncement: true,
  ),
  Message(
    id: 'a3',
    senderName: 'ALU Events Team',
    senderAvatar: 'AE',
    text: '🏆 Prizes: 1st place wins \$500 + internship opportunity. Good luck to all teams!',
    timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
    isMe: false,
    isAnnouncement: true,
  ),
];