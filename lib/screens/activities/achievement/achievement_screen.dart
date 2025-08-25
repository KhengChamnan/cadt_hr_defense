import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/activities/achievement/widgets/achievement_form_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import '../../../models/activities/achievements.dart';
import 'widgets/achievement_list_tile.dart';
import 'widgets/achievement_progress_card.dart';

/// This screen allows employees to:
/// - Submit their own achievements with automatic percentage calculation
/// - View their target vs actual progress
/// - Add remarks for incomplete goals
/// - View their achievement history and progress
class AchievementScreen extends StatefulWidget {
  const AchievementScreen({
    super.key,
  });

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Achievement> _achievements = [];
  bool _isLoading = false;



  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAchievements();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Load employee's achievements from service
  Future<void> _loadAchievements() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Replace with actual service call
      await Future.delayed(Duration(seconds: 1)); // Simulate API call
      
      // Sample data for demonstration
      _achievements = [
        Achievement.fromEmployeeForm(
          id: "ACH001",
          achievementIndex: "CS001",
          achievementDescription: "Complete customer service training",
          keyApi: "Customer Service",
          subApi: "Basic Training",
          fromDate: DateTime(2025, 6, 1),
          toDate: DateTime(2025, 6, 30),
          targetAmount: 10.0,
          actualAchievement: 8.0,
          remark: "Good progress, need 2 more sessions",
        ),
        Achievement.fromEmployeeForm(
          id: "ACH002",
          achievementIndex: "SAL002",
          achievementDescription: "Monthly sales target",
          keyApi: "Sales",
          subApi: "Monthly Target",
          fromDate: DateTime(2025, 7, 1),
          toDate: DateTime(2025, 7, 31),
          targetAmount: 50000.0,
          actualAchievement: 62000.0,
          remark: "Exceeded target due to new client acquisitions",
        ),
      ];
      
    } catch (e) {
      _showErrorSnackbar('Failed to load achievements: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Add new achievement to the list
  void _addAchievement(Achievement achievement) {
    setState(() {
      _achievements.add(achievement);
    });
    _showSuccessSnackbar('Achievement submitted successfully!');
  }

  /// Update existing achievement
  void _updateAchievement(Achievement updatedAchievement) {
    setState(() {
      final index = _achievements.indexWhere(
        (a) => a.id == updatedAchievement.id,
      );
      if (index != -1) {
        _achievements[index] = updatedAchievement;
      }
    });
    _showSuccessSnackbar('Achievement updated successfully!');
  }

  /// Show success message
  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: PalmColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show error message
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: PalmColors.danger,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Navigate to add achievement screen
  void _navigateToAddAchievement() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AchievementFormScreen(
          onSubmit: (achievement) {
            _addAchievement(achievement);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PalmColors.white,
      appBar: AppBar(
        title: Text(
          'My Achievements',
          style: PalmTextStyles.title.copyWith(color: Colors.white),
        ),
        backgroundColor: PalmColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          tabs: const [
            Tab(
              icon: Icon(Icons.dashboard_outlined),
              text: 'Overview',
            ),
            Tab(
              icon: Icon(Icons.history),
              text: 'History',
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildHistoryTab(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddAchievement(),
        backgroundColor: PalmColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// Build overview tab with progress summary
  Widget _buildOverviewTab() {
    final summary = _achievements.getEmployeeSummary();
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(PalmSpacings.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          // Progress summary card
          AchievementProgressCard(
            totalTarget: summary['totalTarget'] ?? 0.0,
            totalActual: summary['totalActual'] ?? 0.0,
            overallPercentage: summary['overallPercentage'] ?? 0.0,
            completedCount: summary['completedCount']?.toInt() ?? 0,
            totalCount: summary['totalCount']?.toInt() ?? 0,
          ),
          
          SizedBox(height: PalmSpacings.l),
          
         
          
          SizedBox(height: PalmSpacings.l),
              ],
            ),
          ),
          
          // Recent achievements section header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: PalmSpacings.m),
            child: Text(
              'Recent Achievements',
              style: PalmTextStyles.title,
            ),
          ),
          SizedBox(height: PalmSpacings.m),
          
          // Recent achievements list (full width)
          ..._achievements.take(3).map(
            (achievement) => AchievementListTile(
              achievement: achievement,
              onTap: () => _showAchievementDetails(achievement),
              canEdit: achievement.isEditableByEmployee,
              onEdit: achievement.isEditableByEmployee
                  ? () => _editAchievement(achievement)
                  : null,
              onQuickUpdate: achievement.isEditableByEmployee
                  ? () => _quickUpdateActual(achievement)
                  : null,
            ),
          ),
          
          if (_achievements.length > 3)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: PalmSpacings.m),
              child: Center(
                child: TextButton(
                  onPressed: () => _tabController.animateTo(1),
                  child: Text('View All Achievements'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build achievement history tab
  Widget _buildHistoryTab() {
    if (_achievements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assessment_outlined,
              size: 64,
              color: PalmColors.textLight,
            ),
            SizedBox(height: PalmSpacings.m),
            Text(
              'No achievements yet',
              style: PalmTextStyles.body.copyWith(
                color: PalmColors.textNormal,
              ),
            ),
            SizedBox(height: PalmSpacings.s),
            Text(
              'Tap the + button to add your first achievement',
              style: PalmTextStyles.label.copyWith(
                color: PalmColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _achievements.length,
      itemBuilder: (context, index) {
        final achievement = _achievements[index];
        return AchievementListTile(
          achievement: achievement,
          onTap: () => _showAchievementDetails(achievement),
          canEdit: achievement.isEditableByEmployee,
          onEdit: achievement.isEditableByEmployee
              ? () => _editAchievement(achievement)
              : null,
          onQuickUpdate: achievement.isEditableByEmployee
              ? () => _quickUpdateActual(achievement)
              : null,
        );
      },
    );
  }

  /// Build a statistics card
  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(PalmSpacings.m),
      decoration: BoxDecoration(
        color: PalmColors.backgroundAccent,
        borderRadius: BorderRadius.circular(PalmSpacings.radius),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: PalmIcons.size,
          ),
          SizedBox(height: PalmSpacings.s),
          Text(
            value,
            style: PalmTextStyles.title.copyWith(
              color: color,
            ),
          ),
          Text(
            title,
            style: PalmTextStyles.label.copyWith(
              color: PalmColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Show achievement details in a dialog
  void _showAchievementDetails(Achievement achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(achievement.achievementDescription ?? 'Achievement'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Index', achievement.achievementIndex),
              _buildDetailRow('Key API', achievement.keyApi),
              _buildDetailRow('Sub API', achievement.subApi),
              _buildDetailRow('Period', 
                '${achievement.fromDate?.toString().split(' ')[0]} - ${achievement.toDate?.toString().split(' ')[0]}'),
              _buildDetailRow('Target', '${achievement.targetAmount}'),
              _buildDetailRow('Actual', '${achievement.actualAchievement}'),
              _buildDetailRow('Progress', achievement.formattedPercentage),
              _buildDetailRow('Status', achievement.getProgressStatus()),
              if (achievement.remark?.isNotEmpty == true)
                _buildDetailRow('Remarks', achievement.remark),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
          if (achievement.isEditableByEmployee)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _quickUpdateActual(achievement);
              },
              child: Text('Quick Update'),
            ),
          if (achievement.isEditableByEmployee)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _editAchievement(achievement);
              },
              child: Text('Edit'),
            ),
        ],
      ),
    );
  }

  /// Build detail row for achievement details
  Widget _buildDetailRow(String label, String? value) {
    if (value == null || value.isEmpty) return SizedBox.shrink();
    
    return Padding(
      padding: EdgeInsets.only(bottom: PalmSpacings.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: PalmTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: PalmTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }

  /// Edit existing achievement
  void _editAchievement(Achievement achievement) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AchievementFormScreen(
          achievement: achievement,
          onSubmit: (updatedAchievement) {
            _updateAchievement(updatedAchievement);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  /// Quick update for actual achievement value
  void _quickUpdateActual(Achievement achievement) {
    final TextEditingController actualController = TextEditingController(
      text: achievement.actualAchievement?.toString() ?? '0.0',
    );
    final TextEditingController remarkController = TextEditingController(
      text: achievement.remark ?? '',
    );

    final double targetAmount = achievement.targetAmount ?? 0.0;
    final double currentPercentage = achievement.calculatePercentage();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quick Update'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              achievement.achievementDescription ?? 'Achievement',
              style: PalmTextStyles.body.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: PalmSpacings.s),
            Text('Target: ${achievement.targetAmount}'),
            SizedBox(height: PalmSpacings.m),
            TextField(
              controller: actualController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Actual Achievement',
                border: OutlineInputBorder(),
                helperText: 'Enter your current progress',
                suffixText: currentPercentage > 0 ? '${currentPercentage.toStringAsFixed(1)}%' : null,
                suffixStyle: TextStyle(
                  color: currentPercentage >= 100
                      ? PalmColors.success
                      : currentPercentage >= 80
                          ? PalmColors.secondary
                          : currentPercentage >= 50
                              ? PalmColors.warning
                              : PalmColors.danger,
                  fontWeight: FontWeight.bold,
                ),
              ),
              autofocus: true,
              onChanged: (value) {
                // This could be enhanced to update the percentage display in real-time
              },
            ),
            SizedBox(height: PalmSpacings.m),
            TextField(
              controller: remarkController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Remarks (Optional)',
                border: OutlineInputBorder(),
                helperText: 'Add notes or explain your progress',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newActual = double.tryParse(actualController.text);
              if (newActual != null) {
                final newPercentage = targetAmount > 0 ? (newActual / targetAmount) * 100 : 0.0;
                final updatedAchievement = achievement.copyWith(
                  actualAchievement: newActual,
                  percentage: newPercentage,
                  remark: remarkController.text.trim(),
                  updatedAt: DateTime.now(),
                );
                _updateAchievement(updatedAchievement);
                Navigator.of(context).pop();
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }
}
