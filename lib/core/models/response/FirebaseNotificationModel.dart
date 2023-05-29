class FirebaseNotificationModel {
  String? userImage;
  String? livekitToken;
  String? groupCall;
  String? notificationType;
  String? userName;
  String? userRole;
  String? userID;
  String? roomID;

  FirebaseNotificationModel(
      {this.userImage,
        this.livekitToken,
        this.groupCall,
        this.notificationType,
        this.userName,
        this.userRole,
        this.userID,
        this.roomID});

  FirebaseNotificationModel.fromJson(Map<String, dynamic> json) {
    userImage = json['userImage'];
    livekitToken = json['livekitToken'];
    groupCall = json['GroupCall'];
    notificationType = json['notificationType'];
    userName = json['userName'];
    userRole = json['userRole'];
    userID = json['userID'];
    roomID = json['roomID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userImage'] = this.userImage;
    data['livekitToken'] = this.livekitToken;
    data['GroupCall'] = this.groupCall;
    data['notificationType'] = this.notificationType;
    data['userName'] = this.userName;
    data['userRole'] = this.userRole;
    data['userID'] = this.userID;
    data['roomID'] = this.roomID;
    return data;
  }
}