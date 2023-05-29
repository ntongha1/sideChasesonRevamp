class GetChatResponseModel {
  String? status;
  String? message;
  List<Data>? data;

  GetChatResponseModel({this.status, this.message, this.data});

  GetChatResponseModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? roomId;
  String? userId;
  String? createdAt;
  String? updatedAt;
  Room? room;

  Data(
      {this.id,
        this.roomId,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.room});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomId = json['room_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    room = json['room'] != null ? new Room.fromJson(json['room']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['room_id'] = this.roomId;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.room != null) {
      data['room'] = this.room!.toJson();
    }
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
  List<Participants>? participants;

  Room(
      {this.id,
        this.name,
        this.emptyTimeout,
        this.isPrivate,
        this.maxNumberOfParticipants,
        this.createdAt,
        this.updatedAt,
        this.participants});

  Room.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    emptyTimeout = json['empty_timeout'];
    isPrivate = json['is_private'];
    maxNumberOfParticipants = json['max_number_of_participants'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['participants'] != null) {
      participants = <Participants>[];
      json['participants'].forEach((v) {
        participants!.add(new Participants.fromJson(v));
      });
    }
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
    if (this.participants != null) {
      data['participants'] = this.participants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Participants {
  String? id;
  String? firstName;
  String? lastName;
  String? dob;
  String? gender;
  String? role;
  String? country;
  String? email;
  int? emailVerified;
  String? phone;
  int? phoneVerified;
  String? maritalStatus;
  String? photo;
  int? isActive;
  int? loginCount;
  String? deletedAt;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;

  Participants(
      {this.id,
        this.firstName,
        this.lastName,
        this.dob,
        this.gender,
        this.role,
        this.country,
        this.email,
        this.emailVerified,
        this.phone,
        this.phoneVerified,
        this.maritalStatus,
        this.photo,
        this.isActive,
        this.loginCount,
        this.deletedAt,
        this.startDate,
        this.endDate,
        this.createdAt,
        this.updatedAt});

  Participants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    dob = json['dob'];
    gender = json['gender'];
    role = json['role'];
    country = json['country'];
    email = json['email'];
    emailVerified = json['email_verified'];
    phone = json['phone'];
    phoneVerified = json['phone_verified'];
    maritalStatus = json['marital_status'];
    photo = json['photo'];
    isActive = json['is_active'];
    loginCount = json['login_count'];
    deletedAt = json['deleted_at'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['role'] = this.role;
    data['country'] = this.country;
    data['email'] = this.email;
    data['email_verified'] = this.emailVerified;
    data['phone'] = this.phone;
    data['phone_verified'] = this.phoneVerified;
    data['marital_status'] = this.maritalStatus;
    data['photo'] = this.photo;
    data['is_active'] = this.isActive;
    data['login_count'] = this.loginCount;
    data['deleted_at'] = this.deletedAt;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}