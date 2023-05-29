import 'dropdown_base_model.dart';

class ActivityType extends DropdownBaseModel {
  final String name;

  ActivityType({required this.name});

  @override
  String get displayName => name;
}