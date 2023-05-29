class CreateTeamResponseModel {
  String? status;
  String? message;
  Data? data;

  CreateTeamResponseModel({this.status, this.message, this.data});

  CreateTeamResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  List<Null>? players;
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
      players = <Null>[];
      json['players'].forEach((v) {
        //players!.add(new Null.fromJson(v));
      });
    }
    if (json['coaches'] != null) {
      coaches = <Null>[];
      json['coaches'].forEach((v) {
        //coaches!.add(new Null.fromJson(v));
      });
    }
    sId = json['_id'];
    clubId = json['club_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.players != null) {
      //data['players'] = this.players!.map((v) => v.toJson()).toList();
    }
    if (this.coaches != null) {
      //data['coaches'] = this.coaches!.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['club_id'] = this.clubId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}