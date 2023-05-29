class AllPlayerInUploadedVideoModel {
  String? status;
  String? message;
  Data? data;

  AllPlayerInUploadedVideoModel({this.status, this.message, this.data});

  AllPlayerInUploadedVideoModel.fromJson(Map<dynamic, dynamic> json) {
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
  List<TeamA>? teamA;
  List<TeamB>? teamB;

  Data({this.teamA, this.teamB});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['Team A'] != null) {
      teamA = <TeamA>[];
      json['Team A'].forEach((v) {
        teamA!.add(new TeamA.fromJson(v));
      });
    }
    if (json['Team B'] != null) {
      teamB = <TeamB>[];
      json['Team B'].forEach((v) {
        teamB!.add(new TeamB.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.teamA != null) {
      data['Team A'] = this.teamA!.map((v) => v.toJson()).toList();
    }
    if (this.teamB != null) {
      data['Team B'] = this.teamB!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeamA {
  String? id;
  String? userId;
  String? clubId;
  String? videoId;
  String? playerId;
  String? teamName;
  String? createdAt;
  String? updatedAt;
  Players? players;
  Club? club;

  TeamA(
      {this.id,
        this.userId,
        this.clubId,
        this.videoId,
        this.playerId,
        this.teamName,
        this.createdAt,
        this.updatedAt,
        this.players,
        this.club});

  TeamA.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    clubId = json['club_id'];
    videoId = json['video_id'];
    playerId = json['player_id'];
    teamName = json['team_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    players =
    json['players'] != null ? new Players.fromJson(json['players']) : null;
    club = json['club'] != null ? new Club.fromJson(json['club']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['club_id'] = this.clubId;
    data['video_id'] = this.videoId;
    data['player_id'] = this.playerId;
    data['team_name'] = this.teamName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.players != null) {
      data['players'] = this.players!.toJson();
    }
    if (this.club != null) {
      data['club'] = this.club!.toJson();
    }
    return data;
  }
}

class TeamB {
  String? id;
  String? userId;
  String? clubId;
  String? videoId;
  String? playerId;
  String? teamName;
  String? createdAt;
  String? updatedAt;
  Players? players;
  Club? club;

  TeamB(
      {this.id,
        this.userId,
        this.clubId,
        this.videoId,
        this.playerId,
        this.teamName,
        this.createdAt,
        this.updatedAt,
        this.players,
        this.club});

  TeamB.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    clubId = json['club_id'];
    videoId = json['video_id'];
    playerId = json['player_id'];
    teamName = json['team_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    players =
    json['players'] != null ? new Players.fromJson(json['players']) : null;
    club = json['club'] != null ? new Club.fromJson(json['club']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['club_id'] = this.clubId;
    data['video_id'] = this.videoId;
    data['player_id'] = this.playerId;
    data['team_name'] = this.teamName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.players != null) {
      data['players'] = this.players!.toJson();
    }
    if (this.club != null) {
      data['club'] = this.club!.toJson();
    }
    return data;
  }
}

class Players {
  String? id;
  String? firstName;
  String? lastName;
  String? dob;
  String? age;
  String? gender;
  String? jerseyNo;
  String? userId;
  String? clubId;
  String? weight;
  String? height;
  String? photo;
  String? position;
  String? teamName;
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

  Players(
      {this.id,
        this.firstName,
        this.lastName,
        this.dob,
        this.age,
        this.gender,
        this.jerseyNo,
        this.userId,
        this.clubId,
        this.weight,
        this.height,
        this.photo,
        this.position,
        this.teamName,
        this.employmentStartDate,
        this.employmentEndDate,
        this.emergencyContactNumber,
        this.phone,
        this.emergencyContactName,
        this.country,
        this.linkToPortfolio,
        this.profileUpdated,
        this.createdAt,
        this.updatedAt});

  Players.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    dob = json['dob'];
    age = json['age'];
    gender = json['gender'];
    jerseyNo = json['jersey_no'];
    userId = json['user_id'];
    clubId = json['club_id'];
    weight = json['weight'];
    height = json['height'];
    photo = json['photo'];
    position = json['position'];
    teamName = json['team_name'];
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
    data['user_id'] = this.userId;
    data['club_id'] = this.clubId;
    data['weight'] = this.weight;
    data['height'] = this.height;
    data['photo'] = this.photo;
    data['position'] = this.position;
    data['team_name'] = this.teamName;
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
    return data;
  }
}

class Club {
  String? id;
  String? name;
  String? slug;
  String? abbreviation;
  String? location;
  String? country;
  String? logo;
  String? reason;
  String? videoUrl;
  String? ownerId;
  String? createdAt;
  String? updatedAt;

  Club(
      {this.id,
        this.name,
        this.slug,
        this.abbreviation,
        this.location,
        this.country,
        this.logo,
        this.reason,
        this.videoUrl,
        this.ownerId,
        this.createdAt,
        this.updatedAt});

  Club.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    abbreviation = json['abbreviation'];
    location = json['location'];
    country = json['country'];
    logo = json['logo'];
    reason = json['reason'];
    videoUrl = json['video_url'];
    ownerId = json['owner_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['abbreviation'] = this.abbreviation;
    data['location'] = this.location;
    data['country'] = this.country;
    data['logo'] = this.logo;
    data['reason'] = this.reason;
    data['video_url'] = this.videoUrl;
    data['owner_id'] = this.ownerId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

