import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/models/activities/daily_activies.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/activities/daily_activities/widgets/improved_daily_activity_form_card.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:palm_ecommerce_mobile_app_2/utils/notification_util.dart';
import 'package:palm_ecommerce_mobile_app_2/widgets/actions/palm_button.dart';
import 'package:palm_ecommerce_mobile_app_2/services/photo_service.dart';
import 'package:palm_ecommerce_mobile_app_2/services/location_service.dart';

/// Improved Daily Activity Form Screen with enhanced UX/UI
/// 
/// Features:
/// - Progressive disclosure (essential fields first, advanced options collapsed)
/// - Real-world language and familiar icons
/// - Consistent design system
/// - Minimal cognitive load
/// - Optional Key API and Sub API fields for better user experience
/// 
/// UX Principles Applied:
/// - Match between system and real world
/// - Consistency and standards
/// - Aesthetic and minimalist design
/// - User control and freedom (progressive disclosure)
class DailyActivityFormScreen extends StatefulWidget {
  final DailyActivity? activity; // For editing existing activity

  const DailyActivityFormScreen({
    super.key,
    this.activity,
  });

  @override
  State<DailyActivityFormScreen> createState() => _DailyActivityFormScreenState();
}

class _DailyActivityFormScreenState extends State<DailyActivityFormScreen> {
  // Form state
  String _selectedCategory = DailyActivity.activityCategories.first;
  final TextEditingController _activityDescriptionController = TextEditingController();
  final TextEditingController _keyApiController = TextEditingController();
  final TextEditingController _subApiController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now().add(const Duration(hours: 8)); // Default 8 hours for new activities
  String? _photoPath;
  ActivityLocation? _location;

  // Services and utilities
  final NotificationUtil _notificationUtil = NotificationUtil();
  final PhotoService _photoService = PhotoService();
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  @override
  void dispose() {
    _activityDescriptionController.dispose();
    _keyApiController.dispose();
    _subApiController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  /// Load existing data if editing
  void _loadExistingData() {
    if (widget.activity != null) {
      final activity = widget.activity!;
      _selectedCategory = activity.activityCategory;
      _activityDescriptionController.text = activity.activityDescription;
      _keyApiController.text = activity.keyApi;
      _subApiController.text = activity.subApi;
      _remarkController.text = activity.remark;
      _fromDate = activity.fromDate;
      _toDate = activity.toDate;
      _photoPath = activity.photoPath;
      _location = activity.location;
    }
  }

  /// Validate the activity form
  bool _validateForm() {
    if (_activityDescriptionController.text.trim().isEmpty) {
      _notificationUtil.showError(context, 'Please enter an activity description');
      return false;
    }

    if (_toDate.isBefore(_fromDate)) {
      _notificationUtil.showError(context, 'End time cannot be before start time');
      return false;
    }

    return true;
  }

  /// Submit the activity record
  Future<void> _submitActivity() async {
    // 1 - Validate form
    if (!_validateForm()) {
      return;
    }

    try {
      // 2 - Create activity model
      final activity = DailyActivity(
        id: widget.activity?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        activityId: widget.activity?.activityId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        activityCategory: _selectedCategory,
        activityDescription: _activityDescriptionController.text.trim(),
        keyApi: _keyApiController.text.trim().isEmpty ? 'GENERAL' : _keyApiController.text.trim(),
        subApi: _subApiController.text.trim().isEmpty ? 'DAILY' : _subApiController.text.trim(),
        fromDate: _fromDate,
        toDate: _toDate,
        remark: _remarkController.text.trim(),
        photoPath: _photoPath,
        location: _location,
        employeeId: 'EMP001', // TODO: Get from authenticated user
        createdAt: widget.activity?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        status: widget.activity?.status ?? ActivityStatus.inProgress, // New activities start as "in progress"
      );

      // 3 - Simulate save operation (replace with actual API call)
      await Future.delayed(const Duration(seconds: 1));
      
      // TODO: Replace with actual service call
      debugPrint('Activity saved: ${activity.toString()}');

      // 4 - Show success message
      _notificationUtil.showSuccess(context, 'Activity record saved successfully');

      // 5 - Navigate back with the created activity
      Navigator.of(context).pop(activity);
    } catch (e) {
      _notificationUtil.showError(context, 'Failed to save activity record: ${e.toString()}');
    }
  }

  /// Capture photo
  Future<void> _capturePhoto() async {
    try {
      final photoPath = await _photoService.capturePhoto(context: context);
      
      if (photoPath != null) {
        setState(() {
          _photoPath = photoPath;
        });
        _notificationUtil.showSuccess(context, 'Photo captured successfully');
      }
    } catch (e) {
      _notificationUtil.showError(context, 'Failed to capture photo: ${e.toString()}');
    }
  }

  /// Record current location
  Future<void> _recordLocation() async {
    try {
      final locationData = await _locationService.getCurrentLocation(context: context);
      
      if (locationData != null) {
        setState(() {
          _location = ActivityLocation(
            latitude: locationData.latitude,
            longitude: locationData.longitude,
            address: locationData.address,
          );
        });
        _notificationUtil.showSuccess(context, 'Location recorded successfully');
      }
    } catch (e) {
      _notificationUtil.showError(context, 'Failed to record location: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PalmColors.backgroundAccent,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(PalmSpacings.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildActivityFormSection(),
            const SizedBox(height: PalmSpacings.l),
            _buildSubmitButton(),
            const SizedBox(height: PalmSpacings.m),
          ],
        ),
      ),
    );
  }

  /// Build the app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        widget.activity == null ? 'Add Daily Activity' : 'Edit Activity',
        style: TextStyle(
          color: PalmColors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      backgroundColor: PalmColors.primary,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: PalmColors.white, size: 20),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  /// Build the activity form section
  Widget _buildActivityFormSection() {
    return ImprovedDailyActivityFormCard(
      selectedCategory: _selectedCategory,
      activityDescriptionController: _activityDescriptionController,
      keyApiController: _keyApiController,
      subApiController: _subApiController,
      remarkController: _remarkController,
      fromDate: _fromDate,
      toDate: _toDate,
      photoPath: _photoPath,
      location: _location,
      onCategoryChanged: (String newValue) {
        setState(() {
          _selectedCategory = newValue;
        });
      },
      onActivityDescriptionChanged: (String value) {
        // Activity description text field changes are handled by the controller
      },
      onKeyApiChanged: (String value) {
        // Key API text field changes are handled by the controller
      },
      onSubApiChanged: (String value) {
        // Sub API text field changes are handled by the controller
      },
      onRemarkChanged: (String value) {
        // Remark text field changes are handled by the controller
      },
      onFromDateChanged: (DateTime picked) {
        setState(() {
          _fromDate = picked;
          // Ensure end time is not before start time
          if (_toDate.isBefore(_fromDate)) {
            _toDate = _fromDate.add(const Duration(hours: 1));
          }
        });
      },
      onToDateChanged: (DateTime picked) {
        setState(() {
          _toDate = picked;
        });
      },
      onCapturePhoto: _capturePhoto,
      onRecordLocation: _recordLocation,
      onRemovePhoto: () {
        setState(() {
          _photoPath = null;
        });
      },
      onRemoveLocation: () {
        setState(() {
          _location = null;
        });
      },
    );
  }

  /// Build the submit button
  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: PalmSpacings.m),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: PalmColors.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: PalmButton(
          text: widget.activity == null ? 'Save Activity' : 'Update Activity',
          backgroundColor: PalmColors.primary,
          textColor: PalmColors.white,
          onPressed: _submitActivity,
        ),
      ),
    );
  }
}
