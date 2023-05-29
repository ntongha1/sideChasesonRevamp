import 'dropdown_base_model.dart';

class Languages extends DropdownBaseModel {
  final String name;

  Languages({required this.name});

  @override
  String get displayName => name;
}