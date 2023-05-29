import 'dropdown_base_model.dart';

class HomeAway extends DropdownBaseModel {
  final String name;

  HomeAway({required this.name});

  @override
  String get displayName => name;
}