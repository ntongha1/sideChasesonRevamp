import 'dropdown_base_model.dart';

class Positions extends DropdownBaseModel {
  final String name;

  Positions({required this.name});

  @override
  String get displayName => name;
}