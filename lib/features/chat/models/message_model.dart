class Message {
  final String id;
  final String senderName;
  final String senderAvatar; // initials e.g "CA" for Chima Agu
  final String text;
  final DateTime timestamp;
  final bool isMe;
  final bool isAnnouncement; // true if sent by organizer as announcement

  Message({
    required this.id,
    required this.senderName,
    required this.senderAvatar,
    required this.text,
    required this.timestamp,
    required this.isMe,
    this.isAnnouncement = false,
  });
}