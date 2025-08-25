/// Data model for team member information
/// Used in team structure views and member management
class TeamMember {
  final String id;
  final String name;
  final String? profilePicture;
  final String? position;
  final String? department;
  final String? email;
  final String? phone;
  final List<TeamMember> children;
  final int memberCount;
  final bool isTeamLead;

  const TeamMember({
    required this.id,
    required this.name,
    this.profilePicture,
    this.position,
    this.department,
    this.email,
    this.phone,
    this.children = const [],
    this.memberCount = 0,
    this.isTeamLead = false,
  });

  /// Creates a copy of this TeamMember with the given fields replaced
  TeamMember copyWith({
    String? id,
    String? name,
    String? profilePicture,
    String? position,
    String? department,
    String? email,
    String? phone,
    List<TeamMember>? children,
    int? memberCount,
    bool? isTeamLead,
  }) {
    return TeamMember(
      id: id ?? this.id,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      position: position ?? this.position,
      department: department ?? this.department,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      children: children ?? this.children,
      memberCount: memberCount ?? this.memberCount,
      isTeamLead: isTeamLead ?? this.isTeamLead,
    );
  }

  /// Creates a TeamMember from JSON data
  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id']?.toString() ?? '',
      name: json['profile']?.toString() ?? json['name']?.toString() ?? '',
      profilePicture: json['profile_pic']?.toString() ?? json['profilePicture']?.toString(),
      position: json['position']?.toString(),
      department: json['department']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      children: (json['child'] as List<dynamic>?)
          ?.map((child) => TeamMember.fromJson(child as Map<String, dynamic>))
          .toList() ?? [],
      memberCount: json['memberCount'] as int? ?? 
                   (json['child'] as List<dynamic>?)?.length ?? 0,
      isTeamLead: json['isTeamLead'] as bool? ?? false,
    );
  }

  /// Converts TeamMember to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile': name, // For compatibility with existing data structure
      'profilePicture': profilePicture,
      'profile_pic': profilePicture, // For compatibility with existing data structure
      'position': position,
      'department': department,
      'email': email,
      'phone': phone,
      'child': children.map((child) => child.toJson()).toList(),
      'memberCount': memberCount,
      'isTeamLead': isTeamLead,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamMember &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          profilePicture == other.profilePicture &&
          position == other.position &&
          department == other.department &&
          email == other.email &&
          phone == other.phone &&
          _listEquals(children, other.children) &&
          memberCount == other.memberCount &&
          isTeamLead == other.isTeamLead;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      profilePicture.hashCode ^
      position.hashCode ^
      department.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      children.hashCode ^
      memberCount.hashCode ^
      isTeamLead.hashCode;

  @override
  String toString() {
    return 'TeamMember(id: $id, name: $name, position: $position, '
           'department: $department, memberCount: $memberCount, '
           'isTeamLead: $isTeamLead, childrenCount: ${children.length})';
  }

  /// Helper function to compare lists
  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// Returns the total number of team members including children
  int get totalMemberCount {
    int total = 1; // Count this member
    for (TeamMember child in children) {
      total += child.totalMemberCount;
    }
    return total;
  }

  /// Returns whether this member has any children/subordinates
  bool get hasChildren => children.isNotEmpty;

  /// Returns the default profile picture URL if none is set
  String get displayProfilePicture => 
      profilePicture ?? 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png';
} 