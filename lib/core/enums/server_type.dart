
enum ServerType { oldServer, newServer }

extension ServerTypeExt on ServerType {
  String get portNo {
    switch (this) {
      case ServerType.oldServer:
        return '3001';
      case ServerType.newServer:
        return '4001';
    }
  }

  String get name {
    switch (this) {
      case ServerType.oldServer:
        return 'Old Server';
      case ServerType.newServer:
        return 'New Server';
    }
  }
}
