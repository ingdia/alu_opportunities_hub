import 'package:flutter/material.dart';
import '../../features/feed/data/mock_events.dart';

class EventFeedState extends InheritedWidget {
  final List<Map<String, String>> events;
  final Map<String, int> spotCounts;
  final void Function(Map<String, String> event) onAdd;
  final void Function(String eventId) onDelete;
  final void Function(String eventId, int delta) onSpotChange;

  const EventFeedState({
    super.key,
    required this.events,
    required this.spotCounts,
    required this.onAdd,
    required this.onDelete,
    required this.onSpotChange,
    required super.child,
  });

  static EventFeedState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EventFeedState>()!;
  }

  int spotsFor(String eventId) {
    if (spotCounts.containsKey(eventId)) return spotCounts[eventId]!;
    final event = events.firstWhere((e) => e['id'] == eventId,
        orElse: () => {});
    return int.tryParse(event['spots'] ?? '0') ?? 0;
  }

  @override
  bool updateShouldNotify(EventFeedState oldWidget) =>
      oldWidget.events != events || oldWidget.spotCounts != spotCounts;
}

List<Map<String, String>> buildInitialEvents() =>
    List<Map<String, String>>.from(mockEvents);

Map<String, int> buildInitialSpots() => {
      for (final e in mockEvents)
        e['id']!: int.tryParse(e['spots'] ?? '0') ?? 0
    };
