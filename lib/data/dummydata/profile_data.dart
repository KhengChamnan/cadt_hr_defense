import 'package:palm_ecommerce_mobile_app_2/models/profile/profile.dart';

class ProfileData {
  static final ProfileInfo profile = ProfileInfo(
    profileId: 'EMP001',
    name: 'John Doe',
    email: 'john.doe@company.com',
    phone: '+855 12 345 678',
    profileImage: 'https://via.placeholder.com/150',
    backgroundCover: 'https://via.placeholder.com/500x200',
    gender: 'Male',
    dob: '1990-05-15',
    status: 'Active',
    memberSince: '2023-01-01',
    
    // Personal Information
    title: 'Mr.',
    firstName: 'John',
    lastName: 'Doe',
    nickName: 'Johnny',
    phone2: '+855 17 987 654',
    address: '123 Main Street, Phnom Penh, Cambodia',
    facebook: 'john.doe.facebook',
    
    // Work Information
    position: 'Senior Software Developer',
    department: 'Engineering',
    dateOfEmployment: '2023-01-15',
    managerId: 'MGR001',
    managerName: 'Jane Smith',
    supervisorId: 'SUP001',
    supervisorName: 'Bob Wilson',
    
    // Organization Information
    companyId: 'COMP001',
    companyName: 'Tech Solutions Ltd.',
    branchId: 'BR001',
    branchName: 'Phnom Penh Main Office',
    employeeId: 'EMP001',
    staffId: 'STF001',
    roleId: 'ROLE003',
    roleName: 'Developer',
    
    // System Information
    isActive: true,
    lastLogin: '2024-08-04 14:30:00',
    createdAt: '2023-01-01 09:00:00',
    updatedAt: '2024-08-04 14:30:00',
    warehouseId: 'WH001',
    maxUpload: '10MB',
  );
}

    