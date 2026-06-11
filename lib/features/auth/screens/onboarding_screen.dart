import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/state/user_session.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final void Function(String name, String email, UserRole role) onLogin;
  const OnboardingScreen({super.key, required this.onToggleTheme, required this.onLogin});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Free Unsplash photos — no API key needed
  final List<Map<String, String>> _slides = [
    {
      'image': 'https://images.unsplash.com/photo-1529390079861-591de354faf5?w=800&q=80',
      'tag': 'DISCOVER',
      'title': 'Find opportunities\nthat move you',
      'subtitle': 'Hackathons, internships, workshops and events — all in one place for ALU students.',
    },
    {
      'image': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&q=80',
      'tag': 'PARTICIPATE',
      'title': 'RSVP and join\nwith one tap',
      'subtitle': 'Register for events instantly and track everything you have joined from your profile.',
    },
    {
      'image': 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=800&q=80',
      'tag': 'CONNECT',
      'title': 'Build your network\nacross campuses',
      'subtitle': 'Collaborate with peers, join clubs, and create lasting connections across ALU.',
    },
  ];

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(onToggleTheme: widget.onToggleTheme, onLogin: widget.onLogin),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _slides.length - 1;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── Full-screen photo page view ───────────────────────────
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _slides.length,
            itemBuilder: (_, i) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    _slides[i]['image']!,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, progress) =>
                        progress == null ? child : Container(color: AppColors.primaryDark),
                    errorBuilder: (_, __, ___) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primaryDark, AppColors.primary],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  // Dark gradient overlay — stronger at bottom
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black87],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.35, 1.0],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // ── Top bar ───────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // App wordmark
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'A',
                            style: GoogleFonts.openSans(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ALU Hub',
                        style: GoogleFonts.openSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: _goToLogin,
                    child: Text(
                      'Skip',
                      style: GoogleFonts.openSans(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom content ────────────────────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: Column(
                    key: ValueKey(_currentPage),
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Slide tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _slides[_currentPage]['tag']!,
                          style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Title
                      Text(
                        _slides[_currentPage]['title']!,
                        style: GoogleFonts.openSans(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Subtitle
                      Text(
                        _slides[_currentPage]['subtitle']!,
                        style: GoogleFonts.openSans(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Dots + button row
                      Row(
                        children: [
                          // Dot indicators
                          Row(
                            children: List.generate(_slides.length, (i) {
                              final active = i == _currentPage;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.only(right: 6),
                                width: active ? 24 : 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: active ? AppColors.primary : Colors.white38,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              );
                            }),
                          ),
                          const Spacer(),

                          // Next / Get Started button
                          GestureDetector(
                            onTap: _nextPage,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: EdgeInsets.symmetric(
                                horizontal: isLast ? 28 : 20,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    isLast ? 'Get Started' : 'Next',
                                    style: GoogleFonts.openSans(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  if (!isLast) ...[
                                    const SizedBox(width: 6),
                                    const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Already have account
                      if (isLast) ...[
                        const SizedBox(height: 20),
                        Center(
                          child: GestureDetector(
                            onTap: _goToLogin,
                            child: Text.rich(
                              TextSpan(
                                text: 'Already have an account? ',
                                style: GoogleFonts.openSans(color: Colors.white60, fontSize: 13),
                                children: [
                                  TextSpan(
                                    text: 'Log in',
                                    style: GoogleFonts.openSans(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
