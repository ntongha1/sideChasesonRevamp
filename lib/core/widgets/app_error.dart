import 'package:sonalysis/core/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppError extends StatelessWidget {
  final String? error;
  final bool center;

  const AppError({Key? key, this.error, this.center = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (error == null) return const SizedBox.shrink();

    String modError = error!;
    if (modError.contains("*")) modError = modError.replaceAll(' *', '');
    return Row(
      mainAxisAlignment:
          center ? MainAxisAlignment.center : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        center
            ? Text(
                modError,
                style: TextStyle(
                  color: AppColors.claretColor,
                  fontSize: 12.0.sp,
                  fontStyle: FontStyle.normal,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
              )
            : Expanded(
                child: Text(
                  modError,
                  style: TextStyle(
                    color: AppColors.claretColor,
                    fontSize: 12.0.sp,
                    fontStyle: FontStyle.normal,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                  ),
                ),
              )
      ],
    );
  }
}
