import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/models/activities/training.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/activities/traning/widgets/request_traning_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/activities/traning/widgets/training_list_tile.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// Training Overview Screen
/// - Displays all training records
/// - Allows adding new training
/// - Provides edit/delete functionality
class TrainingOverviewScreen extends StatefulWidget {
  const TrainingOverviewScreen({super.key});

  @override
  State<TrainingOverviewScreen> createState() => _TrainingOverviewScreenState();
}

class _TrainingOverviewScreenState extends State<TrainingOverviewScreen> {
  // Sample training data - replace with actual data from provider/service
  List<Training> trainings = [
    Training(
      id: '1',
      universityOrTraining: 'RUPP',
      place: 'Phnom Penh',
      country: 'Cambodia',
      fromDate: DateTime(2020, 9, 1),
      toDate: DateTime(2024, 6, 30),
      degree: 'IT Bachelor',
      mainCourseOfStudy: 'Computer Science',
      description: 'Focused on software development and database management',
      createdAt: DateTime.now(),
    ),
    Training(
      id: '2',
      universityOrTraining: 'ACE',
      place: 'Phnom Penh',
      country: 'Cambodia',
      fromDate: DateTime(2024, 7, 1),
      toDate: DateTime(2024, 12, 31),
      degree: 'MBA',
      mainCourseOfStudy: 'Business Administration',
      description: 'Advanced management and leadership training',
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Training Records',
          style: TextStyle(color: PalmColors.white),
        ),
        backgroundColor: PalmColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: PalmColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: PalmColors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TrainingScreen()),
              ).then((_) {
                // Refresh the list when returning from add screen
                setState(() {
                  // In a real app, this would refetch data from the API
                });
              });
            },
          ),
        ],
      ),
      body: trainings.isEmpty ? _buildEmptyState() : _buildTrainingList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TrainingScreen()),
          ).then((_) {
            // Refresh the list when returning from add screen
            setState(() {
              // In a real app, this would refetch data from the API
            });
          });
        },
        backgroundColor: PalmColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// Build empty state widget
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(PalmSpacings.l),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 80,
              color: PalmColors.textLight,
            ),
            const SizedBox(height: PalmSpacings.l),
            Text(
              'No Training Records Yet',
              style: PalmTextStyles.title.copyWith(
                color: PalmColors.textNormal,
              ),
            ),
            const SizedBox(height: PalmSpacings.m),
            Text(
              'Add your education and training history to keep track of your professional development.',
              style: PalmTextStyles.body.copyWith(
                color: PalmColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: PalmSpacings.xl),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TrainingScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Training'),
              style: ElevatedButton.styleFrom(
                backgroundColor: PalmColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: PalmSpacings.l,
                  vertical: PalmSpacings.m,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build training list widget
  Widget _buildTrainingList() {
    return ListView.builder(
      padding: EdgeInsets.zero, // Remove padding for seamless full-width tiles
      itemCount: trainings.length,
      itemBuilder: (context, index) {
        final training = trainings[index];
        return Column(
          children: [
            TrainingListTile(
              training: training,
              onTap: () {
                // Handle tap to view details
                _showTrainingDetails(training);
              },
              onEdit: () {
                // Handle edit
                _editTraining(training);
              },
              onDelete: () {
                // Handle delete
                _deleteTraining(training);
              },
            ),
            // Add spacing between tiles - only vertical spacing
            if (index < trainings.length - 1)
              const SizedBox(height: PalmSpacings.s),
          ],
        );
      },
    );
  }

  /// Show training details dialog
  void _showTrainingDetails(Training training) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(training.universityOrTraining ?? 'Training Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Institution', training.universityOrTraining),
                _buildDetailRow('Place', training.place),
                _buildDetailRow('Country', training.country),
                _buildDetailRow('Duration', training.durationText),
                _buildDetailRow('Degree', training.degree),
                _buildDetailRow('Course of Study', training.mainCourseOfStudy),
                if (training.description != null && training.description!.isNotEmpty)
                  _buildDetailRow('Description', training.description),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  /// Build detail row widget
  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value ?? 'Not specified'),
          ),
        ],
      ),
    );
  }

  /// Edit training record
  void _editTraining(Training training) {
    // TODO: Implement edit functionality
    // Navigate to TrainingScreen with pre-filled data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit functionality will be implemented'),
      ),
    );
  }

  /// Delete training record
  void _deleteTraining(Training training) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Training'),
          content: Text(
            'Are you sure you want to delete this training record from ${training.universityOrTraining}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  trainings.remove(training);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Training record deleted'),
                  ),
                );
              },
              child: const Text('Delete'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }
}
