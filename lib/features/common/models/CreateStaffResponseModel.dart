class CreateStaffResponseModel {
  String? status;
  String? message;
  CreateStaffResponseModelData? createStaffResponseModelData;

  CreateStaffResponseModel({this.status, this.message, this.createStaffResponseModelData});

  CreateStaffResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    createStaffResponseModelData = json['data'] != null ? new CreateStaffResponseModelData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.createStaffResponseModelData != null) {
      data['data'] = this.createStaffResponseModelData!.toJson();
    }
    return data;
  }
}

class CreateStaffResponseModelData {
  String? id;
  String? clubId;
  String? userId;
  String? role;
  String? createdAt;
  String? updatedAt;
  User? user;
  Club? club;

  CreateStaffResponseModelData(
      {this.id,
        this.clubId,
        this.userId,
        this.role,
        this.createdAt,
        this.updatedAt,
        this.user,
        this.club});

  CreateStaffResponseModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clubId = json['club_id'];
    userId = json['user_id'];
    role = json['role'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    club = json['club'] != null ? new Club.fromJson(json['club']) : null;
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
    if (this.club != null) {
      data['club'] = this.club!.toJson();
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
  String? deletedAt;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;

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
        this.deletedAt,
        this.startDate,
        this.endDate,
        this.createdAt,
        this.updatedAt});

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
    deletedAt = json['deleted_at'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    data['deleted_at'] = this.deletedAt;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
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
