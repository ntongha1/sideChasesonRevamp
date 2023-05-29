import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/enums/request_type.dart';
import 'package:sonalysis/core/enums/server_type.dart';
import 'package:sonalysis/core/models/position.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/navigation/keys.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/network/keys.dart';
import 'package:sonalysis/core/network/network_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/utils/validator.dart';
import 'package:sonalysis/core/widgets/app_datefield.dart';
import 'package:sonalysis/core/widgets/app_datefield_global.dart';
import 'package:sonalysis/core/widgets/app_dropdown_modal.dart';
import 'package:sonalysis/core/widgets/app_textfield.dart';
import 'package:sonalysis/core/widgets/button.dart';
import 'package:sonalysis/features/common/cubit/common_cubit.dart';
import 'package:sonalysis/features2/comparison/widgets/player_row_item_global.dart';
import 'package:sonalysis/features2/comparison/widgets/team_row_item_global.dart';
import 'package:sonalysis/style/styles.dart';

import '../../../../../../core/datasource/local_storage.dart';
import '../../../../../core/enums/user_type.dart';
import '../../../../../core/utils/styles.dart';

class TeamSelectorGlobalScreen extends StatefulWidget {
  var match;
  Function onMatchSelected;

  TeamSelectorGlobalScreen(
      {Key? key, required this.onMatchSelected, required this.match})
      : super(key: key);

  @override
  _TeamSelectorGlobalScreenState createState() =>
      _TeamSelectorGlobalScreenState();
}

class _TeamSelectorGlobalScreenState extends State<TeamSelectorGlobalScreen>
    with SingleTickerProviderStateMixin {
  Positions? _selectedPositions;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final Client _httpClient = Client();
  bool canProceed = false, canProceed2 = false;
  bool loadingMatches = true;
  final TextEditingController searchController = TextEditingController();

  bool canSubmit = false;
  final _formKey = GlobalKey<FormState>();
  String? myId, myClubId;
  String dateToday = DateTime.now().toString().substring(0, 10);
  String _format = 'yyyy-MM-dd';
  NetworkService newServerService = new NetworkService(ServerType.newServer);
  XFile? selectedPhoto, xFileForCropper;
  File? _croppedFile;
  final ImagePicker _imagePicker = ImagePicker();
  bool _imagePicked = false, isSubmitting = false, showSuccess = false;
  List<dynamic> players = [];
  List<dynamic> splayers = [];

  final TextEditingController _oFirstNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController _oLastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _jerseyNumberController = TextEditingController();
  TabController? tabController;
  int _selectedIndex = 0;

  var homeTeam = null;
  var awayTeam = null;

  List<dynamic> asplayers = [];
  List<dynamic> aplayers = [];
  List<dynamic> bplayers = [];
  List<dynamic> bsplayers = [];
  String? oldPhoto = null;

  final List<Positions>? position = [
    Positions(name: "Forward"),
    Positions(name: "Midfield"),
    Positions(name: "Defence"),
    Positions(name: "Keeper"),
  ];

  UserResultData? userResultData;

  handlePickPhoto() async {
    XFile? _imagePickerResult = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 675,
        maxWidth: 960,
        preferredCameraDevice: CameraDevice.front);
    if (_imagePickerResult != null) {
      setState(() {
        selectedPhoto = _imagePickerResult;
      });
      cropImage(selectedPhoto!);
    }
  }

  cropImage(XFile documentImages) async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: documentImages.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop selected image',
            toolbarColor: sonaBlack,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Colors.white.withOpacity(0.4),
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    if (croppedFile != null) {
      setState(() {
        _croppedFile = croppedFile;
        _imagePicked = true;
      });
    }
    //_validate(context);
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(() {
      setState(() {
        _selectedIndex = tabController!.index;
      });
    });

    homeTeam = widget.match['teams']['home'];
    awayTeam = widget.match['teams']['away'];

    setState(() {
      loadingMatches = false;
    });

    // _getData();
  }

  Future<void> _getData() async {
    userResultData = await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs);

    if (userResultData!.user!.role!.toLowerCase() == UserType.player.type) {
      //print(userResultData!.user!.players![0].id.toString());
      myId = userResultData!.user!.players![0].id;
      myClubId = userResultData!.user!.players![0].clubId;
    } else if (userResultData!.user!.role!.toLowerCase() ==
        UserType.owner.type) {
      myId = userResultData!.user!.id;
      myClubId = userResultData!.user!.clubs![0].id;
    } else {
      myId = userResultData!.user!.staff![0].id;
      myClubId = userResultData!.user!.staff![0].clubId;
    }

    dateController.text = dateToday;

    getPlayers();

    setState(() {});
  }

  prevDatePlease() {
    DateTime date = DateTime.parse(dateController.text);
    date = date.subtract(Duration(days: 1));
    print("I was here");
    setState(() {
      dateController.text = date.toString().substring(0, 10);
      dateToday = date.toString().substring(0, 10);
    });
  }

  nextDatePlease() {
    DateTime date = DateTime.parse(dateController.text);

    // if date is today's date, return
    if (date.toString().substring(0, 10) ==
        DateTime.now().toString().substring(0, 10)) {
      return;
    }
    date = date.add(Duration(days: 1));
    setState(() {
      dateController.text = date.toString().substring(0, 10);
      dateToday = date.toString().substring(0, 10);
    });
  }

  getPlayers() async {
    setState(() {
      loadingMatches = true;
    });
    String url = ApiConstants.getFixtureByID + "979139";

    Map<String, String> header = {};
    header = {
      'Content-Type': 'application/json',
      'accept': '*/*',
      'X-RapidAPI-Key': ApiConstants.rapidApiToken,
    };

    Response? res = await _httpClient.get(Uri.parse(url), headers: header);
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      print('players:' + data['response'].toString());
      setState(() {
        aplayers = data['response'][0]['players'];
        asplayers = data['response'][0]['players'];
        bplayers = data['response'][1]['players'];
        bsplayers = data['response'][1]['players'];
        players = aplayers + bplayers;
        splayers = players;
        loadingMatches = false;
      });
      return data['data'];
    } else {
      setState(() {
        players = [];
        splayers = [];
        loadingMatches = true;
      });
      return null;
    }
  }

  void searchNow(String? v) {
    String value = "";
    if (v == null || v == "")
      value = "";
    else
      value = v.trim().toLowerCase();
    if (v == "") {
      setState(() {
        aplayers = asplayers;
        bplayers = bsplayers;
      });
      return;
    }
    List tempa = aplayers.where((element) {
      String v1 = element["player"]["name"] == null
          ? ""
          : element["player"]["name"].toLowerCase();
      return v1.contains(value);
    }).toList();
    List tempb = bplayers.where((element) {
      String v1 = element["player"]["name"] == null
          ? ""
          : element["player"]["name"].toLowerCase();
      return v1.contains(value);
    }).toList();
    setState(() {
      aplayers = tempa;
      bplayers = tempb;
    });
  }

  String getGoals(e) {
    String g = "";

    if (e['goals']['home'] != null) {
      g = e['goals']['home'].toString();
    } else {
      g = "0";
    }
    if (e['goals']['away'] != null) {
      g = g + " - " + e['goals']['away'].toString();
    } else {
      g = g + " - 0";
    }

    return g;
  }

  @override
  Widget build(BuildContext context) {
//e2b0101f-2383-467e-b843-aaa3bf8edab2
    return Material(
        child: CupertinoPageScaffold(
      backgroundColor: Colors.transparent.withOpacity(0.9),
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
                    const SizedBox(height: 20),
                    loadingMatches
                        ? Container(
                            child: CircularProgressIndicator(
                            color: AppColors.sonaGreen,
                          ))
                        : Container(
                            child: homeTeam != null || awayTeam != null
                                ? Column(
                                    children: [
                                      Container(
                                        child: TabBar(
                                          controller: tabController,
                                          indicatorPadding: EdgeInsets.all(0.0),
                                          labelPadding: EdgeInsets.only(
                                              left: 0.0, right: 0.0),

                                          indicatorWeight: 4,
                                          indicatorSize:
                                              TabBarIndicatorSize.label,
                                          // indicatorColor: AppColors.sonalysisMediumPurple,
                                          indicator: ShapeDecoration(
                                            shape: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors
                                                    .sonalysisMediumPurple,
                                                width: 4.0,
                                                style: BorderStyle.solid,
                                              ),
                                            ),
                                          ),
                                          onTap: (index) {
                                            // Tab index when user select it, it start from zero
                                          },
                                          tabs: [
                                            Tab(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 0),
                                                child: Text(
                                                  "Home Team".tr(),
                                                  style:
                                                      AppStyle.text2.copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: _selectedIndex == 0
                                                        ? AppColors
                                                            .sonalysisMediumPurple
                                                        : AppColors.sonaGrey2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Tab(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 10),
                                                child: Text("Away Team".tr(),
                                                    style:
                                                        AppStyle.text2.copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: _selectedIndex == 1
                                                          ? AppColors
                                                              .sonalysisMediumPurple
                                                          : AppColors.sonaGrey2,
                                                    )),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      // Padding(
                                      //   padding: EdgeInsets.symmetric(
                                      //       horizontal: 0.w),
                                      //   child: TextField(
                                      //     controller: searchController,
                                      //     onChanged: (value) {
                                      //       searchNow(value);
                                      //     },
                                      //     style: AppStyle.text2,
                                      //     decoration: InputDecoration(
                                      //       fillColor: AppColors.sonaGrey6,
                                      //       isDense: true,
                                      //       filled: true,
                                      //       prefixIcon: Icon(
                                      //         Boxicons.bx_search,
                                      //         color: AppColors.sonaGrey3,
                                      //         size: 30,
                                      //       ),
                                      //       enabledBorder: OutlineInputBorder(
                                      //           borderRadius:
                                      //               BorderRadius.circular(
                                      //                   AppConstants
                                      //                       .normalRadius),
                                      //           borderSide: BorderSide(
                                      //               color:
                                      //                   AppColors.sonaGrey6)),
                                      //       contentPadding:
                                      //           EdgeInsets.symmetric(
                                      //               vertical: 15.h,
                                      //               horizontal: 12.w),
                                      //       border: InputBorder.none,
                                      //       hintText: "Search here",
                                      //       hintStyle: AppStyle.text2,
                                      //     ),
                                      //   ),
                                      // ),
                                      // SizedBox(
                                      //   height: 20.h,
                                      // ),
                                      Container(
                                          height: 400.h,
                                          child: TabBarView(
                                            controller: tabController,
                                            children: [
                                              SingleChildScrollView(
                                                child: Column(
                                                  children: [homeTeam]
                                                      .map((e) =>
                                                          TeamRowItemGlobal(
                                                            player: e,
                                                            onTap: () {
                                                              print("tapped");
                                                              widget
                                                                  .onMatchSelected(
                                                                      e);
                                                              serviceLocator
                                                                  .get<
                                                                      NavigationService>()
                                                                  .pop();
                                                            },
                                                          ))
                                                      .toList(),
                                                ),
                                              ),
                                              SingleChildScrollView(
                                                child: Column(
                                                  children: [awayTeam]
                                                      .map((e) =>
                                                          TeamRowItemGlobal(
                                                            player: e,
                                                            onTap: () {
                                                              print("tapped");
                                                              widget
                                                                  .onMatchSelected(
                                                                      e);
                                                              serviceLocator
                                                                  .get<
                                                                      NavigationService>()
                                                                  .pop();
                                                            },
                                                          ))
                                                      .toList(),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ],
                                  )
                                : Container(
                                    child: Text("No teams found".tr()),
                                  ),
                          ),
                    const SizedBox(height: 40),
                  ],
                ))),
      ),
    ));
  }
}
