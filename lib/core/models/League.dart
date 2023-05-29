import 'dropdown_base_model.dart';

class Leagues extends DropdownBaseModel {
  final String name;
  final int id;

  Leagues({required this.name, required this.id});

  @override
  String get displayName => name;
}
