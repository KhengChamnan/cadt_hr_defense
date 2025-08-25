import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/models/activities/training.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/activities/traning/widgets/training_form_card.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:palm_ecommerce_mobile_app_2/utils/notification_util.dart';
import 'package:palm_ecommerce_mobile_app_2/widgets/actions/palm_button.dart';

/// Training Screen allows users to:
/// - Add new training/education records
/// - Select university/institution
/// - Choose degree and course of study
/// - Set duration and location
/// - Provide description
class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  // Form state
  String _selectedUniversity = Training.commonUniversities[0];
  bool _isManualUniversity = false;
  final TextEditingController _manualUniversityController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  String _selectedCountry = Training.countryOptions[0];
  bool _isManualCountry = false;
  final TextEditingController _manualCountryController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;
  String _selectedDegree = Training.degreeOptions[0];
  final TextEditingController _mainCourseController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Services and utilities
  final NotificationUtil _notificationUtil = NotificationUtil();

  @override
  void initState() {
    super.initState();
    // Initialize with current date
    _fromDate = DateTime.now();
  }

  @override
  void dispose() {
    _manualUniversityController.dispose();
    _placeController.dispose();
    _manualCountryController.dispose();
    _mainCourseController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Calculate duration in months/years
  void _calculateDuration() {
    setState(() {
      // Trigger rebuild to update duration display
    });
  }

  /// Validate the training form
  bool _validateForm() {
    String university = _isManualUniversity 
        ? _manualUniversityController.text.trim()
        : _selectedUniversity;

    String country = _isManualCountry 
        ? _manualCountryController.text.trim()
        : _selectedCountry;

    if (university.isEmpty) {
      _notificationUtil.showError(context, 'Please select or enter a university/training');
      return false;
    }

    if (_placeController.text.trim().isEmpty) {
      _notificationUtil.showError(context, 'Please enter the place/location');
      return false;
    }

    if (country.isEmpty) {
      _notificationUtil.showError(context, 'Please select or enter a country');
      return false;
    }

    if (_fromDate == null) {
      _notificationUtil.showError(context, 'Please select the start date');
      return false;
    }

    if (_toDate != null && _toDate!.isBefore(_fromDate!)) {
      _notificationUtil.showError(context, 'End date cannot be before start date');
      return false;
    }

    if (_mainCourseController.text.trim().isEmpty) {
      _notificationUtil.showError(context, 'Please enter the main course of study');
      return false;
    }

    return true;
  }

  /// Submit the training record
  Future<void> _submitTraining() async {
    // 1 - Validate form
    if (!_validateForm()) {
      return;
    }

    try {
      // 2 - Create training model
      final training = Training.create(
        universityOrTraining: _isManualUniversity 
            ? _manualUniversityController.text.trim()
            : _selectedUniversity,
        isManualUniversity: _isManualUniversity,
        place: _placeController.text.trim(),
        country: _isManualCountry 
            ? _manualCountryController.text.trim()
            : _selectedCountry,
        fromDate: _fromDate!,
        toDate: _toDate,
        degree: _selectedDegree,
        mainCourseOfStudy: _mainCourseController.text.trim(),
        description: _descriptionController.text.trim().isNotEmpty 
            ? _descriptionController.text.trim() 
            : null,
      );

      // 3 - Simulate save operation (replace with actual API call)
      await Future.delayed(const Duration(seconds: 1));
      
      // TODO: Replace with actual service call
      print('Training saved: ${training.toString()}');

      // 4 - Show success message
      _notificationUtil.showSuccess(context, 'Training record saved successfully');

      // 5 - Navigate back and return the created training
      Navigator.of(context).pop(training);
    } catch (e) {
      _notificationUtil.showError(context, 'Failed to save training record: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(PalmSpacings.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: PalmSpacings.m),
            _buildTrainingFormSection(),
            const SizedBox(height: PalmSpacings.xl),
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
        'Add Training',
        style: TextStyle(color: PalmColors.white),
      ),
      backgroundColor: PalmColors.primary,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: PalmColors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  /// Build the training form section
  Widget _buildTrainingFormSection() {
    return TrainingFormCard(
      selectedUniversity: _selectedUniversity,
      isManualUniversity: _isManualUniversity,
      manualUniversityController: _manualUniversityController,
      placeController: _placeController,
      selectedCountry: _selectedCountry,
      isManualCountry: _isManualCountry,
      manualCountryController: _manualCountryController,
      fromDate: _fromDate,
      toDate: _toDate,
      selectedDegree: _selectedDegree,
      mainCourseController: _mainCourseController,
      descriptionController: _descriptionController,
      onUniversityChanged: (String newValue) {
        setState(() {
          _selectedUniversity = newValue;
          _isManualUniversity = newValue == 'Other (Manual Input)';
          if (!_isManualUniversity) {
            _manualUniversityController.clear();
          }
        });
      },
      onPlaceChanged: (String value) {
        // Place text field changes are handled by the controller
      },
      onCountryChanged: (String newValue) {
        setState(() {
          _selectedCountry = newValue;
          _isManualCountry = newValue == 'Other (Manual Input)';
          if (!_isManualCountry) {
            _manualCountryController.clear();
          }
        });
      },
      onFromDateChanged: (DateTime picked) {
        setState(() {
          _fromDate = picked;
          // Ensure end date is not before start date
          if (_toDate != null && _toDate!.isBefore(_fromDate!)) {
            _toDate = _fromDate;
          }
          _calculateDuration();
        });
      },
      onToDateChanged: (DateTime? picked) {
        setState(() {
          _toDate = picked;
          _calculateDuration();
        });
      },
      onDegreeChanged: (String newValue) {
        setState(() {
          _selectedDegree = newValue;
        });
      },
      onMainCourseChanged: (String value) {
        // Main course text field changes are handled by the controller
      },
      onDescriptionChanged: (String value) {
        // Description text field changes are handled by the controller
      },
    );
  }

  /// Build the submit button
  Widget _buildSubmitButton() {
    return Center(
      child: PalmButton(
        text: 'Save Training',
        backgroundColor: PalmColors.primary,
        textColor: PalmColors.white,
        onPressed: _submitTraining,
      ),
    );
  }
}