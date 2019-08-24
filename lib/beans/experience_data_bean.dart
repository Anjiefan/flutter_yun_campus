class ExperienceData {
  int id;
  String eventType;
  String eventId;
  int increaseExperience;
  String date;

  ExperienceData(
      {this.id,
        this.eventType,
        this.eventId,
        this.increaseExperience,
        this.date});

  ExperienceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventType = json['event_type'];
    eventId = json['event_id'];
    increaseExperience = json['increase_experience'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['event_type'] = this.eventType;
    data['event_id'] = this.eventId;
    data['increase_experience'] = this.increaseExperience;
    data['date'] = this.date;
    return data;
  }
}