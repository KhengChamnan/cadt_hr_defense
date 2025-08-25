/// Training status enumeration
/// Represents the current status of a training/education record
enum TrainingStatus {
  /// Training is currently in progress
  inProgress,
  
  /// Training has been completed successfully
  completed,
  
  /// Training is planned but not yet started
  planned,
  
  /// Training has been paused/suspended
  paused,
  
  /// Training was cancelled or discontinued
  cancelled;

  /// Get display name for the status
  String get displayName {
    switch (this) {
      case TrainingStatus.inProgress:
        return 'In Progress';
      case TrainingStatus.completed:
        return 'Completed';
      case TrainingStatus.planned:
        return 'Planned';
      case TrainingStatus.paused:
        return 'Paused';
      case TrainingStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// Get color for the status
  static const Map<TrainingStatus, int> _colors = {
    TrainingStatus.inProgress: 0xFFFF9800, // Orange
    TrainingStatus.completed: 0xFF4CAF50,  // Green
    TrainingStatus.planned: 0xFF2196F3,    // Blue
    TrainingStatus.paused: 0xFF9E9E9E,     // Grey
    TrainingStatus.cancelled: 0xFFF44336,  // Red
  };

  /// Get color value for the status
  int get colorValue => _colors[this] ?? 0xFF9E9E9E;

  /// Get icon for the status
  static const Map<TrainingStatus, int> _icons = {
    TrainingStatus.inProgress: 0xe1c1, // Icons.schedule
    TrainingStatus.completed: 0xe86c,  // Icons.check_circle
    TrainingStatus.planned: 0xe8f4,    // Icons.event
    TrainingStatus.paused: 0xe034,     // Icons.pause_circle
    TrainingStatus.cancelled: 0xe5c9,  // Icons.cancel
  };

  /// Get icon code point for the status
  int get iconCodePoint => _icons[this] ?? 0xe8f4;
}
