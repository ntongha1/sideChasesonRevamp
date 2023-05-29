import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppAmountField extends StatelessWidget {
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  AppAmountField({
    Key? key,
    this.onSaved,
    this.validator,
    this.onChanged,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            style: _textStyle,
            controller: controller,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            autofocus: true,
            validator: validator,
            onSaved: onSaved,
            showCursor: false,
            maxLines: 1,
            onChanged: (value) {
              // String val = formatCurrency(value.substring(0, value.length - 2));
              // if (controller != null) {
              //   controller!.text = val;
              //   controller!.selection = TextSelection.fromPosition(
              //     TextPosition(offset: controller!.text.length),
              //   );
              // }
              if (onChanged != null) onChanged!(value);
            },
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              border: InputBorder.none,
              errorBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintStyle: _textStyle,
              hintText: '0.00',
            ),
          ),
        ),
      ],
    );
  }

  final _textStyle = TextStyle(
    fontSize: 48.sp,
    fontWeight: FontWeight.w800,
    color: Colors.black,
    height: 1.37,
    fontFamily: '',
  );
}
