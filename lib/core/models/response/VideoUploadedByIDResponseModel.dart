class VideoUploadedByIDResponseModel {
  String? status;
  String? message;
  Data? data;

  VideoUploadedByIDResponseModel({this.status, this.message, this.data});

  VideoUploadedByIDResponseModel.fromJson(Map<String, dynamic> json) {
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
  ModelData? modelData;
  bool? analyzed;
  String? filename;
  String? lastMediaUrl;
  String? statusText;
  String? status;
  String? text;
  String? gpuId;
  String? sId;
  String? userId;
  Null homeTeam;
  Null awayTeam;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.modelData,
        this.analyzed,
        this.filename,
        this.lastMediaUrl,
        this.statusText,
        this.status,
        this.text,
        this.gpuId,
        this.sId,
        this.userId,
        this.homeTeam,
        this.awayTeam,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    modelData = json['model_data'] != null
        ? ModelData.fromJson(json['model_data'])
        : null;
    analyzed = json['analyzed'];
    filename = json['filename'];
    lastMediaUrl = json['last_media_url'];
    statusText = json['statusText'];
    status = json['status'];
    text = json['text'];
    gpuId = json['gpu_id'];
    sId = json['_id'];
    userId = json['user_id'];
    homeTeam = json['home_team'];
    awayTeam = json['away_team'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (modelData != null) {
      data['model_data'] = modelData!.toJson();
    }
    data['analyzed'] = analyzed;
    data['filename'] = filename;
    data['last_media_url'] = lastMediaUrl;
    data['statusText'] = statusText;
    data['status'] = status;
    data['text'] = text;
    data['gpu_id'] = gpuId;
    data['_id'] = sId;
    data['user_id'] = userId;
    data['home_team'] = homeTeam;
    data['away_team'] = awayTeam;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class ModelData {
  TeamA? teamA;
  TeamA? teamB;
  Url? url;
  bool? isFootballVideo;
  dynamic team1Possession;
  dynamic team2Possession;
  dynamic team1Penalty;
  dynamic team2Penalty;
  dynamic team1Longpass;
  dynamic team2Longpass;
  dynamic team1Cross;
  dynamic team2Cross;
  dynamic team1Freethrow;
  dynamic team2Freethrow;
  dynamic team1Shortpass;
  dynamic team2Shortpass;
  dynamic team1Foul;
  dynamic team2Foul;
  dynamic team1Cornerkick;
  dynamic team2Cornerkick;
  dynamic team1FreeKick;
  dynamic team2FreeKick;
  dynamic team1Longshot;
  dynamic team2Longshot;
  dynamic team1Yellowcard;
  dynamic team2Yellowcard;
  dynamic team1Shots;
  dynamic team2Shots;
  dynamic team1Save;
  dynamic team2Save;
  dynamic team1Dribble;
  dynamic team2Dribble;
  dynamic team1Redcard;
  dynamic team2Redcard;
  dynamic team1Tackle;
  dynamic team2Tackle;
  dynamic team1Goals;
  dynamic team2Goals;
  //Actions actions;
  //Highlightreels highlightreels;

  ModelData(
      {this.teamA,
        this.teamB,
        this.url,
        this.isFootballVideo,
        this.team1Possession,
        this.team2Possession,
        this.team1Penalty,
        this.team2Penalty,
        this.team1Longpass,
        this.team2Longpass,
        this.team1Cross,
        this.team2Cross,
        this.team1Freethrow,
        this.team2Freethrow,
        this.team1Shortpass,
        this.team2Shortpass,
        this.team1Foul,
        this.team2Foul,
        this.team1Cornerkick,
        this.team2Cornerkick,
        this.team1FreeKick,
        this.team2FreeKick,
        this.team1Longshot,
        this.team2Longshot,
        this.team1Yellowcard,
        this.team2Yellowcard,
        this.team1Shots,
        this.team2Shots,
        this.team1Save,
        this.team2Save,
        this.team1Dribble,
        this.team2Dribble,
        this.team1Redcard,
        this.team2Redcard,
        this.team1Tackle,
        this.team2Tackle,
        this.team1Goals,
        this.team2Goals,
        //this.actions,
        //this.highlightreels
      });

  ModelData.fromJson(Map<String, dynamic> json) {
    teamA = json['TeamA'] != null ? TeamA.fromJson(json['TeamA']) : null;
    teamB = json['TeamB'] != null ? TeamA.fromJson(json['TeamB']) : null;
    url = json['url'] != null ? Url.fromJson(json['url']) : null;
    isFootballVideo = json['isFootballVideo'];
    team1Possession = json['team1_possession'];
    team2Possession = json['team2_possession'];
    team1Penalty = json['team1_penalty'];
    team2Penalty = json['team2_penalty'];
    team1Longpass = json['team1_longpass'];
    team2Longpass = json['team2_longpass'];
    team1Cross = json['team1_cross'];
    team2Cross = json['team2_cross'];
    team1Freethrow = json['team1_freethrow'];
    team2Freethrow = json['team2_freethrow'];
    team1Shortpass = json['team1_shortpass'];
    team2Shortpass = json['team2_shortpass'];
    team1Foul = json['team1_foul'];
    team2Foul = json['team2_foul'];
    team1Cornerkick = json['team1_cornerkick'];
    team2Cornerkick = json['team2_cornerkick'];
    team1FreeKick = json['team1_free_kick'];
    team2FreeKick = json['team2_free_kick'];
    team1Longshot = json['team1_longshot'];
    team2Longshot = json['team2_longshot'];
    team1Yellowcard = json['team1_yellowcard'];
    team2Yellowcard = json['team2_yellowcard'];
    team1Shots = json['team1_shots'];
    team2Shots = json['team2_shots'];
    team1Save = json['team1_save'];
    team2Save = json['team2_save'];
    team1Dribble = json['team1_dribble'];
    team2Dribble = json['team2_dribble'];
    team1Redcard = json['team1_redcard'];
    team2Redcard = json['team2_redcard'];
    team1Tackle = json['team1_tackle'];
    team2Tackle = json['team2_tackle'];
    team1Goals = json['team1_goals'];
    team2Goals = json['team2_goals'];
    //actions = json['actions'] != null ? new Actions.fromJson(json['actions']) : null;
    // highlightreels = json['highlightreels'] != null
    //     ? Highlightreels.fromJson(json['highlightreels'])
    //     : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (teamA != null) {
      data['TeamA'] = teamA!.toJson();
    }
    if (teamB != null) {
      data['TeamB'] = teamB!.toJson();
    }
    if (url != null) {
      data['url'] = url!.toJson();
    }
    data['isFootballVideo'] = isFootballVideo;
    data['team1_possession'] = team1Possession;
    data['team2_possession'] = team2Possession;
    data['team1_penalty'] = team1Penalty;
    data['team2_penalty'] = team2Penalty;
    data['team1_longpass'] = team1Longpass;
    data['team2_longpass'] = team2Longpass;
    data['team1_cross'] = team1Cross;
    data['team2_cross'] = team2Cross;
    data['team1_freethrow'] = team1Freethrow;
    data['team2_freethrow'] = team2Freethrow;
    data['team1_shortpass'] = team1Shortpass;
    data['team2_shortpass'] = team2Shortpass;
    data['team1_foul'] = team1Foul;
    data['team2_foul'] = team2Foul;
    data['team1_cornerkick'] = team1Cornerkick;
    data['team2_cornerkick'] = team2Cornerkick;
    data['team1_free_kick'] = team1FreeKick;
    data['team2_free_kick'] = team2FreeKick;
    data['team1_longshot'] = team1Longshot;
    data['team2_longshot'] = team2Longshot;
    data['team1_yellowcard'] = team1Yellowcard;
    data['team2_yellowcard'] = team2Yellowcard;
    data['team1_shots'] = team1Shots;
    data['team2_shots'] = team2Shots;
    data['team1_save'] = team1Save;
    data['team2_save'] = team2Save;
    data['team1_dribble'] = team1Dribble;
    data['team2_dribble'] = team2Dribble;
    data['team1_redcard'] = team1Redcard;
    data['team2_redcard'] = team2Redcard;
    data['team1_tackle'] = team1Tackle;
    data['team2_tackle'] = team2Tackle;
    data['team1_goals'] = team1Goals;
    data['team2_goals'] = team2Goals;
    // if (this.actions != null) {
    //   data['actions'] = this.actions.toJson();
    // }
    // if (highlightreels != null) {
    //   data['highlightreels'] = highlightreels.toJson();
    // }
    return data;
  }
}

class TeamA {
  List<Players>? players;

  TeamA({this.players});

  TeamA.fromJson(Map<String, dynamic> json) {
    if (json['Players'] != null) {
      players = <Players>[];
      json['Players'].forEach((v) {
        players!.add(Players.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (players != null) {
      data['Players'] = players!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Players {
  String? team;
  String? position;
  String? name;
  String? jerseyNo;
  String? weight;
  String? height;
  String? color;
  dynamic formation;
  String? image;
  dynamic ballPossession;
  dynamic goalAttempt;
  dynamic truePasses;
  dynamic passes;
  String? time;
  String? sId;
  Speed? speed;
  Speed? distance;
  Penalty? penalty;
  Penalty? longPass;
  Penalty? cross;
  Penalty? freeThrow;
  Penalty? shortPass;
  Penalty? foul;
  Penalty? cornerkick;
  Penalty? freekick;
  Penalty? longShot;
  Penalty? yellowCard;
  Penalty? shot;
  BallSaved? ballSaved;
  Penalty? dribble;
  Penalty? redCard;
  Penalty? tackle;
  Penalty? goal;

  Players(
      {this.team,
        this.position,
        this.name,
        this.jerseyNo,
        this.weight,
        this.height,
        this.color,
        this.formation,
        this.image,
        this.ballPossession,
        this.goalAttempt,
        this.truePasses,
        this.passes,
        this.time,
        this.sId,
        this.speed,
        this.distance,
        this.penalty,
        this.longPass,
        this.cross,
        this.freeThrow,
        this.shortPass,
        this.foul,
        this.cornerkick,
        this.freekick,
        this.longShot,
        this.yellowCard,
        this.shot,
        this.ballSaved,
        this.dribble,
        this.redCard,
        this.tackle,
        this.goal});

  Players.fromJson(Map<String, dynamic> json) {
    team = json['Team'];
    position = json['Position'];
    name = json['Name'];
    jerseyNo = json['Jersey_no'];
    weight = json['Weight'];
    height = json['Height'];
    color = json['Color'];
    formation = json['Formation'];
    image = json['Image'];
    ballPossession = json['Ball_possession'];
    goalAttempt = json['Goal_attempt'];
    truePasses = json['True_passes'];
    passes = json['Passes'];
    time = json['Time'];
    sId = json['_id'];
    speed = json['Speed'] != null ? Speed.fromJson(json['Speed']) : null;
    distance =
    json['Distance'] != null ? Speed.fromJson(json['Distance']) : null;
    penalty =
    json['penalty'] != null ? Penalty.fromJson(json['penalty']) : null;
    longPass = json['long_pass'] != null
        ? Penalty.fromJson(json['long_pass'])
        : null;
    cross = json['cross'] != null ? Penalty.fromJson(json['cross']) : null;
    freeThrow = json['free_throw'] != null
        ? Penalty.fromJson(json['free_throw'])
        : null;
    shortPass = json['short_pass'] != null
        ? Penalty.fromJson(json['short_pass'])
        : null;
    foul = json['foul'] != null ? Penalty.fromJson(json['foul']) : null;
    cornerkick = json['cornerkick'] != null
        ? Penalty.fromJson(json['cornerkick'])
        : null;
    freekick = json['freekick'] != null
        ? Penalty.fromJson(json['freekick'])
        : null;
    longShot = json['long_shot'] != null
        ? Penalty.fromJson(json['long_shot'])
        : null;
    yellowCard = json['yellow_card'] != null
        ? Penalty.fromJson(json['yellow_card'])
        : null;
    shot = json['shot'] != null ? Penalty.fromJson(json['shot']) : null;
    ballSaved = json['ball_saved'] != null
        ? BallSaved.fromJson(json['ball_saved'])
        : null;
    dribble =
    json['dribble'] != null ? Penalty.fromJson(json['dribble']) : null;
    redCard = json['red_card'] != null
        ? Penalty.fromJson(json['red_card'])
        : null;
    tackle =
    json['tackle'] != null ? Penalty.fromJson(json['tackle']) : null;
    goal = json['goal'] != null ? Penalty.fromJson(json['goal']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Team'] = team;
    data['Position'] = position;
    data['Name'] = name;
    data['Jersey_no'] = jerseyNo;
    data['Weight'] = weight;
    data['Height'] = height;
    data['Color'] = color;
    data['Formation'] = formation;
    data['Image'] = image;
    data['Ball_possession'] = ballPossession;
    data['Goal_attempt'] = goalAttempt;
    data['True_passes'] = truePasses;
    data['Passes'] = passes;
    data['Time'] = time;
    data['_id'] = sId;
    if (speed != null) {
      data['Speed'] = speed!.toJson();
    }
    if (distance != null) {
      data['Distance'] = distance!.toJson();
    }
    if (penalty != null) {
      data['penalty'] = penalty!.toJson();
    }
    if (longPass != null) {
      data['long_pass'] = longPass!.toJson();
    }
    if (cross != null) {
      data['cross'] = cross!.toJson();
    }
    if (freeThrow != null) {
      data['free_throw'] = freeThrow!.toJson();
    }
    if (shortPass != null) {
      data['short_pass'] = shortPass!.toJson();
    }
    if (foul != null) {
      data['foul'] = foul!.toJson();
    }
    if (cornerkick != null) {
      data['cornerkick'] = cornerkick!.toJson();
    }
    if (freekick != null) {
      data['freekick'] = freekick!.toJson();
    }
    if (longShot != null) {
      data['long_shot'] = longShot!.toJson();
    }
    if (yellowCard != null) {
      data['yellow_card'] = yellowCard!.toJson();
    }
    if (shot != null) {
      data['shot'] = shot!.toJson();
    }
    if (ballSaved != null) {
      data['ball_saved'] = ballSaved!.toJson();
    }
    if (dribble != null) {
      data['dribble'] = dribble!.toJson();
    }
    if (redCard != null) {
      data['red_card'] = redCard!.toJson();
    }
    if (tackle != null) {
      data['tackle'] = tackle!.toJson();
    }
    if (goal != null) {
      data['goal'] = goal!.toJson();
    }
    return data;
  }
}

class Speed {
  dynamic d3;
  dynamic d6;
  dynamic d9;
  dynamic d12;
  dynamic d15;
  dynamic d18;
  dynamic d21;
  dynamic i0;

  Speed(
      {this.d3,
        this.d6,
        this.d9,
        this.d12,
        this.d15,
        this.d18,
        this.d21,
        this.i0});

  Speed.fromJson(Map<String, dynamic> json) {
    d3 = json['3'];
    d6 = json['6'];
    d9 = json['9'];
    d12 = json['12'];
    d15 = json['15'];
    d18 = json['18'];
    d21 = json['21'];
    i0 = json['0'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['3'] = d3;
    data['6'] = d6;
    data['9'] = d9;
    data['12'] = d12;
    data['15'] = d15;
    data['18'] = d18;
    data['21'] = d21;
    data['0'] = i0;
    return data;
  }
}

class Penalty {
  dynamic i0;
  dynamic i3;
  dynamic i6;
  dynamic i9;
  dynamic i12;

  Penalty({this.i0, this.i3, this.i6, this.i9, this.i12});

  Penalty.fromJson(Map<String, dynamic> json) {
    i0 = json['0'];
    i3 = json['3'];
    i6 = json['6'];
    i9 = json['9'];
    i12 = json['12'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['0'] = i0;
    data['3'] = i3;
    data['6'] = i6;
    data['9'] = i9;
    data['12'] = i12;
    return data;
  }
}

class BallSaved {
  dynamic i0;

  BallSaved({this.i0});

  BallSaved.fromJson(Map<String, dynamic> json) {
    i0 = json['0'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['0'] = i0;
    return data;
  }
}

class Url {
  String? objectDetection;
  String? minimap;
  String? team;
  String? weight;
  String? height;
  String? color;
  String? formation;
  String? position;
  String? name;
  String? jerseynumber;

  Url(
      {this.objectDetection,
        this.minimap,
        this.team,
        this.weight,
        this.height,
        this.color,
        this.formation,
        this.position,
        this.name,
        this.jerseynumber});

  Url.fromJson(Map<String, dynamic> json) {
    objectDetection = json['object_detection'];
    minimap = json['minimap'];
    team = json['team'];
    weight = json['weight'];
    height = json['height'];
    color = json['color'];
    formation = json['formation'];
    position = json['position'];
    name = json['name'];
    jerseynumber = json['jerseynumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['object_detection'] = objectDetection;
    data['minimap'] = minimap;
    data['team'] = team;
    data['weight'] = weight;
    data['height'] = height;
    data['color'] = color;
    data['formation'] = formation;
    data['position'] = position;
    data['name'] = name;
    data['jerseynumber'] = jerseynumber;
    return data;
  }
}

// class Actions {
//   List<String> action0;
//   List<String> action1;
//   List<String> action2;
//   List<String> action3;
//   List<String> action4;
//   List<String> action5;
//   List<String> action6;
//   List<String> action7;
//   List<String> action8;
//   List<String> action9;
//
//   Actions(
//       {this.action0,
//         this.action1,
//         this.action2,
//         this.action3,
//         this.action4,
//         this.action5,
//         this.action6,
//         this.action7,
//         this.action8,
//         this.action9});
//
//   Actions.fromJson(Map<String, dynamic> json) {
//     action0 = json['Action_0'].cast<String>();
//     action1 = json['Action_1'].cast<String>();
//     action2 = json['Action_2'].cast<String>();
//     action3 = json['Action_3'].cast<String>();
//     action4 = json['Action_4'].cast<String>();
//     action5 = json['Action_5'].cast<String>();
//     action6 = json['Action_6'].cast<String>();
//     action7 = json['Action_7'].cast<String>();
//     action8 = json['Action_8'].cast<String>();
//     action9 = json['Action_9'].cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['Action_0'] = this.action0;
//     data['Action_1'] = this.action1;
//     data['Action_2'] = this.action2;
//     data['Action_3'] = this.action3;
//     data['Action_4'] = this.action4;
//     data['Action_5'] = this.action5;
//     data['Action_6'] = this.action6;
//     data['Action_7'] = this.action7;
//     data['Action_8'] = this.action8;
//     data['Action_9'] = this.action9;
//     return data;
//   }
// }

class Highlightreels {
  String? freekick;
  String? shortPass;

  Highlightreels({this.freekick, this.shortPass});

  Highlightreels.fromJson(Map<String, dynamic> json) {
    freekick = json['freekick'];
    shortPass = json['short_pass'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['freekick'] = freekick;
    data['short_pass'] = shortPass;
    return data;
  }
}