import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/models/activities/training.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// A widget that displays and collects training information
/// This widget allows users to:
/// - Select university/training institution or enter manually
/// - Choose location and country
/// - Select start and end dates
/// - Choose degree type
/// - Enter main course of study
/// - Add optional description
class TrainingFormCard extends StatefulWidget {
  final String selectedUniversity;
  final bool isManualUniversity;
  final TextEditingController manualUniversityController;
  final TextEditingController placeController;
  final String selectedCountry;
  final bool isManualCountry;
  final TextEditingController manualCountryController;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String selectedDegree;
  final TextEditingController mainCourseController;
  final TextEditingController descriptionController;
  final Function(String) onUniversityChanged;
  final Function(String) onPlaceChanged;
  final Function(String) onCountryChanged;
  final Function(DateTime) onFromDateChanged;
  final Function(DateTime?) onToDateChanged;
  final Function(String) onDegreeChanged;
  final Function(String) onMainCourseChanged;
  final Function(String) onDescriptionChanged;

  const TrainingFormCard({
    super.key,
    required this.selectedUniversity,
    required this.isManualUniversity,
    required this.manualUniversityController,
    required this.placeController,
    required this.selectedCountry,
    required this.isManualCountry,
    required this.manualCountryController,
    required this.fromDate,
    required this.toDate,
    required this.selectedDegree,
    required this.mainCourseController,
    required this.descriptionController,
    required this.onUniversityChanged,
    required this.onPlaceChanged,
    required this.onCountryChanged,
    required this.onFromDateChanged,
    required this.onToDateChanged,
    required this.onDegreeChanged,
    required this.onMainCourseChanged,
    required this.onDescriptionChanged,
  });

  @override
  State<TrainingFormCard> createState() => _TrainingFormCardState();
}

class _TrainingFormCardState extends State<TrainingFormCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: PalmColors.primary,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: PalmColors.white.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Training Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // University/Training Institution
          const Text(
            'University/Training Institution',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          _buildUniversitySection(),
          
          const SizedBox(height: 16),

          // Place
          const Text(
            'Place',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          _buildTextInput(
            controller: widget.placeController,
            hintText: 'Enter place/location',
            onChanged: widget.onPlaceChanged,
          ),

          const SizedBox(height: 16),

          // Country
          const Text(
            'Country',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          _buildCountrySection(),

          const SizedBox(height: 16),

          // Date Range
          Row(
            children: [
              // From Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'From Date',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDateSelector(
                      date: widget.fromDate,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: widget.fromDate ?? DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          widget.onFromDateChanged(picked);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // To Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'To Date (Optional)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDateSelector(
                      date: widget.toDate,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: widget.toDate ?? widget.fromDate ?? DateTime.now(),
                          firstDate: widget.fromDate ?? DateTime(1950),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        widget.onToDateChanged(picked);
                      },
                      isOptional: true,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Duration Display
          if (widget.fromDate != null) ...[
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Duration: ${_getDurationText()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Degree
          const Text(
            'Degree/Qualification',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          _buildDropdown(
            value: widget.selectedDegree,
            items: Training.degreeOptions,
            onChanged: widget.onDegreeChanged,
          ),

          const SizedBox(height: 16),

          // Main Course of Study
          const Text(
            'Main Course of Study',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          _buildTextInput(
            controller: widget.mainCourseController,
            hintText: 'Enter your main course of study',
            onChanged: widget.onMainCourseChanged,
          ),

          const SizedBox(height: 16),

          // Description (Optional)
          const Text(
            'Description (Optional)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          _buildTextInput(
            controller: widget.descriptionController,
            hintText: 'Add any additional details about your training...',
            onChanged: widget.onDescriptionChanged,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  /// Build university selection section
  Widget _buildUniversitySection() {
    return Column(
      children: [
        _buildDropdown(
          value: widget.selectedUniversity,
          items: Training.commonUniversities,
          onChanged: widget.onUniversityChanged,
        ),
        if (widget.isManualUniversity) ...[
          const SizedBox(height: 8),
          _buildTextInput(
            controller: widget.manualUniversityController,
            hintText: 'Enter university/training name',
            onChanged: (value) {},
          ),
        ],
      ],
    );
  }

  /// Build country selection section
  Widget _buildCountrySection() {
    return Column(
      children: [
        _buildDropdown(
          value: widget.selectedCountry,
          items: Training.countryOptions,
          onChanged: widget.onCountryChanged,
        ),
        if (widget.isManualCountry) ...[
          const SizedBox(height: 8),
          _buildTextInput(
            controller: widget.manualCountryController,
            hintText: 'Enter country name',
            onChanged: (value) {},
          ),
        ],
      ],
    );
  }

  /// Build dropdown widget
  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ),
    );
  }

  /// Build text input widget
  Widget _buildTextInput({
    required TextEditingController controller,
    required String hintText,
    required Function(String) onChanged,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.all(12.0),
          border: InputBorder.none,
        ),
      ),
    );
  }

  /// Build date selector widget
  Widget _buildDateSelector({
    required DateTime? date,
    required VoidCallback onTap,
    bool isOptional = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                date != null
                    ? "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}"
                    : isOptional ? "Select date (optional)" : "Select date",
                style: TextStyle(
                  fontSize: 14,
                  color: date != null ? Colors.black : Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  /// Get duration text
  String _getDurationText() {
    if (widget.fromDate == null) return '';
    
    final from = widget.fromDate!;
    final to = widget.toDate ?? DateTime.now();
    
    final years = to.year - from.year;
    final months = to.month - from.month;
    
    int totalMonths = years * 12 + months;
    
    if (totalMonths < 0) totalMonths = 0;
    
    if (totalMonths < 12) {
      return '$totalMonths month${totalMonths != 1 ? 's' : ''}';
    } else {
      final y = totalMonths ~/ 12;
      final m = totalMonths % 12;
      if (m == 0) {
        return '$y year${y != 1 ? 's' : ''}';
      } else {
        return '$y year${y != 1 ? 's' : ''} $m month${m != 1 ? 's' : ''}';
      }
    }
  }
}
