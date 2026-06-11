import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isPinned;
  final bool canManage;
  final VoidCallback? onPin;
  final VoidCallback? onDelete;

  const MessageBubble({
    super.key,
    required this.message,
    this.isPinned = false,
    this.canManage = false,
    this.onPin,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (message.isAnnouncement) {
      return _AnnouncementBubble(
        message: message,
        isPinned: isPinned,
        canManage: canManage,
        onPin: onPin,
        onDelete: onDelete,
        isDark: isDark,
      );
    }

    return _ChatBubble(
      message: message,
      isPinned: isPinned,
      canManage: canManage,
      onPin: onPin,
      onDelete: onDelete,
      isDark: isDark,
    );
  }
}

// ── Announcement Bubble ─────────────────────────────────────────
class _AnnouncementBubble extends StatelessWidget {
  final Message message;
  final bool isPinned, canManage, isDark;
  final VoidCallback? onPin, onDelete;

  const _AnnouncementBubble({
    required this.message,
    required this.isPinned,
    required this.canManage,
    required this.isDark,
    this.onPin,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: canManage ? () => _showMenu(context) : null,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isPinned
              ? const Color(0xFFF59E0B).withValues(alpha: 0.12)
              : AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08),
          border: Border.all(
            color: isPinned ? const Color(0xFFF59E0B) : AppColors.primary,
            width: isPinned ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isPinned ? Icons.push_pin : Icons.campaign,
                  color: isPinned ? const Color(0xFFF59E0B) : AppColors.primary,
                  size: 15,
                ),
                const SizedBox(width: 6),
                Text(message.senderName,
                    style: GoogleFonts.openSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isPinned
                            ? const Color(0xFFF59E0B)
                            : AppColors.primary)),
                if (isPinned) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Pinned',
                        style: GoogleFonts.openSans(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFF59E0B))),
                  ),
                ],
                const Spacer(),
                if (canManage)
                  GestureDetector(
                    onTap: () => _showMenu(context),
                    child: Icon(Icons.more_horiz,
                        size: 16,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : Colors.black38),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(message.text,
                style: GoogleFonts.openSans(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextPrimary : Colors.black87,
                    height: 1.4)),
            const SizedBox(height: 4),
            Text(_formatTime(message.timestamp),
                style: GoogleFonts.openSans(
                    fontSize: 10,
                    color: isDark ? AppColors.darkTextMuted : Colors.black38)),
          ],
        ),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _MessageMenu(
          isPinned: isPinned, onPin: onPin, onDelete: onDelete),
    );
  }

  String _formatTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

// ── Regular Chat Bubble ──────────────────────────────────────────
class _ChatBubble extends StatelessWidget {
  final Message message;
  final bool isPinned, canManage, isDark;
  final VoidCallback? onPin, onDelete;

  const _ChatBubble({
    required this.message,
    required this.isPinned,
    required this.canManage,
    required this.isDark,
    this.onPin,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final bubbleColor = isMe
        ? AppColors.primary
        : isDark
            ? AppColors.darkCard
            : const Color(0xFFF1F5F9);
    final textColor = isMe
        ? Colors.white
        : isDark
            ? AppColors.darkTextPrimary
            : Colors.black87;

    return GestureDetector(
      onLongPress: canManage ? () => _showMenu(context) : null,
      child: Container(
        margin: isPinned
            ? const EdgeInsets.symmetric(vertical: 4)
            : EdgeInsets.zero,
        decoration: isPinned
            ? BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
              )
            : null,
        padding: isPinned ? const EdgeInsets.all(4) : EdgeInsets.zero,
        child: Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) _avatar(),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (!isMe)
                        Text(message.senderName,
                            style: GoogleFonts.openSans(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary)),
                      if (isPinned)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.push_pin,
                                size: 10, color: Color(0xFFF59E0B)),
                            const SizedBox(width: 3),
                            Text('Pinned',
                                style: GoogleFonts.openSans(
                                    fontSize: 9,
                                    color: const Color(0xFFF59E0B),
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      Text(message.text,
                          style:
                              GoogleFonts.openSans(fontSize: 14, color: textColor)),
                      const SizedBox(height: 3),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_formatTime(message.timestamp),
                              style: GoogleFonts.openSans(
                                  fontSize: 10,
                                  color: isMe
                                      ? Colors.white60
                                      : isDark
                                          ? AppColors.darkTextMuted
                                          : Colors.black38)),
                          if (isMe) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.done_all,
                                size: 12, color: Colors.white60),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (isMe) const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _MessageMenu(
          isPinned: isPinned, onPin: onPin, onDelete: onDelete),
    );
  }

  Widget _avatar() {
    return CircleAvatar(
      radius: 16,
      backgroundColor: AppColors.primary.withValues(alpha: 0.15),
      child: Text(message.senderAvatar,
          style: GoogleFonts.openSans(
              fontSize: 10,
              color: AppColors.primary,
              fontWeight: FontWeight.bold)),
    );
  }

  String _formatTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

// ── Organizer Message Menu ───────────────────────────────────────
class _MessageMenu extends StatelessWidget {
  final bool isPinned;
  final VoidCallback? onPin, onDelete;

  const _MessageMenu({required this.isPinned, this.onPin, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(
              isPinned ? Icons.push_pin_outlined : Icons.push_pin,
              color: const Color(0xFFF59E0B),
            ),
            title: Text(isPinned ? 'Unpin Message' : 'Pin Message',
                style: GoogleFonts.openSans(fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.pop(context);
              onPin?.call();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
            title: Text('Delete Message',
                style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w500, color: Colors.redAccent)),
            onTap: () {
              Navigator.pop(context);
              onDelete?.call();
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
