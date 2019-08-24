class VipPayInfo {
  var yearPay;
  var monthPay;
  var realMonthPay;
  var realYearPay;
  String userVipInfo;
  String activity;

  VipPayInfo(
      {this.yearPay,
        this.monthPay,
        this.realMonthPay,
        this.realYearPay,
        this.userVipInfo,
        this.activity});

  VipPayInfo.fromJson(Map<String, dynamic> json) {
    yearPay = json['year_pay'];
    monthPay = json['month_pay'];
    realMonthPay = json['real_month_pay'];
    realYearPay = json['real_year_pay'];
    userVipInfo = json['user_vip_info'];
    activity = json['activity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['year_pay'] = this.yearPay;
    data['month_pay'] = this.monthPay;
    data['real_month_pay'] = this.realMonthPay;
    data['real_year_pay'] = this.realYearPay;
    data['user_vip_info'] = this.userVipInfo;
    data['activity'] = this.activity;
    return data;
  }
}