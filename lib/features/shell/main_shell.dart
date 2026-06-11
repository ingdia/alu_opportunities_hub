import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/state/rsvp_state.dart';
import '../../core/state/event_feed_state.dart';
import '../../core/state/persistence_service.dart';
import '../../core/state/user_session.dart';
import '../../core/theme/app_colors.dart';
import '../home/screens/home_screen.dart';
import '../feed/screens/event_feed_screen.dart';
import '../feed/screens/post_event_screen.dart';
import '../chat/screens/chat_list_screen.dart';
import '../profile/screens/profile_screen.dart';
import '../notifications/notifications_screen.dart';

class MainShell extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final String userName;
  final String userEmail;
  final UserRole userRole;

  const MainShell({
    super.key,
    required this.onToggleTheme,
    required this.userName,
    required this.userEmail,
    required this.userRole,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  int _unreadNotifications = 6;
  Map<String, RsvpStatus> _rsvps = {};
  Set<String> _bookmarks = {};
  late List<Map<String, String>> _events;
  late Map<String, int> _spotCounts;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _events = buildInitialEvents();
    _spotCounts = buildInitialSpots();
    _loadPersistedData();
  }

  Future<void> _loadPersistedData() async {
    final rsvps = await PersistenceService.loadRsvps();
    final bookmarks = await PersistenceService.loadBookmarks();
    final savedEvents = await PersistenceService.loadPostedEvents();
    setState(() {
      _rsvps = rsvps;
      _bookmarks = bookmarks;
      if (savedEvents.isNotEmpty) {
        // Merge saved events at front, avoiding duplicates by id
        final existingIds = _events.map((e) => e['id']).toSet();
        final newOnes = savedEvents.where((e) => !existingIds.contains(e['id'])).toList();
        _events = [...newOnes, ..._events];
        for (final e in newOnes) {
          _spotCounts[e['id']!] = int.tryParse(e['spots'] ?? '0') ?? 0;
        }
      }
      _loaded = true;
    });
  }

  void _updateRsvp(String eventId, RsvpStatus status) {
    setState(() => _rsvps = {..._rsvps, eventId: status});
    PersistenceService.saveRsvp(eventId, status);
  }

  void _updateBookmark(String eventId, bool saved) {
    setState(() {
      _bookmarks = Set.from(_bookmarks);
      saved ? _bookmarks.add(eventId) : _bookmarks.remove(eventId);
    });
    PersistenceService.saveBookmark(eventId, saved);
  }

  void _addEvent(Map<String, String> event) {
    setState(() {
      _events = [event, ..._events];
      _spotCounts = {
        ..._spotCounts,
        event['id']!: int.tryParse(event['spots'] ?? '0') ?? 0
      };
    });
    _savePostedEvents();
  }

  void _deleteEvent(String eventId) {
    setState(() {
      _events = _events.where((e) => e['id'] != eventId).toList();
      _spotCounts = Map.from(_spotCounts)..remove(eventId);
    });
    _savePostedEvents();
  }

  void _savePostedEvents() {
    // Only persist organizer-posted events (those with an id starting with 'evt_')
    final posted = _events.where((e) => e['id']!.startsWith('evt_')).toList();
    PersistenceService.savePostedEvents(posted);
  }

  void _changeSpot(String eventId, int delta) {
    final current = _spotCounts[eventId] ?? 0;
    setState(() => _spotCounts = {
          ..._spotCounts,
          eventId: (current + delta).clamp(0, 9999)
        });
  }

  void _onFabTap() {
    if (widget.userRole == UserRole.organizer) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PostEventScreen()),
      );
    } else {
      setState(() => _currentIndex = 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    final pages = [
      HomeScreen(onNavigate: (i) => setState(() => _currentIndex = i)),
      const EventFeedScreen(),
      const ChatListScreen(),
      ProfileScreen(onToggleTheme: widget.onToggleTheme),
    ];

    return UserSession(
      name: widget.userName,
      email: widget.userEmail,
      role: widget.userRole,
      child: EventFeedState(
        events: _events,
        spotCounts: _spotCounts,
        onAdd: _addEvent,
        onDelete: _deleteEvent,
        onSpotChange: _changeSpot,
        child: RsvpState(
          rsvps: _rsvps,
          bookmarks: _bookmarks,
          onUpdate: _updateRsvp,
          onBookmark: _updateBookmark,
          child: Scaffold(
            body: Stack(
              children: [
                pages[_currentIndex],
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  right: 16,
                  child: GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const NotificationsScreen()),
                      );
                      setState(() => _unreadNotifications = 0);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.notifications_outlined,
                              color: Colors.white, size: 22),
                          if (_unreadNotifications > 0)
                            Positioned(
                              right: -4,
                              top: -4,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '$_unreadNotifications',
                                  style: GoogleFonts.openSans(
                                      fontSize: 9,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: _CenterFab(
              isOrganizer: widget.userRole == UserRole.organizer,
              onTap: _onFabTap,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: _BottomNav(
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Floating Center FAB ───────────────────────────────────────────────────────
class _CenterFab extends StatelessWidget {
  final bool isOrganizer;
  final VoidCallback onTap;

  const _CenterFab({required this.isOrganizer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.45),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(
          isOrganizer ? Icons.add_rounded : Icons.explore_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}

// ── Custom Bottom Nav ─────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkCard : Colors.white;
    final border = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);

    // 4 items — 2 left, gap for FAB, 2 right
    const leftItems = [
      _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home', index: 0),
      _NavItem(icon: Icons.explore_outlined, activeIcon: Icons.explore_rounded, label: 'Feed', index: 1),
    ];
    const rightItems = [
      _NavItem(icon: Icons.chat_bubble_outline_rounded, activeIcon: Icons.chat_bubble_rounded, label: 'Chat', index: 2),
      _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profile', index: 3),
    ];

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              // Left 2 items
              ...leftItems.map((item) => _buildItem(context, item, isDark)),
              // Center gap for FAB
              const Expanded(child: SizedBox()),
              // Right 2 items
              ...rightItems.map((item) => _buildItem(context, item, isDark)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, _NavItem item, bool isDark) {
    final isActive = currentIndex == item.index;
    final activeColor = AppColors.primary;
    final inactiveColor = isDark ? AppColors.darkTextMuted : const Color(0xFF94A3B8);

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(item.index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? item.activeIcon : item.icon,
                key: ValueKey(isActive),
                color: isActive ? activeColor : inactiveColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: GoogleFonts.openSans(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive ? activeColor : inactiveColor,
              ),
            ),
            // Active indicator dot
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isActive ? 18 : 0,
              height: isActive ? 3 : 0,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
  });
}
