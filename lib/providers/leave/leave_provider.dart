import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/leave_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/models/leaves/leave_info.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';

class LeaveProvider extends ChangeNotifier {
  final LeaveRepository leaveRepository;

  AsyncValue<List<LeaveInfo>>? leaveList;
  AsyncValue<Map<String, dynamic>>? submitLeaveStatus;

  LeaveProvider({required this.leaveRepository});

  Future<void> getLeaveList() async {
    leaveList = AsyncValue.loading();
    notifyListeners();

    try {
      final leaves = await leaveRepository.getLeaveList();
      leaveList = AsyncValue.success(leaves);
    } catch (e) {
      leaveList = AsyncValue.error(e);
    }
    notifyListeners();
  }

  Future<void> submitLeaveRequest(SubmitLeaveRequest leaveRequest) async {
    submitLeaveStatus = AsyncValue.loading();
    notifyListeners();

    try {
      final responseData = await leaveRepository.submitLeaveRequest(leaveRequest);
      submitLeaveStatus = AsyncValue.success(responseData);
      
      // Automatically refresh leave list to keep data in sync
      await getLeaveList();
    } catch (e) {
      // Exception during API call
      submitLeaveStatus = AsyncValue.error({'message': e.toString()});
    }
    notifyListeners();
  }

  /// Clear submit leave status (useful for resetting UI state)
  void clearSubmitStatus() {
    submitLeaveStatus = null;
    notifyListeners();
  }

  /// Clear leave list (useful for logout or refresh)
  void clearLeaveList() {
    leaveList = null;
    notifyListeners();
  }
}
