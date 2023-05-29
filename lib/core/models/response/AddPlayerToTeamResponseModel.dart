class AddPlayerToTeamResponseModel {
  String? status;
  String? message;
  Data? data;

  AddPlayerToTeamResponseModel({this.status, this.message, this.data});

  AddPlayerToTeamResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? name;
  List<Players>? players;
  List<Null>? coaches;
  String? sId;
  String? clubId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.name,
        this.players,
        this.coaches,
        this.sId,
        this.clubId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['players'] != null) {
      players = <Players>[];
      json['players'].forEach((v) {
        players!.add(Players.fromJson(v));
      });
    }
    if (json['coaches'] != null) {
      coaches = <Null>[];
      json['coaches'].forEach((v) {
        //coaches!.add(Null.fromJson(v));
      });
    }
    sId = json['_id'];
    clubId = json['club_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    if (players != null) {
      data['players'] = players!.map((v) => v.toJson()).toList();
    }
    if (coaches != null) {
      //data['coaches'] = coaches.map((v) => v.toJson()).toList();
    }
    data['_id'] = sId;
    data['club_id'] = clubId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Players {
  String? name;
  String? photo;
  String? clubName;
  String? position;
  String? jerseyNo;
  String? reason;
  String? weight;
  String? height;
  String? age;
  String? dob;
  String? status;
  String? sId;
  String? clubId;
  String? userId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Players(
      {this.name,
        this.photo,
        this.clubName,
        this.position,
        this.jerseyNo,
        this.reason,
        this.weight,
        this.height,
        this.age,
        this.dob,
        this.status,
        this.sId,
        this.clubId,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Players.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    photo = json['photo'];
    clubName = json['club_name'];
    position = json['position'];
    jerseyNo = json['jersey_no'];
    reason = json['reason'];
    weight = json['weight'];
    height = json['height'];
    age = json['age'];
    dob = json['dob'];
    status = json['status'];
    sId = json['_id'];
    clubId = json['club_id'];
    userId = json['user_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['photo'] = photo;
    data['club_name'] = clubName;
    data['position'] = position;
    data['jersey_no'] = jerseyNo;
    data['reason'] = reason;
    data['weight'] = weight;
    data['height'] = height;
    data['age'] = age;
    data['dob'] = dob;
    data['status'] = status;
    data['_id'] = sId;
    data['club_id'] = clubId;
    data['user_id'] = userId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
