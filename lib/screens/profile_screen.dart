import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color darkBlue = Color(0xFF101A2E);
  static const Color green = Color(0xFF16C79A);
  static const Color lightGreen = Color(0xFFE8FFF7);
  static const Color background = Color(0xFFF7F9FC);
  static const Color textDark = Color(0xFF101828);
  static const Color textMuted = Color(0xFF667085);

  @override
  Widget build(BuildContext context) {
    final profile = _MockProfileData.studentProfile;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: darkBlue, fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings will be integrated later.'),
                ),
              );
            },
            icon: const Icon(Icons.settings_rounded, color: darkBlue),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _ProfileHeader(profile: profile),
          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'RSVPs',
                  value: profile.rsvpCount.toString(),
                  icon: Icons.event_available_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  title: 'Saved',
                  value: profile.savedCount.toString(),
                  icon: Icons.bookmark_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  title: 'Role',
                  value: profile.role,
                  icon: Icons.school_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const _SectionTitle(title: 'Interests'),
          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: profile.interests.map((interest) {
              return Chip(
                backgroundColor: lightGreen,
                side: BorderSide.none,
                avatar: const Icon(
                  Icons.favorite_rounded,
                  size: 18,
                  color: green,
                ),
                label: Text(
                  interest,
                  style: const TextStyle(
                    color: darkBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),
          const _SectionTitle(title: 'Identity Representation'),
          const SizedBox(height: 10),

          _IdentityTile(
            icon: Icons.verified_user_rounded,
            title: 'Student identity',
            subtitle:
                'Shows the user as an ALU student with campus, program, interests, and activity summary.',
          ),
          const _IdentityTile(
            icon: Icons.event_note_rounded,
            title: 'Participation record',
            subtitle:
                'This section will later connect to RSVP state and show real events the student joined.',
          ),
          const _IdentityTile(
            icon: Icons.bookmark_rounded,
            title: 'Saved opportunities',
            subtitle:
                'This section will later connect to saved-event state and display opportunities saved from the feed.',
          ),
          _IdentityTile(
            icon: Icons.location_city_rounded,
            title: 'Campus representation',
            subtitle: profile.campus,
          ),

          const SizedBox(height: 24),
          const _SectionTitle(title: 'My Activity Preview'),
          const SizedBox(height: 10),

          ...profile.activities.map((activity) {
            return _ActivityTile(activity: activity);
          }),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final _MockProfile profile;

  const _ProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: ProfileScreen.darkBlue,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Container(
            height: 84,
            width: 84,
            decoration: BoxDecoration(
              color: ProfileScreen.green,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                profile.initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            profile.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${profile.role} • ${profile.campus}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              profile.program,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: ProfileScreen.green),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: ProfileScreen.textDark,
              fontWeight: FontWeight.w900,
              fontSize: 19,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              color: ProfileScreen.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: ProfileScreen.textDark,
      ),
    );
  }
}

class _IdentityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _IdentityTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: ProfileScreen.lightGreen,
            child: Icon(icon, color: ProfileScreen.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: ProfileScreen.textDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: ProfileScreen.textMuted,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final _MockActivity activity;

  const _ActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: ProfileScreen.lightGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(activity.icon, color: ProfileScreen.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    color: ProfileScreen.textDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  activity.subtitle,
                  style: const TextStyle(
                    color: ProfileScreen.textMuted,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MockProfile {
  final String name;
  final String initial;
  final String role;
  final String campus;
  final String program;
  final int rsvpCount;
  final int savedCount;
  final List<String> interests;
  final List<_MockActivity> activities;

  const _MockProfile({
    required this.name,
    required this.initial,
    required this.role,
    required this.campus,
    required this.program,
    required this.rsvpCount,
    required this.savedCount,
    required this.interests,
    required this.activities,
  });
}

class _MockActivity {
  final String title;
  final String subtitle;
  final IconData icon;

  const _MockActivity({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class _MockProfileData {
  static const _MockProfile studentProfile = _MockProfile(
    name: 'ALU Student',
    initial: 'A',
    role: 'Student',
    campus: 'ALU Rwanda Campus',
    program: 'Undergraduate Student',
    rsvpCount: 3,
    savedCount: 2,
    interests: [
      'Leadership',
      'Entrepreneurship',
      'Technology',
      'Career Growth',
    ],
    activities: [
      _MockActivity(
        title: 'ALU Leadership Workshop',
        subtitle: 'RSVP confirmed • June 14, 2026',
        icon: Icons.event_available_rounded,
      ),
      _MockActivity(
        title: 'Startup Pitch Night',
        subtitle: 'Saved opportunity • Entrepreneurship',
        icon: Icons.bookmark_rounded,
      ),
      _MockActivity(
        title: 'Community Impact Hackathon',
        subtitle: 'Recommended based on Technology interest',
        icon: Icons.groups_rounded,
      ),
    ],
  );
}
