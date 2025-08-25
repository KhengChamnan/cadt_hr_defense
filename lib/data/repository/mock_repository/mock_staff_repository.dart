import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/staff_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/auth_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/models/staff/staff_info.dart';

class MockStaffRepository implements StaffRepository {
  final AuthRepository authRepository;
  
  MockStaffRepository({required this.authRepository});
  
  @override
  Future<StaffInfo> getStaffInfo() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Check if the user is authenticated
    final token = await authRepository.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('User not authenticated');
    }
    
    // Return mock staff data
    return StaffInfo(
      staffId: 'S001',
      firstNameEng: 'John',
      lastNameEng: 'Doe',
      firstNameKh: 'ជន',
      lastNameKh: 'ដូ',
      email: 'john.doe@company.com',
      phone: '012 345 678',
      positionId: '40',
      branchCode: 'PALM-00170001',
      balanceAnnually: '20',
      balanceSick: '5',
      balanceSpecial: '3',
      manager: StaffManager(
        staffId: 'S100',
        firstNameEng: 'Manager',
        lastNameEng: 'Smith',
        email: 'manager@company.com',
        phone: '012 000 001',
        branchCode: 'PALM-00170001',
      ),
      supervisor: StaffSupervisor(
        staffId: 'S200',
        firstNameEng: 'Supervisor',
        lastNameEng: 'Johnson',
        email: 'supervisor@company.com',
        phone: '012 000 002',
        branchCode: 'PALM-00170001',
      ),
    );
  }
}
