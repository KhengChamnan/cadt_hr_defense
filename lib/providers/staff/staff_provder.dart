import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/staff_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/models/staff/staff_info.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';

class StaffProvider extends ChangeNotifier {
  final StaffRepository staffRepository;

  AsyncValue<StaffInfo>? staffInfo;

  StaffProvider({required this.staffRepository});

  Future<void> getStaffInfo() async {
    staffInfo = AsyncValue.loading();
    notifyListeners();

    try {
      final staff = await staffRepository.getStaffInfo();
      staffInfo = AsyncValue.success(staff);
    } catch (e) {
      staffInfo = AsyncValue.error(e);
    }
    notifyListeners();
  }

  /// Safe method to get staff info that prevents duplicate loading
  Future<void> getStaffInfoSafe() async {
    // Don't load if already loading or if we have successful data
    if (staffInfo?.state == AsyncValueState.loading ||
        staffInfo?.state == AsyncValueState.success) {
      return;
    }
    
    await getStaffInfo();
  }
}
