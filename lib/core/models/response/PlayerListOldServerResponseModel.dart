class PlayerListOldServerResponseModel {
  String? status;
  String? message;
  List<PlayerListOldServerResponseModelData>? playerListOldServerResponseModelData;
  int? totalPages;
  int? currentPage;

  PlayerListOldServerResponseModel(
      {this.status,
        this.message,
        this.playerListOldServerResponseModelData,
        this.totalPages,
        this.currentPage});

  PlayerListOldServerResponseModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      playerListOldServerResponseModelData = <PlayerListOldServerResponseModelData>[];
      json['data'].forEach((v) {
        playerListOldServerResponseModelData!.add(PlayerListOldServerResponseModelData.fromJson(v));
      });
    }
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (playerListOldServerResponseModelData != null) {
      data['data'] = playerListOldServerResponseModelData!.map((v) => v.toJson()).toList();
    }
    data['totalPages'] = totalPages;
    data['currentPage'] = currentPage;
    return data;
  }
}

class PlayerListOldServerResponseModelData {
  String? firstname;
  String? lastname;
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
  String? userId;
  String? clubId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  PlayerListOldServerResponseModelData(
      {this.firstname,
        this.lastname,
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
        this.userId,
        this.clubId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  PlayerListOldServerResponseModelData.fromJson(Map<String, dynamic> json) {
    firstname = json['firstname'];
    lastname = json['lastname'];
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
    userId = json['user_id'];
    clubId = json['club_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstname'] = firstname;
    data['lastname'] = lastname;
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
    data['user_id'] = userId;
    data['club_id'] = clubId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
