class CommissionPopup {
  final String? id;
  final String? originalAmount;
  final String? directFrom;
  final String? toMember;
  final String? fromCustomer;
  final String? remark;
  final String? amount;

  CommissionPopup({
    this.id,
    this.originalAmount,
    this.directFrom,
    this.toMember,
    this.fromCustomer,
    this.remark,
    this.amount,
  });

 

  @override
  String toString() {
    return 'CommissionPopup{id: $id, originalAmount: $originalAmount, directFrom: $directFrom, toMember: $toMember, fromCustomer: $fromCustomer, remark: $remark, amount: $amount}';
  }
}
