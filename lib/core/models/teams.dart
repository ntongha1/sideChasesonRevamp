import 'dropdown_base_model.dart';

class TeamsDropdown extends DropdownBaseModel {
  final String name;
  final String id;

  TeamsDropdown({required this.name, required this.id});

  @override
  String get displayName => name;
}
