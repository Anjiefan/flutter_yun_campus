class Level {
  String levelDesignation;
  String bigLevelDesignation;

  Level({this.levelDesignation, this.bigLevelDesignation});

  Level.fromJson(Map<String, dynamic> json) {
    levelDesignation = json['level_designation'];
    bigLevelDesignation = json['big_level_designation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['level_designation'] = this.levelDesignation;
    data['big_level_designation'] = this.bigLevelDesignation;
    return data;
  }
}