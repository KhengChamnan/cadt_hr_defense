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
    // Only proceed if not already loading or loaded
    if (staffInfo?.state == AsyncValueState.loading) return;
    if (staffInfo?.state == AsyncValueState.success) return;

    // Schedule the actual call after the current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getStaffInfo();
    });
  }

  /// Clear all staff data (used during logout)
  void clearStaffInfo() {
    print('🧹 StaffProvider: Clearing staff data...');
    staffInfo = null;
    notifyListeners();
    print('✅ StaffProvider: Staff data cleared successfully');
  }

  /// Force refresh staff data (for new login sessions)
  void forceRefreshStaff() {
    print('🔄 StaffProvider: Force refreshing staff...');
    staffInfo = null;

    // Trigger immediate refresh
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getStaffInfoSafe();
    });
  }

  /// Load staff data after successful authentication
  Future<void> loadStaffAfterAuth() async {
    print('🔄 StaffProvider: Loading staff after auth...');

    // Clear any previous error states
    staffInfo = null;

    // Wait a bit for auth to settle
    await Future.delayed(const Duration(milliseconds: 400));

    // Load staff info
    await getStaffInfo();

    print('✅ StaffProvider: Post-auth staff loading completed');
  }
}
