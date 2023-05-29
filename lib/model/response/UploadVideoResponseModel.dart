class UploadVideoResponseModel {
  String? status;
  String? message;
  Data? data;

  UploadVideoResponseModel({this.status, this.message, this.data});

  UploadVideoResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? sId;
  String? lastMediaUrl;
  String? originalFilename;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.sId,
        this.lastMediaUrl,
        this.originalFilename,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    lastMediaUrl = json['last_media_url'];
    originalFilename = json['originalFilename'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['last_media_url'] = this.lastMediaUrl;
    data['originalFilename'] = this.originalFilename;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
