class LineUpModel {
  String? status;
  String? message;
  List<Data>? data;

  LineUpModel({this.status, this.message, this.data});

  LineUpModel.fromJson(Map<dynamic, dynamic> json) {
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
  String? id;
  String? userId;
  String? clubId;
  String? videoId;
  String? jerseyNumber;
  String? playerId;
  String? unverifiedPlayer;
  String? teamName;
  String? createdAt;
  String? updatedAt;
  Club? club;
  List<Players>? players;
  Players? unverifiedPlayers;

  Data(
      {this.id,
        this.userId,
        this.clubId,
        this.videoId,
        this.jerseyNumber,
        this.playerId,
        this.unverifiedPlayer,
        this.teamName,
        this.createdAt,
        this.updatedAt,
        this.club,
        this.players,
        this.unverifiedPlayers});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    clubId = json['club_id'];
    videoId = json['video_id'];
    jerseyNumber = json['jersey_number'];
    playerId = json['player_id'];
    unverifiedPlayer = json['unverified_player'];
    teamName = json['team_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    club = json['club'] != null ? new Club.fromJson(json['club']) : null;
    if (json['players'] != null) {
      players = <Players>[];
      json['players'].forEach((v) {
        players!.add(new Players.fromJson(v));
      });
    }
    unverifiedPlayers = json['unverified_players'] != null
        ? new Players.fromJson(json['unverified_players'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['club_id'] = this.clubId;
    data['video_id'] = this.videoId;
    data['jersey_number'] = this.jerseyNumber;
    data['player_id'] = this.playerId;
    data['unverified_player'] = this.unverifiedPlayer;
    data['team_name'] = this.teamName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.club != null) {
      data['club'] = this.club!.toJson();
    }
    if (this.players != null) {
      data['players'] = this.players!.map((v) => v.toJson()).toList();
    }
    if (this.unverifiedPlayers != null) {
      data['unverified_players'] = this.unverifiedPlayers!.toJson();
    }
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

class Players {
  String? id;
  String? firstName;
  String? lastName;
  String? jerseyNumber;
  String? videoId;
  String? photo;
  String? position;
  String? teamName;
  String? linkToPortfolio;
  int? isVerified;
  String? createdAt;
  String? updatedAt;

  Players(
      {this.id,
        this.firstName,
        this.lastName,
        this.jerseyNumber,
        this.videoId,
        this.photo,
        this.position,
        this.teamName,
        this.linkToPortfolio,
        this.isVerified,
        this.createdAt,
        this.updatedAt});

  Players.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    jerseyNumber = json['jersey_number'];
    videoId = json['video_id'];
    photo = json['photo'];
    position = json['position'];
    teamName = json['team_name'];
    linkToPortfolio = json['link_to_portfolio'];
    isVerified = json['is_verified'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['jersey_number'] = this.jerseyNumber;
    data['video_id'] = this.videoId;
    data['photo'] = this.photo;
    data['position'] = this.position;
    data['team_name'] = this.teamName;
    data['link_to_portfolio'] = this.linkToPortfolio;
    data['is_verified'] = this.isVerified;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}