class CompareVideosModel {
  String? status;
  String? message;
  List<CompareVideosModelData>? compareVideosModelData;

  CompareVideosModel({this.status, this.message, this.compareVideosModelData});

  CompareVideosModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      compareVideosModelData = <CompareVideosModelData>[];
      json['data'].forEach((v) {
        compareVideosModelData!.add(new CompareVideosModelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.compareVideosModelData != null) {
      data['data'] = this.compareVideosModelData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CompareVideosModelData {
  String? id;
  String? analyticsId;
  String? pitchSide;
  int? shortPass;
  int? foul;
  int? shots;
  int? penalty;
  int? ballPossession;
  int? freeKick;
  int? dribble;
  String? offside;
  int? corners;
  int? longPass;
  int? freeThrow;
  int? longShot;
  int? cross;
  String? interceptions;
  String? isHome;
  String? tempTeamName;
  int? tackles;
  int? yellowCards;
  int? redCards;
  int? saves;
  int? goals;
  String? sampleImage;
  String? clubId;
  String? createdAt;
  String? updatedAt;

  CompareVideosModelData(
      {this.id,
        this.analyticsId,
        this.pitchSide,
        this.shortPass,
        this.foul,
        this.shots,
        this.penalty,
        this.ballPossession,
        this.freeKick,
        this.dribble,
        this.offside,
        this.corners,
        this.longPass,
        this.freeThrow,
        this.longShot,
        this.cross,
        this.interceptions,
        this.isHome,
        this.tempTeamName,
        this.tackles,
        this.yellowCards,
        this.redCards,
        this.saves,
        this.goals,
        this.sampleImage,
        this.clubId,
        this.createdAt,
        this.updatedAt});

  CompareVideosModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    analyticsId = json['analytics_id'];
    pitchSide = json['pitch_side'] ?? "0";
    shortPass = json['short_pass'] ?? 0;
    foul = json['foul'] ?? 0;
    shots = json['shots'] ?? 0;
    penalty = json['penalty'] ?? 0;
    ballPossession = json['ball_possession'] ?? 0;
    freeKick = json['free_kick'] ?? 0;
    dribble = json['dribble'] ?? 0;
    offside = json['offside'] ?? "0";
    corners = json['corners'] ?? 0;
    longPass = json['long_pass'] ?? 0;
    freeThrow = json['free_throw'] ?? 0;
    longShot = json['long_shot'] ?? 0;
    cross = json['cross'] ?? 0;
    interceptions = json['interceptions'] ?? "0";
    isHome = json['is_home'] ?? "0";
    tempTeamName = json['temp_team_name'] ?? "0";
    tackles = json['tackles'] ?? 0;
    yellowCards = json['yellow_cards'] ?? 0;
    redCards = json['red_cards'] ?? 0;
    saves = json['saves'] ?? 0;
    goals = json['goals'] ?? 0;
    sampleImage = json['sample_image'];
    clubId = json['club_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['analytics_id'] = this.analyticsId;
    data['pitch_side'] = this.pitchSide;
    data['short_pass'] = this.shortPass;
    data['foul'] = this.foul;
    data['shots'] = this.shots;
    data['penalty'] = this.penalty;
    data['ball_possession'] = this.ballPossession;
    data['free_kick'] = this.freeKick;
    data['dribble'] = this.dribble;
    data['offside'] = this.offside;
    data['corners'] = this.corners;
    data['long_pass'] = this.longPass;
    data['free_throw'] = this.freeThrow;
    data['long_shot'] = this.longShot;
    data['cross'] = this.cross;
    data['interceptions'] = this.interceptions;
    data['is_home'] = this.isHome;
    data['temp_team_name'] = this.tempTeamName;
    data['tackles'] = this.tackles;
    data['yellow_cards'] = this.yellowCards;
    data['red_cards'] = this.redCards;
    data['saves'] = this.saves;
    data['goals'] = this.goals;
    data['sample_image'] = this.sampleImage;
    data['club_id'] = this.clubId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
