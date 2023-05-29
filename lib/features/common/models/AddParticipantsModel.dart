class AddParticipantsModel {
  String? status;
  String? message;
  Data? data;

  AddParticipantsModel({this.status, this.message, this.data});

  AddParticipantsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Participant? participant;
  String? livekitToken;

  Data({this.participant, this.livekitToken});

  Data.fromJson(Map<String, dynamic> json) {
    participant = json['participant'] != null
        ? new Participant.fromJson(json['participant'])
        : null;
    livekitToken = json['livekitToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.participant != null) {
      data['participant'] = this.participant!.toJson();
    }
    data['livekitToken'] = this.livekitToken;
    return data;
  }
}

class Participant {
  String? id;
  String? roomId;
  String? userId;
  String? createdAt;
  String? updatedAt;

  Participant(
      {this.id, this.roomId, this.userId, this.createdAt, this.updatedAt});

  Participant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomId = json['room_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['room_id'] = this.roomId;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}