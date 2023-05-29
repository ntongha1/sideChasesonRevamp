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
import 'package:sonalysis/core/models/response/StaffListResponseModel.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/widgets/button.dart';
import 'package:sonalysis/core/widgets/empty_response.dart';
import 'package:sonalysis/features/common/cubit/common_cubit.dart';
import 'package:sonalysis/features/common/models/PlayersInATeamModel.dart';
import 'package:sonalysis/features/common/models/StaffInATeamModel.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:sonalysis/widgets/player_row_item.dart';
import 'package:sonalysis/widgets/staff_row_item.dart';
import '../../../../../../core/datasource/local_storage.dart';
import '../../../../../core/enums/user_type.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/models/response/UserResultModel.dart'
    as UserResultModel;

class AddStaffFlowScreen extends StatefulWidget {
  String? teamId;
  String? clubId;
  Function? onPlayersAdded;

  AddStaffFlowScreen({Key? key, this.teamId, this.clubId, this.onPlayersAdded})
      : super(key: key);

  @override
  _AddStaffFlowScreenState createState() => _AddStaffFlowScreenState();
}

class _AddStaffFlowScreenState extends State<AddStaffFlowScreen> {
  Positions? _selectedPositions;
  bool canProceed = false, canProceed2 = false;
  bool canSubmit = false;
  final _formKey = GlobalKey<FormState>();
  String? myId, myClubId;

  XFile? selectedPhoto, xFileForCropper;
  File? _croppedFile;
  final ImagePicker _imagePicker = ImagePicker();
  bool _imagePicked = false, isSubmitting = false, showSuccess = false;
  final TextEditingController searchController = TextEditingController();

  final TextEditingController _oFirstNameController = TextEditingController();
  final TextEditingController _oLastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _jerseyNumberController = TextEditingController();
  List<dynamic> filteredItems = [];
  bool isLoading = true;
  StaffListResponseModel? playersInATeamModel;
  StaffListResponseModel? playersInATeamModelAll;
  List<StaffListResponseModelData> playersSelected = [];
  List<StaffListResponseModelData> playersAll = [];
  List<StaffListResponseModelData> playersFiltered = [];
  int len = 0;
  UserResultModel.UserResultData? userResultData;
  String clubId = "";

  final List<Positions>? position = [
    Positions(name: "Forward"),
    Positions(name: "Midfield"),
    Positions(name: "Defence"),
    Positions(name: "Keeper"),
  ];

  @override
  void initState() {
    _getData();
    super.initState();
  }

  Future<void> _getData() async {
    userResultData = await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs);
    //load all teams
    clubId = userResultData!.user!.clubs![0].id!;
    //getPlayerInAClubList
    await serviceLocator<CommonCubit>().getStaffList(widget.clubId!);

    setState(() {});
  }

  void doSelect(StaffListResponseModelData player) {
    if (playersSelected.contains(player)) {
      playersSelected.remove(player);
    } else {
      playersSelected.add(player);
    }
    setState(() {});
  }

  bool canGoNext() {
    if (playersSelected.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  void searchNow(String? v) {
    String value = "f";
    if (v == null || v == "")
      value = "";
    else
      value = v.trim().toLowerCase();
    if (v == "") {
      setState(() {
        playersFiltered = playersAll;
      });
      return;
    }
    List<StaffListResponseModelData> temp = playersAll.where((element) {
      var el = element.staff;
      String fname =
          el!.user!.firstName == null ? "" : el.user!.firstName!.toLowerCase();
      String lname =
          el.user!.lastName == null ? "" : el.user!.lastName!.toLowerCase();

      return fname.contains(value) || lname.contains(value);
    }).toList();
    print("temp length ${temp.length}");
    setState(() {
      playersFiltered = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (searchController.text.isEmpty) {
    //   filteredItems = widget.options.cast<T>();
    // }
//e2b0101f-2383-467e-b843-aaa3bf8edab2
    return Material(
        child: CupertinoPageScaffold(
      backgroundColor: Colors.transparent.withOpacity(0.9),
      child: BlocListener(
        bloc: serviceLocator.get<CommonCubit>(),
        listener: (_, state) {
          if (state is StaffListLoading) {
            setState(() {
              isLoading = true;
            });
            context.loaderOverlay.show();
          }

          if (state is StaffListError) {
            isLoading = false;
            setState(() {});
            context.loaderOverlay.hide();
            ResponseMessage.showErrorSnack(
                context: context, message: state.message);
          }

          if (state is StaffListSuccess) {
            context.loaderOverlay.hide();
            StaffListResponseModel p =
                serviceLocator.get<StaffListResponseModel>();
            setState(() {
              isLoading = false;
              playersInATeamModelAll = p;
              playersInATeamModel = p;
              playersAll = p.staffListResponseModelData!;
              playersFiltered = p.staffListResponseModelData!;
            });
          }
        },
        child: Container(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
          decoration: BoxDecoration(
              color: AppColors.sonaWhite,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              )),
          height: MediaQuery.of(context).size.height * 0.9,
          child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  onChanged: () {
                    setState(() {
                      canSubmit = _formKey.currentState!.validate();
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      InkWell(
                          onTap: () {
                            serviceLocator.get<NavigationService>().pop();
                          },
                          child: Container(
                            // padding: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Boxicons.bx_x_circle,
                              color: AppColors.sonaBlack2,
                              size: 24,
                            ),
                          )),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 0),
                            // padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "Add existing staff".tr(),
                              style: AppStyle.h3.copyWith(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.sonaBlack2),
                            )),
                      ),
                      const SizedBox(height: 40),
                      isLoading
                          ? Container()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 0.w),
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
                                          vertical: 15.h, horizontal: 12.w),
                                      border: InputBorder.none,
                                      hintText: "Search here",
                                      hintStyle: AppStyle.text2,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40.h,
                                ),
                                Container(
                                  color: AppColors.sonaWhite,
                                  child: playersFiltered.length == 0
                                      ? EmptyResponseWidget(
                                          msg: "Added staff will appear here",
                                          iconData: Iconsax.menu_board5)
                                      : Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w),
                                          child: Column(
                                            children: List.generate(
                                                playersFiltered.length,
                                                (index) {
                                              return StaffRowItem(
                                                  player: playersFiltered
                                                      .elementAt(index),
                                                  onSelect: doSelect);
                                            }),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                      SizedBox(height: 40),
                      Container(
                          margin: EdgeInsets.only(bottom: 40),
                          child: AppButton(
                              buttonText: isSubmitting
                                  ? "Adding...".tr()
                                  : "Add staff".tr(),
                              onPressed: canGoNext()
                                  ? () {
                                      // pop
                                      serviceLocator
                                          .get<NavigationService>()
                                          .pop();
                                      widget.onPlayersAdded!(playersSelected);
                                    }
                                  : null)),
                    ],
                  ))),
        ),
      ),
    ));
  }
}
