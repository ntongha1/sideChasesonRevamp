import 'package:sonalysis/core/models/dropdown_base_model.dart';

class TeamCategory {
  String? status;
  String? message;
  List<TeamCategoryData>? teamCategoryData;

  TeamCategory({this.status, this.message, this.teamCategoryData});

  TeamCategory.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      teamCategoryData = <TeamCategoryData>[];
      json['data'].forEach((v) {
        teamCategoryData!.add(new TeamCategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.teamCategoryData != null) {
      data['data'] = this.teamCategoryData!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class TeamCategoryData extends DropdownBaseModel {
  String? id;
  String? name;
  String? categoryId;
  Null location;
  Null country;
  String? clubId;
  String? createdAt;
  String? updatedAt;

  TeamCategoryData(
      {this.id,
        this.name,
        this.categoryId,
        this.location,
        this.country,
        this.clubId,
        this.createdAt,
        this.updatedAt});

  TeamCategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    location = json['location'];
    country = json['country'];
    clubId = json['club_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    return data;
  }

  @override
  String? get displayName => name;
}
