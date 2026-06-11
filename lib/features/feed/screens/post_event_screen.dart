import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/state/event_feed_state.dart';
import '../../../core/state/user_session.dart';

class PostEventScreen extends StatefulWidget {
  const PostEventScreen({super.key});

  @override
  State<PostEventScreen> createState() => _PostEventScreenState();
}

class _PostEventScreenState extends State<PostEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _spotsCtrl = TextEditingController();
  String _selectedCategory = 'Event';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  File? _coverImage;
  bool _pickingImage = false;

  final _categories = ['Event', 'Hackathon', 'Workshop', 'Program', 'Talk', 'Internship'];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locationCtrl.dispose();
    _spotsCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    setState(() => _pickingImage = true);
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        imageQuality: 85,
      );
      if (picked != null) setState(() => _coverImage = File(picked.path));
    } finally {
      setState(() => _pickingImage = false);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final session = UserSession.of(context);
    final feedState = EventFeedState.of(context);
    final newEvent = {
      'id': 'evt_${DateTime.now().millisecondsSinceEpoch}',
      'title': _titleCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
      'location': _locationCtrl.text.trim(),
      'date': '${_selectedDate.day} ${_monthName(_selectedDate.month)}, ${_selectedDate.year}',
      'category': _selectedCategory,
      'organizer': session.name,
      'spots': _spotsCtrl.text.trim(),
      'postedBy': session.email,
      'trending': 'false',
      if (_coverImage != null) 'localImagePath': _coverImage!.path,
    };
    feedState.onAdd(newEvent);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Event posted!', style: GoogleFonts.openSans()),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _monthName(int m) => const [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Post New Event',
            style: GoogleFonts.openSans(
                fontSize: 17, fontWeight: FontWeight.bold, color: textPrimary)),
        actions: [
          TextButton(
            onPressed: _submit,
            child: Text('Post',
                style: GoogleFonts.openSans(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Cover Image Picker ──────────────────────────────────
              _label('Cover Image', textMuted),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickingImage ? null : _pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _coverImage != null
                          ? AppColors.primary.withValues(alpha: 0.5)
                          : borderColor,
                      width: _coverImage != null ? 2 : 1,
                    ),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: _coverImage != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(_coverImage!, fit: BoxFit.cover),
                            // Edit overlay
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.edit, color: Colors.white, size: 14),
                                      const SizedBox(width: 4),
                                      Text('Change',
                                          style: GoogleFonts.openSans(
                                              fontSize: 12, color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_pickingImage)
                              const CircularProgressIndicator(
                                  color: AppColors.primary)
                            else ...[
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.add_photo_alternate_outlined,
                                    color: AppColors.primary, size: 32),
                              ),
                              const SizedBox(height: 10),
                              Text('Tap to add cover image',
                                  style: GoogleFonts.openSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary)),
                              const SizedBox(height: 4),
                              Text('Recommended: 1200×630px',
                                  style: GoogleFonts.openSans(
                                      fontSize: 11, color: textMuted)),
                            ],
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),

              _label('Event Title', textMuted),
              const SizedBox(height: 6),
              _field(_titleCtrl, 'e.g. ALU Leadership Summit', textPrimary,
                  cardColor, borderColor, textMuted,
                  validator: (v) => v == null || v.isEmpty ? 'Title required' : null),
              const SizedBox(height: 16),

              _label('Category', textMuted),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    dropdownColor: cardColor,
                    style: GoogleFonts.openSans(color: textPrimary),
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedCategory = v!),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _label('Description', textMuted),
              const SizedBox(height: 6),
              _field(_descCtrl, 'What is this event about?', textPrimary,
                  cardColor, borderColor, textMuted,
                  maxLines: 3,
                  validator: (v) => v == null || v.isEmpty ? 'Description required' : null),
              const SizedBox(height: 16),

              _label('Location', textMuted),
              const SizedBox(height: 6),
              _field(_locationCtrl, 'e.g. Kigali Campus / Online', textPrimary,
                  cardColor, borderColor, textMuted,
                  validator: (v) => v == null || v.isEmpty ? 'Location required' : null),
              const SizedBox(height: 16),

              _label('Available Spots', textMuted),
              const SizedBox(height: 6),
              _field(_spotsCtrl, 'e.g. 50', textPrimary, cardColor,
                  borderColor, textMuted,
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.isEmpty ? 'Spots required' : null),
              const SizedBox(height: 16),

              _label('Event Date', textMuted),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    builder: (ctx, child) => Theme(
                      data: Theme.of(ctx).copyWith(
                        colorScheme: const ColorScheme.light(primary: AppColors.primary),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          color: AppColors.primary, size: 18),
                      const SizedBox(width: 10),
                      Text(
                        '${_selectedDate.day} ${_monthName(_selectedDate.month)} ${_selectedDate.year}',
                        style: GoogleFonts.openSans(color: textPrimary, fontSize: 14),
                      ),
                      const Spacer(),
                      Icon(Icons.chevron_right, color: textMuted, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Post Event',
                      style: GoogleFonts.openSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text, Color color) => Text(text,
      style: GoogleFonts.openSans(
          fontSize: 13, fontWeight: FontWeight.w600, color: color));

  Widget _field(
    TextEditingController ctrl,
    String hint,
    Color textPrimary,
    Color cardColor,
    Color borderColor,
    Color textMuted, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: GoogleFonts.openSans(color: textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.openSans(color: textMuted, fontSize: 13),
        filled: true,
        fillColor: cardColor,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: borderColor)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: borderColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary, width: 2)),
      ),
      validator: validator,
    );
  }
}
