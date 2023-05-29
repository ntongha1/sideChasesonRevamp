import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/dropdown_base_model.dart';
import '../utils/colors.dart';
import '../utils/response_message.dart';
import '../utils/styles.dart';
import 'app_form_label.dart';

class AppDropdown<T extends DropdownBaseModel> extends FormField<T> {
  final BuildContext context;
  final String hintText;
  final List<T> options;
  final T? value;
  final String hint;
  final String label;
  final String? parentName;
  final double? fontSize;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final Function(T?)? onChanged;

  final Widget? suffix;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final bool isLocked;
  final bool isLoading;
  final String? prefix;

  AppDropdown({
    required this.context,
    FormFieldSetter<dynamic>? onSaved,
    Key? key,
    FormFieldValidator<dynamic>? validator,
    bool autovalidate = false,
    this.parentName,
    this.hintText = 'Please select an Option',
    this.options = const [],
    this.hintStyle,
    this.labelStyle,
    this.isLocked = false,
    this.fontSize,
    this.value,
    required this.onChanged,
    required this.hint,
    required this.label,
    this.isLoading = false,
    this.suffix,
    this.suffixIcon,
    this.prefixIcon,
    this.prefix,
  }) : super(
      key: key,
      onSaved: onSaved,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<dynamic> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppLabel(headerText: label),
            // SizedBox(height: 6.h),
            Container(
              width: double.infinity,
              height: 42,
              padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
              decoration: BoxDecoration(
                color: isLocked
                    ? AppColors.sonaDisabledGrey
                    : AppColors.sonaGrey6,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: DropdownButtonHideUnderline(
                key: UniqueKey(),
                child: GestureDetector(
                  onTap: () {
                    if (options.isEmpty &&
                        parentName != null &&
                        parentName.isNotEmpty) {
                      String message = 'Please select a $parentName';
                      String vowels = 'aeiou';
                      if (vowels.contains(
                          parentName.characters.first.toLowerCase())) {
                        message = 'Please select an $parentName';
                      }

                      ResponseMessage.showErrorSnack(
                          context: context, message: message);
                    }
                  },
                  child: DropdownButton<T>(
                    key: UniqueKey(),
                    icon: isLoading
                        ? const CupertinoActivityIndicator()
                        : const Icon(Icons.arrow_drop_down_sharp),
                    value: value,
                    isDense: true,
                    isExpanded: true,
                    dropdownColor: AppColors.sonaWhite,
                    onChanged: (T? newValue) {
                      state.didChange(newValue);
                      if (onChanged != null) onChanged(newValue);
                    },
                    items: options.map((T value) {
                      return DropdownMenuItem<T>(
                        value: value,
                        child: Text(
                          value.displayName!.replaceFirst('ARM', ''),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyle.text2.copyWith(color: AppColors.sonaBlack2, fontWeight: FontWeight.w400),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            SizedBox(height: state.hasError ? 5.0 : 0.0),
            Text(
              state.errorText ?? '',
              style: TextStyle(
                  color: Colors.redAccent.shade700,
                  fontSize: state.hasError ? 11.0 : 0.0),
            ),
          ],
        );
      });
}