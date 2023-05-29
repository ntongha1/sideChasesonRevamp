import 'package:sonalysis/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/helpers/modules/datePicker/flutter_datetime_picker.dart';
import 'package:sonalysis/helpers/modules/datePicker/src/i18n_model.dart';

import 'app_textfield.dart';

class AppDateField extends StatefulWidget {
  final String? headerText;
  final String? descriptionText;
  final String? hintText;
  final bool enabled;
  final DateTime? initialDate;
  final int? minDate;
  final int? maxDate;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final ValueChanged<DateTime> onChanged;
  final AppTextFieldSize textFieldSize;

  const AppDateField({
    Key? key,
    this.headerText,
    this.hintText,
    this.enabled = true,
    this.onTap,
    required this.onChanged,
    this.validator,
    this.descriptionText,
    this.minDate,
    this.maxDate,
    this.initialDate,
    this.textFieldSize = AppTextFieldSize.normal,
  }) : super(key: key);

  @override
  State<AppDateField> createState() => _AppDateFieldState();
}

class _AppDateFieldState extends State<AppDateField> {
  final TextEditingController controller = TextEditingController();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  // DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  String _format = 'yyyy-MM-dd';
  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      String val = _dateFormat.format(widget.initialDate!);
      controller.text = val;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      headerText: widget.headerText,
      hintText: widget.hintText,
      descriptionText: widget.descriptionText,
      enabled: widget.enabled,
      readOnly: true,
      textFieldSize: widget.textFieldSize,
      // onChanged: widget.onChanged,
      validator: widget.validator,
      controller: controller,
      suffixWidget: Padding(
          padding: EdgeInsets.only(right: 10.w),
          child:
              Icon(Icons.calendar_today_outlined, color: AppColors.sonaGrey3)),
      onTap: () async {
        if (!widget.enabled) return;

        DatePicker.showDatePicker(context,
            showTitleActions: true,
            minTime: DateTime(widget.minDate ?? 1950),
            maxTime: DateTime(widget.maxDate ?? 2023), onChanged: (date) {
          print('change $date');
        }, onConfirm: (date) {
          setState(() {
            controller.text = DateFormat(_format).format(date);
          });
          widget.onChanged(date);
        }, currentTime: DateTime.now(), locale: LocaleType.en);
      },
    );
  }
}
