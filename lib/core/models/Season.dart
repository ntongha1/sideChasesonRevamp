import 'dropdown_base_model.dart';

class Season extends DropdownBaseModel {
  final String name;

  Season({required this.name});

  @override
  String get displayName => name;
}
