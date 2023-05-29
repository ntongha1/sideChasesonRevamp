import 'package:sonalysis/features/common/models/ComparePlayersModel.dart';

class CompareVTVModel {
  String? status;
  String? message;
  List<Data>? data;

  CompareVTVModel({this.status, this.message, this.data});

  CompareVTVModel.fromJson(Map<dynamic, dynamic> json) {
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
  Analytics? analytics;
  Player? player;

  Data({this.analytics});

  Data.fromJson(Map<String, dynamic> json) {
    analytics = json['analytics'] != null
        ? new Analytics.fromJson(json['analytics'])
        : null;
    player =
        json['player'] != null ? new Player.fromJson(json['player']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.analytics != null) {
      data['analytics'] = this.analytics!.toJson();
      data['player'] = this.player!.toJson();
    }
    return data;
  }
}

class Analytics {
  int? long_pass;
  int? short_pass;
  int? dribble;
  int? shots;
  int? tackles;
  int? yellow_cards;
  int? red_cards;
  int? foul;
  int? offside;
  int? ball_possession;
  int? free_kick;
  int? penalty;
  int? corners;
  int? free_throw;
  int? goals;
  int? saves;
  int? cross;
  int? long_shot;

  Analytics(
      {this.long_pass,
      this.short_pass,
      this.dribble,
      this.shots,
      this.tackles,
      this.yellow_cards,
      this.red_cards,
      this.foul,
      this.offside,
      this.ball_possession,
      this.free_kick,
      this.penalty,
      this.corners,
      this.free_throw,
      this.goals,
      this.saves,
      this.cross,
      this.long_shot});

  Analytics.fromJson(Map<String, dynamic> json) {
    long_pass = json['long_pass'];
    short_pass = json['short_pass'];
    dribble = json['dribble'];
    shots = json['shots'];
    tackles = json['tackles'];
    yellow_cards = json['yellow_cards'];
    red_cards = json['red_cards'];
    foul = json['foul'];
    offside = json['offside'];
    ball_possession = json['ball_possession'];
    free_kick = json['free_kick'];
    penalty = json['penalty'];
    corners = json['corners'];
    free_throw = json['free_throw'];
    goals = json['goals'];
    saves = json['saves'];
    cross = json['cross'];
    long_shot = json['long_shot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['long_pass'] = this.long_pass;
    data['short_pass'] = this.short_pass;
    data['dribble'] = this.dribble;
    data['shots'] = this.shots;
    data['tackles'] = this.tackles;
    data['yellow_cards'] = this.yellow_cards;
    data['red_cards'] = this.red_cards;
    data['foul'] = this.foul;
    data['offside'] = this.offside;
    data['ball_possession'] = this.ball_possession;
    data['free_kick'] = this.free_kick;
    data['penalty'] = this.penalty;
    data['corners'] = this.corners;
    data['free_throw'] = this.free_throw;
    data['goals'] = this.goals;
    data['saves'] = this.saves;
    data['cross'] = this.cross;
    data['long_shot'] = this.long_shot;

    return data;
  }
}
