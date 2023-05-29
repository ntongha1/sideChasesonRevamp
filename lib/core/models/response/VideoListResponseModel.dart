import '../../utils/helpers.dart';
import '../dropdown_base_model.dart';

class VideoListResponseModel {
  String? status;
  String? message;
  List<VideoListResponseModelData>? videoListResponseModelData;

  VideoListResponseModel({this.status, this.message, this.videoListResponseModelData});

  VideoListResponseModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != String) {
      videoListResponseModelData = <VideoListResponseModelData>[];
      json['data'].forEach((v) {
        videoListResponseModelData!.add(new VideoListResponseModelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.videoListResponseModelData != String) {
      data['data'] = this.videoListResponseModelData!.map((v) => v.toJson()).toList();
    }
    return data;
  }


}

class VideoListResponseModelData extends DropdownBaseModel{
  String? id;
  int? analysed;
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
  int? firstView;
  String? videoUploadType;
  String? createdAt;
  String? updatedAt;

  VideoListResponseModelData(
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
        this.firstView,
        this.videoUploadType,
        this.createdAt,
        this.updatedAt});

  VideoListResponseModelData.fromJson(Map<String, dynamic> json) {
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
    firstView = json['first_view'];
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
    data['first_view'] = this.firstView;
    data['video_upload_type'] = this.videoUploadType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  @override
  // TODO: implement displayName
  String? get displayName => filename! +" (" + convertToAgo(createdAt!) + ")";
}