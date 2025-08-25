import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/models/activities/training.dart';
import 'package:palm_ecommerce_mobile_app_2/models/activities/training_status.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/activities/traning/widgets/request_traning_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/activities/traning/widgets/training_list_tile.dart';
import 'package:palm_ecommerce_mobile_app_2/services/training_service.dart';
import 'package:palm_ecommerce_mobile_app_2/utils/training_ui_utils.dart';
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
  late TrainingService _trainingService;
  String _currentFilter = 'all';
  String _searchKeyword = '';
  
  @override
  void initState() {
    super.initState();
    _trainingService = TrainingService();
  }

  /// Get filtered trainings based on current filter and search
  List<Training> get filteredTrainings {
    List<Training> trainings;
    
    // Apply filter
    switch (_currentFilter) {
      case 'completed':
        trainings = _trainingService.getCompletedTrainings();
        break;
      case 'ongoing':
        trainings = _trainingService.getOngoingTrainings();
        break;
      case 'all':
      default:
        trainings = _trainingService.getAllTrainings();
        break;
    }
    
    // Apply search
    if (_searchKeyword.isNotEmpty) {
      trainings = _trainingService.searchTrainings(_searchKeyword);
    }
    
    return trainings;
  }

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
            icon: const Icon(Icons.search),
            color: PalmColors.white,
            onPressed: () => _showSearchDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            color: PalmColors.white,
            onPressed: () => _showFilterDialog(),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: PalmColors.white),
            onSelected: (value) {
              switch (value) {
                case 'statistics':
                  _showStatistics();
                  break;
                case 'add':
                  _navigateToAddTraining();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'statistics',
                child: Row(
                  children: [
                    Icon(Icons.analytics),
                    SizedBox(width: 8),
                    Text('Statistics'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'add',
                child: Row(
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text('Add Training'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: filteredTrainings.isEmpty ? _buildEmptyState() : _buildTrainingList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTraining(),
        backgroundColor: PalmColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// Build empty state widget
  Widget _buildEmptyState() {
    String title;
    String message;
    
    if (_searchKeyword.isNotEmpty) {
      title = 'No Results Found';
      message = 'No training records match your search for "$_searchKeyword".';
    } else {
      switch (_currentFilter) {
        case 'completed':
          title = 'No Completed Trainings';
          message = 'You don\'t have any completed training records yet.';
          break;
        case 'ongoing':
          title = 'No Ongoing Trainings';
          message = 'You don\'t have any ongoing training records.';
          break;
        case 'all':
        default:
          title = 'No Training Records Yet';
          message = 'Add your education and training history to keep track of your professional development.';
          break;
      }
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(PalmSpacings.l),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchKeyword.isNotEmpty ? Icons.search_off : Icons.school_outlined,
              size: 80,
              color: PalmColors.textLight,
            ),
            const SizedBox(height: PalmSpacings.l),
            Text(
              title,
              style: PalmTextStyles.title.copyWith(
                color: PalmColors.textNormal,
              ),
            ),
            const SizedBox(height: PalmSpacings.m),
            Text(
              message,
              style: PalmTextStyles.body.copyWith(
                color: PalmColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: PalmSpacings.xl),
            if (_searchKeyword.isNotEmpty)
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _searchKeyword = '';
                  });
                },
                icon: const Icon(Icons.clear),
                label: const Text('Clear Search'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: PalmSpacings.l,
                    vertical: PalmSpacings.m,
                  ),
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: () => _navigateToAddTraining(),
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
      padding: EdgeInsets.zero,
      itemCount: filteredTrainings.length,
      itemBuilder: (context, index) {
        final training = filteredTrainings[index];
        return TrainingListTile(
          training: training,
          onTap: () => _showTrainingDetails(training),
          onEdit: () => _editTraining(training),
          onDelete: () => _deleteTraining(training),
          onStatusChanged: (newStatus) => _changeTrainingStatusQuick(training, newStatus),
        );
      },
    );
  }

  /// Navigate to add training screen
  void _navigateToAddTraining() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TrainingScreen()),
    ).then((result) {
      // Add the new training to the list if one was created
      if (result != null && result is Training) {
        _trainingService.addTraining(result);
        setState(() {}); // Refresh UI
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Training record for "${result.universityOrTraining}" added successfully'),
            backgroundColor: PalmColors.success,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }

  /// Show search dialog
  void _showSearchDialog() {
    TrainingUIUtils.showSearchDialog(context, (keyword) {
      setState(() {
        _searchKeyword = keyword;
      });
    });
  }

  /// Show filter dialog
  void _showFilterDialog() {
    TrainingUIUtils.showFilterDialog(context, (filter) {
      setState(() {
        _currentFilter = filter;
      });
    });
  }

  /// Show statistics dialog
  void _showStatistics() {
    final stats = _trainingService.getTrainingStatistics();
    TrainingUIUtils.showTrainingStatistics(context, stats);
  }

  /// Show training details dialog
  void _showTrainingDetails(Training training) {
    TrainingUIUtils.showTrainingDetailsWithActions(
      context, 
      training, 
      _handleStatusChange,
    );
  }

  /// Edit training record
  void _editTraining(Training training) {
    // Check if training can be edited
    if (!_trainingService.canEditTraining(training)) {
      TrainingUIUtils.showErrorMessage(
        context,
        'This training record cannot be edited',
      );
      return;
    }
    
    // TODO: Implement edit functionality
    // Navigate to TrainingScreen with pre-filled data
    TrainingUIUtils.showInfoMessage(
      context,
      'Edit functionality will be implemented',
    );
  }

  /// Delete training record
  void _deleteTraining(Training training) {
    // Check if training can be deleted
    if (!_trainingService.canDeleteTraining(training)) {
      TrainingUIUtils.showErrorMessage(
        context,
        'This training record cannot be deleted',
      );
      return;
    }

    TrainingUIUtils.showDeleteConfirmation(
      context,
      training,
      () => _performDelete(training),
    );
  }

  /// Perform actual delete operation
  void _performDelete(Training training) {
    if (training.id == null) {
      TrainingUIUtils.showErrorMessage(
        context,
        'Training ID is missing',
      );
      return;
    }

    final success = _trainingService.deleteTraining(training.id!);
    if (success) {
      setState(() {}); // Refresh UI
      TrainingUIUtils.showSuccessMessage(
        context,
        'Training record deleted successfully',
      );
    } else {
      TrainingUIUtils.showErrorMessage(
        context,
        'Failed to delete training record',
      );
    }
  }

  /// Handle training status change
  void _handleStatusChange(Training training, TrainingStatus newStatus) {
    if (training.id == null) {
      TrainingUIUtils.showErrorMessage(
        context, 
        'Training ID is missing',
      );
      return;
    }
    
    final success = _trainingService.changeTrainingStatus(training.id!, newStatus);
    if (success) {
      setState(() {}); // Refresh UI
      TrainingUIUtils.showStatusChangeMessage(context, newStatus);
    } else {
      TrainingUIUtils.showErrorMessage(
        context, 
        'Failed to update training status',
      );
    }
  }

  /// Quick status change from list tile (without confirmation)
  void _changeTrainingStatusQuick(Training training, TrainingStatus newStatus) {
    if (training.id == null) {
      TrainingUIUtils.showErrorMessage(
        context, 
        'Training ID is missing',
      );
      return;
    }
    
    final success = _trainingService.changeTrainingStatus(training.id!, newStatus);
    if (success) {
      setState(() {}); // Refresh UI
      TrainingUIUtils.showStatusChangeMessage(context, newStatus);
    } else {
      TrainingUIUtils.showErrorMessage(
        context, 
        'Failed to update training status',
      );
    }
  }
}
