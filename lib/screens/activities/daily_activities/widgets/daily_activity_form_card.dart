import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/models/activities/daily_activies.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:palm_ecommerce_mobile_app_2/widgets/media/full_screen_image_viewer.dart';
import 'dart:io';

/// A widget that displays and collects daily activity information
/// This widget allows users to:
/// - Select activity category
/// - Enter activity details (ID, description, APIs)
/// - Set time range
/// - Add remarks
/// - Capture photos and location
class DailyActivityFormCard extends StatefulWidget {
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

  const DailyActivityFormCard({
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
  State<DailyActivityFormCard> createState() => _DailyActivityFormCardState();
}

class _DailyActivityFormCardState extends State<DailyActivityFormCard> {
  // State for manual input
  bool _isManualKeyApi = false;
  bool _isManualSubApi = false;
  String _selectedKeyApi = 'MEETING';
  String _selectedSubApi = 'WEEKLY';
  TextEditingController _manualKeyApiController = TextEditingController();
  TextEditingController _manualSubApiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with existing values if any
    if (widget.keyApiController.text.isNotEmpty) {
      if (DailyActivity.keyApiOptions.contains(widget.keyApiController.text)) {
        _selectedKeyApi = widget.keyApiController.text;
        _isManualKeyApi = false;
      } else {
        _selectedKeyApi = 'Other (Manual Input)';
        _isManualKeyApi = true;
        _manualKeyApiController.text = widget.keyApiController.text;
      }
    }
    
    if (widget.subApiController.text.isNotEmpty) {
      if (DailyActivity.subApiOptions.contains(widget.subApiController.text)) {
        _selectedSubApi = widget.subApiController.text;
        _isManualSubApi = false;
      } else {
        _selectedSubApi = 'Other (Manual Input)';
        _isManualSubApi = true;
        _manualSubApiController.text = widget.subApiController.text;
      }
    }
  }

  @override
  void dispose() {
    _manualKeyApiController.dispose();
    _manualSubApiController.dispose();
    super.dispose();
  }

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
            'Activity Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Activity Category
          const Text(
            'Activity Category',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          _buildDropdown(
            value: widget.selectedCategory,
            items: DailyActivity.activityCategories,
            onChanged: widget.onCategoryChanged,
          ),

          const SizedBox(height: 16),

          // Activity Description
          const Text(
            'Activity Description',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          _buildTextInput(
            controller: widget.activityDescriptionController,
            hintText: 'Describe your activity...',
            onChanged: widget.onActivityDescriptionChanged,
            maxLines: 3,
          ),

          const SizedBox(height: 16),

          // Key API (Full width)
          const Text(
            'Key API',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          _buildKeyApiSection(),

          const SizedBox(height: 16),

          // Sub API (Full width)
          const Text(
            'Sub API',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          _buildSubApiSection(),

          const SizedBox(height: 16),

          // Start Time Only
          const Text(
            'Start Time',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          _buildDateTimeSelector(
            dateTime: widget.fromDate,
            onTap: () async {
              final picked = await _selectDateTime(context, widget.fromDate);
              if (picked != null) {
                widget.onFromDateChanged(picked);
              }
            },
          ),

          // Info Display
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'End time will be automatically set when you mark the activity as completed',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Remark
          const Text(
            'Remark (Optional)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          _buildTextInput(
            controller: widget.remarkController,
            hintText: 'Add any remarks or notes...',
            onChanged: widget.onRemarkChanged,
            maxLines: 3,
          ),

          const SizedBox(height: 16),

          // Photo and Location Section
          _buildPhotoLocationSection(),
        ],
      ),
    );
  }

  /// Build Key API section with dropdown and manual input
  Widget _buildKeyApiSection() {
    return Column(
      children: [
        // Dropdown for Key API
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedKeyApi,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: DailyActivity.keyApiOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedKeyApi = newValue;
                    _isManualKeyApi = newValue == 'Other (Manual Input)';
                    
                    if (!_isManualKeyApi) {
                      // Update the main controller with the selected value
                      widget.keyApiController.text = newValue;
                      widget.onKeyApiChanged(newValue);
                    } else {
                      // Clear main controller for manual input
                      widget.keyApiController.text = _manualKeyApiController.text;
                      widget.onKeyApiChanged(_manualKeyApiController.text);
                    }
                  });
                }
              },
            ),
          ),
        ),
        
        // Manual input field (shown only when "Other" is selected)
        if (_isManualKeyApi) ...[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextField(
              controller: _manualKeyApiController,
              onChanged: (value) {
                widget.keyApiController.text = value;
                widget.onKeyApiChanged(value);
              },
              decoration: const InputDecoration(
                hintText: 'Enter custom Key API...',
                contentPadding: EdgeInsets.all(12.0),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Build Sub API section with dropdown and manual input
  Widget _buildSubApiSection() {
    return Column(
      children: [
        // Dropdown for Sub API
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedSubApi,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: DailyActivity.subApiOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedSubApi = newValue;
                    _isManualSubApi = newValue == 'Other (Manual Input)';
                    
                    if (!_isManualSubApi) {
                      // Update the main controller with the selected value
                      widget.subApiController.text = newValue;
                      widget.onSubApiChanged(newValue);
                    } else {
                      // Clear main controller for manual input
                      widget.subApiController.text = _manualSubApiController.text;
                      widget.onSubApiChanged(_manualSubApiController.text);
                    }
                  });
                }
              },
            ),
          ),
        ),
        
        // Manual input field (shown only when "Other" is selected)
        if (_isManualSubApi) ...[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextField(
              controller: _manualSubApiController,
              onChanged: (value) {
                widget.subApiController.text = value;
                widget.onSubApiChanged(value);
              },
              decoration: const InputDecoration(
                hintText: 'Enter custom Sub API...',
                contentPadding: EdgeInsets.all(12.0),
                border: InputBorder.none,
              ),
            ),
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

  /// Build date time selector widget
  Widget _buildDateTimeSelector({
    required DateTime dateTime,
    required VoidCallback onTap,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.access_time, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  /// Build photo and location section
  Widget _buildPhotoLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Information',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        
        // Photo section
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Photo (Optional)',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (widget.photoPath != null)
                    IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white),
                      onPressed: widget.onRemovePhoto,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (widget.photoPath == null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: widget.onCapturePhoto,
                    icon: const Icon(Icons.camera, size: 18),
                    label: const Text('Take Photo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: PalmColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    // Photo preview
                    GestureDetector(
                      onTap: () => FullScreenImageViewer.show(context, widget.photoPath!),
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            children: [
                              widget.photoPath!.startsWith('http')
                                  ? Image.network(
                                      widget.photoPath!,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        );
                                      },
                                    )
                                  : Image.file(
                                      File(widget.photoPath!),
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        );
                                      },
                                    ),
                              // Tap to expand indicator
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Icon(
                                    Icons.zoom_in,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Success indicator and retake button
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.white, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Photo captured',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: widget.onCapturePhoto,
                          icon: const Icon(Icons.camera_alt, size: 16),
                          label: const Text('Retake'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: PalmColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: Size.zero,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Location section
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Location (Optional)',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (widget.location != null)
                    IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white),
                      onPressed: widget.onRemoveLocation,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (widget.location == null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: widget.onRecordLocation,
                    icon: const Icon(Icons.my_location, size: 18),
                    label: const Text('Record Location'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: PalmColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Location recorded',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (widget.location!.address != null && widget.location!.address!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.location!.address!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// Select date and time
  Future<DateTime?> _selectDateTime(BuildContext context, DateTime currentDateTime) async {
    final date = await showDatePicker(
      context: context,
      initialDate: currentDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentDateTime),
      );
      
      if (time != null) {
        return DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      }
    }
    return null;
  }
}
