import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/enums/user_type.dart';
import 'package:sonalysis/core/models/response/AnalysedVideosSingletonModel.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/features/common/cubit/common_cubit.dart';
import '../../../core/utils/styles.dart';
import 'tabs/highlights.dart';
import 'tabs/lineUpSingleton.dart';
import 'tabs/matchStatSingleton.dart';

class AnalysedVideosSingletonScreen extends StatefulWidget {

  Map? data;

  AnalysedVideosSingletonScreen(
      {Key? key,
        required this.data})
      : super(key: key);

  @override
  _AnalysedVideosSingletonScreenState createState() => _AnalysedVideosSingletonScreenState();
}

class _AnalysedVideosSingletonScreenState extends State<AnalysedVideosSingletonScreen> with SingleTickerProviderStateMixin {

  UserResultData? userResultData;
  TabController? tabController;
  int _selectedIndex = 0;
  bool? isLoading = true;
  AnalysedVideosSingletonModel? analysedVideosSingletonModel;

  @override
  void initState() {
    super.initState();
    _getData();
    // Create TabController for getting the index of current tab
    tabController = TabController(length: 3, vsync: this);
    tabController!.addListener(() {
      setState(() {
        _selectedIndex = tabController!.index;
      });
      print("Selected Index: " + tabController!.index.toString());
    });
    }

  Future<void> _getData() async {
    userResultData = await serviceLocator.get<LocalStorage>().readSecureObject(LocalStorageKeys.kUserPrefs);
    await serviceLocator<CommonCubit>().getAnalysedVideosSingleton(widget.data!["analyticsId"]);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: serviceLocator.get<CommonCubit>(),
      listener: (_, state) {
        if (state is AnalysedVideosSingletonLoading) {
          isLoading = true;
          context.loaderOverlay.show();
        }

        if (state is AnalysedVideosSingletonError) {
          isLoading = false;
          context.loaderOverlay.hide();
          ResponseMessage.showErrorSnack(context: context, message: state.message);
        }

        if (state is AnalysedVideosSingletonSuccess) {
          isLoading = false;
          context.loaderOverlay.hide();
          analysedVideosSingletonModel = serviceLocator.get<AnalysedVideosSingletonModel>();
          setState(() {});
        }
      },
      child: isLoading!
          ? Container()
          : Scaffold(
      backgroundColor: AppColors.sonaGrey6,
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 50),
          ListTile(
            leading: InkWell(
                onTap: () {
                  serviceLocator.get<NavigationService>().pop();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Iconsax.arrow_circle_left4,
                    color: AppColors.sonaBlack2,
                    size: 30,
                  ),
                )),
            title: Container(
              margin: const EdgeInsets.only(right: 70),
              child: Text(
                "View analytics".tr(),
                textAlign: TextAlign.center,
                style: AppStyle.h3.copyWith(color: AppColors.sonaBlack2, fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: TabBar(
              controller: tabController,
              indicatorWeight: 1,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: AppColors.sonalysisMediumPurple,
              onTap: (index) {
                // Tab index when user select it, it start from zero
              },
              tabs: [
                Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 6),
                    child: Text("highlights".tr(),
                        style: AppStyle.text2.copyWith(
                          fontWeight: FontWeight.w400,
                          color: _selectedIndex == 0
                              ? AppColors.sonalysisMediumPurple
                              : AppColors.sonaGrey2,
                        )),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 6),
                    child: Text("match_stats".tr(),
                        style: AppStyle.text2.copyWith(
                          fontWeight: FontWeight.w400,
                          color: _selectedIndex == 1
                              ? AppColors.sonalysisMediumPurple
                              : AppColors.sonaGrey2,
                        )),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 6),
                    child: Text(userResultData!.user!.role!.toLowerCase() == UserType.player.type
                        ? "my_stats".tr()
                        : "line_up".tr(),
                        style: AppStyle.text2.copyWith(
                          fontWeight: FontWeight.w400,
                          color: _selectedIndex == 2
                              ? AppColors.sonalysisMediumPurple
                              : AppColors.sonaGrey2,
                        )),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
              child: Container(
                  color: AppColors.sonaWhite,
                  child: TabBarView(
                controller: tabController,
                children: [
                  SingleChildScrollView(
                    child: Highlights(
                        analysedVideosSingletonModel: analysedVideosSingletonModel
                    ),
                  ),
                  SingleChildScrollView(
                    child: MatchStatSingleton(
                        analysedVideosSingletonModel: analysedVideosSingletonModel
                    ),
                  ),
                  LineUpSingleton(
                      analysedVideosSingletonModel: analysedVideosSingletonModel
                  ),
                ],
              ))),
        ],
      )),
    );
  }
}