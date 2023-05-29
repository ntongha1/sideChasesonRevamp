class UploadVideoResponseModel {
  String? status;
  String? message;
  Data? data;

  UploadVideoResponseModel({this.status, this.message, this.data});

  UploadVideoResponseModel.fromJson(Map<dynamic, dynamic> json) {
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
  String? id;
  bool? analysed;
  String? choice;
  String? gpuId;
  String? lastMediaUrl;
  String? about;
  String? userId;
  String? clubId;
  String? statusText;
  String? code;
  String? text;
  String? filename;
  String? videoUploadType;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.analysed,
        this.choice,
        this.gpuId,
        this.lastMediaUrl,
        this.about,
        this.userId,
        this.clubId,
        this.statusText,
        this.code,
        this.text,
        this.filename,
        this.videoUploadType,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    analysed = json['analysed'];
    choice = json['choice'];
    gpuId = json['gpu_id'];
    lastMediaUrl = json['last_media_url'];
    about = json['about'];
    userId = json['user_id'];
    clubId = json['club_id'];
    statusText = json['status_text'];
    code = json['code'];
    text = json['text'];
    filename = json['filename'];
    videoUploadType = json['video_upload_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['analysed'] = this.analysed;
    data['choice'] = this.choice;
    data['gpu_id'] = this.gpuId;
    data['last_media_url'] = this.lastMediaUrl;
    data['about'] = this.about;
    data['user_id'] = this.userId;
    data['club_id'] = this.clubId;
    data['status_text'] = this.statusText;
    data['code'] = this.code;
    data['text'] = this.text;
    data['filename'] = this.filename;
    data['video_upload_type'] = this.videoUploadType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}