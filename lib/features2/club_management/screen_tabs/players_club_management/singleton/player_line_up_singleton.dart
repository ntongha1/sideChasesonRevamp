import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/helpers/helpers.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:sonalysis/widgets/custom_button.dart';
import 'package:sonalysis/widgets/custom_outline_button.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../../core/datasource/key.dart';
import '../../../../../../core/datasource/local_storage.dart';
import '../../../../../../core/models/response/UserResultModel.dart';
import '../../../../../../core/startup/app_startup.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/constants.dart';
import '../../../../../../core/utils/response_message.dart';
import '../../../../../features/common/cubit/common_cubit.dart';
import '../../../../../features/common/messages/MessagesScreen.dart';
import '../../../../../features/common/models/SinglePlayerModel.dart';

class PlayerLineUpSingletonScreen extends StatefulWidget {
  const PlayerLineUpSingletonScreen({Key? key, this.playerID})
      : super(key: key);

  final String? playerID;

  @override
  _PlayerLineUpSingletonScreenState createState() =>
      _PlayerLineUpSingletonScreenState();
}

class _PlayerLineUpSingletonScreenState
    extends State<PlayerLineUpSingletonScreen> {
  TooltipBehavior? _tooltipBehavior;
  UserResultData? userResultData;
  bool isLoading = true;
  SinglePlayerModel? singlePlayerModel;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _getData();
    super.initState();
  }

  Future<void> _getData() async {
    userResultData = await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs);
    await serviceLocator<CommonCubit>()
        .getSinglePlayerProfile(widget.playerID!);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: CupertinoPageScaffold(
      backgroundColor: Colors.transparent.withOpacity(0.9),
      child: BlocListener(
          bloc: serviceLocator.get<CommonCubit>(),
          listener: (_, state) {
            if (state is GetSinglePlayerProfileLoading) {
              setState(() {
                isLoading = true;
              });
              context.loaderOverlay.show();
            }

            if (state is GetSinglePlayerProfileError) {
              setState(() {
                isLoading = false;
              });
              context.loaderOverlay.hide();
              ResponseMessage.showErrorSnack(
                  context: context, message: AppConstants.exceptionMessage);
            }

            if (state is GetSinglePlayerProfileSuccess) {
              //singlePlayerModel = serviceLocator.get<SinglePlayerModel>();
              singlePlayerModel = state.singlePlayerModel;
              context.loaderOverlay.hide();
              setState(() {
                isLoading = false;
              });
            }
          },
          child: isLoading
              ? Container()
              : Container(
                  decoration: BoxDecoration(
                      color: sonaBlack,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      )),
                  child: ListView(
                    children: [
                      const SizedBox(height: 20),
                      ListTile(
                        leading: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(Icons.arrow_back_ios,
                                color: Colors.white, size: 20.h)),
                        title: Container(
                          margin: const EdgeInsets.only(left: 70),
                          child: Text(
                            "Player Management",
                            style:
                                TextStyle(fontSize: 14.sp,
                                    color: Colors.white,
                                  fontWeight: FontWeight.w700
                                ),
                          ),
                        ),
                      ),
                      CircleAvatar(
                          radius: 70,
                          backgroundColor: AppColors.sonaBlack,
                          child: ClipOval(
                              child: Image.network(
                                  singlePlayerModel!.data!.player!.photo == null
                                      ? AppConstants.defaultProfilePictures
                                      : singlePlayerModel!.data!.player!.photo!,
                                  fit: BoxFit.contain,
                                  repeat: ImageRepeat.noRepeat,
                                  width: 140.w))),
                      const SizedBox(height: 10),
                      Align(
                          alignment: Alignment.center,
                          child: Container(
                              margin: const EdgeInsets.only(top: 10, bottom: 0),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                singlePlayerModel!.data!.player!.jerseyNo! +
                                    ", " +
                                    singlePlayerModel!.data!.player!.firstName! +
                                    " " +
                                    singlePlayerModel!.data!.player!.lastName!,
                                style: TextStyle(
                                    color: const Color(0xFFFFFFFF),
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700),
                              ))),
                      Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 0),
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              playerFeatures(singlePlayerModel!.data!.player!.teamName ?? "tttt"),
                              const SizedBox(width: 15),
                              playerFeatures(singlePlayerModel!.data!.player!.position!),
                              const SizedBox(width: 15),
                              playerFeatures("23 Yrs")
                            ],
                          )),
                      Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 0),
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              playerFeatures("United States"),
                              const SizedBox(width: 15),
                              playerFeatures("Invite Pending"),
                            ],
                          )),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.43,
                            child: CustomButton(
                              text: "Send a Message",
                              verticalPadding: 8,
                              color: sonaPurple1,
                              action: () {
                                pushNewScreen(
                                  context,
                                  screen: const MessagesScreen(),
                                  withNavBar: true, // OPTIONAL VALUE. True by default.
                                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.43,
                            child: CustomOutlineButton(
                              text: 'Share analytics',
                              verticalPadding: 8,
                              // buttonIcon: const Icon(
                              //   FontAwesomeIcons.pencilAlt,
                              //   size: 12,
                              //   color: Colors.white,
                              // ),
                              borderColor: Colors.white,
                              color: sonaPurple1,
                              action: () {
                                //bottomSheet(context, AddEditPlayerScreen(
                                //type: "edit"
                                //));
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 0),
                        decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                playerAttributes(
                                    singlePlayerModel!.data!.analysis!.goals.toString(),
                                    "Goals"),
                                const SizedBox(width: 15),
                                playerAttributes(
                                    singlePlayerModel!.data!.analysis!.speed.toString(),
                                    "Speed"),
                                const SizedBox(width: 15),
                                playerAttributes(
                                    singlePlayerModel!.data!.analysis!.penalty.toString(),
                                    "Penalty"),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                playerAttributes(
                                    singlePlayerModel!.data!.analysis!.goals.toString(),
                                    "Goals"),
                                const SizedBox(width: 15),
                                playerAttributes(
                                    singlePlayerModel!.data!.analysis!.yellowCard.toString(),
                                    "Yellow cards",
                                    image: AppAssets.yellowCard),
                                const SizedBox(width: 15),
                                playerAttributes(
                                    singlePlayerModel!.data!.analysis!.redCard.toString(),
                                    "Red cards",
                                    image: AppAssets.redCard),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                playerAnalytics(singlePlayerModel!.data!.analysis!.freeKick,
                                    "Free Kick"),
                                const SizedBox(width: 15),
                                playerAnalytics(singlePlayerModel!.data!.analysis!.longPass,
                                    "Long Pass"),
                                const SizedBox(width: 15),
                                playerAnalytics(singlePlayerModel!.data!.analysis!.shortPass,
                                    "Short Pass"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 15),
                        decoration: BoxDecoration(
                            color: sonaLightBlack,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            // Chart title
                            title: ChartTitle(
                                text: 'Speed Graph (In Kilometer/second)',
                                alignment: ChartAlignment.near,
                                textStyle: TextStyle(
                                    color: getColorHexFromStr("C4C4C4"),
                                    fontSize: 12.sp)),
                            // Enable legend
                            legend: Legend(isVisible: false),
                            primaryYAxis: NumericAxis(
                                minimum: 0, maximum: 80, interval: 10),
                            // Enable tooltip
                            tooltipBehavior: _tooltipBehavior,
                            series: <ChartSeries<SalesData, String>>[
                              AreaSeries<SalesData, String>(
                                  dataSource: <SalesData>[
                                    SalesData('02', 35),
                                    SalesData('04', 28),
                                    SalesData('06', 34),
                                    SalesData('08', 32),
                                    SalesData('10', 40)
                                  ],
                                  xValueMapper: (SalesData sales, _) =>
                                      sales.year,
                                  yValueMapper: (SalesData sales, _) =>
                                      sales.sales,
                                  name: 'Gold',
                                  color: getColorHexFromStr("811AFF"),
                                  // Enable data label
                                  dataLabelSettings: DataLabelSettings(
                                      isVisible: true,
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp)))
                            ]),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                )),
    ));
  }

  Widget playerFeatures(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Text(text,
          textAlign: TextAlign.center,
          style:
              TextStyle(color: getColorHexFromStr("C4C4C4"), fontSize: 13.sp)),
    );
  }

  Widget playerAttributes(String value, String text, {String? image}) {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
          color: sonaLightBlack,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Column(
        children: [
          image == null
              ? Text(value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Image.asset(image,
                        fit: BoxFit.cover,
                        repeat: ImageRepeat.noRepeat,
                        width: 15)
                  ],
                ),
          const SizedBox(height: 5),
          Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: getColorHexFromStr("C4C4C4"), fontSize: 13.sp))
        ],
      ),
    );
  }

  Widget playerAnalytics(int? value, String text) {
    return SizedBox(
        width: 90,
        child: Column(
          children: [
            CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 8.0,
              percent: value! / 100,
              center: Text(value.toString() + "%",
                  style: const TextStyle(color: Colors.white)),
              progressColor: getColorHexFromStr("47DC40"),
            ),
            const SizedBox(height: 10),
            Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: getColorHexFromStr("C4C4C4"), fontSize: 13.sp)),
          ],
        ));
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
