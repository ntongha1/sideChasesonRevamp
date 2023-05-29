import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/utils/styles.dart';
import 'package:sonalysis/features/common/cubit/common_cubit.dart';
import 'package:sonalysis/core/models/response/TeamsListResponseModel.dart';
import '../../../../../../../widgets/team_grid_item.dart';
import '../../../../core/enums/user_type.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/widgets/empty_response.dart';

class TeamsList extends StatefulWidget {
  final _TeamsListState _teamsClubManagementState = new _TeamsListState();

  @override
  void getData() {
    _teamsClubManagementState.getData();
  }

  TeamsList({Key? key}) : super(key: key);

  @override
  State<TeamsList> createState() => _TeamsListState();
}

class _TeamsListState extends State<TeamsList> {
  bool isLoading = true;
  TeamsListResponseModel? teamsListResponseModel;
  List<TeamsListResponseModelData> teamsFiltered = [];
  //List<String?> searchableList = [];
  late UserResultData userResultData;
  String? myId, myClubId;
  bool showOptions = false;
  int currentIndex = 0;
  final TextEditingController searchController = TextEditingController();

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  @override
  void initState() {
    getData();
    context.loaderOverlay.show();

    super.initState();
  }

  void _onRefresh() async {
    getData();
    _refreshController.refreshCompleted();
  }

  void onRefresh(v) async {
    print("refreshing step 1");
    getData();
  }

  void _onLoading() async {
    getData();
    _refreshController.loadComplete();
  }

  Future<void> getData() async {
    userResultData = (await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs))!;

    if (userResultData.user!.role!.toLowerCase() == UserType.player.type) {
      //print(userResultData!.user!.players![0].id.toString());
      myId = userResultData.user!.players![0].id;
      myClubId = userResultData.user!.players![0].clubId;
    } else if (userResultData.user!.role!.toLowerCase() ==
        UserType.owner.type) {
      myId = userResultData.user!.id;
      myClubId = userResultData.user!.clubs![0].id;
    } else {
      myId = userResultData.user!.staff![0].id;
      myClubId = userResultData.user!.staff![0].clubId;
    }

    // print("Token::: "+userResultData!.user!.clubs!.length.toString());
    // print("Token2::: "+userResultData!.user!.clubs![0].id.toString());
    await serviceLocator<CommonCubit>().getTeamList(myClubId!);
    setState(() {});
  }

  void searchNow(String? v) {
    List<TeamsListResponseModelData> all =
        teamsListResponseModel!.teamsListResponseModelData!;
    String value = "f";
    if (v == null || v == "")
      value = "";
    else
      value = v.trim().toLowerCase();
    if (v == "") {
      setState(() {
        teamsFiltered = all;
      });
      return;
    }

    List<TeamsListResponseModelData> temp = all.where((element) {
      String fname =
          element.teamName == null ? "" : element.teamName!.toLowerCase();

      return fname.contains(value);
    }).toList();
    setState(() {
      teamsFiltered = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocListener(
        bloc: serviceLocator.get<CommonCubit>(),
        listener: (_, state) {
          if (state is TeamListLoading) {
            setState(() {
              isLoading = true;
            });
          }

          if (state is TeamListError) {
            setState(() {
              isLoading = false;
            });
            context.loaderOverlay.hide();
            ResponseMessage.showErrorSnack(
                context: context, message: state.message);
          }

          if (state is TeamListSuccess) {
            context.loaderOverlay.hide();
            setState(() {
              isLoading = false;
              teamsListResponseModel =
                  serviceLocator.get<TeamsListResponseModel>();
              teamsFiltered =
                  teamsListResponseModel!.teamsListResponseModelData!;
            });
          }
        },
        child: isLoading
            ? Container()
            : Container(
                color: AppColors.sonaWhite,
                //margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (teamsListResponseModel
                            ?.teamsListResponseModelData!.length ==
                        0)
                      EmptyResponseWidget(
                          msg: 'Added teams will appear here',
                          iconData: Iconsax.menu_board5),
                    if (teamsFiltered.length > 0)
                      Column(children: [
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) {
                              searchNow(value);
                            },
                            style: AppStyle.text2,
                            decoration: InputDecoration(
                              fillColor: AppColors.sonaGrey6,
                              isDense: true,
                              filled: true,
                              prefixIcon: Icon(
                                Boxicons.bx_search,
                                color: AppColors.sonaGrey3,
                                size: 30,
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.normalRadius),
                                  borderSide:
                                      BorderSide(color: AppColors.sonaGrey6)),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15.h, horizontal: 12.w),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              hintText: "Search here",
                              hintStyle: AppStyle.text2,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            padding: const EdgeInsets.only(top: 4, bottom: 80),
                            //childAspectRatio: 8.0 / 9.0,
                            children:
                                List.generate(teamsFiltered.length, (index) {
                              return TeamGridItem(
                                  onRefresh: () {
                                    print("refreshing step fuck");
                                    onRefresh(false);
                                  },
                                  teamsListResponseModelItem:
                                      teamsFiltered.elementAt(index),
                                  onTap: () {
                                    setState(() {
                                      showOptions = true;
                                      currentIndex = index;
                                    });
                                  });
                            }),
                          ),
                        ),
                      ]),
                  ],
                ),
              ),
      ),
    );
  }
}
