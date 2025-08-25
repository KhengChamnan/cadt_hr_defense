import 'package:palm_ecommerce_mobile_app_2/models/activities/training_status.dart';

class Training {
  final String? id;
  final String? universityOrTraining;
  final bool isManualUniversity;
  final String? place;
  final String? country;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? degree;
  final String? mainCourseOfStudy;
  final String? description;
  final TrainingStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Training({
    this.id,
    this.universityOrTraining,
    this.isManualUniversity = false,
    this.place,
    this.country,
    this.fromDate,
    this.toDate,
    this.degree,
    this.mainCourseOfStudy,
    this.description,
    this.status = TrainingStatus.planned,
    this.createdAt,
    this.updatedAt,
  });

  // Common university/training options for dropdown
  static const List<String> commonUniversities = [
  'RUPP', // Royal University of Phnom Penh
  'ACE',  // ACE
  'PUC',  // Pannasastra University of Cambodia
  'NUM',  // National University of Management
  'NIB',  // National Institute of Business
  'CUS',  // CUS
  'CICI', // CICI
  'Personal Company', // Personal Company
  'Other (Manual Input)',
  ];

  // Common degree/qualification options for dropdown
  static const List<String> degreeOptions = [
    'IT Bachelor',
    'MBA',
    'PHD',
    'BBA',
  ];

  //Country options for dropdown
  static const List<String> countryOptions = [ 
    'Cambodia',
    'Thailand',
    'Vietnam',
    'Laos',
    'Myanmar',
    'Malaysia',
    'Singapore',
    'Indonesia',
    'Philippines',
    'Brunei',
    'Other (Manual Input)',
  ];

  // Copy with method
  Training copyWith({
    String? id,
    String? universityOrTraining,
    bool? isManualUniversity,
    String? place,
    String? country,
    DateTime? fromDate,
    DateTime? toDate,
    String? degree,
    String? mainCourseOfStudy,
    String? description,
    TrainingStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Training(
      id: id ?? this.id,
      universityOrTraining: universityOrTraining ?? this.universityOrTraining,
      isManualUniversity: isManualUniversity ?? this.isManualUniversity,
      place: place ?? this.place,
      country: country ?? this.country,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      degree: degree ?? this.degree,
      mainCourseOfStudy: mainCourseOfStudy ?? this.mainCourseOfStudy,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }



  // To string
  @override
  String toString() {
    return 'Training{id: $id, universityOrTraining: $universityOrTraining, place: $place, country: $country, fromDate: $fromDate, toDate: $toDate, degree: $degree, mainCourseOfStudy: $mainCourseOfStudy, status: $status}';
  }

  // Equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Training &&
        other.id == id &&
        other.universityOrTraining == universityOrTraining &&
        other.isManualUniversity == isManualUniversity &&
        other.place == place &&
        other.country == country &&
        other.fromDate == fromDate &&
        other.toDate == toDate &&
        other.degree == degree &&
        other.mainCourseOfStudy == mainCourseOfStudy &&
        other.description == description &&
        other.status == status;
  }

  // Hash code
  @override
  int get hashCode {
    return Object.hash(
      id,
      universityOrTraining,
      isManualUniversity,
      place,
      country,
      fromDate,
      toDate,
      degree,
      mainCourseOfStudy,
      description,
      status,
    );
  }

  // Validation methods
  bool get isValid {
    return universityOrTraining != null && 
           universityOrTraining!.isNotEmpty &&
           place != null && 
           place!.isNotEmpty &&
           country != null && 
           country!.isNotEmpty &&
           fromDate != null;
  }

  String? get validationError {
    if (universityOrTraining == null || universityOrTraining!.isEmpty) {
      return 'University/Training is required';
    }
    if (place == null || place!.isEmpty) {
      return 'Place is required';
    }
    if (country == null || country!.isEmpty) {
      return 'Country is required';
    }
    if (fromDate == null) {
      return 'From date is required';
    }
    if (toDate != null && fromDate != null && toDate!.isBefore(fromDate!)) {
      return 'To date must be after from date';
    }
    return null;
  }

  // Helper getters
  String get durationText {
    if (fromDate == null) return '';
    
    final from = '${fromDate!.month}/${fromDate!.year}';
    if (toDate == null) {
      return '$from - Present';
    }
    final to = '${toDate!.month}/${toDate!.year}';
    return '$from - $to';
  }

  /// Calculate the actual duration in months/years for display
  String get actualDuration {
    if (fromDate == null) return '';
    
    final DateTime endDate = toDate ?? DateTime.now();
    final int totalMonths = (endDate.year - fromDate!.year) * 12 + (endDate.month - fromDate!.month);
    
    if (totalMonths < 1) {
      return '< 1 month';
    } else if (totalMonths < 12) {
      return '${totalMonths} month${totalMonths == 1 ? '' : 's'}';
    } else {
      final int years = totalMonths ~/ 12;
      final int remainingMonths = totalMonths % 12;
      
      if (remainingMonths == 0) {
        return '${years} year${years == 1 ? '' : 's'}';
      } else {
        return '${years}y ${remainingMonths}m';
      }
    }
  }

  String get formattedFromDate {
    if (fromDate == null) return '';
    return '${fromDate!.day}/${fromDate!.month}/${fromDate!.year}';
  }

  String get formattedToDate {
    if (toDate == null) return 'Present';
    return '${toDate!.day}/${toDate!.month}/${toDate!.year}';
  }

  // Static methods for creating empty instances
  static Training empty() {
    return const Training();
  }

  static Training create({
    required String universityOrTraining,
    bool isManualUniversity = false,
    required String place,
    required String country,
    required DateTime fromDate,
    DateTime? toDate,
    String? degree,
    String? mainCourseOfStudy,
    String? description,
  }) {
    final now = DateTime.now();
    return Training(
      universityOrTraining: universityOrTraining,
      isManualUniversity: isManualUniversity,
      place: place,
      country: country,
      fromDate: fromDate,
      toDate: toDate,
      degree: degree,
      mainCourseOfStudy: mainCourseOfStudy,
      description: description,
      createdAt: now,
      updatedAt: now,
    );
  }
}