import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_datefield.dart';
import 'app_form_label.dart';
import 'app_textfield.dart';

class AppDaterange extends StatefulWidget {
  final String headerText;
  final double? spacing;
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTime> onEndDateCompleted;
  final ValueChanged<DateTime> onStartDateCompleted;
  final AppTextFieldSize textFieldSize;
  const AppDaterange({
    Key? key,
    this.spacing,
    this.headerText = '',
    required this.onEndDateCompleted,
    required this.onStartDateCompleted,
    this.startDate,
    this.endDate,
    this.textFieldSize = AppTextFieldSize.normal,
  }) : super(key: key);

  @override
  _AppDaterangeState createState() => _AppDaterangeState();
}

class _AppDaterangeState extends State<AppDaterange> {
  late DateTime? endDate;
  late DateTime? startDate;

  @override
  void initState() {
    startDate = widget.startDate;
    endDate = widget.endDate;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppLabel(headerText: widget.headerText),
        Row(
          children: [
            Expanded(
              child: AppDateField(
                textFieldSize: widget.textFieldSize,
                initialDate: startDate,
                onChanged: (val) {
                  startDate = val;
                  widget.onStartDateCompleted(val);
                  setState(() {});
                },
                validator: (val) {
                  startDate = DateTime.tryParse(val ?? '');
                  if (startDate == null || endDate == null) {
                    return 'field is required';
                  }
                  if (endDate!.isBefore(startDate!)) {
                    return 'End date cannot be earlier than start date';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: widget.spacing ?? 11.w),
            Expanded(
              child: AppDateField(
                textFieldSize: widget.textFieldSize,
                initialDate: endDate,
                onChanged: (val) {
                  endDate = val;
                  widget.onEndDateCompleted(val);
                  setState(() {});
                },
                validator: (val) {
                  endDate = DateTime.tryParse(val ?? '');
                  if (startDate == null || endDate == null) {
                    return 'field is required';
                  }
                  if (startDate!.isAfter(endDate!)) {
                    return 'End date cannot be earlier than start date';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
