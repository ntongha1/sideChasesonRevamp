import 'dropdown_base_model.dart';

class Roles extends DropdownBaseModel {
  final String name;

  Roles({required this.name});

  @override
  String get displayName => name;
}