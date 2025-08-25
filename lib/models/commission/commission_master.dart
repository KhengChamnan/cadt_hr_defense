class CommissionMaster {
  final String? directCommission;
  final String? directBalanceCommission;
  final String? indirectCommission;
  final String? indirectBalanceCommission;

  CommissionMaster({
    this.directCommission,
    this.directBalanceCommission,
    this.indirectCommission,
    this.indirectBalanceCommission,
  });



  @override
  String toString() {
    return 'CommissionMaster{directCommission: $directCommission, directBalanceCommission: $directBalanceCommission, indirectCommission: $indirectCommission, indirectBalanceCommission: $indirectBalanceCommission}';
  }
}
