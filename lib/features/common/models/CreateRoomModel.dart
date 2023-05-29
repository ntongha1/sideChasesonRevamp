class CreateRoomModel {
  String? status;
  String? message;
  Data? data;

  CreateRoomModel({this.status, this.message, this.data});

  CreateRoomModel.fromJson(Map<dynamic, dynamic> json) {
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
  Room? room;
  String? token;

  Data({this.room, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    room = json['room'] != null ? new Room.fromJson(json['room']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.room != null) {
      data['room'] = this.room!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class Room {
  String? id;
  String? name;
  int? emptyTimeout;
  int? isPrivate;
  int? maxNumberOfParticipants;
  String? createdAt;
  String? updatedAt;

  Room(
      {this.id,
        this.name,
        this.emptyTimeout,
        this.isPrivate,
        this.maxNumberOfParticipants,
        this.createdAt,
        this.updatedAt});

  Room.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    emptyTimeout = json['empty_timeout'];
    isPrivate = json['is_private'];
    maxNumberOfParticipants = json['max_number_of_participants'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['empty_timeout'] = this.emptyTimeout;
    data['is_private'] = this.isPrivate;
    data['max_number_of_participants'] = this.maxNumberOfParticipants;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}