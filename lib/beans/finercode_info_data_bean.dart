class FinerCodeInfoData {
  int id;
  String finerCode;
  String incident;
  String operate;
  String date;
  String user;

  FinerCodeInfoData(
      {this.id,
        this.finerCode,
        this.incident,
        this.operate,
        this.date,
        this.user});

  FinerCodeInfoData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    finerCode = json['finer_code'];
    incident = json['incident'];
    operate = json['operate'];
    date = json['date'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['finer_code'] = this.finerCode;
    data['incident'] = this.incident;
    data['operate'] = this.operate;
    data['date'] = this.date;
    data['user'] = this.user;
    return data;
  }
}