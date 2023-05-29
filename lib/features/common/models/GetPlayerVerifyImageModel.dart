class GetPlayerVerifyImageModel {
  String? status;
  String? message;
  GetPlayerVerifyImageModelData? getPlayerVerifyImageModelData;

  GetPlayerVerifyImageModel({this.status, this.message, this.getPlayerVerifyImageModelData});

  GetPlayerVerifyImageModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    getPlayerVerifyImageModelData = json['data'] != null ? new GetPlayerVerifyImageModelData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.getPlayerVerifyImageModelData != null) {
      data['data'] = this.getPlayerVerifyImageModelData!.toJson();
    }
    return data;
  }
}

class GetPlayerVerifyImageModelData {
  TeamA? teamA;
  TeamA? teamB;

  GetPlayerVerifyImageModelData({this.teamA, this.teamB});

  GetPlayerVerifyImageModelData.fromJson(Map<String, dynamic> json) {
    teamA = json['team_a'] != null ? new TeamA.fromJson(json['team_a']) : null;
    teamB = json['team_b'] != null ? new TeamA.fromJson(json['team_b']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.teamA != null) {
      data['team_a'] = this.teamA!.toJson();
    }
    if (this.teamB != null) {
      data['team_b'] = this.teamB!.toJson();
    }
    return data;
  }
}

class TeamA {
  String? image;
  String? teamName;

  TeamA({this.image, this.teamName});

  TeamA.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    teamName = json['team_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['team_name'] = this.teamName;
    return data;
  }
}