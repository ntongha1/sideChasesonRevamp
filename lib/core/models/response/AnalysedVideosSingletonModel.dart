class AnalysedVideosSingletonModel {
  String? status;
  String? message;
  Data? data;

  AnalysedVideosSingletonModel({this.status, this.message, this.data});

  AnalysedVideosSingletonModel.fromJson(Map<dynamic, dynamic> json) {
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
  String? id;
  int? analysed;
  String? choice;
  String? gpuId;
  String? lastMediaUrl;
  String? about;
  String? userId;
  String? clubId;
  String? statusText;
  String? code;
  String? text;
  String? filename;
  int? firstView;
  int? fps;
  int? videoLength;
  String? videoUploadType;
  String? fullVideo;
  String? gameId;
  String? createdAt;
  String? updatedAt;
  List<ClubStats>? clubStats;
  List<Actions>? actions;
  String? minimap;
  List<ActionsUrls>? actionsUrls;

  Data(
      {this.id,
        this.analysed,
        this.choice,
        this.gpuId,
        this.lastMediaUrl,
        this.about,
        this.userId,
        this.clubId,
        this.statusText,
        this.code,
        this.text,
        this.filename,
        this.firstView,
        this.fps,
        this.videoLength,
        this.videoUploadType,
        this.fullVideo,
        this.gameId,
        this.createdAt,
        this.updatedAt,
        this.clubStats,
        this.actions,
        this.minimap,
        this.actionsUrls});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    analysed = json['analysed'];
    choice = json['choice'];
    gpuId = json['gpu_id'];
    lastMediaUrl = json['last_media_url'];
    about = json['about'];
    userId = json['user_id'];
    clubId = json['club_id'];
    statusText = json['status_text'];
    code = json['code'];
    text = json['text'];
    filename = json['filename'];
    firstView = json['first_view'];
    fps = json['fps'];
    videoLength = json['video_length'];
    videoUploadType = json['video_upload_type'];
    fullVideo = json['full_video'];
    gameId = json['game_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['club_stats'] != null) {
      clubStats = <ClubStats>[];
      json['club_stats'].forEach((v) {
        clubStats!.add(new ClubStats.fromJson(v));
      });
    }
    if (json['actions'] != null) {
      actions = <Actions>[];
      json['actions'].forEach((v) {
        actions!.add(new Actions.fromJson(v));
      });
    }
    minimap = json['minimap'];
    if (json['actions_urls'] != null) {
      actionsUrls = <ActionsUrls>[];
      json['actions_urls'].forEach((v) {
        actionsUrls!.add(new ActionsUrls.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['analysed'] = this.analysed;
    data['choice'] = this.choice;
    data['gpu_id'] = this.gpuId;
    data['last_media_url'] = this.lastMediaUrl;
    data['about'] = this.about;
    data['user_id'] = this.userId;
    data['club_id'] = this.clubId;
    data['status_text'] = this.statusText;
    data['code'] = this.code;
    data['text'] = this.text;
    data['filename'] = this.filename;
    data['first_view'] = this.firstView;
    data['fps'] = this.fps;
    data['video_length'] = this.videoLength;
    data['video_upload_type'] = this.videoUploadType;
    data['full_video'] = this.fullVideo;
    data['game_id'] = this.gameId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.clubStats != null) {
      data['club_stats'] = this.clubStats!.map((v) => v.toJson()).toList();
    }
    if (this.actions != null) {
      data['actions'] = this.actions!.map((v) => v.toJson()).toList();
    }
    data['minimap'] = this.minimap;
    if (this.actionsUrls != null) {
      data['actions_urls'] = this.actionsUrls!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClubStats {
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
  int? offside;
  int? corners;
  int? longPass;
  int? freeThrow;
  int? longShot;
  int? cross;
  int? interceptions;
  bool? isHome;
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

  ClubStats(
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

  ClubStats.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    analyticsId = json['analytics_id'];
    pitchSide = json['pitch_side'];
    shortPass = json['short_pass'];
    foul = json['foul'];
    shots = json['shots'];
    penalty = json['penalty'];
    ballPossession = json['ball_possession'];
    freeKick = json['free_kick'];
    dribble = json['dribble'];
    offside = json['offside'];
    corners = json['corners'];
    longPass = json['long_pass'];
    freeThrow = json['free_throw'];
    longShot = json['long_shot'];
    cross = json['cross'];
    interceptions = json['interceptions'];
    isHome = json['is_home'];
    tempTeamName = json['temp_team_name'];
    tackles = json['tackles'];
    yellowCards = json['yellow_cards'];
    redCards = json['red_cards'];
    saves = json['saves'];
    goals = json['goals'];
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

class Actions {
  String? id;
  String? playerPosition;
  String? actionId;
  String? analyticsId;
  String? actiontype;
  int? periodId;
  int? timeSeconds;
  int? teamId;
  String? playerId;
  String? player;
  int? startX;
  int? startY;
  int? endX;
  int? endY;
  int? typeId;
  int? resultId;
  String? result;
  String? bodypart;
  int? bodypartId;
  String? team;
  int? startTime;
  int? endTime;
  String? createdAt;
  String? updatedAt;
  Action? action;

  Actions(
      {this.id,
        this.playerPosition,
        this.actionId,
        this.analyticsId,
        this.actiontype,
        this.periodId,
        this.timeSeconds,
        this.teamId,
        this.playerId,
        this.player,
        this.startX,
        this.startY,
        this.endX,
        this.endY,
        this.typeId,
        this.resultId,
        this.result,
        this.bodypart,
        this.bodypartId,
        this.team,
        this.startTime,
        this.endTime,
        this.createdAt,
        this.updatedAt,
        this.action});

  Actions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    playerPosition = json['player_position'] ?? "";
    actionId = json['action_id'];
    analyticsId = json['analytics_id'];
    actiontype = json['actiontype'];
    periodId = json['period_id'];
    timeSeconds = json['time_seconds'];
    teamId = json['team_id'];
    playerId = json['player_id'];
    player = json['player'];
    startX = json['start_x'];
    startY = json['start_y'];
    endX = json['end_x'];
    endY = json['end_y'];
    typeId = json['type_id'];
    resultId = json['result_id'];
    result = json['result'];
    bodypart = json['bodypart'];
    bodypartId = json['bodypart_id'];
    team = json['team'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    action =
    json['action'] != null ? new Action.fromJson(json['action']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['player_position'] = this.playerPosition;
    data['action_id'] = this.actionId;
    data['analytics_id'] = this.analyticsId;
    data['actiontype'] = this.actiontype;
    data['period_id'] = this.periodId;
    data['time_seconds'] = this.timeSeconds;
    data['team_id'] = this.teamId;
    data['player_id'] = this.playerId;
    data['player'] = this.player;
    data['start_x'] = this.startX;
    data['start_y'] = this.startY;
    data['end_x'] = this.endX;
    data['end_y'] = this.endY;
    data['type_id'] = this.typeId;
    data['result_id'] = this.resultId;
    data['result'] = this.result;
    data['bodypart'] = this.bodypart;
    data['bodypart_id'] = this.bodypartId;
    data['team'] = this.team;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.action != null) {
      data['action'] = this.action!.toJson();
    }
    return data;
  }
}

class Action {
  String? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Action({this.id, this.name, this.createdAt, this.updatedAt});

  Action.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ActionsUrls {
  String? videoUrl;
  String? actionId;
  Action? action;
  String? name;

  ActionsUrls({this.videoUrl, this.actionId, this.action, this.name});

  ActionsUrls.fromJson(Map<String, dynamic> json) {
    videoUrl = json['video_url'];
    actionId = json['action_id'];
    action =
    json['action'] != null ? new Action.fromJson(json['action']) : null;
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video_url'] = this.videoUrl;
    data['action_id'] = this.actionId;
    if (this.action != null) {
      data['action'] = this.action!.toJson();
    }
    data['name'] = this.name;
    return data;
  }
}