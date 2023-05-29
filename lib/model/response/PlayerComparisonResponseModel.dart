class PlayerComparisonResponseModel {
  String? status;
  String? message;
  List<PlayerComparisonResponseModelData>? playerComparisonResponseModelData;

  PlayerComparisonResponseModel({this.status, this.message, this.playerComparisonResponseModelData});

  PlayerComparisonResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      playerComparisonResponseModelData = <PlayerComparisonResponseModelData>[];
      json['data'].forEach((v) {
        playerComparisonResponseModelData!.add(PlayerComparisonResponseModelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (playerComparisonResponseModelData != null) {
      data['data'] = playerComparisonResponseModelData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlayerComparisonResponseModelData {
  String? team;
  String? position;
  String? name;
  String? jerseyNo;
  String? weight;
  String? height;
  String? color;
  int? formation;
  String? image;
  int? ballPossession;
  int? goalAttempt;
  int? truePasses;
  int? passes;
  String? time;
  String? sId;
  Speed? speed;
  Speed? distance;
  Cornerkick? cornerkick;
  Cornerkick? longShot;
  Cornerkick? yellowCard;
  Cornerkick? shot;
  BallSaved? ballSaved;
  Cornerkick? dribble;
  Cornerkick? redCard;
  Cornerkick? tackle;
  Cornerkick? goal;

  PlayerComparisonResponseModelData(
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
        this.cornerkick,
        this.longShot,
        this.yellowCard,
        this.shot,
        this.ballSaved,
        this.dribble,
        this.redCard,
        this.tackle,
        this.goal});

  PlayerComparisonResponseModelData.fromJson(Map<String, dynamic> json) {
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
    cornerkick = json['cornerkick'] != null
        ? Cornerkick.fromJson(json['cornerkick'])
        : null;
    longShot = json['long_shot'] != null
        ? Cornerkick.fromJson(json['long_shot'])
        : null;
    yellowCard = json['yellow_card'] != null
        ? Cornerkick.fromJson(json['yellow_card'])
        : null;
    shot = json['shot'] != null ? Cornerkick.fromJson(json['shot']) : null;
    ballSaved = json['ball_saved'] != null
        ? BallSaved.fromJson(json['ball_saved'])
        : null;
    dribble = json['dribble'] != null
        ? Cornerkick.fromJson(json['dribble'])
        : null;
    redCard = json['red_card'] != null
        ? Cornerkick.fromJson(json['red_card'])
        : null;
    tackle =
    json['tackle'] != null ? Cornerkick.fromJson(json['tackle']) : null;
    goal = json['goal'] != null ? Cornerkick.fromJson(json['goal']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    if (cornerkick != null) {
      data['cornerkick'] = cornerkick!.toJson();
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
  dynamic d24;
  dynamic d27;
  dynamic d33;
  dynamic d42;
  dynamic d45;
  dynamic d48;
  dynamic d51;
  dynamic d54;
  dynamic d57;
  dynamic d60;
  dynamic d63;
  dynamic d66;
  dynamic d69;
  dynamic d72;
  dynamic d75;
  dynamic d78;
  dynamic d81;
  dynamic d84;
  dynamic d87;
  dynamic d90;
  dynamic d93;
  dynamic d96;
  dynamic d99;
  dynamic d102;
  dynamic d105;
  dynamic d108;
  dynamic d111;
  dynamic d114;
  dynamic d117;
  dynamic d120;
  dynamic d123;
  dynamic d126;
  dynamic d129;
  dynamic d132;
  dynamic d135;
  dynamic d138;
  dynamic d141;
  dynamic d144;
  dynamic d147;
  dynamic d150;
  dynamic d153;
  dynamic d156;
  dynamic d159;
  dynamic d162;
  dynamic d30;
  dynamic d39;
  dynamic d165;
  dynamic d168;
  dynamic d171;
  dynamic d174;
  dynamic d177;
  dynamic d180;
  dynamic d183;
  dynamic d186;
  dynamic d189;
  dynamic d192;
  dynamic d195;
  dynamic d198;
  dynamic d201;
  dynamic d204;
  dynamic d207;
  dynamic d210;
  dynamic d213;

  Speed(
      {this.d3,
        this.d6,
        this.d9,
        this.d12,
        this.d15,
        this.d18,
        this.d21,
        this.d24,
        this.d27,
        this.d33,
        this.d42,
        this.d45,
        this.d48,
        this.d51,
        this.d54,
        this.d57,
        this.d60,
        this.d63,
        this.d66,
        this.d69,
        this.d72,
        this.d75,
        this.d78,
        this.d81,
        this.d84,
        this.d87,
        this.d90,
        this.d93,
        this.d96,
        this.d99,
        this.d102,
        this.d105,
        this.d108,
        this.d111,
        this.d114,
        this.d117,
        this.d120,
        this.d123,
        this.d126,
        this.d129,
        this.d132,
        this.d135,
        this.d138,
        this.d141,
        this.d144,
        this.d147,
        this.d150,
        this.d153,
        this.d156,
        this.d159,
        this.d162,
        this.d30,
        this.d39,
        this.d165,
        this.d168,
        this.d171,
        this.d174,
        this.d177,
        this.d180,
        this.d183,
        this.d186,
        this.d189,
        this.d192,
        this.d195,
        this.d198,
        this.d201,
        this.d204,
        this.d207,
        this.d210,
        this.d213});

  Speed.fromJson(Map<String, dynamic> json) {
    d3 = json['3'];
    d6 = json['6'];
    d9 = json['9'];
    d12 = json['12'];
    d15 = json['15'];
    d18 = json['18'];
    d21 = json['21'];
    d24 = json['24'];
    d27 = json['27'];
    d33 = json['33'];
    d42 = json['42'];
    d45 = json['45'];
    d48 = json['48'];
    d51 = json['51'];
    d54 = json['54'];
    d57 = json['57'];
    d60 = json['60'];
    d63 = json['63'];
    d66 = json['66'];
    d69 = json['69'];
    d72 = json['72'];
    d75 = json['75'];
    d78 = json['78'];
    d81 = json['81'];
    d84 = json['84'];
    d87 = json['87'];
    d90 = json['90'];
    d93 = json['93'];
    d96 = json['96'];
    d99 = json['99'];
    d102 = json['102'];
    d105 = json['105'];
    d108 = json['108'];
    d111 = json['111'];
    d114 = json['114'];
    d117 = json['117'];
    d120 = json['120'];
    d123 = json['123'];
    d126 = json['126'];
    d129 = json['129'];
    d132 = json['132'];
    d135 = json['135'];
    d138 = json['138'];
    d141 = json['141'];
    d144 = json['144'];
    d147 = json['147'];
    d150 = json['150'];
    d153 = json['153'];
    d156 = json['156'];
    d159 = json['159'];
    d162 = json['162'];
    d30 = json['30'];
    d39 = json['39'];
    d165 = json['165'];
    d168 = json['168'];
    d171 = json['171'];
    d174 = json['174'];
    d177 = json['177'];
    d180 = json['180'];
    d183 = json['183'];
    d186 = json['186'];
    d189 = json['189'];
    d192 = json['192'];
    d195 = json['195'];
    d198 = json['198'];
    d201 = json['201'];
    d204 = json['204'];
    d207 = json['207'];
    d210 = json['210'];
    d213 = json['213'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['3'] = d3;
    data['6'] = d6;
    data['9'] = d9;
    data['12'] = d12;
    data['15'] = d15;
    data['18'] = d18;
    data['21'] = d21;
    data['24'] = d24;
    data['27'] = d27;
    data['33'] = d33;
    data['42'] = d42;
    data['45'] = d45;
    data['48'] = d48;
    data['51'] = d51;
    data['54'] = d54;
    data['57'] = d57;
    data['60'] = d60;
    data['63'] = d63;
    data['66'] = d66;
    data['69'] = d69;
    data['72'] = d72;
    data['75'] = d75;
    data['78'] = d78;
    data['81'] = d81;
    data['84'] = d84;
    data['87'] = d87;
    data['90'] = d90;
    data['93'] = d93;
    data['96'] = d96;
    data['99'] = d99;
    data['102'] = d102;
    data['105'] = d105;
    data['108'] = d108;
    data['111'] = d111;
    data['114'] = d114;
    data['117'] = d117;
    data['120'] = d120;
    data['123'] = d123;
    data['126'] = d126;
    data['129'] = d129;
    data['132'] = d132;
    data['135'] = d135;
    data['138'] = d138;
    data['141'] = d141;
    data['144'] = d144;
    data['147'] = d147;
    data['150'] = d150;
    data['153'] = d153;
    data['156'] = d156;
    data['159'] = d159;
    data['162'] = d162;
    data['30'] = d30;
    data['39'] = d39;
    data['165'] = d165;
    data['168'] = d168;
    data['171'] = d171;
    data['174'] = d174;
    data['177'] = d177;
    data['180'] = d180;
    data['183'] = d183;
    data['186'] = d186;
    data['189'] = d189;
    data['192'] = d192;
    data['195'] = d195;
    data['198'] = d198;
    data['201'] = d201;
    data['204'] = d204;
    data['207'] = d207;
    data['210'] = d210;
    data['213'] = d213;
    return data;
  }
}

class Cornerkick {
  int? i0;
  int? i3;
  int? i6;
  int? i9;
  int? i12;
  int? i15;

  Cornerkick({this.i0, this.i3, this.i6, this.i9, this.i12, this.i15});

  Cornerkick.fromJson(Map<String, dynamic> json) {
    i0 = json['0'];
    i3 = json['3'];
    i6 = json['6'];
    i9 = json['9'];
    i12 = json['12'];
    i15 = json['15'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['0'] = i0;
    data['3'] = i3;
    data['6'] = i6;
    data['9'] = i9;
    data['12'] = i12;
    data['15'] = i15;
    return data;
  }
}

class BallSaved {
  int? i0;

  BallSaved({this.i0});

  BallSaved.fromJson(Map<String, dynamic> json) {
    i0 = json['0'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['0'] = i0;
    return data;
  }
}