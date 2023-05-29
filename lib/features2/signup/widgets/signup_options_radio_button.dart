import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sonalysis/core/utils/constants.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/styles.dart';

class SignupOptionsRadioButtons<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final IconData icon;
  final String onImage;
  final String offImage;
  final String? title;
  final String? subTitle;
  final ValueChanged<T?> onChanged;

  SignupOptionsRadioButtons({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.icon,
    required this.onImage,
    required this.offImage,
    this.title,
    this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    return Container(
        margin: EdgeInsets.only(top: 40.h),
        child: CustomPaint(
            painter: _GradientPainter(
              strokeWidth: 2,
              radius: 10,
              gradient: LinearGradient(colors: [
                AppColors.sonalysisMediumPurple,
                AppColors.sonalysisBabyBlue,
                AppColors.sonalysisMediumSlateBlue
              ]),
            ),
            child: Container(
              // height: 160,

              decoration: BoxDecoration(
                  color: value == groupValue
                      ? AppColors.sonalysisMediumPurple.withOpacity(0.05)
                      : AppColors.sonaWhite,
                  // border: Border.all(
                  //     color: value == groupValue
                  //         ? AppColors.sonalysisMediumPurple
                  //         : AppColors.sonaGrey6,
                  //     width: value == groupValue ? 2.0 : 2.0),
                  borderRadius:
                      BorderRadius.circular(AppConstants.normalRadius)),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: InkWell(
                onTap: () => onChanged(value),
                splashColor: AppColors.sonaWhite,
                highlightColor: AppColors.sonaWhite,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          value == groupValue ? onImage : offImage,
                        ),
                        Expanded(child: SizedBox.shrink()),
                        _customRadioButton,
                        //if (title != null) title,
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      title!,
                      textAlign: TextAlign.left,
                      style: AppStyle.text3.copyWith(
                          color: AppColors.sonaBlack2,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      subTitle!,
                      textAlign: TextAlign.left,
                      style: AppStyle.text1.copyWith(
                          color: AppColors.sonaGrey2,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            )));
  }

  Widget get _customRadioButton {
    bool isSelected = value == groupValue;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          onChanged(this.value);
        },
        child: isSelected
            ? SvgPicture.asset('assets/svgs/check_gradient.svg')
            : SvgPicture.asset('assets/svgs/grey_check_holder.svg'),
      ),
    );
  }
}

class _GradientPainter extends CustomPainter {
  final Paint _paint = Paint();
  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  _GradientPainter(
      {required double strokeWidth,
      required double radius,
      required Gradient gradient})
      : this.strokeWidth = strokeWidth,
        this.radius = radius,
        this.gradient = gradient;

  @override
  void paint(Canvas canvas, Size size) {
    // create outer rectangle equals size
    Rect outerRect = Offset.zero & size;
    var outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    // create inner rectangle smaller by strokeWidth
    Rect innerRect = Rect.fromLTWH(strokeWidth, strokeWidth,
        size.width - strokeWidth * 2, size.height - strokeWidth * 2);
    var innerRRect = RRect.fromRectAndRadius(
        innerRect, Radius.circular(radius - strokeWidth));

    // apply gradient shader
    _paint.shader = gradient.createShader(outerRect);

    // create difference between outer and inner paths and draw it
    Path path1 = Path()..addRRect(outerRRect);
    Path path2 = Path()..addRRect(innerRRect);
    var path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
