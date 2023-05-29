
enum UserType { owner, coach, manager, player }

extension UserTypeExt on UserType {

  String get type {
    switch (this) {
      case UserType.owner:
        return "owner";
      case UserType.coach:
        return "coach";
    case UserType.manager:
        return "manager";
    case UserType.player:
        return "player";
    }
  }
}
