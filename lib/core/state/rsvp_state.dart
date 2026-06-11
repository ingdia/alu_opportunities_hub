import 'package:flutter/material.dart';

enum RsvpStatus { none, going, interested }

class RsvpState extends InheritedWidget {
  final Map<String, RsvpStatus> _rsvps;
  final Set<String> _bookmarks;
  final void Function(String eventId, RsvpStatus status) onUpdate;
  final void Function(String eventId, bool saved) onBookmark;

  const RsvpState({
    super.key,
    required Map<String, RsvpStatus> rsvps,
    required Set<String> bookmarks,
    required this.onUpdate,
    required this.onBookmark,
    required super.child,
  })  : _rsvps = rsvps,
        _bookmarks = bookmarks;

  static RsvpState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RsvpState>()!;
  }

  RsvpStatus statusOf(String eventId) => _rsvps[eventId] ?? RsvpStatus.none;
  bool isBookmarked(String eventId) => _bookmarks.contains(eventId);

  Map<String, RsvpStatus> get all => Map.unmodifiable(_rsvps);
  Set<String> get allBookmarks => Set.unmodifiable(_bookmarks);

  @override
  bool updateShouldNotify(RsvpState oldWidget) =>
      oldWidget._rsvps != _rsvps || oldWidget._bookmarks != _bookmarks;
}
