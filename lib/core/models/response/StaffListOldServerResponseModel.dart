class StaffListOldServerResponseModel {
  String? status;
  String? message;
  List<StaffListResponseModelData>? staffListResponseModelData;

  StaffListOldServerResponseModel({this.status, this.message, this.staffListResponseModelData});

  StaffListOldServerResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      staffListResponseModelData = <StaffListResponseModelData>[];
      json['data'].forEach((v) {
        staffListResponseModelData!.add(StaffListResponseModelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (staffListResponseModelData != null) {
      data['data'] = staffListResponseModelData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StaffListResponseModelData {
  String? sId;
  String? email;
  String? firstname;
  String? lastname;
  String? country;
  String? role;
  String? club;

  StaffListResponseModelData(
      {this.sId,
        this.email,
        this.firstname,
        this.lastname,
        this.country,
        this.role,
        this.club});

  StaffListResponseModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    country = json['country'];
    role = json['role'];
    club = json['club'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['email'] = email;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['country'] = country;
    data['role'] = role;
    data['club'] = club;
    return data;
  }
}
