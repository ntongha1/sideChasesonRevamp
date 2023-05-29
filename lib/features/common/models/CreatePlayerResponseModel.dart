class CreatePlayerResponseModel {
  String? status;
  String? message;
  CreatePlayerResponseModelData? createPlayerResponseModelData;

  CreatePlayerResponseModel({this.status, this.message, this.createPlayerResponseModelData});

  CreatePlayerResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    createPlayerResponseModelData = json['data'] != null ? new CreatePlayerResponseModelData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.createPlayerResponseModelData != null) {
      data['data'] = this.createPlayerResponseModelData!.toJson();
    }
    return data;
  }
}

class CreatePlayerResponseModelData {
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

  CreatePlayerResponseModelData(
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

  CreatePlayerResponseModelData.fromJson(Map<String, dynamic> json) {
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