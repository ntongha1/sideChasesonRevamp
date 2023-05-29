class CreateStaffResponseModel {
  String? status;
  String? message;
  Data? data;

  CreateStaffResponseModel({this.status, this.message, this.data});

  CreateStaffResponseModel.fromJson(Map<String, dynamic> json) {
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
  User? user;
  String? authToken;

  Data({this.user, this.authToken});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    authToken = json['auth_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['auth_token'] = this.authToken;
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
  String? lastname;
  String? firstname;
  String? email;
  String? createdAt;
  String? updatedAt;
  int? iV;

  User(
      {this.photo,
        this.role,
        this.club,
        this.loginCount,
        this.permision,
        this.sId,
        this.lastname,
        this.firstname,
        this.email,
        this.createdAt,
        this.updatedAt,
        this.iV});

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
    lastname = json['lastname'];
    firstname = json['firstname'];
    email = json['email'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo'] = this.photo;
    data['role'] = this.role;
    data['club'] = this.club;
    data['login_count'] = this.loginCount;
    if (this.permision != null) {
      //data['permision'] = this.permision!.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['lastname'] = this.lastname;
    data['firstname'] = this.firstname;
    data['email'] = this.email;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}