class SinglePlayerModel {
  String? status;
  String? message;
  Data? data;

  SinglePlayerModel({this.status, this.message, this.data});

  SinglePlayerModel.fromJson(Map<dynamic, dynamic> json) {
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
  Player? player;
  Analysis? analysis;
  Videos? videos;

  Data({this.player, this.analysis});

  Data.fromJson(Map<String, dynamic> json) {
    player =
        json['player'] != null ? new Player.fromJson(json['player']) : null;
    analysis = json['analysis'] != null
        ? new Analysis.fromJson(json['analysis'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.player != null) {
      data['player'] = this.player!.toJson();
    }
    if (this.analysis != null) {
      data['analysis'] = this.analysis!.toJson();
    }
    return data;
  }
}

class Player {
  String? id;
  String? firstName;
  String? lastName;
  String? dob;
  String? age;
  String? gender;
  String? jerseyNo;
  String? jerseyNumber;
  String? userId;
  String? clubId;
  String? weight;
  String? height;
  String? photo;
  String? position;
  String? teamName;
  String? email;
  String? employmentStartDate;
  String? employmentEndDate;
  String? emergencyContactNumber;
  String? phone;
  String? emergencyContactName;
  String? country;
  String? linkToPortfolio;
  int? profileUpdated;
  String? createdAt;
  String? updatedAt;
  String? teamId;
  String? teamNameNew;

  Player(
      {this.id,
      this.firstName,
      this.lastName,
      this.dob,
      this.age,
      this.gender,
      this.jerseyNo,
      this.jerseyNumber,
      this.userId,
      this.clubId,
      this.weight,
      this.height,
      this.photo,
      this.position,
      this.teamName,
      this.email,
      this.employmentStartDate,
      this.employmentEndDate,
      this.emergencyContactNumber,
      this.phone,
      this.emergencyContactName,
      this.country,
      this.linkToPortfolio,
      this.profileUpdated,
      this.createdAt,
      this.updatedAt,
      this.teamId,
      this.teamNameNew});

  Player.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    dob = json['dob'];
    age = json['age'];
    gender = json['gender'];
    jerseyNo = json['jersey_no'];
    jerseyNumber = json['jersey_number'];
    userId = json['user_id'];
    clubId = json['club_id'];
    weight = json['weight'];
    height = json['height'];
    photo = json['photo'];
    position = json['position'];
    teamName = json['team_name'];
    email = json['user_profile']['email'];
    employmentStartDate = json['employment_start_date'];
    employmentEndDate = json['employment_end_date'];
    emergencyContactNumber = json['emergency_contact_number'];
    phone = json['phone'];
    emergencyContactName = json['emergency_contact_name'];
    country = json['country'];
    linkToPortfolio = json['link_to_portfolio'];
    profileUpdated = json['profile_updated'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    teamId = json["team"] != null && json["team"] != "No team"
        ? json["team"]['team_id']
        : "";
    teamNameNew = json["team"] != null && json["team"] != "No team"
        ? json["team"]['team_name']
        : "N/A";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['dob'] = this.dob;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['jersey_no'] = this.jerseyNo;
    data['jersey_number'] = this.jerseyNumber;
    data['user_id'] = this.userId;
    data['club_id'] = this.clubId;
    data['weight'] = this.weight;
    data['height'] = this.height;
    data['photo'] = this.photo;
    data['position'] = this.position;
    data['team_name'] = this.teamName;
    data['email'] = this.email;
    data['employment_start_date'] = this.employmentStartDate;
    data['employment_end_date'] = this.employmentEndDate;
    data['emergency_contact_number'] = this.emergencyContactNumber;
    data['phone'] = this.phone;
    data['emergency_contact_name'] = this.emergencyContactName;
    data['country'] = this.country;
    data['link_to_portfolio'] = this.linkToPortfolio;
    data['profile_updated'] = this.profileUpdated;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['team_id'] = this.teamId;
    data['team_name_new'] = this.teamNameNew;
    return data;
  }
}

class Analysis {
  int? goals;
  int? speed;
  int? penalty;
  int? shortPass;
  int? longPass;
  int? freeKick;
  int? redCard;
  int? yellowCard;

  Analysis(
      {this.goals,
      this.speed,
      this.penalty,
      this.shortPass,
      this.longPass,
      this.freeKick,
      this.redCard,
      this.yellowCard});

  Analysis.fromJson(Map<String, dynamic> json) {
    goals = json['goals'];
    speed = json['speed'];
    penalty = json['penalty'];
    shortPass = json['short_pass'];
    longPass = json['long_pass'];
    freeKick = json['free_kick'];
    redCard = json['red_card'];
    yellowCard = json['yellow_card'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goals'] = this.goals;
    data['speed'] = this.speed;
    data['penalty'] = this.penalty;
    data['short_pass'] = this.shortPass;
    data['long_pass'] = this.longPass;
    data['free_kick'] = this.freeKick;
    data['red_card'] = this.redCard;
    data['yellow_card'] = this.yellowCard;
    return data;
  }
}

class Videos {
  List<Video>? videos;

  Videos({this.videos});

  Videos.fromJson(Map<String, dynamic> json) {
    videos = json['videos'] != null
        ? (json['videos'] as List).map((i) => Video.fromJson(i)).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.videos != null) {
      data['videos'] = this.videos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Video {
  String? id;
  int? analysed;
  String? choice;
  String? gpu_id;
  String? last_media_url;
  String? about;
  String? user_id;
  String? club_id;
  String? status_text;
  String? code;
  String? text;
  String? filename;
  int? first_view;
  int? fps;
  int? video_length;
  String? video_upload_type;
  String? full_video;
  String? game_id;
  String? created_at;
  String? updated_at;

  Video({
    this.id,
    this.analysed,
    this.choice,
    this.gpu_id,
    this.last_media_url,
    this.about,
    this.user_id,
    this.club_id,
    this.status_text,
    this.code,
    this.text,
    this.filename,
    this.first_view,
    this.fps,
    this.video_length,
    this.video_upload_type,
    this.full_video,
    this.game_id,
    this.created_at,
    this.updated_at,
  });

  Video.fromJson(Map<String, dynamic> json) {
    id = json['video']['id'];
    analysed = json['video']['analysed'];
    choice = json['video']['choice'];
    gpu_id = json['video']['gpu_id'];
    last_media_url = json['video']['last_media_url'];
    about = json['video']['about'];
    user_id = json['video']['user_id'];
    club_id = json['video']['club_id'];
    status_text = json['video']['status_text'];
    code = json['video']['code'];
    text = json['video']['text'];
    filename = json['video']['filename'];
    first_view = json['video']['first_view'];
    fps = json['video']['fps'];
    video_length = json['video']['video_length'];
    video_upload_type = json['video']['video_upload_type'];
    full_video = json['video']['full_video'];
    game_id = json['video']['game_id'];
    created_at = json['video']['created_at'];
    updated_at = json['video']['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['analysed'] = this.analysed;
    data['choice'] = this.choice;
    data['gpu_id'] = this.gpu_id;
    data['last_media_url'] = this.last_media_url;
    data['about'] = this.about;
    data['user_id'] = this.user_id;
    data['club_id'] = this.club_id;
    data['status_text'] = this.status_text;
    data['code'] = this.code;
    data['text'] = this.text;
    data['filename'] = this.filename;
    data['first_view'] = this.first_view;
    data['fps'] = this.fps;
    data['video_length'] = this.video_length;
    data['video_upload_type'] = this.video_upload_type;
    data['full_video'] = this.full_video;
    data['game_id'] = this.game_id;
    data['created_at'] = this.created_at;
    data['updated_at'] = this.updated_at;
    return data;
  }
}
