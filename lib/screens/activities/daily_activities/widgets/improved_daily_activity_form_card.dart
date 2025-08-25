import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/models/activities/daily_activies.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:palm_ecommerce_mobile_app_2/widgets/media/full_screen_image_viewer.dart';
import 'dart:io';

/// Improved Daily Activity Form Card with better UX/UI
/// Principles applied:
/// - Match between system and real world (familiar icons and language)
/// - Consistency and standards (consistent spacing, typography, interaction)
/// - Aesthetic and minimalist design (clean, focused, progressive disclosure)
class ImprovedDailyActivityFormCard extends StatefulWidget {
  final String selectedCategory;
  final TextEditingController activityDescriptionController;
  final TextEditingController keyApiController;
  final TextEditingController subApiController;
  final TextEditingController remarkController;
  final DateTime fromDate;
  final DateTime toDate;
  final String? photoPath;
  final ActivityLocation? location;
  final Function(String) onCategoryChanged;
  final Function(String) onActivityDescriptionChanged;
  final Function(String) onKeyApiChanged;
  final Function(String) onSubApiChanged;
  final Function(String) onRemarkChanged;
  final Function(DateTime) onFromDateChanged;
  final Function(DateTime) onToDateChanged;
  final VoidCallback onCapturePhoto;
  final VoidCallback onRecordLocation;
  final VoidCallback? onRemovePhoto;
  final VoidCallback? onRemoveLocation;

  const ImprovedDailyActivityFormCard({
    super.key,
    required this.selectedCategory,
    required this.activityDescriptionController,
    required this.keyApiController,
    required this.subApiController,
    required this.remarkController,
    required this.fromDate,
    required this.toDate,
    required this.photoPath,
    required this.location,
    required this.onCategoryChanged,
    required this.onActivityDescriptionChanged,
    required this.onKeyApiChanged,
    required this.onSubApiChanged,
    required this.onRemarkChanged,
    required this.onFromDateChanged,
    required this.onToDateChanged,
    required this.onCapturePhoto,
    required this.onRecordLocation,
    this.onRemovePhoto,
    this.onRemoveLocation,
  });

  @override
  State<ImprovedDailyActivityFormCard> createState() => _ImprovedDailyActivityFormCardState();
}

class _ImprovedDailyActivityFormCardState extends State<ImprovedDailyActivityFormCard> {
  bool _showAdvancedOptions = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Essential Fields Section
        _buildEssentialSection(),
        
        const SizedBox(height: PalmSpacings.l),
        
        // Advanced Options Toggle
        _buildAdvancedToggle(),
        
        if (_showAdvancedOptions) ...[
          const SizedBox(height: PalmSpacings.m),
          _buildAdvancedSection(),
        ],
        
        const SizedBox(height: PalmSpacings.l),
        
        // Media & Location Section
        _buildMediaLocationSection(),
      ],
    );
  }

  /// Essential fields that every user needs to fill
  Widget _buildEssentialSection() {
    return Container(
      padding: const EdgeInsets.all(PalmSpacings.l),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Icon(Icons.work_outline, color: PalmColors.primary, size: 20),
              const SizedBox(width: PalmSpacings.s),
              Text(
                'What did you do?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: PalmColors.dark,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: PalmSpacings.l),

          // Activity Type
          _buildFieldLabel('Activity Type', Icons.category_outlined),
          const SizedBox(height: PalmSpacings.s),
          _buildCategorySelection(),

          const SizedBox(height: PalmSpacings.l),

          // Activity Description
          _buildFieldLabel('Description', Icons.description_outlined),
          const SizedBox(height: PalmSpacings.s),
          _buildDescriptionField(),

          const SizedBox(height: PalmSpacings.l),

          // Start Time
          _buildFieldLabel('When did you start?', Icons.schedule),
          const SizedBox(height: PalmSpacings.s),
          _buildTimeSelector(),
        ],
      ),
    );
  }

  /// Advanced options toggle
  Widget _buildAdvancedToggle() {
    return InkWell(
      onTap: () {
        setState(() {
          _showAdvancedOptions = !_showAdvancedOptions;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: PalmSpacings.m,
          vertical: PalmSpacings.s,
        ),
        decoration: BoxDecoration(
          color: PalmColors.backgroundAccent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: PalmColors.greyLight),
        ),
        child: Row(
          children: [
            Icon(
              _showAdvancedOptions ? Icons.expand_less : Icons.expand_more,
              color: PalmColors.neutralLight,
            ),
            const SizedBox(width: PalmSpacings.s),
            Text(
              'Advanced Options',
              style: TextStyle(
                color: PalmColors.neutralLight,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              _showAdvancedOptions ? 'Hide' : 'Show',
              style: TextStyle(
                color: PalmColors.primary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Advanced fields section (collapsed by default)
  Widget _buildAdvancedSection() {
    return Container(
      padding: const EdgeInsets.all(PalmSpacings.l),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PalmColors.greyLight.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Icon(Icons.tune, color: PalmColors.neutralLight, size: 18),
              const SizedBox(width: PalmSpacings.s),
              Text(
                'Additional Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: PalmColors.neutralLight,
                ),
              ),
            ],
          ),

          const SizedBox(height: PalmSpacings.m),

          // Key API (simplified)
          _buildAdvancedField(
            'Category Tag',
            'Optional categorization',
            widget.keyApiController,
            widget.onKeyApiChanged,
            Icons.tag,
          ),

          const SizedBox(height: PalmSpacings.m),

          // Sub API (simplified)
          _buildAdvancedField(
            'Sub Category',
            'Additional categorization',
            widget.subApiController,
            widget.onSubApiChanged,
            Icons.label_outline,
          ),

          const SizedBox(height: PalmSpacings.m),

          // Remarks
          _buildAdvancedField(
            'Notes',
            'Any additional comments...',
            widget.remarkController,
            widget.onRemarkChanged,
            Icons.note_outlined,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  /// Media and location section
  Widget _buildMediaLocationSection() {
    return Container(
      padding: const EdgeInsets.all(PalmSpacings.l),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Icon(Icons.add_a_photo_outlined, color: PalmColors.primary, size: 20),
              const SizedBox(width: PalmSpacings.s),
              Text(
                'Add Evidence',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: PalmColors.dark,
                ),
              ),
            ],
          ),

          const SizedBox(height: PalmSpacings.m),

          // Action Buttons Row
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.camera_alt_outlined,
                  label: 'Take Photo',
                  onTap: widget.onCapturePhoto,
                  isActive: widget.photoPath != null,
                ),
              ),
              const SizedBox(width: PalmSpacings.m),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.location_on_outlined,
                  label: 'Add Location',
                  onTap: widget.onRecordLocation,
                  isActive: widget.location != null,
                ),
              ),
            ],
          ),

          // Show captured media/location
          if (widget.photoPath != null || widget.location != null) ...[
            const SizedBox(height: PalmSpacings.m),
            _buildAttachmentsPreview(),
          ],
        ],
      ),
    );
  }

  /// Build field label with icon
  Widget _buildFieldLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: PalmColors.neutralLight),
        const SizedBox(width: PalmSpacings.xs),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: PalmColors.dark,
          ),
        ),
      ],
    );
  }

  /// Build category selection with visual cards
  Widget _buildCategorySelection() {
    final categories = [
      {
        'value': 'កាលប្រជុំប្រចាំសប្តាហ៍',
        'label': 'Weekly Meeting',
        'icon': Icons.calendar_today,
        'color': Colors.blue,
      },
      {
        'value': 'កាលជួបជុំ',
        'label': 'Meeting',
        'icon': Icons.people,
        'color': Colors.green,
      },
      {
        'value': 'កាលរៀបចំសម្ភារៈ',
        'label': 'Preparation',
        'icon': Icons.inventory_2,
        'color': Colors.orange,
      },
      {
        'value': 'កាលតាំងតំណាងលក់ទំនិញ',
        'label': 'Sales Setup',
        'icon': Icons.storefront,
        'color': Colors.purple,
      },
      {
        'value': 'កាលអភិវឌ្ឍន៍គុណភាពនិងសុវត្ថិភាព',
        'label': 'Quality & Safety',
        'icon': Icons.verified_user,
        'color': Colors.teal,
      },
      {
        'value': 'កាលធ្វើបទបង្ហាញ និង កាលរៀបចំឯកសារ',
        'label': 'Presentation',
        'icon': Icons.present_to_all,
        'color': Colors.indigo,
      },
      {
        'value': 'ធ្វើកម្មវិធីអាប់ដេត',
        'label': 'Update Program',
        'icon': Icons.system_update,
        'color': Colors.cyan,
      },
      {
        'value': 'បង្ហរក បង្ហាញ',
        'label': 'Display/Show',
        'icon': Icons.visibility,
        'color': Colors.pink,
      },
      {
        'value': 'ចំណាចំពាក់ព័ន្ធជាមួយអតិថិជន',
        'label': 'Customer Relations',
        'icon': Icons.handshake,
        'color': Colors.amber,
      },
    ];

    return Column(
      children: [
        // Grid of category cards
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: PalmSpacings.s,
            mainAxisSpacing: PalmSpacings.s,
            childAspectRatio: 3.5, // Make cards rectangular
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = widget.selectedCategory == category['value'];
            
            return InkWell(
              onTap: () {
                widget.onCategoryChanged(category['value'] as String);
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(PalmSpacings.s),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? (category['color'] as Color).withOpacity(0.1)
                      : PalmColors.backgroundAccent,
                  border: Border.all(
                    color: isSelected 
                        ? (category['color'] as Color)
                        : PalmColors.greyLight,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: (category['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        category['icon'] as IconData,
                        color: category['color'] as Color,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: PalmSpacings.xs),
                    Expanded(
                      child: Text(
                        category['label'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected 
                              ? (category['color'] as Color)
                              : PalmColors.dark,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: category['color'] as Color,
                        size: 16,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Build description field
  Widget _buildDescriptionField() {
    return TextField(
      controller: widget.activityDescriptionController,
      onChanged: widget.onActivityDescriptionChanged,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Describe what you worked on...',
        hintStyle: TextStyle(color: PalmColors.neutralLight),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: PalmColors.greyLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: PalmColors.greyLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: PalmColors.primary, width: 2),
        ),
        filled: true,
        fillColor: PalmColors.backgroundAccent,
        contentPadding: const EdgeInsets.all(PalmSpacings.m),
      ),
    );
  }

  /// Build time selector
  Widget _buildTimeSelector() {
    return InkWell(
      onTap: () async {
        final picked = await _selectDateTime(context, widget.fromDate);
        if (picked != null) {
          widget.onFromDateChanged(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(PalmSpacings.m),
        decoration: BoxDecoration(
          border: Border.all(color: PalmColors.greyLight),
          borderRadius: BorderRadius.circular(8),
          color: PalmColors.backgroundAccent,
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, color: PalmColors.neutralLight, size: 20),
            const SizedBox(width: PalmSpacings.s),
            Text(
              _formatDateTime(widget.fromDate),
              style: TextStyle(
                color: PalmColors.dark,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(Icons.edit, color: PalmColors.neutralLight, size: 16),
          ],
        ),
      ),
    );
  }

  /// Build advanced field
  Widget _buildAdvancedField(
    String label,
    String hint,
    TextEditingController controller,
    Function(String) onChanged,
    IconData icon, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: PalmColors.neutralLight),
            const SizedBox(width: PalmSpacings.xs),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: PalmColors.neutralLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: PalmSpacings.xs),
        TextField(
          controller: controller,
          onChanged: onChanged,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: PalmColors.neutralLight.withOpacity(0.7)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: PalmColors.greyLight.withOpacity(0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: PalmColors.greyLight.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: PalmColors.primary),
            ),
            filled: true,
            fillColor: PalmColors.backgroundAccent.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: PalmSpacings.s,
              vertical: PalmSpacings.s,
            ),
            isDense: true,
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  /// Build action button
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: PalmSpacings.m,
          vertical: PalmSpacings.s,
        ),
        decoration: BoxDecoration(
          color: isActive ? PalmColors.primary.withOpacity(0.1) : PalmColors.backgroundAccent,
          border: Border.all(
            color: isActive ? PalmColors.primary : PalmColors.greyLight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? PalmColors.primary : PalmColors.neutralLight,
              size: 18,
            ),
            const SizedBox(width: PalmSpacings.xs),
            Text(
              label,
              style: TextStyle(
                color: isActive ? PalmColors.primary : PalmColors.neutralLight,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: PalmSpacings.xs),
              Icon(
                Icons.check_circle,
                color: PalmColors.primary,
                size: 14,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build attachments preview
  Widget _buildAttachmentsPreview() {
    return Container(
      padding: const EdgeInsets.all(PalmSpacings.s),
      decoration: BoxDecoration(
        color: PalmColors.backgroundAccent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: PalmColors.greyLight.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          if (widget.photoPath != null) _buildPhotoPreview(),
          if (widget.photoPath != null && widget.location != null)
            const SizedBox(height: PalmSpacings.s),
          if (widget.location != null) _buildLocationPreview(),
        ],
      ),
    );
  }

  /// Build photo preview
  Widget _buildPhotoPreview() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.file(
            File(widget.photoPath!),
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: PalmSpacings.s),
        Expanded(
          child: Text(
            'Photo attached',
            style: TextStyle(
              color: PalmColors.dark,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        IconButton(
          onPressed: widget.onRemovePhoto,
          icon: Icon(
            Icons.close,
            size: 16,
            color: PalmColors.neutralLight,
          ),
        ),
      ],
    );
  }

  /// Build location preview
  Widget _buildLocationPreview() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: PalmColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            Icons.location_on,
            color: PalmColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: PalmSpacings.s),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Location recorded',
                style: TextStyle(
                  color: PalmColors.dark,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (widget.location?.address != null)
                Text(
                  widget.location!.address!,
                  style: TextStyle(
                    color: PalmColors.neutralLight,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        IconButton(
          onPressed: widget.onRemoveLocation,
          icon: Icon(
            Icons.close,
            size: 16,
            color: PalmColors.neutralLight,
          ),
        ),
      ],
    );
  }

  /// Select date and time
  Future<DateTime?> _selectDateTime(BuildContext context, DateTime initial) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );

    if (date == null) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );

    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  /// Format date time for display
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final activityDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dateStr;
    if (activityDate == today) {
      dateStr = 'Today';
    } else if (activityDate == today.subtract(const Duration(days: 1))) {
      dateStr = 'Yesterday';
    } else {
      dateStr = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }

    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$dateStr at $hour:$minute';
  }
}
