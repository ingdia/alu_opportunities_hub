import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'rsvp_state.dart';

class PersistenceService {
  static const _rsvpPrefix = 'rsvp_';
  static const _bookmarkPrefix = 'bookmark_';
  static const _eventsKey = 'posted_events';

  // ── Events ────────────────────────────────────────────
  static Future<List<Map<String, String>>> loadPostedEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_eventsKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => Map<String, String>.from(e as Map)).toList();
  }

  static Future<void> savePostedEvents(
      List<Map<String, String>> events) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_eventsKey, jsonEncode(events));
  }

  // ── RSVPs ──────────────────────────────────────────────
  static Future<Map<String, RsvpStatus>> loadRsvps() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(_rsvpPrefix));
    final map = <String, RsvpStatus>{};
    for (final key in keys) {
      final val = prefs.getString(key);
      final eventId = key.substring(_rsvpPrefix.length);
      if (val == 'going') map[eventId] = RsvpStatus.going;
      if (val == 'interested') map[eventId] = RsvpStatus.interested;
    }
    return map;
  }

  static Future<void> saveRsvp(String eventId, RsvpStatus status) async {
    final prefs = await SharedPreferences.getInstance();
    if (status == RsvpStatus.none) {
      await prefs.remove('$_rsvpPrefix$eventId');
    } else {
      await prefs.setString(
          '$_rsvpPrefix$eventId', status == RsvpStatus.going ? 'going' : 'interested');
    }
  }

  // ── Bookmarks ──────────────────────────────────────────
  static Future<Set<String>> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getKeys().where((k) => k.startsWith(_bookmarkPrefix)).map((k) => k.substring(_bookmarkPrefix.length)).toSet();
  }

  static Future<void> saveBookmark(String eventId, bool saved) async {
    final prefs = await SharedPreferences.getInstance();
    if (saved) {
      await prefs.setBool('$_bookmarkPrefix$eventId', true);
    } else {
      await prefs.remove('$_bookmarkPrefix$eventId');
    }
  }
}
