class ComparePlayersModel {
  String? status;
  String? message;
  List<Data>? data;

  ComparePlayersModel({this.status, this.message, this.data});

  ComparePlayersModel.fromJson(Map<dynamic, dynamic> json) {
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
  Player? player;
  int? speed;
  int? goal;
  int? freeKick;
  int? longPass;
  int? shortPass;
  int? redCard;
  int? yellowCard;
  int? penalty;

  Data(
      {this.player,
        this.speed,
        this.goal,
        this.freeKick,
        this.longPass,
        this.shortPass,
        this.redCard,
        this.yellowCard,
        this.penalty});

  Data.fromJson(Map<String, dynamic> json) {
    player =
    json['player'] != null ? new Player.fromJson(json['player']) : null;
    speed = json['speed'];
    goal = json['goal'];
    freeKick = json['free_kick'];
    longPass = json['long_pass'];
    shortPass = json['short_pass'];
    redCard = json['red_card'];
    yellowCard = json['yellow_card'];
    penalty = json['penalty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.player != null) {
      data['player'] = this.player!.toJson();
    }
    data['speed'] = this.speed;
    data['goal'] = this.goal;
    data['free_kick'] = this.freeKick;
    data['long_pass'] = this.longPass;
    data['short_pass'] = this.shortPass;
    data['red_card'] = this.redCard;
    data['yellow_card'] = this.yellowCard;
    data['penalty'] = this.penalty;
    return data;
  }
}

class Player {
  String? id;
  String? firstName;
  String? lastName;
  String? dob;
  String? age;
  String? gender;
  String? jerseyNo;
  String? userId;
  String? clubId;
  String? weight;
  String? height;
  String? photo;
  String? position;
  String? teamName;
  String? createdAt;
  String? updatedAt;

  Player(
      {this.id,
        this.firstName,
        this.lastName,
        this.dob,
        this.age,
        this.gender,
        this.jerseyNo,
        this.userId,
        this.clubId,
        this.weight,
        this.height,
        this.photo,
        this.position,
        this.teamName,
        this.createdAt,
        this.updatedAt});

  Player.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    dob = json['dob'];
    age = json['age'];
    gender = json['gender'];
    jerseyNo = json['jersey_no'];
    userId = json['user_id'];
    clubId = json['club_id'];
    weight = json['weight'];
    height = json['height'];
    photo = json['photo'];
    position = json['position'];
    teamName = json['team_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['dob'] = this.dob;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['jersey_no'] = this.jerseyNo;
    data['user_id'] = this.userId;
    data['club_id'] = this.clubId;
    data['weight'] = this.weight;
    data['height'] = this.height;
    data['photo'] = this.photo;
    data['position'] = this.position;
    data['team_name'] = this.teamName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
