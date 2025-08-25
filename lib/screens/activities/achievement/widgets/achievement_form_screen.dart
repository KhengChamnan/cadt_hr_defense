import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../models/activities/achievements.dart';
import '../../../../theme/app_theme.dart';
import '../../../../utils/notification_util.dart';
import '../../../../widgets/actions/palm_button.dart';

/// Full Screen Achievement Form allows users to:
/// - Add new achievement records
/// - Edit existing achievements
/// - Calculate achievement percentage automatically
/// - Validate all required fields
class AchievementFormScreen extends StatefulWidget {
  final Achievement? achievement; // For editing existing achievement
  final Function(Achievement)? onSubmit;

  const AchievementFormScreen({
    super.key,
    this.achievement,
    this.onSubmit,
  });

  @override
  State<AchievementFormScreen> createState() => _AchievementFormScreenState();
}

class _AchievementFormScreenState extends State<AchievementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  late TextEditingController _indexController;
  late TextEditingController _descriptionController;
  late TextEditingController _keyApiController;
  late TextEditingController _subApiController;
  late TextEditingController _targetController;
  late TextEditingController _actualController;
  late TextEditingController _remarkController;
  
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _isSubmitting = false;

  // Services and utilities
  final NotificationUtil _notificationUtil = NotificationUtil();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _indexController.dispose();
    _descriptionController.dispose();
    _keyApiController.dispose();
    _subApiController.dispose();
    _targetController.dispose();
    _actualController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    final achievement = widget.achievement;
    
    _indexController = TextEditingController(text: achievement?.achievementIndex ?? '');
    _descriptionController = TextEditingController(text: achievement?.achievementDescription ?? '');
    _keyApiController = TextEditingController(text: achievement?.keyApi ?? '');
    _subApiController = TextEditingController(text: achievement?.subApi ?? '');
    _targetController = TextEditingController(text: achievement?.targetAmount?.toString() ?? '');
    _actualController = TextEditingController(text: achievement?.actualAchievement?.toString() ?? '');
    _remarkController = TextEditingController(text: achievement?.remark ?? '');
    
    _fromDate = achievement?.fromDate;
    _toDate = achievement?.toDate;
  }

  /// Validate the achievement form
  bool _validateForm() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    if (_fromDate == null || _toDate == null) {
      _notificationUtil.showError(context, 'Please select both from and to dates');
      return false;
    }

    if (_fromDate!.isAfter(_toDate!)) {
      _notificationUtil.showError(context, 'From date cannot be after to date');
      return false;
    }

    return true;
  }

  /// Submit the achievement record
  Future<void> _submitAchievement() async {
    // 1 - Validate form
    if (!_validateForm()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // 2 - Create achievement model
      final achievement = Achievement.fromEmployeeForm(
     achievementIndex: _indexController.text.trim(),
        achievementDescription: _descriptionController.text.trim(),
        keyApi: _keyApiController.text.trim().isNotEmpty ? _keyApiController.text.trim() : null,
        subApi: _subApiController.text.trim().isNotEmpty ? _subApiController.text.trim() : null,
        fromDate: _fromDate!,
        toDate: _toDate!,
        targetAmount: double.parse(_targetController.text),
        actualAchievement: double.parse(_actualController.text),
        remark: _remarkController.text.trim().isNotEmpty ? _remarkController.text.trim() : null,
      );

      // If editing, preserve the ID
      final finalAchievement = widget.achievement != null
          ? achievement.copyWith(id: widget.achievement!.id)
          : achievement;

      // 3 - Simulate save operation (replace with actual API call)
      await Future.delayed(const Duration(seconds: 1));
      
      // TODO: Replace with actual service call
      debugPrint('Achievement saved: ${finalAchievement.toString()}');

      // 4 - Show success message
      _notificationUtil.showSuccess(context, 'Achievement record saved successfully');

      // 5 - Call onSubmit callback if provided or navigate back
      if (widget.onSubmit != null) {
        widget.onSubmit!(finalAchievement);
      } else {
        Navigator.of(context).pop(finalAchievement);
      }
    } catch (e) {
      _notificationUtil.showError(context, 'Failed to save achievement record: ${e.toString()}');
    } finally {
      setState(() {
        _isSubmitting = false;
      });
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
            _buildAchievementFormSection(),
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
        widget.achievement == null ? 'Add Achievement' : 'Edit Achievement',
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

  /// Build the achievement form section
  Widget _buildAchievementFormSection() {
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Achievement Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fill in your achievement details. Percentage will be calculated automatically.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            
            // Achievement Index
            _buildFormSection(
              label: 'Achievement Index *',
              child: _buildTextField(
                controller: _indexController,
                hint: 'e.g., CS001, SAL002',
                validator: (value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'Achievement index is required';
                  }
                  return null;
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Achievement Description
            _buildFormSection(
              label: 'Achievement Description *',
              child: _buildTextField(
                controller: _descriptionController,
                hint: 'Describe what you achieved',
                maxLines: 3,
                validator: (value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'Achievement description is required';
                  }
                  return null;
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Key API and Sub API
            Row(
              children: [
                Expanded(
                  child: _buildFormSection(
                    label: 'Key API',
                    child: _buildTextField(
                      controller: _keyApiController,
                      hint: 'e.g., Customer Service',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormSection(
                    label: 'Sub API',
                    child: _buildTextField(
                      controller: _subApiController,
                      hint: 'e.g., Training',
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Date range
            Row(
              children: [
                Expanded(
                  child: _buildFormSection(
                    label: 'From Date *',
                    child: _buildDateField(
                      date: _fromDate,
                      onDateSelected: (date) {
                        setState(() {
                          _fromDate = date;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormSection(
                    label: 'To Date *',
                    child: _buildDateField(
                      date: _toDate,
                      onDateSelected: (date) {
                        setState(() {
                          _toDate = date;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Target and Actual amounts
            Row(
              children: [
                Expanded(
                  child: _buildFormSection(
                    label: 'Target Amount *',
                    child: _buildNumberField(
                      controller: _targetController,
                      hint: 'e.g., 5, 1000',
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Target amount is required';
                        }
                        final number = double.tryParse(value!);
                        if (number == null || number <= 0) {
                          return 'Must be a positive number';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFormSection(
                    label: 'Actual Achievement *',
                    child: _buildNumberField(
                      controller: _actualController,
                      hint: 'e.g., 6, 1200',
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Actual achievement is required';
                        }
                        final number = double.tryParse(value!);
                        if (number == null || number < 0) {
                          return 'Must be a non-negative number';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Percentage preview
            _buildPercentagePreview(),
            
            const SizedBox(height: 16),
            
            // Remarks
            _buildFormSection(
              label: 'Remarks (Optional)',
              child: _buildTextField(
                controller: _remarkController,
                hint: 'Any additional comments or notes',
                maxLines: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build form section with label and white styling
  Widget _buildFormSection({
    required String label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.all(12.0),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
        validator: validator,
        onChanged: (_) => setState(() {}), // Trigger percentage update
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.all(12.0),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDateField({
    required DateTime? date,
    required Function(DateTime) onDateSelected,
  }) {
    return GestureDetector(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (selectedDate != null) {
          onDateSelected(selectedDate);
        }
      },
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
                    ? '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}'
                    : 'Select date',
                style: TextStyle(
                  fontSize: 14,
                  color: date != null ? Colors.black : Colors.grey[500],
                ),
              ),
            ),
            Icon(Icons.calendar_today, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildPercentagePreview() {
    final target = double.tryParse(_targetController.text) ?? 0.0;
    final actual = double.tryParse(_actualController.text) ?? 0.0;
    final percentage = target > 0 ? (actual / target) * 100 : 0.0;
    
    Color percentageColor;
    if (percentage >= 100) {
      percentageColor = Colors.green;
    } else if (percentage >= 80) {
      percentageColor = Colors.blue;
    } else if (percentage >= 60) {
      percentageColor = Colors.orange;
    } else {
      percentageColor = Colors.red;
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.calculate, color: percentageColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Calculated Percentage',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: percentageColor,
                  ),
                ),
              ],
            ),
          ),
          if (percentage >= 100)
            Icon(Icons.check_circle, color: Colors.green, size: 24)
          else if (percentage >= 80)
            Icon(Icons.trending_up, color: Colors.blue, size: 24)
          else if (percentage >= 60)
            Icon(Icons.warning, color: Colors.orange, size: 24)
          else
            Icon(Icons.trending_down, color: Colors.red, size: 24),
        ],
      ),
    );
  }

  /// Build the submit button
  Widget _buildSubmitButton() {
    return Center(
      child: _isSubmitting
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(PalmColors.primary),
              ),
            )
          : PalmButton(
              text: widget.achievement == null ? 'Save Achievement' : 'Update Achievement',
              backgroundColor: PalmColors.primary,
              textColor: PalmColors.white,
              onPressed: _submitAchievement,
            ),
    );
  }
}
