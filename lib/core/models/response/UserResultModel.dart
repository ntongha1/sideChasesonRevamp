class AuthResultModel {
  String? status;
  String? message;
  UserResultData? userResultData;

  AuthResultModel({this.status, this.message, this.userResultData});

  AuthResultModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userResultData = json['data'] != null ? new UserResultData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.userResultData != null) {
      data['data'] = this.userResultData!.toJson();
    }
    return data;
  }
}

class UserResultData {
  User? user;
  String? authToken;

  UserResultData({this.user, this.authToken});

  UserResultData.fromJson(Map<dynamic, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    authToken = json['auth_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['auth_token'] = this.authToken;
    return data;
  }
}

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? dob;
  String? gender;
  String? role;
  String? country;
  String? email;
  int? emailVerified;
  String? phone;
  int? phoneVerified;
  String? maritalStatus;
  String? photo;
  int? isActive;
  int? paid;
  int? loginCount;
  String? deletedAt;
  String? employmentStartDate;
  String? employmentEndDate;
  String? emergencyContactNumber;
  String? emergencyContactName;
  String? linkToPortfolio;
  int? profileUpdated;
  String? yearsOfExperience;
  String? createdAt;
  String? updatedAt;
  List<Clubs>? clubs;
  List<Players>? players;
  List<Staff>? staff;

  User(
      {this.id,
        this.firstName,
        this.lastName,
        this.dob,
        this.gender,
        this.role,
        this.country,
        this.email,
        this.emailVerified,
        this.phone,
        this.phoneVerified,
        this.maritalStatus,
        this.photo,
        this.isActive,
        this.loginCount,
        this.deletedAt,
        this.employmentStartDate,
        this.employmentEndDate,
        this.emergencyContactNumber,
        this.emergencyContactName,
        this.linkToPortfolio,
        this.profileUpdated,
        this.yearsOfExperience,
        this.createdAt,
        this.updatedAt,
        this.clubs,
        this.players,
        this.staff});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    dob = json['dob'];
    gender = json['gender'];
    role = json['role'];
    country = json['country'];
    email = json['email'];
    emailVerified = json['email_verified'];
    phone = json['phone'];
    phoneVerified = json['phone_verified'];
    maritalStatus = json['marital_status'];
    photo = json['photo'];
    isActive = json['is_active'];
    paid = json['paid'];
    loginCount = json['login_count'];
    deletedAt = json['deleted_at'];
    employmentStartDate = json['employment_start_date'];
    employmentEndDate = json['employment_end_date'];
    emergencyContactNumber = json['emergency_contact_number'];
    emergencyContactName = json['emergency_contact_name'];
    linkToPortfolio = json['link_to_portfolio'];
    profileUpdated = json['profile_updated'];
    yearsOfExperience = json['years_of_experience'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['clubs'] != null) {
      clubs = <Clubs>[];
      json['clubs'].forEach((v) {
        clubs!.add(new Clubs.fromJson(v));
      });
    }
    if (json['players'] != null) {
      players = <Players>[];
      json['players'].forEach((v) {
        players!.add(new Players.fromJson(v));
      });
    }
    if (json['staff'] != null) {
      staff = <Staff>[];
      json['staff'].forEach((v) {
        staff!.add(new Staff.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['role'] = this.role;
    data['country'] = this.country;
    data['email'] = this.email;
    data['email_verified'] = this.emailVerified;
    data['phone'] = this.phone;
    data['phone_verified'] = this.phoneVerified;
    data['marital_status'] = this.maritalStatus;
    data['photo'] = this.photo;
    data['is_active'] = this.isActive;
    data['paid'] = this.paid;
    data['login_count'] = this.loginCount;
    data['deleted_at'] = this.deletedAt;
    data['employment_start_date'] = this.employmentStartDate;
    data['employment_end_date'] = this.employmentEndDate;
    data['emergency_contact_number'] = this.emergencyContactNumber;
    data['emergency_contact_name'] = this.emergencyContactName;
    data['link_to_portfolio'] = this.linkToPortfolio;
    data['profile_updated'] = this.profileUpdated;
    data['years_of_experience'] = this.yearsOfExperience;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.clubs != null) {
      data['clubs'] = this.clubs!.map((v) => v.toJson()).toList();
    }
    if (this.players != null) {
      data['players'] = this.players!.map((v) => v.toJson()).toList();
    }
    if (this.staff != null) {
      data['staff'] = this.staff!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Clubs {
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

  Clubs(
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

  Clubs.fromJson(Map<String, dynamic> json) {
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
  String? dob;
  int? age;
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
  int? yearsOfExperience;

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
        this.yearsOfExperience});

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
    yearsOfExperience = json['years_of_experience'];
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
    data['years_of_experience'] = this.yearsOfExperience;
    return data;
  }
}

class Staff {
  String? id;
  String? firstName;
  String? lastName;
  String? dob;
  int? age;
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
  int? yearsOfExperience;

  Staff(
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
        this.yearsOfExperience});

  Staff.fromJson(Map<String, dynamic> json) {
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
    yearsOfExperience = json['years_of_experience'];
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
    data['years_of_experience'] = this.yearsOfExperience;
    return data;
  }
}
