import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/styles.dart';
import 'package:sonalysis/features/common/dashboard/widgets/lineup_grid_item.dart';

import '../../../../../../../core/datasource/key.dart';
import '../../../../../../../core/datasource/local_storage.dart';
import '../../../../../../../core/models/response/AnalysedVideosSingletonModel.dart';
import '../../../../../../../core/startup/app_startup.dart';
import '../../../../../../../core/utils/images.dart';
import '../../../../../../../core/utils/response_message.dart';
import '../../../../features/common/cubit/common_cubit.dart';
import '../../../../features/common/models/LineUpModel.dart';

class LineUpSingleton extends StatefulWidget {
  AnalysedVideosSingletonModel? analysedVideosSingletonModel;
  LineUpSingleton({Key? key, required this.analysedVideosSingletonModel})
      : super(key: key);

  @override
  State<LineUpSingleton> createState() => _LineUpSingletonState();
}

class _LineUpSingletonState extends State<LineUpSingleton>
    with SingleTickerProviderStateMixin {
  UserResultData? userResultData;
  bool? isLoading = true;
  LineUpModel? lineUpModel;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    userResultData = await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs);
    await serviceLocator<CommonCubit>().getLineUp(
        widget.analysedVideosSingletonModel!.data!.id!,
        widget.analysedVideosSingletonModel!.data!.clubStats!
            .elementAt(0)
            .tempTeamName!);
    setState(() {});
  }

  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: serviceLocator.get<CommonCubit>(),
        listener: (_, state) {
          if (state is LineUpLoading) {
            isLoading = true;
            context.loaderOverlay.show();
          }

          if (state is LineUpError) {
            isLoading = false;
            context.loaderOverlay.hide();
            ResponseMessage.showErrorSnack(
                context: context, message: state.message);
          }

          if (state is LineUpSuccess) {
            isLoading = false;
            context.loaderOverlay.hide();
            setState(() {
              lineUpModel = serviceLocator.get<LineUpModel>();
              //print("filename:::::: "+lineUpModel!.data.toString());
            });
          }
        },
        child: isLoading!
            ? Container()
            : 2 == 2
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text("This area is under development"),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        // Container(
                        //     decoration: BoxDecoration(
                        //         color: AppColors.sonaWhite,
                        //         border: Border.all(
                        //           color: AppColors.sonalysisMediumPurple,
                        //         ),
                        //         borderRadius:
                        //             const BorderRadius.all(Radius.circular(8))),
                        //     child: DropdownButton<String>(
                        //       value: dropdownValue,
                        //       hint: Padding(
                        //         padding: EdgeInsets.symmetric(horizontal: 10),
                        //         child: Text(
                        //           "choose_a_team".tr(),
                        //           overflow: TextOverflow.ellipsis,
                        //           style: AppStyle.text1
                        //               .copyWith(color: AppColors.sonaBlack2),
                        //         ),
                        //       ),
                        //       icon: Icon(Icons.keyboard_arrow_down_sharp,
                        //           color: AppColors.sonaBlack2),
                        //       iconSize: 20.sp,
                        //       elevation: 16,
                        //       dropdownColor: AppColors.sonaWhite,
                        //       underline: Container(
                        //         height: 0,
                        //         color: AppColors.sonaWhite,
                        //       ),
                        //       onChanged: (newValue) async {
                        //         await serviceLocator<CommonCubit>().getLineUp(
                        //             widget.analysedVideosSingletonModel!.data!
                        //                 .id!,
                        //             newValue!);
                        //         dropdownValue = newValue!;
                        //         setState(() {});
                        //       },
                        //       items: <String>[
                        //         widget.analysedVideosSingletonModel!.data!
                        //             .clubStats!
                        //             .elementAt(0)
                        //             .tempTeamName!,
                        //         widget.analysedVideosSingletonModel!.data!
                        //             .clubStats!
                        //             .elementAt(1)
                        //             .tempTeamName!
                        //       ].map<DropdownMenuItem<String>>((String value) {
                        //         return DropdownMenuItem<String>(
                        //             value: value,
                        //             child: Row(
                        //               children: [
                        //                 Image.asset(AppAssets.clubLogo,
                        //                     fit: BoxFit.contain,
                        //                     repeat: ImageRepeat.noRepeat,
                        //                     width: 60),
                        //                 Column(
                        //                   children: [
                        //                     Text(
                        //                       value.length == 0
                        //                           ? widget
                        //                               .analysedVideosSingletonModel!
                        //                               .data!
                        //                               .clubStats!
                        //                               .elementAt(0)
                        //                               .tempTeamName!
                        //                           : value,
                        //                       overflow: TextOverflow.ellipsis,
                        //                       style: AppStyle.text1.copyWith(
                        //                           color: AppColors.sonaBlack2),
                        //                     ),
                        //                     Text(
                        //                       "Soccer League".tr(),
                        //                       overflow: TextOverflow.ellipsis,
                        //                       style: AppStyle.text1.copyWith(
                        //                           color: AppColors.sonaBlack2),
                        //                     )
                        //                   ],
                        //                 )
                        //               ],
                        //             ));
                        //       }).toList(),
                        //     )),
                        const SizedBox(height: 10),
                        if (widget.analysedVideosSingletonModel!.data!
                            .clubStats!.isNotEmpty)
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 2,
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              childAspectRatio: 9.0 / 10.0,
                              children: List.generate(lineUpModel!.data!.length,
                                  (index) {
                                return LineUpPlayerGridItem(
                                    lineupData:
                                        lineUpModel!.data!.elementAt(index));
                              }),
                            ),
                          ),
                        const SizedBox(height: 110),
                      ],
                    )));
  }
}
