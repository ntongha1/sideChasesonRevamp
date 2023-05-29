class StaffInATeamModel {
  String? status;
  String? message;
  StaffInATeamModelData? staffInATeamModelData;

  StaffInATeamModel({this.status, this.message, this.staffInATeamModelData});

  StaffInATeamModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    staffInATeamModelData = json['data'] != null
        ? new StaffInATeamModelData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.staffInATeamModelData != null) {
      data['data'] = this.staffInATeamModelData!.toJson();
    }
    return data;
  }
}

class StaffInAClubModel {
  String? status;
  String? message;
  StaffInAClubModelData? staffInATeamModelData;

  StaffInAClubModel({this.status, this.message, this.staffInATeamModelData});

  StaffInAClubModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    staffInATeamModelData = json['data'] != null
        ? new StaffInAClubModelData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.staffInATeamModelData != null) {
      data['data'] = this.staffInATeamModelData!.toJson();
    }
    return data;
  }
}

class StaffInAClubModelData {
  String? id;
  String? teamName;
  String? categoryId;
  String? location;
  String? country;
  String? photo;
  String? clubId;
  String? createdAt;
  String? updatedAt;
  List<Staff>? staff;

  StaffInAClubModelData(
      {this.id,
      this.teamName,
      this.categoryId,
      this.location,
      this.country,
      this.photo,
      this.clubId,
      this.createdAt,
      this.updatedAt,
      this.staff});

  StaffInAClubModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamName = json['team_name'];
    categoryId = json['category_id'];
    location = json['location'];
    country = json['country'];
    photo = json['photo'];
    clubId = json['club_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    data['team_name'] = this.teamName;
    data['category_id'] = this.categoryId;
    data['location'] = this.location;
    data['country'] = this.country;
    data['photo'] = this.photo;
    data['club_id'] = this.clubId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.staff != null) {
      data['staff'] = this.staff!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StaffInATeamModelData {
  String? id;
  String? teamName;
  String? categoryId;
  String? location;
  String? country;
  String? photo;
  String? clubId;
  String? createdAt;
  String? updatedAt;
  List<Staff>? staff;

  StaffInATeamModelData(
      {this.id,
      this.teamName,
      this.categoryId,
      this.location,
      this.country,
      this.photo,
      this.clubId,
      this.createdAt,
      this.updatedAt,
      this.staff});

  StaffInATeamModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamName = json['team_name'];
    categoryId = json['category_id'];
    location = json['location'];
    country = json['country'];
    photo = json['photo'];
    clubId = json['club_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    data['team_name'] = this.teamName;
    data['category_id'] = this.categoryId;
    data['location'] = this.location;
    data['country'] = this.country;
    data['photo'] = this.photo;
    data['club_id'] = this.clubId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.staff != null) {
      data['staff'] = this.staff!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Staff {
  String? id;
  String? clubId;
  String? userId;
  String? role;
  String? createdAt;
  String? updatedAt;
  User? user;
  bool? selected;

  Staff(
      {this.id,
      this.clubId,
      this.userId,
      this.role,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.selected});

  Staff.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clubId = json['club_id'];
    userId = json['user_id'];
    role = json['role'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    selected = false;
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
    data['selected'] = false;
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
  int? paid;

  User(
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
      this.updatedAt,
      this.paid});

  User.fromJson(Map<String, dynamic> json) {
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
    profileUpdated = int.parse(json['profile_updated'].toString());
    yearsOfExperience = json['years_of_experience'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    paid = json['paid'];
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
    data['paid'] = this.paid;
    return data;
  }
}
