import '../models/team/team_member.dart';

/// Service class for team-related operations
/// Currently provides static test data for team structure
class TeamService {
  
  /// Returns mock team structure data for testing
  /// TODO: Replace with actual API calls when backend is available
  static TeamMember getMockTeamStructure() {
    return TeamMember.fromJson({
      'id': 'team_lead_001',
      'profile': 'Team Leader - លោក ប៊ុនធឿន',
      'profile_pic': 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
      'position': 'Senior Team Lead',
      'department': 'Engineering',
      'email': 'sok.vichitra@palmhr.com',
      'phone': '+855-12-345-678',
      'isTeamLead': true,
      'child': [
        {
          'id': 'member_001',
          'profile': 'នាង សុផាត សុវណ្ណរី',
          'profile_pic': 'https://images.unsplash.com/photo-1494790108755-2616b9e32f6b?w=150&h=150&fit=crop&crop=face',
          'position': 'Senior Developer',
          'department': 'Engineering',
          'email': 'sophat.sovannarey@palmhr.com',
          'phone': '+855-17-888-999',
          'child': [
            {
              'id': 'member_002',
              'profile': 'លោក ចាន់ វុទ្ធី',
              'profile_pic': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
              'position': 'Junior Developer',
              'department': 'Engineering',
              'email': 'chan.vuthey@palmhr.com',
              'phone': '+855-12-777-888',
              'child': []
            },
            {
              'id': 'member_003',
              'profile': 'នាង គង់ សុខមាលា',
              'profile_pic': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
              'position': 'Junior Developer',
              'department': 'Engineering',
              'email': 'kong.sokmalea@palmhr.com',
              'phone': '+855-96-123-456',
              'child': []
            }
          ]
        },
        {
          'id': 'member_004',
          'profile': 'លោក ពេជ្រ ចាន់ថារ៉ា',
          'profile_pic': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
          'position': 'Project Manager',
          'department': 'Engineering',
          'email': 'pich.chanthara@palmhr.com',
          'phone': '+855-70-234-567',
          'child': [
            {
              'id': 'member_005',
              'profile': 'នាង ឡេង សុវត្តី',
              'profile_pic': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face',
              'position': 'Business Analyst',
              'department': 'Engineering',
              'email': 'leng.sovattey@palmhr.com',
              'phone': '+855-15-345-678',
              'child': []
            },
            {
              'id': 'member_006',
              'profile': 'លោក ខេម ពិសាច',
              'profile_pic': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
              'position': 'UX Designer',
              'department': 'Design',
              'email': 'khem.pisach@palmhr.com',
              'phone': '+855-87-456-789',
              'child': []
            },
            {
              'id': 'member_007',
              'profile': 'នាង ម៉ម សុគន្ធា',
              'profile_pic': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&h=150&fit=crop&crop=face',
              'position': 'QA Engineer',
              'department': 'Quality Assurance',
              'email': 'mom.sokantha@palmhr.com',
              'phone': '+855-92-567-890',
              'child': []
            }
          ]
        },
        {
          'id': 'member_008',
          'profile': 'លោក រ៉ា សុធីរ៉ា',
          'profile_pic': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150&h=150&fit=crop&crop=face',
          'position': 'DevOps Engineer',
          'department': 'Infrastructure',
          'email': 'ra.sothira@palmhr.com',
          'phone': '+855-77-678-901',
          'child': [
            {
              'id': 'member_009',
              'profile': 'នាង នុត ចន្ទនីដា',
              'profile_pic': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150&h=150&fit=crop&crop=face',
              'position': 'Cloud Specialist',
              'department': 'Infrastructure',
              'email': 'nuth.chantnida@palmhr.com',
              'phone': '+855-88-789-012',
              'child': []
            }
          ]
        },
        {
          'id': 'member_010',
          'profile': 'នាង យុន សុវណ្ណា',
          'profile_pic': 'https://images.unsplash.com/photo-1485875437342-9b39470b3d95?w=150&h=150&fit=crop&crop=face',
          'position': 'HR Specialist',
          'department': 'Human Resources',
          'email': 'yun.sovanna@palmhr.com',
          'phone': '+855-10-890-123',
          'child': []
        },
        {
          'id': 'member_011',
          'profile': 'លោក លីម សុគន្ធ',
          'profile_pic': 'https://images.unsplash.com/photo-1507591064344-4c6ce005b128?w=150&h=150&fit=crop&crop=face',
          'position': 'Security Analyst',
          'department': 'Security',
          'email': 'lim.sokun@palmhr.com',
          'phone': '+855-69-901-234',
          'child': [
            {
              'id': 'member_012',
              'profile': 'នាង សុខ សុវណ្ណី',
              'profile_pic': 'https://images.unsplash.com/photo-1489424731084-a5d8b219a5bb?w=150&h=150&fit=crop&crop=face',
              'position': 'Security Intern',
              'department': 'Security',
              'email': 'sok.sovannary@palmhr.com',
              'phone': '+855-93-012-345',
              'child': []
            },
            {
              'id': 'member_013',
              'profile': 'លោក ហ៊ុន ណារុន',
              'profile_pic': 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=150&h=150&fit=crop&crop=face',
              'position': 'Penetration Tester',
              'department': 'Security',
              'email': 'hun.narun@palmhr.com',
              'phone': '+855-78-123-456',
              'child': []
            }
          ]
        }
      ]
    });
  }

  /// Simulates API loading delay
  static Future<TeamMember> fetchTeamStructure() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return getMockTeamStructure();
  }

  /// Searches team members by name
  static List<TeamMember> searchMembers(TeamMember root, String query) {
    List<TeamMember> results = [];
    
    // Check if current member matches
    if (root.name.toLowerCase().contains(query.toLowerCase())) {
      results.add(root);
    }
    
    // Recursively search children
    for (TeamMember child in root.children) {
      results.addAll(searchMembers(child, query));
    }
    
    return results;
  }

  /// Gets all members at a specific level (flattened)
  static List<TeamMember> getFlatMembersList(TeamMember root) {
    List<TeamMember> members = [];
    
    void collectMembers(TeamMember member) {
      members.add(member);
      for (TeamMember child in member.children) {
        collectMembers(child);
      }
    }
    
    collectMembers(root);
    return members;
  }
} 