import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/enums/button.dart';
import 'package:sonalysis/core/models/response/StaffListResponseModel.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/navigation/keys.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/utils/helpers.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/utils/styles.dart';
import 'package:sonalysis/core/widgets/create_team_step_2_bottom_sheet.dart';
import 'package:sonalysis/core/widgets/player_on_tap_sheet.dart';
import 'package:sonalysis/core/widgets/popup_screen.dart';
import 'package:sonalysis/features/common/cubit/common_cubit.dart';
import 'package:sonalysis/features/common/models/StaffInATeamModel.dart'
    as staffModel;
import 'package:sonalysis/features2/club_management/screen_tabs/staff_club_management/add_edit_staff/addEditStaff.dart';
import 'package:sonalysis/widgets/staff_grid_item.dart';

import '../../../../../core/models/response/TeamsListResponseModel.dart';
import '../../../../core/enums/user_type.dart';
import '../../../../core/widgets/empty_response.dart';

class StaffClubManagement extends StatefulWidget {
  final TeamsListResponseModelData? teamsListResponseModelItem;
  final bool isSingleton;
  const StaffClubManagement(
      {Key? key, this.teamsListResponseModelItem, required this.isSingleton})
      : super(key: key);

  @override
  State<StaffClubManagement> createState() => _StaffClubManagementState();
}

class _StaffClubManagementState extends State<StaffClubManagement> {
  bool isLoading = true;
  StaffListResponseModel? staffListResponseModel;
  List<StaffListResponseModelData?>? staffListFiltered = [];
  //List<String?> searchableList = [];
  late UserResultData userResultData;
  final TextEditingController searchController = TextEditingController();
  bool showStaffEdit = false;

  staffModel.Staff? contextStaff;
  String? contextStaffId = "";
  bool showStaffRemoveSure = false;
  bool staffRemoved = false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  String? myId, myClubId;

  @override
  void initState() {
    _getData();
    context.loaderOverlay.show();
    super.initState();
  }

  void _onRefresh() async {
    _getData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _getData();
    _refreshController.loadComplete();
  }

  Future<void> _getData() async {
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
    await serviceLocator<CommonCubit>().getStaffList(myClubId!);
    setState(() {});
  }

  void searchNow(String? v) {
    List<StaffListResponseModelData> all =
        staffListResponseModel!.staffListResponseModelData!;
    String value = "f";
    if (v == null || v == "")
      value = "";
    else
      value = v.trim().toLowerCase();
    if (v == "") {
      setState(() {
        staffListFiltered = all;
      });
      return;
    }

    List<StaffListResponseModelData> temp = all.where((element) {
      String fname = element.user!.firstName == null
          ? ""
          : element.user!.firstName!.toLowerCase();

      String lname = element.user!.lastName == null
          ? ""
          : element.user!.lastName!.toLowerCase();

      String role =
          element.user!.role == null ? "" : element.user!.role!.toLowerCase();

      return fname.contains(value) ||
          lname.contains(value) ||
          role.contains(value);
    }).toList();
    setState(() {
      staffListFiltered = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isSingleton) {
      // not from singleton
      return SingleChildScrollView(
          child: Stack(
        children: [
          BlocListener(
              bloc: serviceLocator.get<CommonCubit>(),
              listener: (_, state) {
                if (state is StaffListLoading) {
                  setState(() {
                    isLoading = true;
                  });
                }

                if (state is StaffListError) {
                  setState(() {
                    isLoading = false;
                  });
                  context.loaderOverlay.hide();
                  ResponseMessage.showErrorSnack(
                      context: context, message: state.message);
                }

                if (state is StaffListSuccess) {
                  context.loaderOverlay.hide();
                  setState(() {
                    isLoading = false;
                    staffListResponseModel =
                        serviceLocator.get<StaffListResponseModel>();
                    staffListFiltered = serviceLocator
                        .get<StaffListResponseModel>()
                        .staffListResponseModelData!;
                  });
                }
              },
              child: isLoading || staffListResponseModel == null
                  ? Container()
                  : Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: staffListResponseModel!
                              .staffListResponseModelData!.isEmpty
                          ? EmptyResponseWidget(
                              msg: "Added staff will appear here",
                              iconData: Iconsax.menu_board5)
                          : Column(children: [
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
                                        borderSide: BorderSide(
                                            color: AppColors.sonaGrey6)),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 12),
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
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: GridView.count(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 80),
                                  //childAspectRatio: 8.0 / 9.0,
                                  children: List.generate(
                                      staffListFiltered!.length, (index) {
                                    return StaffGridItem(
                                        staffListResponseModelData:
                                            staffListFiltered!.elementAt(index),
                                        onTap: () {
                                          serviceLocator
                                              .get<NavigationService>()
                                              .toWithPameter(
                                                  routeName: RouteKeys
                                                      .routeStaffSingletonScreen,
                                                  data: {
                                                "staffId": staffListFiltered!
                                                    .elementAt(index)!
                                                    .id,
                                                "clubId": staffListFiltered!
                                                    .elementAt(index)!
                                                    .clubId,
                                                "staffListResponseModelData":
                                                    staffListFiltered!
                                                        .elementAt(index),
                                              }).then((value) => {
                                                    _getData(),
                                                  });
                                        });
                                  }),
                                ),
                              ),
                            ]),
                    )),
          Positioned(
              child: staffRemoved
                  ? PopUpPageScreen(data: {
                      "title": "Staff Removed".tr(),
                      "subTitle": "Staff has been removed successfully!".tr(),
                      "routeType": "callback",
                      "route": null,
                      "buttonText": "okay_thank_you".tr(),
                      "callback": () {
                        setState(() {
                          staffRemoved = false;
                        });
                      }
                    })
                  : Container()),
          Positioned(
              child: showStaffEdit
                  ? PlayerOnTapSheet({
                      "buttons": [
                        {
                          "onPressed": () {
                            setState(() {
                              showStaffEdit = false;
                            });
                            bottomSheet(
                                context,
                                AddEditStaffScreen(
                                  type: "edit",
                                  playerID: contextStaffId,
                                  staff: contextStaff,
                                )).then((value) {
                              _getData();
                            });
                          },
                          "buttonText": "Edit Staff".tr(),
                          "buttonType": ButtonType.primary
                        },
                        {
                          "onPressed": () => setState(() {
                                setState(() {
                                  showStaffEdit = false;
                                });
                              }),
                          "buttonText": "Share Staff".tr(),
                          "buttonType": ButtonType.secondary
                        },
                        {
                          "onPressed": () => setState(() {
                                setState(() {
                                  showStaffEdit = false;
                                  showStaffRemoveSure = true;
                                });
                              }),
                          "buttonText": "Remove Staff".tr(),
                          "buttonType": ButtonType.deleteButton
                        },
                      ]
                    }, context, () {
                      setState(() {
                        showStaffEdit = false;
                      });
                    })
                  : Container()),
          Positioned(
              child: showStaffRemoveSure
                  ? AddPlayerChoices({
                      "title": "Remove Staff".tr(),
                      "subTitle":
                          "Are you sure you want to remove this staff from this team? This won't delete staff from the club"
                              .tr(),
                      "buttons": [
                        {
                          "onPressed": () {
                            setState(() {
                              showStaffRemoveSure = false;
                            });
                            deleteStaff(contextStaffId);
                            // TODO: remove player
                          },
                          "buttonText": "Remove".tr(),
                          "buttonType": ButtonType.primary
                        },
                        {
                          "onPressed": () => setState(() {
                                setState(() {
                                  showStaffRemoveSure = false;
                                });
                              }),
                          "buttonText": "Cancel".tr(),
                          "buttonType": ButtonType.secondary
                        }
                      ]
                    }, context, () {
                      setState(() {
                        showStaffRemoveSure = false;
                      });
                    })
                  : Container()),
        ],
      ));
    } else {
      if (widget.teamsListResponseModelItem == null)
        return EmptyResponseWidget(
            msg: "Added staff will appear here", iconData: Iconsax.menu_board5);
      else
        return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   margin: const EdgeInsets.only(top: 10.0),
                //   child: CustomSearch(
                //   labelText: "Search for staff",
                //   searchableList: searchableList,
                //   )
                // ),
                // const SizedBox(height: 20),
                // Row(
                //   children: [
                //     Container(
                //         margin: const EdgeInsets.only(left: 10, right: 10),
                //         child: SizedBox(
                //             width: MediaQuery.of(context).size.width * 0.35,
                //             child: CustomOutlineButton(
                //                 color: Colors.white,
                //                 text: 'Add a staff',
                //                 verticalPadding: 5,
                //                 action: () {
                //                   bottomSheet(context,
                //                           const NewExistingStaffModalQuiz())
                //                       .then((value) {
                //                     if (value != null && value) {
                //                       bottomSheet(context,
                //                               const CreateStaffFlowScreen())
                //                           .then((value) {
                //                         if (value != null && value) {
                //                           _getData();
                //                         }
                //                       });
                //                     }
                //                   });
                //                 }))),
                //     SizedBox(
                //       width: 70,
                //       child: Container(
                //         padding: const EdgeInsets.symmetric(
                //             vertical: 10, horizontal: 5),
                //         decoration: BoxDecoration(
                //             color: sonaLightBlack,
                //             borderRadius:
                //                 const BorderRadius.all(Radius.circular(4))),
                //         child: Text(
                //             staffListResponseModel!
                //                     .staffListResponseModelData!.length
                //                     .toString() +
                //                 "/150",
                //             textAlign: TextAlign.center,
                //             style: const TextStyle(color: Colors.white)),
                //       ),
                //     ),
                //   ],
                // ),
                //const SizedBox(height: 10),
                if (widget.teamsListResponseModelItem!.totalStaff! == 0)
                  EmptyResponseWidget(
                      msg: "Added staff will appear here",
                      iconData: Iconsax.menu_board5),
                if (widget.teamsListResponseModelItem!.totalStaff! != 0)
                  GridView.count(
                    crossAxisCount: 2,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    childAspectRatio: 8.0 / 9.0,
                    children: List.generate(
                        widget.teamsListResponseModelItem!.totalStaff!,
                        (index) {
                      // return StaffGridItem(teamsListResponseModelStaff: widget.teamsListResponseModelItem!.teamsListResponseModelStaff!.elementAt(index));
                      return StaffGridItem(teamsListResponseModelStaff: null);
                    }),
                  ),
              ],
            ));
    }
  }

  Future<void> deleteStaff(String? contextId) async {
    setState(() {
      isLoading = true;
    });
    context.loaderOverlay.show();

    await serviceLocator<CommonCubit>().deleteStaff(contextId!);
    context.loaderOverlay.hide();
    setState(() {
      isLoading = false;
      staffRemoved = true;
    });
    _getData();
  }
}
