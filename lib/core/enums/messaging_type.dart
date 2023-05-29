
enum MessagingType { chat, audioCall, videoCall }

extension MessagingTypeExt on MessagingType {

  String get type {
    switch (this) {
      case MessagingType.chat:
        return 'chat';
      case MessagingType.audioCall:
        return 'audio';
    case MessagingType.videoCall:
        return 'video';
    }
  }
}
