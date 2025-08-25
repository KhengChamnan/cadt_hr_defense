import 'package:palm_ecommerce_mobile_app_2/models/activities/training.dart';
import 'package:palm_ecommerce_mobile_app_2/models/activities/training_status.dart';

/// Service for managing training records business logic
/// - Manages training data operations
/// - Handles training validation
/// - Provides filtering and formatting utilities
/// - Manages training statistics
class TrainingService {
  static final TrainingService _instance = TrainingService._internal();
  factory TrainingService() => _instance;
  TrainingService._internal();

  // Sample data - in real app, this would come from API/database
  List<Training> _trainings = [
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
      status: TrainingStatus.completed,
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
      status: TrainingStatus.inProgress,
      createdAt: DateTime.now(),
    ),
    Training(
      id: '3',
      universityOrTraining: 'PUC',
      place: 'Phnom Penh',
      country: 'Cambodia',
      fromDate: DateTime(2025, 1, 1),
      toDate: DateTime(2025, 6, 30),
      degree: 'Digital Marketing Certificate',
      mainCourseOfStudy: 'Digital Marketing',
      description: 'Online marketing strategies and analytics',
      status: TrainingStatus.planned,
      createdAt: DateTime.now(),
    ),
  ];

  /// Get all training records
  List<Training> getAllTrainings() {
    return List.unmodifiable(_trainings);
  }

  /// Get completed training records only
  List<Training> getCompletedTrainings() {
    return _trainings.where((training) {
      return training.status == TrainingStatus.completed;
    }).toList();
  }

  /// Get ongoing training records only
  List<Training> getOngoingTrainings() {
    return _trainings.where((training) {
      return training.status == TrainingStatus.inProgress;
    }).toList();
  }

  /// Get trainings by institution
  List<Training> getTrainingsByInstitution(String institution) {
    return _trainings.where((training) {
      return training.universityOrTraining?.toLowerCase().contains(institution.toLowerCase()) ?? false;
    }).toList();
  }

  /// Get trainings by country
  List<Training> getTrainingsByCountry(String country) {
    return _trainings.where((training) {
      return training.country?.toLowerCase() == country.toLowerCase();
    }).toList();
  }

  /// Get trainings by degree type
  List<Training> getTrainingsByDegree(String degree) {
    return _trainings.where((training) {
      return training.degree?.toLowerCase().contains(degree.toLowerCase()) ?? false;
    }).toList();
  }

  /// Add new training record
  void addTraining(Training training) {
    final newTraining = training.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _trainings.insert(0, newTraining); // Add to beginning of list
  }

  /// Update existing training record
  bool updateTraining(Training updatedTraining) {
    final index = _trainings.indexWhere((training) => training.id == updatedTraining.id);
    if (index != -1) {
      _trainings[index] = updatedTraining.copyWith(
        updatedAt: DateTime.now(),
      );
      return true;
    }
    return false;
  }

  /// Delete training record by ID
  bool deleteTraining(String trainingId) {
    final initialLength = _trainings.length;
    _trainings.removeWhere((training) => training.id == trainingId);
    return _trainings.length < initialLength;
  }

  /// Validate training record
  bool validateTraining(Training training) {
    return training.isValid;
  }

  /// Get validation error message for training
  String? getValidationError(Training training) {
    return training.validationError;
  }

  /// Check if training can be edited
  bool canEditTraining(Training training) {
    // All trainings can be edited for now
    // In future, might add business rules like "cannot edit approved trainings"
    return true;
  }

  /// Check if training can be deleted
  bool canDeleteTraining(Training training) {
    // All trainings can be deleted for now
    // In future, might add business rules like "cannot delete verified trainings"
    return true;
  }

  /// Search trainings by keyword
  List<Training> searchTrainings(String keyword) {
    if (keyword.trim().isEmpty) {
      return getAllTrainings();
    }

    final searchTerm = keyword.toLowerCase().trim();
    return _trainings.where((training) {
      return (training.universityOrTraining?.toLowerCase().contains(searchTerm) ?? false) ||
             (training.place?.toLowerCase().contains(searchTerm) ?? false) ||
             (training.country?.toLowerCase().contains(searchTerm) ?? false) ||
             (training.degree?.toLowerCase().contains(searchTerm) ?? false) ||
             (training.mainCourseOfStudy?.toLowerCase().contains(searchTerm) ?? false) ||
             (training.description?.toLowerCase().contains(searchTerm) ?? false);
    }).toList();
  }

  /// Get training statistics
  TrainingStatistics getTrainingStatistics() {
    final total = _trainings.length;
    final completed = getTrainingsByStatus(TrainingStatus.completed).length;
    final ongoing = getTrainingsByStatus(TrainingStatus.inProgress).length;
    final planned = getTrainingsByStatus(TrainingStatus.planned).length;
    final paused = getTrainingsByStatus(TrainingStatus.paused).length;
    final cancelled = getTrainingsByStatus(TrainingStatus.cancelled).length;
    
    // Count unique institutions
    final institutions = _trainings
        .where((t) => t.universityOrTraining != null)
        .map((t) => t.universityOrTraining!)
        .toSet()
        .length;
    
    // Count unique countries
    final countries = _trainings
        .where((t) => t.country != null)
        .map((t) => t.country!)
        .toSet()
        .length;

    // Count degrees
    final degrees = _trainings
        .where((t) => t.degree != null)
        .map((t) => t.degree!)
        .toSet()
        .length;

    return TrainingStatistics(
      total: total,
      completed: completed,
      ongoing: ongoing,
      planned: planned,
      paused: paused,
      cancelled: cancelled,
      uniqueInstitutions: institutions,
      uniqueCountries: countries,
      uniqueDegrees: degrees,
    );
  }

  /// Get most common institutions
  List<String> getMostCommonInstitutions({int limit = 5}) {
    final institutionCounts = <String, int>{};
    
    for (final training in _trainings) {
      if (training.universityOrTraining != null) {
        institutionCounts[training.universityOrTraining!] = 
            (institutionCounts[training.universityOrTraining!] ?? 0) + 1;
      }
    }
    
    final sorted = institutionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sorted.take(limit).map((e) => e.key).toList();
  }

  /// Get most common degrees
  List<String> getMostCommonDegrees({int limit = 5}) {
    final degreeCounts = <String, int>{};
    
    for (final training in _trainings) {
      if (training.degree != null) {
        degreeCounts[training.degree!] = 
            (degreeCounts[training.degree!] ?? 0) + 1;
      }
    }
    
    final sorted = degreeCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sorted.take(limit).map((e) => e.key).toList();
  }

  /// Format training duration for display
  String formatTrainingDuration(Training training) {
    return training.actualDuration;
  }

  /// Check if training is currently ongoing
  bool isTrainingOngoing(Training training) {
    return training.toDate == null || training.toDate!.isAfter(DateTime.now());
  }

  /// Check if training is completed
  bool isTrainingCompleted(Training training) {
    return training.toDate != null && training.toDate!.isBefore(DateTime.now());
  }

  /// Get training by ID
  Training? getTrainingById(String id) {
    try {
      return _trainings.firstWhere((training) => training.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Sort trainings by date (newest first)
  List<Training> sortTrainingsByDate({bool descending = true}) {
    final sorted = List<Training>.from(_trainings);
    sorted.sort((a, b) {
      final aDate = a.fromDate ?? DateTime(1900);
      final bDate = b.fromDate ?? DateTime(1900);
      return descending ? bDate.compareTo(aDate) : aDate.compareTo(bDate);
    });
    return sorted;
  }

  /// Sort trainings by institution name
  List<Training> sortTrainingsByInstitution({bool ascending = true}) {
    final sorted = List<Training>.from(_trainings);
    sorted.sort((a, b) {
      final aInstitution = a.universityOrTraining ?? '';
      final bInstitution = b.universityOrTraining ?? '';
      return ascending 
          ? aInstitution.compareTo(bInstitution)
          : bInstitution.compareTo(aInstitution);
    });
    return sorted;
  }

  /// Change training status
  bool changeTrainingStatus(String trainingId, TrainingStatus newStatus) {
    final index = _trainings.indexWhere((training) => training.id == trainingId);
    if (index != -1) {
      final training = _trainings[index];
      _trainings[index] = training.copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
        // Update toDate to current time when marking as completed
        toDate: newStatus == TrainingStatus.completed && training.toDate == null
            ? DateTime.now()
            : training.toDate,
      );
      return true;
    }
    return false;
  }

  /// Mark training as in progress
  bool markTrainingAsInProgress(String trainingId) {
    return changeTrainingStatus(trainingId, TrainingStatus.inProgress);
  }

  /// Mark training as completed
  bool markTrainingAsCompleted(String trainingId) {
    return changeTrainingStatus(trainingId, TrainingStatus.completed);
  }

  /// Mark training as paused
  bool markTrainingAsPaused(String trainingId) {
    return changeTrainingStatus(trainingId, TrainingStatus.paused);
  }

  /// Mark training as cancelled
  bool markTrainingAsCancelled(String trainingId) {
    return changeTrainingStatus(trainingId, TrainingStatus.cancelled);
  }

  /// Get trainings by status
  List<Training> getTrainingsByStatus(TrainingStatus status) {
    return _trainings.where((training) => training.status == status).toList();
  }

  /// Get training completion rate as percentage
  double getCompletionRate() {
    if (_trainings.isEmpty) return 0.0;
    final completedCount = _trainings.where((t) => t.status == TrainingStatus.completed).length;
    return (completedCount / _trainings.length) * 100;
  }

  /// Check if training can be started (must be planned)
  bool canStartTraining(String trainingId) {
    final training = getTrainingById(trainingId);
    return training?.status == TrainingStatus.planned;
  }

  /// Check if training can be completed (must be in progress)
  bool canCompleteTraining(String trainingId) {
    final training = getTrainingById(trainingId);
    return training?.status == TrainingStatus.inProgress;
  }

  /// Check if training can be paused (must be in progress)
  bool canPauseTraining(String trainingId) {
    final training = getTrainingById(trainingId);
    return training?.status == TrainingStatus.inProgress;
  }

  /// Check if training can be resumed (must be paused)
  bool canResumeTraining(String trainingId) {
    final training = getTrainingById(trainingId);
    return training?.status == TrainingStatus.paused;
  }

  /// Resume training (from paused to in progress)
  bool resumeTraining(String trainingId) {
    if (canResumeTraining(trainingId)) {
      return changeTrainingStatus(trainingId, TrainingStatus.inProgress);
    }
    return false;
  }
}

/// Training statistics data class
class TrainingStatistics {
  final int total;
  final int completed;
  final int ongoing;
  final int planned;
  final int paused;
  final int cancelled;
  final int uniqueInstitutions;
  final int uniqueCountries;
  final int uniqueDegrees;

  TrainingStatistics({
    required this.total,
    required this.completed,
    required this.ongoing,
    required this.planned,
    required this.paused,
    required this.cancelled,
    required this.uniqueInstitutions,
    required this.uniqueCountries,
    required this.uniqueDegrees,
  });

  double get completionRate => total > 0 ? (completed / total) * 100 : 0.0;
  double get ongoingRate => total > 0 ? (ongoing / total) * 100 : 0.0;
  double get plannedRate => total > 0 ? (planned / total) * 100 : 0.0;
}
