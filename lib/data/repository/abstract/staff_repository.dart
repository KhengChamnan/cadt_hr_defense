import '../../../models/staff/staff_info.dart';

abstract class StaffRepository {
  Future<StaffInfo> getStaffInfo();
}
