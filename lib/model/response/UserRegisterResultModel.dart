class UserRegisterResultModel {
  String? status;
  String? message;
  UserRegisterResultData? userRegisterResultData;

  UserRegisterResultModel({this.status, this.message, this.userRegisterResultData});

  UserRegisterResultModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userRegisterResultData = json['data'] != null ? UserRegisterResultData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (userRegisterResultData != null) {
      data['data'] = userRegisterResultData!.toJson();
    }
    return data;
  }
}

class UserRegisterResultData {
  User? user;
  String? authToken;

  UserRegisterResultData({this.user, this.authToken});

  UserRegisterResultData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    authToken = json['auth_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['auth_token'] = authToken;
    return data;
  }
}

class User {
  String? photo;
  String? role;
  String? club;
  int? loginCount;
  List<Null>? permision;
  String? sId;
  String? email;
  String? firstname;
  String? lastname;
  String? country;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? clubId;

  User(
      {this.photo,
        this.role,
        this.club,
        this.loginCount,
        this.permision,
        this.sId,
        this.email,
        this.firstname,
        this.lastname,
        this.country,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.clubId});

  User.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    role = json['role'];
    club = json['club'];
    loginCount = json['login_count'];
    if (json['permision'] != null) {
      permision = <Null>[];
      json['permision'].forEach((v) {
        //permision!.add(new Null.fromJson(v));
      });
    }
    sId = json['_id'];
    email = json['email'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    country = json['country'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    clubId = json['club_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['photo'] = photo;
    data['role'] = role;
    data['club'] = club;
    data['login_count'] = loginCount;
    if (permision != null) {
      //data['permision'] = this.permision.map((v) => v.toJson()).toList();
    }
    data['_id'] = sId;
    data['email'] = email;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['country'] = country;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['club_id'] = clubId;
    return data;
  }
}