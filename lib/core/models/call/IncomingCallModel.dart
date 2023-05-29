class IncomingCallModel {
  String? event;
  Body? body;

  IncomingCallModel({this.event, this.body});

  IncomingCallModel.fromJson(Map json) {
    event = json['event'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event'] = this.event;
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class Body {
  String? id;
  String? nameCaller;
  String? avatar;
  String? number;
  int? type;
  int? duration;
  String? textAccept;
  String? textDecline;
  String? textMissedCall;
  String? textCallback;
  Extra? extra;
  Android? android;

  Body(
      {this.id,
        this.nameCaller,
        this.avatar,
        this.number,
        this.type,
        this.duration,
        this.textAccept,
        this.textDecline,
        this.textMissedCall,
        this.textCallback,
        this.extra,
        this.android});

  Body.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameCaller = json['nameCaller'];
    avatar = json['avatar'];
    number = json['number'];
    type = json['type'];
    duration = json['duration'];
    textAccept = json['textAccept'];
    textDecline = json['textDecline'];
    textMissedCall = json['textMissedCall'];
    textCallback = json['textCallback'];
    extra = json['extra'] != null ? new Extra.fromJson(json['extra']) : null;
    android =
    json['android'] != null ? new Android.fromJson(json['android']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nameCaller'] = this.nameCaller;
    data['avatar'] = this.avatar;
    data['number'] = this.number;
    data['type'] = this.type;
    data['duration'] = this.duration;
    data['textAccept'] = this.textAccept;
    data['textDecline'] = this.textDecline;
    data['textMissedCall'] = this.textMissedCall;
    data['textCallback'] = this.textCallback;
    if (this.extra != null) {
      data['extra'] = this.extra!.toJson();
    }
    if (this.android != null) {
      data['android'] = this.android!.toJson();
    }
    return data;
  }
}

class Extra {
  String? userId;

  Extra({this.userId});

  Extra.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    return data;
  }
}

class Android {
  bool? isCustomNotification;
  String? ringtonePath;
  String? backgroundColor;
  String? backgroundUrl;
  String? actionColor;

  Android(
      {this.isCustomNotification,
        this.ringtonePath,
        this.backgroundColor,
        this.backgroundUrl,
        this.actionColor});

  Android.fromJson(Map<String, dynamic> json) {
    isCustomNotification = json['isCustomNotification'];
    ringtonePath = json['ringtonePath'];
    backgroundColor = json['backgroundColor'];
    backgroundUrl = json['backgroundUrl'];
    actionColor = json['actionColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isCustomNotification'] = this.isCustomNotification;
    data['ringtonePath'] = this.ringtonePath;
    data['backgroundColor'] = this.backgroundColor;
    data['backgroundUrl'] = this.backgroundUrl;
    data['actionColor'] = this.actionColor;
    return data;
  }
}
