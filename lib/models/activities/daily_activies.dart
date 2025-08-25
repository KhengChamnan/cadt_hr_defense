class DailyActivity {
  final String? id;
  final String activityId;
  final String activityCategory;
  final String activityDescription;
  final String keyApi;
  final String subApi;
  final DateTime fromDate;
  final DateTime toDate;
  final String remark;
  final String? photoPath; // For storing photo when meeting clients
  final ActivityLocation? location; // For storing location when meeting clients
  final double? score; // Admin evaluation score (0-100), null if not evaluated
  final String employeeId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final ActivityStatus status;

  DailyActivity({
    this.id,
    required this.activityId,
    required this.activityCategory,
    required this.activityDescription,
    required this.keyApi,
    required this.subApi,
    required this.fromDate,
    required this.toDate,
    required this.remark,
    this.photoPath,
    this.location,
    this.score,
    required this.employeeId,
    required this.createdAt,
    this.updatedAt,
    this.status = ActivityStatus.pending,
  });

  // Factory constructor for creating from JSON
  factory DailyActivity.fromJson(Map<String, dynamic> json) {
    return DailyActivity(
      id: json['id'],
      activityId: json['activityId'] ?? '',
      activityCategory: json['activityCategory'] ?? '',
      activityDescription: json['activityDescription'] ?? '',
      keyApi: json['keyApi'] ?? '',
      subApi: json['subApi'] ?? '',
      fromDate: DateTime.parse(json['fromDate']),
      toDate: DateTime.parse(json['toDate']),
      remark: json['remark'] ?? '',
      photoPath: json['photoPath'],
      location: json['location'] != null 
          ? ActivityLocation.fromJson(json['location']) 
          : null,
      score: json['score']?.toDouble(),
      employeeId: json['employeeId'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
      status: ActivityStatus.values.firstWhere(
        (e) => e.toString() == 'ActivityStatus.${json['status']}',
        orElse: () => ActivityStatus.pending,
      ),
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activityId': activityId,
      'activityCategory': activityCategory,
      'activityDescription': activityDescription,
      'keyApi': keyApi,
      'subApi': subApi,
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
      'remark': remark,
      'photoPath': photoPath,
      'location': location?.toJson(),
      'score': score,
      'employeeId': employeeId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'status': status.toString().split('.').last,
    };
  }

  // Method to create a copy with updated fields
  DailyActivity copyWith({
    String? id,
    String? activityId,
    String? activityName,
    String? activityCategory,
    String? activityDescription,
    String? keyApi,
    String? subApi,
    DateTime? fromDate,
    DateTime? toDate,
    String? remark,
    String? photoPath,
    ActivityLocation? location,
    double? score,
    String? employeeId,
    DateTime? createdAt,
    DateTime? updatedAt,
    ActivityStatus? status,
  }) {
    return DailyActivity(
      id: id ?? this.id,
      activityId: activityId ?? this.activityId,
      activityCategory: activityCategory ?? this.activityCategory,
      activityDescription: activityDescription ?? this.activityDescription,
      keyApi: keyApi ?? this.keyApi,
      subApi: subApi ?? this.subApi,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      remark: remark ?? this.remark,
      photoPath: photoPath ?? this.photoPath,
      location: location ?? this.location,
      score: score ?? this.score,
      employeeId: employeeId ?? this.employeeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'DailyActivity(id: $id, category: $activityCategory, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DailyActivity &&
        other.id == id &&
        other.activityId == activityId &&
        other.employeeId == employeeId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ activityId.hashCode ^ employeeId.hashCode;
  }

  // Static activity categories list based on the data provided
  static const List<String> activityCategories = [
    'កាលប្រជុំប្រចាំសប្តាហ៍',      // Weekly meeting
    'កាលជួបជុំ',                  // Meeting
    'កាលរៀបចំសម្ភារៈ',              // Material preparation
    'កាលតាំងតំណាងលក់ទំនិញ',        // Sales representative setup
    'កាលអភិវឌ្ឍន៍គុណភាពនិងសុវត្ថិភាព', // Quality and safety development
    'កាលធ្វើបទបង្ហាញ និង កាលរៀបចំឯកសារ', // Presentation and document preparation
    'ធ្វើកម្មវិធីអាប់ដេត',              // Update program
    'បង្ហរក បង្ហាញ',                  // Display/show
    'ចំណាចំពាក់ព័ន្ធជាមួយអតិថិជន',      // Customer relations
  ];

  // Static Key API options
  static const List<String> keyApiOptions = [
    'MEETING',
    'TRAINING',
    'CLIENT',
    'PRESENTATION',
    'DOCUMENT',
    'PLANNING',
    'REVIEW',
    'DEVELOPMENT',
    'ANALYSIS',
    'UPDATE',
    'Other (Manual Input)',
  ];

  // Static Sub API options
  static const List<String> subApiOptions = [
    'WEEKLY',
    'MONTHLY',
    'DAILY',
    'VISIT',
    'REPORT',
    'UPDATE',
    'PREPARATION',
    'ANALYSIS',
    'DEVELOPMENT',
    'REVIEW',
    'SETUP',
    'QUALITY',
    'SAFETY',
    'Other (Manual Input)',
  ];
}

// Activity Location model for storing GPS coordinates and address
class ActivityLocation {
  final double latitude;
  final double longitude;
  final String? address;
  final String? clientName;
  final String? clientCompany;

  ActivityLocation({
    required this.latitude,
    required this.longitude,
    this.address,
    this.clientName,
    this.clientCompany,
  });

  factory ActivityLocation.fromJson(Map<String, dynamic> json) {
    return ActivityLocation(
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      address: json['address'],
      clientName: json['clientName'],
      clientCompany: json['clientCompany'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'clientName': clientName,
      'clientCompany': clientCompany,
    };
  }

  @override
  String toString() {
    return 'ActivityLocation(lat: $latitude, lng: $longitude, address: $address)';
  }
}

// Activity Status enum
enum ActivityStatus {
  pending,
  inProgress,
  completed,
  cancelled,
  approved,
  rejected,
}

extension ActivityStatusExtension on ActivityStatus {
  String get displayName {
    switch (this) {
      case ActivityStatus.pending:
        return 'Pending';
      case ActivityStatus.inProgress:
        return 'In Progress';
      case ActivityStatus.completed:
        return 'Completed';
      case ActivityStatus.cancelled:
        return 'Cancelled';
      case ActivityStatus.approved:
        return 'Approved';
      case ActivityStatus.rejected:
        return 'Rejected';
    }
  }

  String get colorCode {
    switch (this) {
      case ActivityStatus.pending:
        return '#FFA500'; // Orange
      case ActivityStatus.inProgress:
        return '#0066CC'; // Blue
      case ActivityStatus.completed:
        return '#28A745'; // Green
      case ActivityStatus.cancelled:
        return '#6C757D'; // Gray
      case ActivityStatus.approved:
        return '#28A745'; // Green
      case ActivityStatus.rejected:
        return '#DC3545'; // Red
    }
  }
}