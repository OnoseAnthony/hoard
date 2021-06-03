class LoanInfo {
  String docId;
  String userId;
  String loanName;
  String loanId;
  String contractPeriod;
  String expiryPeriod;
  String upcomingRepayment;
  String contractFormattedDate;
  double contractAmount;
  double repaidAmount;
  double monthlyInstallment;
  double totalInterest;
  bool isFullyPaid;
  List<dynamic> paymentSchedule;

  LoanInfo(
      {this.docId,
      this.userId,
      this.loanName,
      this.loanId,
      this.contractPeriod,
      this.expiryPeriod,
      this.upcomingRepayment,
      this.contractFormattedDate,
      this.contractAmount,
      this.repaidAmount,
      this.monthlyInstallment,
      this.totalInterest,
      this.isFullyPaid,
      this.paymentSchedule});

  LoanInfo.fromMap(Map map)
      : this.docId = map['docId'],
        this.userId = map['userId'],
        this.loanName = map['loanName'],
        this.loanId = map['loanId'],
        this.contractPeriod = map['contractPeriod'],
        this.expiryPeriod = map['expiryPeriod'],
        this.upcomingRepayment = map['upcomingRepayment'],
        this.contractFormattedDate = map['contractFormattedDate'],
        this.contractAmount = map['contractAmount'],
        this.repaidAmount = map['repaidAmount'],
        this.monthlyInstallment = map['monthlyInstallment'],
        this.totalInterest = map['totalInterest'],
        this.isFullyPaid = map['isFullyPaid'],
        this.paymentSchedule = map['paymentSchedule'];

  Map toMap() {
    return {
      'docId': this.docId,
      'userId': this.userId,
      'loanName': this.loanName,
      'loanId': this.loanId,
      'contractPeriod': this.contractPeriod,
      'expiryPeriod': this.expiryPeriod,
      'upcomingRepayment': this.upcomingRepayment,
      'contractFormattedDate': this.contractFormattedDate,
      'contractAmount': this.contractAmount,
      'repaidAmount': this.repaidAmount,
      'monthlyInstallment': this.monthlyInstallment,
      'totalInterest': this.totalInterest,
      'expMonth': this.isFullyPaid,
      'paymentSchedule': this.paymentSchedule
    };
  }
}

class RepaymentSummaryInfo {
  String loanPurpose;
  double loanTotal;
  double amountPaid;
  double amountOwed;
  String duration;

  RepaymentSummaryInfo(
      {this.loanPurpose,
      this.loanTotal,
      this.amountPaid,
      this.amountOwed,
      this.duration});
}
