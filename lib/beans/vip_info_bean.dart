class VipInfo {
  bool isOpening;
  bool isAnnual;
  String levelDesignation;

  VipInfo({this.isOpening, this.isAnnual, this.levelDesignation});

  VipInfo.fromJson(Map<String, dynamic> json) {
    isOpening = json['is_opening'];
    isAnnual = json['is_annual'];
    levelDesignation = json['level_designation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_opening'] = this.isOpening;
    data['is_annual'] = this.isAnnual;
    data['level_designation'] = this.levelDesignation;
    return data;
  }
}