class Achievement {
  final String? id;
  final String? employeeId;
  final String? achievementIndex;
  final String? achievementDescription;
  final String? keyApi;
  final String? subApi;
  final DateTime? fromDate;
  final DateTime? toDate;
  final double? targetAmount;
  final double? actualAchievement;
  final double? percentage;
  final String? remark;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Achievement({
    this.id,
    this.employeeId,
    this.achievementIndex,
    this.achievementDescription,
    this.keyApi,
    this.subApi,
    this.fromDate,
    this.toDate,
    this.targetAmount,
    this.actualAchievement,
    this.percentage,
    this.remark,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor for creating Achievement from JSON
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String?,
      employeeId: json['employee_id'] as String?,
      achievementIndex: json['achievement_index'] as String?,
      achievementDescription: json['achievement_description'] as String?,
      keyApi: json['key_api'] as String?,
      subApi: json['sub_api'] as String?,
      fromDate: json['from_date'] != null 
        ? DateTime.tryParse(json['from_date'].toString())
        : null,
      toDate: json['to_date'] != null 
        ? DateTime.tryParse(json['to_date'].toString())
        : null,
      targetAmount: json['target_amount'] != null
        ? double.tryParse(json['target_amount'].toString())
        : null,
      actualAchievement: json['actual_achievement'] != null
        ? double.tryParse(json['actual_achievement'].toString())
        : null,
      percentage: json['percentage'] != null
        ? double.tryParse(json['percentage'].toString())
        : null,
      remark: json['remark'] as String?,
      createdAt: json['created_at'] != null 
        ? DateTime.tryParse(json['created_at'].toString())
        : null,
      updatedAt: json['updated_at'] != null 
        ? DateTime.tryParse(json['updated_at'].toString())
        : null,
    );
  }

  // Method to convert Achievement to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'achievement_index': achievementIndex,
      'achievement_description': achievementDescription,
      'key_api': keyApi,
      'sub_api': subApi,
      'from_date': fromDate?.toIso8601String(),
      'to_date': toDate?.toIso8601String(),
      'target_amount': targetAmount,
      'actual_achievement': actualAchievement,
      'percentage': percentage,
      'remark': remark,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Method to create a copy with modified fields
  Achievement copyWith({
    String? id,
    String? employeeId,
    String? achievementIndex,
    String? achievementDescription,
    String? keyApi,
    String? subApi,
    DateTime? fromDate,
    DateTime? toDate,
    double? targetAmount,
    double? actualAchievement,
    double? percentage,
    String? remark,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Achievement(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      achievementIndex: achievementIndex ?? this.achievementIndex,
      achievementDescription: achievementDescription ?? this.achievementDescription,
      keyApi: keyApi ?? this.keyApi,
      subApi: subApi ?? this.subApi,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      targetAmount: targetAmount ?? this.targetAmount,
      actualAchievement: actualAchievement ?? this.actualAchievement,
      percentage: percentage ?? this.percentage,
      remark: remark ?? this.remark,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Method to calculate percentage automatically
  double calculatePercentage() {
    if (targetAmount != null && targetAmount! > 0 && actualAchievement != null) {
      return (actualAchievement! / targetAmount!) * 100;
    }
    return 0.0;
  }

  // Method to check if achievement target is met
  bool isTargetMet() {
    return actualAchievement != null && 
           targetAmount != null && 
           actualAchievement! >= targetAmount!;
  }

  // Method to get achievement status
  String getAchievementStatus() {
    if (actualAchievement == null || targetAmount == null) {
      return 'Incomplete';
    }
    
    double percent = calculatePercentage();
    if (percent >= 100) {
      return 'Achieved';
    } else if (percent >= 80) {
      return 'Nearly Achieved';
    } else if (percent >= 50) {
      return 'In Progress';
    } else {
      return 'Below Target';
    }
  }

  // Method to validate achievement data
  bool isValid() {
    return achievementIndex != null && 
           achievementIndex!.isNotEmpty &&
           achievementDescription != null && 
           achievementDescription!.isNotEmpty &&
           fromDate != null &&
           toDate != null &&
           targetAmount != null &&
           targetAmount! > 0;
  }

  // Employee-specific methods for submission workflow

  // Check if achievement is editable by employee
  bool get isEditableByEmployee {
    // Employee can edit if it's within 30 days of creation
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(Duration(days: 30));
    
    return createdAt != null && 
           createdAt!.isAfter(thirtyDaysAgo);
  }

  // Get achievement progress status for employee view
  String getProgressStatus() {
    if (actualAchievement == null || targetAmount == null) {
      return 'Not Started';
    }

    final percentage = calculatePercentage();
    
    if (percentage >= 100) {
      return 'Target Exceeded ✅';
    } else if (percentage >= 80) {
      return 'Near Target 🎯';
    } else if (percentage >= 50) {
      return 'In Progress 📈';
    } else if (percentage > 0) {
      return 'Started 🚀';
    } else {
      return 'Not Started ❌';
    }
  }

  // Format percentage for display
  String get formattedPercentage {
    final percent = calculatePercentage();
    return '${percent.toStringAsFixed(1)}%';
  }

  // Check if achievement needs attention (incomplete with approaching deadline)
  bool get needsAttention {
    if (toDate == null || actualAchievement == null || targetAmount == null) {
      return false;
    }

    final now = DateTime.now();
    final daysUntilDeadline = toDate!.difference(now).inDays;
    final completionPercentage = calculatePercentage();

    // Needs attention if less than 80% complete and less than 7 days remaining
    return daysUntilDeadline <= 7 && completionPercentage < 80;
  }

  // Create achievement from employee form data
  static Achievement fromEmployeeForm({
    String? id, // Optional ID parameter
    required String achievementIndex,
    required String achievementDescription,
    String? keyApi,
    String? subApi,
    required DateTime fromDate,
    required DateTime toDate,
    required double targetAmount,
    required double actualAchievement,
    String? remark,
  }) {
    final calculatedPercentage = targetAmount > 0 
        ? (actualAchievement / targetAmount) * 100 
        : 0.0;

    return Achievement(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(), // Generate ID if not provided
      achievementIndex: achievementIndex,
      achievementDescription: achievementDescription,
      keyApi: keyApi,
      subApi: subApi,
      fromDate: fromDate,
      toDate: toDate,
      targetAmount: targetAmount,
      actualAchievement: actualAchievement,
      percentage: calculatedPercentage,
      remark: remark,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

// Extension for list operations
extension AchievementListExtension on List<Achievement> {
  // Get total target amount
  double get totalTargetAmount {
    return fold(0.0, (sum, achievement) => sum + (achievement.targetAmount ?? 0.0));
  }

  // Get total actual achievement
  double get totalActualAchievement {
    return fold(0.0, (sum, achievement) => sum + (achievement.actualAchievement ?? 0.0));
  }

  // Get overall percentage
  double get overallPercentage {
    double total = totalTargetAmount;
    if (total > 0) {
      return (totalActualAchievement / total) * 100;
    }
    return 0.0;
  }

  // Filter achievements by status
  List<Achievement> filterByStatus(String status) {
    return where((achievement) => achievement.getAchievementStatus() == status).toList();
  }

  // Filter achievements by date range
  List<Achievement> filterByDateRange(DateTime start, DateTime end) {
    return where((achievement) => 
      achievement.fromDate != null &&
      achievement.toDate != null &&
      achievement.fromDate!.isAfter(start.subtract(Duration(days: 1))) &&
      achievement.toDate!.isBefore(end.add(Duration(days: 1)))
    ).toList();
  }

  // Employee-specific list operations
  
  // Get achievements for specific employee
  List<Achievement> forEmployee(String employeeId) {
    return where((achievement) => achievement.employeeId == employeeId).toList();
  }

  // Get achievements that need attention (approaching deadline with low completion)
  List<Achievement> get needingAttention {
    return where((achievement) => achievement.needsAttention).toList();
  }

  // Get completed achievements (100% or more)
  List<Achievement> get completed {
    return where((achievement) => achievement.calculatePercentage() >= 100).toList();
  }

  // Get in-progress achievements
  List<Achievement> get inProgress {
    return where((achievement) {
      final percentage = achievement.calculatePercentage();
      return percentage > 0 && percentage < 100;
    }).toList();
  }

  // Get achievements by month/year
  List<Achievement> filterByMonth(int year, int month) {
    return where((achievement) =>
      achievement.fromDate != null &&
      achievement.fromDate!.year == year &&
      achievement.fromDate!.month == month
    ).toList();
  }

  // Get employee's target vs actual summary
  Map<String, double> getEmployeeSummary() {
    return {
      'totalTarget': totalTargetAmount,
      'totalActual': totalActualAchievement,
      'overallPercentage': overallPercentage,
      'completedCount': completed.length.toDouble(),
      'totalCount': length.toDouble(),
    };
  }
}