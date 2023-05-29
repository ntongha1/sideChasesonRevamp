import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/models/position.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/widgets/button.dart';
import 'package:sonalysis/core/widgets/empty_response.dart';
import 'package:sonalysis/features/common/cubit/common_cubit.dart';
import 'package:sonalysis/features/common/models/ComparePVPModel.dart';
import 'package:sonalysis/features/common/models/PlayersInATeamModel.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:sonalysis/widgets/player_row_item.dart';
import '../../../../../../core/datasource/local_storage.dart';
import '../../../../../core/enums/user_type.dart';
import '../../../../../core/utils/styles.dart';

class SelectPillsWidget extends StatefulWidget {
  List<PillModel>? pills;
  Function onSelect;
  bool? horizontal = false;

  SelectPillsWidget(
      {Key? key, this.pills, required this.onSelect, required this.horizontal})
      : super(key: key);

  @override
  _SelectPillsWidgetState createState() => _SelectPillsWidgetState();
}

class _SelectPillsWidgetState extends State<SelectPillsWidget> {
  int activeIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (searchController.text.isEmpty) {
    //   filteredItems = widget.options.cast<T>();
    // }
//e2b0101f-2383-467e-b843-aaa3bf8edab2
    return Material(
      child: Container(
          color: AppColors.sonaWhite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: widget.horizontal!
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: getPillsNow(),
                              ),
                            )
                          : Wrap(children: getPillsNow()),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  List<Widget> getPillsNow() {
    return List.generate(widget.pills!.length, (index) {
      return InkWell(
        onTap: () {
          setState(() {
            activeIndex = index;
            widget.onSelect(widget.pills![index]);
          });
        },
        child: Container(
          // make a pill,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
          margin: EdgeInsets.symmetric(

              // horizontal: 10.w,
              vertical: 5.h,
              horizontal: 5.w),
          decoration: BoxDecoration(
            color: activeIndex == index
                ? AppColors.sonaBlack
                : AppColors.sonaWhite,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
                color: activeIndex == index
                    ? AppColors.sonaBlack
                    : AppColors.sonaGrey6),
          ),

          child: Text(
            widget.pills![index].title,
            style: AppStyle.text2.copyWith(
              fontWeight: FontWeight.w400,
              color: activeIndex == index
                  ? AppColors.sonaWhite
                  : AppColors.sonaBlack,
            ),
          ),
        ),
      );
    });
  }
}
