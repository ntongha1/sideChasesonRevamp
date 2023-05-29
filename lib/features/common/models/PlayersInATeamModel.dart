class PlayersInATeamModel {
  String? status;
  String? message;
  PlayersInATeamModelData? playersInATeamModelData;

  PlayersInATeamModel(
      {this.status, this.message, this.playersInATeamModelData});

  PlayersInATeamModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    playersInATeamModelData = json['data'] != null
        ? new PlayersInATeamModelData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.playersInATeamModelData != null) {
      data['data'] = this.playersInATeamModelData!.toJson();
    }
    return data;
  }
}

class PlayersInAClubModel {
  String? status;
  String? message;
  PlayersInAClubModelData? playersInATeamModelData;

  PlayersInAClubModel(
      {this.status, this.message, this.playersInATeamModelData});

  PlayersInAClubModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];

    playersInATeamModelData = json['data'] != null
        ? new PlayersInAClubModelData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.playersInATeamModelData != null) {
      data['data'] = this.playersInATeamModelData!.toJson();
    }
    return data;
  }
}

class PlayersInATeamModelData {
  String? id;
  String? name;
  String? categoryId;
  String? location;
  String? country;
  String? clubId;
  String? createdAt;
  String? updatedAt;
  List<Players>? players;

  PlayersInATeamModelData(
      {this.id,
      this.name,
      this.categoryId,
      this.location,
      this.country,
      this.clubId,
      this.createdAt,
      this.updatedAt,
      this.players});

  PlayersInATeamModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    location = json['location'];
    country = json['country'];
    clubId = json['club_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['players'] != null) {
      players = <Players>[];
      json['players'].forEach((v) {
        players!.add(new Players.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['location'] = this.location;
    data['country'] = this.country;
    data['club_id'] = this.clubId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.players != null) {
      data['players'] = this.players!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlayersInAClubModelData {
  String? id;
  String? name;
  String? location;
  String? country;
  String? ownerId;
  String? createdAt;
  String? updatedAt;
  List<Players>? players;

  PlayersInAClubModelData(
      {this.id,
      this.name,
      this.location,
      this.country,
      this.ownerId,
      this.createdAt,
      this.updatedAt,
      this.players});

  PlayersInAClubModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location = json['location'];
    country = json['country'];
    ownerId = json['owner_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['players'] != null) {
      players = <Players>[];
      json['players'].forEach((v) {
        players!.add(new Players.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['location'] = this.location;
    data['country'] = this.country;
    data['owner_id'] = this.ownerId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.players != null) {
      data['players'] = this.players!.map((v) => v.toJson()).toList();
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
  String? email;
  bool? selected = false;

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
      this.updatedAt,
      this.email,
      this.selected});

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
    email = json['email'];
    selected = false;
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
    data['email'] = this.email;
    return data;
  }
}
