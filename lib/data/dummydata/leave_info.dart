import 'package:flutter/material.dart';

/// Dummy data for leave types available in the system
final List<String> leaveTypes = [
  'Casual Leave',
  'Sick Leave',
  'Annual Leave',
  'Maternity Leave',
  'Paternity Leave',
  'Study Leave',
  'Unpaid Leave',
];

/// Dummy data for leave balance information
final Map<String, double> leaveBalances = {
  'Annual Leave': 15.0,
  'Casual Leave': 10.0,
  'Sick Leave': 7.0,
  'Study Leave': 5.0,
  'Unpaid Leave': 0.0,
  'Maternity Leave': 90.0,
  'Paternity Leave': 14.0,
};

/// Status options for leave requests
enum LeaveStatus {
  pendingCertification,
  pendingApproval,
  approved,
  rejected,
  cancelled
}

/// Leave request dummy data for display in lists and details
final List<Map<String, dynamic>> leaveRequests = [
  {
    'id': 'LR001',
    'leaveType': 'Casual Leave',
    'startDate': DateTime(2025, 6, 15),
    'endDate': DateTime(2025, 6, 16),
    'totalDays': 2,
    'reason': "Dear Sir,\n\nI'd like to request a leave form for today's work sir.\nThanks in advance.\nLove, Chamnan",
    'attachment': 'leave_documents.pdf',
    'status': LeaveStatus.pendingApproval,
    'requestedBy': {
      'id': 'EMP001',
      'name': 'Vicheka Thea',
      'position': 'Software Developer',
      'department': 'IT',
      'avatarUrl': 'https://randomuser.me/api/portraits/women/44.jpg',
    },
    'certifiedBy': {
      'id': 'EMP002',
      'name': 'Ryan Gravenberch',
      'position': 'Team Lead',
      'department': 'IT',
      'avatarUrl': 'https://randomuser.me/api/portraits/men/32.jpg',
    },
    'approvedBy': {
      'id': 'EMP003',
      'name': 'Thong Somol',
      'position': 'Department Manager',
      'department': 'IT',
      'avatarUrl': 'https://randomuser.me/api/portraits/men/51.jpg',
    },
    'comments': [
      {
        'user': 'Ryan Gravenberch',
        'timestamp': DateTime(2025, 6, 10, 14, 30),
        'text': 'I confirm that the team workload is managed during this period.',
      },
    ],
    'createdAt': DateTime(2025, 6, 9, 10, 15),
    'updatedAt': DateTime(2025, 6, 10, 15, 30),
  },
  {
    'id': 'LR002',
    'leaveType': 'Sick Leave',
    'startDate': DateTime(2025, 5, 20),
    'endDate': DateTime(2025, 5, 22),
    'totalDays': 3,
    'reason': 'I am suffering from fever and have been advised to rest for 3 days by the doctor.',
    'attachment': 'medical_certificate.pdf',
    'status': LeaveStatus.approved,
    'requestedBy': {
      'id': 'EMP001',
      'name': 'Vicheka Thea',
      'position': 'Software Developer',
      'department': 'IT',
      'avatarUrl': 'https://randomuser.me/api/portraits/women/44.jpg',
    },
    'certifiedBy': {
      'id': 'EMP004',
      'name': 'Sarah Johnson',
      'position': 'Senior Developer',
      'department': 'IT',
      'avatarUrl': 'https://randomuser.me/api/portraits/women/22.jpg',
    },
    'approvedBy': {
      'id': 'EMP003',
      'name': 'Thong Somol',
      'position': 'Department Manager',
      'department': 'IT',
      'avatarUrl': 'https://randomuser.me/api/portraits/men/51.jpg',
    },
    'comments': [
      {
        'user': 'Sarah Johnson',
        'timestamp': DateTime(2025, 5, 19, 11, 45),
        'text': 'Medical certificate verified.',
      },
      {
        'user': 'Thong Somol',
        'timestamp': DateTime(2025, 5, 19, 15, 30),
        'text': 'Approved. Get well soon.',
      },
    ],
    'createdAt': DateTime(2025, 5, 19, 9, 30),
    'updatedAt': DateTime(2025, 5, 19, 15, 30),
  },
  {
    'id': 'LR003',
    'leaveType': 'Annual Leave',
    'startDate': DateTime(2025, 8, 10),
    'endDate': DateTime(2025, 8, 24),
    'totalDays': 15,
    'reason': 'I am planning a family vacation to visit my hometown.',
    'attachment': null,
    'status': LeaveStatus.pendingCertification,
    'requestedBy': {
      'id': 'EMP001',
      'name': 'Vicheka Thea',
      'position': 'Software Developer',
      'department': 'IT',
      'avatarUrl': 'https://randomuser.me/api/portraits/women/44.jpg',
    },
    'certifiedBy': {
      'id': 'EMP002',
      'name': 'Ryan Gravenberch',
      'position': 'Team Lead',
      'department': 'IT',
      'avatarUrl': 'https://randomuser.me/api/portraits/men/32.jpg',
    },
    'approvedBy': {
      'id': 'EMP003',
      'name': 'Thong Somol',
      'position': 'Department Manager',
      'department': 'IT',
      'avatarUrl': 'https://randomuser.me/api/portraits/men/51.jpg',
    },
    'comments': [],
    'createdAt': DateTime(2025, 7, 15, 14, 20),
    'updatedAt': DateTime(2025, 7, 15, 14, 20),
  },
  {
    'id': 'LR004',
    'leaveType': 'Study Leave',
    'startDate': DateTime(2025, 9, 5),
    'endDate': DateTime(2025, 9, 7),
    'totalDays': 3,
    'reason': 'Need to attend Flutter Developer conference in Singapore.',
    'attachment': 'conference_invitation.pdf',
    'status': LeaveStatus.rejected,
    'requestedBy': {
      'id': 'EMP001',
      'name': 'Vicheka Thea',
      'position': 'Software Developer',
      'department': 'IT',
      'avatarUrl': 'https://randomuser.me/api/portraits/women/44.jpg',
    },
    'certifiedBy': {
      'id': 'EMP002',
      'name': 'Ryan Gravenberch',
      'position': 'Team Lead',
      'department': 'IT',
      'avatarUrl': 'https://randomuser.me/api/portraits/men/32.jpg',
    },
    'approvedBy': {
      'id': 'EMP003',
      'name': 'Thong Somol',
      'position': 'Department Manager',
      'department': 'IT',
      'avatarUrl': 'https://randomuser.me/api/portraits/men/51.jpg',
    },
    'comments': [
      {
        'user': 'Ryan Gravenberch',
        'timestamp': DateTime(2025, 8, 25, 10, 10),
        'text': 'Conference details verified. Recommended for approval.',
      },
      {
        'user': 'Thong Somol',
        'timestamp': DateTime(2025, 8, 26, 11, 30),
        'text': 'Rejected due to critical project deadline. We can consider funding for next year\'s conference.',
      },
    ],
    'createdAt': DateTime(2025, 8, 24, 9, 0),
    'updatedAt': DateTime(2025, 8, 26, 11, 30),
  },
  {
    'id': 'LR005',
    'leaveType': 'Casual Leave',
    'startDate': DateTime(2025, 7, 3),
    'endDate': DateTime(2025, 7, 3),
    'totalDays': 1,
    'reason': 'Need to attend a family function.',
    'attachment': null,
    'status': LeaveStatus.pendingApproval,
    'requestedBy': {
      'id': 'EMP001',
      'name': 'Vicheka Thea',
      'position': 'Software Developer',
      'department': 'IT',
      'avatarUrl': 'https://randomuser.me/api/portraits/women/44.jpg',
    },
    'certifiedBy': {
      'id': 'EMP004',
      'name': 'Sarah Johnson',
      'position': 'Senior Developer',
      'department': 'IT',
      'avatarUrl': 'https://randomuser.me/api/portraits/women/22.jpg',
    },
    'approvedBy': {
      'id': 'EMP003',
      'name': 'Thong Somol',
      'position': 'Department Manager',
      'department': 'IT',
      'avatarUrl': 'https://randomuser.me/api/portraits/men/51.jpg',
    },
    'comments': [
      {
        'user': 'Sarah Johnson',
        'timestamp': DateTime(2025, 7, 1, 13, 15),
        'text': 'Workload is manageable. Recommended for approval.',
      },
    ],
    'createdAt': DateTime(2025, 7, 1, 10, 45),
    'updatedAt': DateTime(2025, 7, 1, 13, 15),
  },
  {
    'id': 'LR006',
    'leaveType': 'Annual Leave',
    'startDate': DateTime(2025, 7, 20),
    'endDate': DateTime(2025, 7, 25),
    'totalDays': 6,
    'reason': 'Family vacation to Siem Reap.',
    'attachment': null,
    'status': LeaveStatus.pendingCertification,
    'requestedBy': {
      'id': 'EMP001',
      'name': 'Vicheka Thea',
      'position': 'Software Developer',
      'department': 'IT',
      'avatarUrl': 'https://randomuser.me/api/portraits/women/44.jpg',
    },
    'certifiedBy': {
      'id': 'EMP002',
      'name': 'Ryan Gravenberch',
      'position': 'Team Lead',
      'department': 'IT',
      'avatarUrl': 'https://randomuser.me/api/portraits/men/32.jpg',
    },
    'approvedBy': {
      'id': 'EMP003',
      'name': 'Thong Somol',
      'position': 'Department Manager',
      'department': 'IT',
      'avatarUrl': 'https://randomuser.me/api/portraits/men/51.jpg',
    },
    'comments': [],
    'createdAt': DateTime(2025, 7, 1, 9, 15),
    'updatedAt': DateTime(2025, 7, 1, 9, 15),
  },
  {
    'id': 'LR007',
    'leaveType': 'Sick Leave',
    'startDate': DateTime(2025, 8, 5),
    'endDate': DateTime(2025, 8, 6),
    'totalDays': 2,
    'reason': 'Feeling unwell with flu symptoms.',
    'attachment': 'medical_note.pdf',
    'status': LeaveStatus.pendingCertification,
    'requestedBy': {
      'id': 'EMP001',
      'name': 'Vicheka Thea',
      'position': 'Software Developer',
      'department': 'IT',
      'avatarUrl': 'https://randomuser.me/api/portraits/women/44.jpg',
    },
    'certifiedBy': {
      'id': 'EMP004',
      'name': 'Sarah Johnson',
      'position': 'Senior Developer',
      'department': 'IT',
      'avatarUrl': 'https://randomuser.me/api/portraits/women/22.jpg',
    },
    'approvedBy': {
      'id': 'EMP003',
      'name': 'Thong Somol',
      'position': 'Department Manager',
      'department': 'IT',
      'avatarUrl': 'https://randomuser.me/api/portraits/men/51.jpg',
    },
    'comments': [],
    'createdAt': DateTime(2025, 8, 4, 16, 30),
    'updatedAt': DateTime(2025, 8, 4, 16, 30),
  },
];

/// Dummy data for certifiers that can be selected
final List<Map<String, dynamic>> certifiers = [
  {
    'id': 'EMP002',
    'name': 'Ryan Gravenberch',
    'position': 'Team Lead',
    'department': 'IT',
    'avatarUrl': 'https://randomuser.me/api/portraits/men/32.jpg',
  },
  {
    'id': 'EMP004',
    'name': 'Sarah Johnson',
    'position': 'Senior Developer',
    'department': 'IT',
    'avatarUrl': 'https://randomuser.me/api/portraits/women/22.jpg',
  },
  {
    'id': 'EMP006',
    'name': 'David Wong',
    'position': 'Senior Developer',
    'department': 'IT',
    'avatarUrl': 'https://randomuser.me/api/portraits/men/75.jpg',
  },
];

/// Dummy data for approvers that can be selected
final List<Map<String, dynamic>> approvers = [
  {
    'id': 'EMP003',
    'name': 'Thong Somol',
    'position': 'Department Manager',
    'department': 'IT',
    'avatarUrl': 'https://randomuser.me/api/portraits/men/51.jpg',
  },
  {
    'id': 'EMP007',
    'name': 'Lisa Chen',
    'position': 'HR Manager',
    'department': 'Human Resources',
    'avatarUrl': 'https://randomuser.me/api/portraits/women/56.jpg',
  },
  {
    'id': 'EMP008',
    'name': 'John Williams',
    'position': 'Operations Director',
    'department': 'Operations',
    'avatarUrl': 'https://randomuser.me/api/portraits/men/64.jpg',
  },
];

/// Helper function to get a formatted status string from enum
String getStatusString(LeaveStatus status) {
  switch (status) {
    case LeaveStatus.pendingCertification:
      return 'Pending Certification';
    case LeaveStatus.pendingApproval:
      return 'Pending Approval';
    case LeaveStatus.approved:
      return 'Approved';
    case LeaveStatus.rejected:
      return 'Rejected';
    case LeaveStatus.cancelled:
      return 'Cancelled';
    default:
      return 'Unknown';
  }
}

/// Helper function to get status color
Color getStatusColor(LeaveStatus status) {
  switch (status) {
    case LeaveStatus.approved:
      return Colors.green;
    case LeaveStatus.rejected:
      return Colors.red;
    case LeaveStatus.cancelled:
      return Colors.grey;
    case LeaveStatus.pendingCertification:
    case LeaveStatus.pendingApproval:
      return Colors.orange;
    default:
      return Colors.blue;
  }
}

/// Find a leave request by ID
Map<String, dynamic>? findLeaveRequestById(String id) {
  try {
    return leaveRequests.firstWhere((request) => request['id'] == id);
  } catch (e) {
    return null;
  }
}

/// Get leave requests for a specific user
List<Map<String, dynamic>> getLeaveRequestsByUser(String userId) {
  return leaveRequests.where((request) => request['requestedBy']['id'] == userId).toList();
}

/// Get pending certification requests for a certifier
List<Map<String, dynamic>> getPendingCertificationRequests(String certifierId) {
  return leaveRequests.where((request) => 
    request['certifiedBy']['id'] == certifierId && 
    request['status'] == LeaveStatus.pendingCertification
  ).toList();
}

/// Get pending approval requests for an approver
List<Map<String, dynamic>> getPendingApprovalRequests(String approverId) {
  return leaveRequests.where((request) => 
    request['approvedBy']['id'] == approverId && 
    request['status'] == LeaveStatus.pendingApproval
  ).toList();
}

/// Format date as string
String formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
