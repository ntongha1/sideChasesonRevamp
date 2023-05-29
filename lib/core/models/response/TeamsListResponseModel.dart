import '../dropdown_base_model.dart';

class TeamsListResponseModel {
  String? status;
  String? message;
  List<TeamsListResponseModelData>? teamsListResponseModelData;

  TeamsListResponseModel(
      {this.status, this.message, this.teamsListResponseModelData});

  TeamsListResponseModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      teamsListResponseModelData = <TeamsListResponseModelData>[];
      json['data'].forEach((v) {
        teamsListResponseModelData!
            .add(new TeamsListResponseModelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.teamsListResponseModelData != null) {
      data['data'] =
          this.teamsListResponseModelData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeamsSingleModel extends DropdownBaseModel {
  String? id;
  String? teamName;
  String? abbreviation;
  String? categoryId;
  String? location;
  String? country;
  String? clubId;
  String? photo;
  String? createdAt;
  String? updatedAt;
  int? totalPlayers;
  int? totalStaff;

  TeamsSingleModel(
      {this.id,
      this.teamName,
      this.abbreviation,
      this.categoryId,
      this.location,
      this.country,
      this.clubId,
      this.photo,
      this.createdAt,
      this.updatedAt,
      this.totalPlayers,
      this.totalStaff});

  TeamsSingleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamName = json['team_name'];
    abbreviation = json['name_abbreviation'];
    categoryId = json['category_id'];
    location = json['location'];
    country = json['country'];
    clubId = json['club_id'];
    photo = json['photo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    totalPlayers = json['players'] != null ? json['players'].length : 0;
    totalStaff = json['staff'] != null ? json['staff'].length : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['team_name'] = this.teamName;
    data['name_abbreviation'] = this.abbreviation;
    data['category_id'] = this.categoryId;
    data['location'] = this.location;
    data['country'] = this.country;
    data['club_id'] = this.clubId;
    data['photo'] = this.photo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['total_players'] = this.totalPlayers;
    data['total_staff'] = this.totalStaff;
    return data;
  }

  @override
  String? get displayName => this.teamName;
}

class TeamsListResponseModelData extends DropdownBaseModel {
  String? id;
  String? teamName;
  String? categoryId;
  String? location;
  String? country;
  String? clubId;
  String? photo;
  String? createdAt;
  String? updatedAt;
  int? totalPlayers;
  int? totalStaff;
  bool? selected = false;

  TeamsListResponseModelData(
      {this.id,
      this.teamName,
      this.categoryId,
      this.location,
      this.country,
      this.clubId,
      this.photo,
      this.createdAt,
      this.updatedAt,
      this.totalPlayers,
      this.totalStaff,
      this.selected});

  TeamsListResponseModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamName = json['team_name'];
    categoryId = json['category_id'];
    location = json['location'];
    country = json['country'];
    clubId = json['club_id'];
    photo = json['photo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    totalPlayers = json['total_players'];
    totalStaff = json['total_staff'];
    selected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['team_name'] = this.teamName;
    data['category_id'] = this.categoryId;
    data['location'] = this.location;
    data['country'] = this.country;
    data['club_id'] = this.clubId;
    data['photo'] = this.photo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['total_players'] = this.totalPlayers;
    data['total_staff'] = this.totalStaff;
    data['selected'] = this.selected;
    return data;
  }

  @override
  String? get displayName => this.teamName;
}

class TeamsListResponseModelPlayers {
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
  UserProfile? userProfile;

  TeamsListResponseModelPlayers(
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
      this.userProfile});

  TeamsListResponseModelPlayers.fromJson(Map<String, dynamic> json) {
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
    userProfile = json['user_profile'] != null
        ? new UserProfile.fromJson(json['user_profile'])
        : null;
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
    if (this.userProfile != null) {
      data['user_profile'] = this.userProfile!.toJson();
    }
    return data;
  }
}

class UserProfile {
  String? id;
  String? firstName;
  String? lastName;
  String? dob;
  String? password;
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

  UserProfile(
      {this.id,
      this.firstName,
      this.lastName,
      this.dob,
      this.password,
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
      this.updatedAt});

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    dob = json['dob'];
    password = json['password'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['dob'] = this.dob;
    data['password'] = this.password;
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
    return data;
  }
}

class TeamsListResponseModelStaff {
  String? id;
  String? clubId;
  String? userId;
  String? role;
  String? createdAt;
  String? updatedAt;
  User? user;

  TeamsListResponseModelStaff(
      {this.id,
      this.clubId,
      this.userId,
      this.role,
      this.createdAt,
      this.updatedAt,
      this.user});

  TeamsListResponseModelStaff.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clubId = json['club_id'];
    userId = json['user_id'];
    role = json['role'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['club_id'] = this.clubId;
    data['user_id'] = this.userId;
    data['role'] = this.role;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
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
  String? teamName;

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
      this.teamName});

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
    teamName = json['team_name'];
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
    data['team_name'] = this.teamName;
    return data;
  }
}
