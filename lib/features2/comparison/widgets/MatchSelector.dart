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
import 'package:sonalysis/core/models/League.dart';
import 'package:sonalysis/core/models/Season.dart';
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
import 'package:sonalysis/style/styles.dart';

import '../../../../../../core/datasource/local_storage.dart';
import '../../../../../core/enums/user_type.dart';
import '../../../../../core/utils/styles.dart';

class MatchSelectorScreen extends StatefulWidget {
  String? teamId;
  List<Leagues> leagues;
  Function onMatchSelected;

  MatchSelectorScreen(
      {Key? key,
      this.teamId,
      required this.onMatchSelected,
      required this.leagues})
      : super(key: key);

  @override
  _MatchSelectorScreenState createState() => _MatchSelectorScreenState();
}

class _MatchSelectorScreenState extends State<MatchSelectorScreen> {
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
  List<dynamic> matches = [];
  List<dynamic> smatches = [];

  final TextEditingController _oFirstNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController _oLastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _jerseyNumberController = TextEditingController();
  String? oldPhoto = null;
  Leagues selectedLeague = Leagues(name: "Euro Championship", id: 4);
  Season selectedSeason = Season(name: "2022");

  final List<Positions>? position = [
    Positions(name: "Forward"),
    Positions(name: "Midfield"),
    Positions(name: "Defence"),
    Positions(name: "Keeper"),
  ];

  List<Leagues> leagues = [];
  List<Season> seasons = [];

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
    _getData();
    makeSeasons();
    leagues = widget.leagues;
  }

  void makeSeasons() {
    for (int i = 2023; i >= 2010; i--) {
      seasons.add(Season(name: i.toString()));
    }

    setState(() {});
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

    getMatches();

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
    getMatches();
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

    getMatches();
  }

  getMatches() async {
    setState(() {
      loadingMatches = true;
    });
    String url = ApiConstants.getFixturesbyDateSonaBackend;

    String year = selectedSeason.name.toString();
    String league = selectedLeague.id.toString();

    String? authToken = await serviceLocator
        .get<LocalStorage>()
        .readString(LocalStorageKeys.kTokenPrefs);

    url = url + "league=" + league + "&season=" + year;

    print('final url ' + url);

    Map<String, String> header = {};
    header = {
      'Content-Type': 'application/json',
      'accept': '*/*',
      'Authorization': "Bearer " + authToken.toString(),
    };

    Response? res = await _httpClient.get(Uri.parse(url), headers: header);
    print("response status code for matches" + res.statusCode.toString());
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      print('matches:' + data['data']['response'].toString());
      setState(() {
        matches = data['data']['response'];
        smatches = data['data']['response'];
        loadingMatches = false;
      });
      return data['data'];
    } else {
      setState(() {
        matches = [];
        smatches = [];
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
        matches = smatches;
      });
      return;
    }
    List temp = smatches.where((element) {
      String v1 = element["league"]["name"] == null
          ? ""
          : element["league"]["name"].toLowerCase();
      return v1.contains(value);
    }).toList();
    print("temp length ${temp.length}");
    setState(() {
      matches = temp;
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
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     GestureDetector(
                    //       onTap: () {
                    //         prevDatePlease();
                    //       },
                    //       child: Container(
                    //           child: Row(
                    //         children: [
                    //           SvgPicture.asset(
                    //             'assets/svgs/prev.svg',
                    //             width: 12,
                    //             height: 12,
                    //           ),
                    //           const SizedBox(width: 5),
                    //           Text(
                    //             "Previous".tr(),
                    //             style: AppStyle.text1.copyWith(
                    //               color: AppColors.sonaGrey3,
                    //               fontWeight: FontWeight.w400,
                    //             ),
                    //           ),
                    //         ],
                    //       )),
                    //     ),
                    //     Container(
                    //         width: MediaQuery.of(context).size.width * 0.5,
                    //         child: AppDateFieldGlobal(
                    //           controller: dateController,
                    //           onChanged: (value) {
                    //             print('date::' +
                    //                 DateFormat(_format).format(value));
                    //           },
                    //           hintText: dateToday,
                    //           validator: (value) {
                    //             if (value!.isEmpty) {
                    //               return "Date".tr();
                    //             }
                    //             return null;
                    //           },
                    //         )),
                    //     GestureDetector(
                    //       onTap: () {
                    //         nextDatePlease();
                    //       },
                    //       child: Container(
                    //           child: Row(
                    //         children: [
                    //           Text(
                    //             "Next".tr(),
                    //             style: AppStyle.text1.copyWith(
                    //               color: AppColors.sonaGrey3,
                    //               fontWeight: FontWeight.w400,
                    //             ),
                    //           ),
                    //           const SizedBox(width: 5),
                    //           SvgPicture.asset(
                    //             'assets/svgs/next.svg',
                    //             width: 12,
                    //             height: 12,
                    //           ),
                    //         ],
                    //       )),
                    //     ),
                    //   ],
                    // ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Container(
                        //   width: MediaQuery.of(context).size.width * 0.44,
                        //   margin: EdgeInsets.only(top: 10),
                        //   child: AppDateFieldGlobal(
                        //     controller: dateController,
                        //     onChanged: (value) {
                        //       print(
                        //           'date::' + DateFormat(_format).format(value));
                        //       setState(() {
                        //         dateToday = DateFormat(_format).format(value);
                        //       });
                        //       getMatches(DateFormat(_format).format(value));
                        //     },
                        //     hintText: dateToday,
                        //     validator: (value) {
                        //       if (value!.isEmpty) {
                        //         return "Date".tr();
                        //       }
                        //       return null;
                        //     },
                        //   ),
                        // ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.44,
                          child: AppDropdownModal(
                            options: seasons,
                            value: selectedSeason == null
                                ? ""
                                : selectedSeason.name,
                            hasSearch: true,
                            onChanged: (val) {
                              selectedSeason = val as Season;
                              setState(() {});

                              getMatches();
                            },
                            validator: Validator.requiredValidator,
                            modalHeight:
                                MediaQuery.of(context).size.height * 0.7,
                            // hint: 'Select an option',
                            headerText: "",
                            hintText: "Type here".tr(),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.44,
                          child: AppDropdownModal(
                            options: leagues,
                            value: selectedLeague == null
                                ? ""
                                : selectedLeague.name,
                            hasSearch: true,
                            onChanged: (val) {
                              selectedLeague = val as Leagues;
                              setState(() {});

                              getMatches();
                            },
                            validator: Validator.requiredValidator,
                            modalHeight:
                                MediaQuery.of(context).size.height * 0.7,
                            // hint: 'Select an option',
                            headerText: "",
                            hintText: "Type here".tr(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    loadingMatches
                        ? Container(
                            child: CircularProgressIndicator(
                            color: AppColors.sonaGreen,
                          ))
                        : Container(
                            child: matches.length > 0
                                ? Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0.w),
                                        child: TextField(
                                          controller: searchController,
                                          onChanged: (value) {
                                            print('temp length ' + value);
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppConstants
                                                            .normalRadius),
                                                borderSide: BorderSide(
                                                    color:
                                                        AppColors.sonaGrey6)),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 15.h,
                                                    horizontal: 12.w),
                                            border: InputBorder.none,
                                            hintText: "Search here",
                                            hintStyle: AppStyle.text2,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40.h,
                                      ),
                                      SingleChildScrollView(
                                          child: Column(
                                              children: matches
                                                  .map((e) => GestureDetector(
                                                        onTap: () {
                                                          widget
                                                              .onMatchSelected(
                                                                  e);
                                                          serviceLocator
                                                              .get<
                                                                  NavigationService>()
                                                              .pop();
                                                        },
                                                        child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        // convert timestamp to date
                                                                        e["fixture"]["date"]
                                                                            .split("T")[0],
                                                                        style: AppStyle.text0.copyWith(
                                                                            color:
                                                                                AppColors.sonaBlack2,
                                                                            fontWeight: FontWeight.w400),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            5.h,
                                                                      ),
                                                                      Text(
                                                                        e["league"]["name"].toString().length > 15
                                                                            ? e["league"]["name"].toString().substring(0, 15) +
                                                                                "..."
                                                                            : e["league"]["name"],
                                                                        style: AppStyle.text0.copyWith(
                                                                            color:
                                                                                AppColors.sonaGrey3,
                                                                            fontWeight: FontWeight.w400),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            // convert timestamp to date
                                                                            e["teams"]["home"]["name"].toString().length > 10
                                                                                ? e["teams"]["home"]["name"].toString().substring(0, 10) + "..."
                                                                                : e["teams"]["home"]["name"],

                                                                            style:
                                                                                AppStyle.text0.copyWith(color: AppColors.sonaBlack2, fontWeight: FontWeight.w400),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                2.h,
                                                                          ),
                                                                          Image.network(
                                                                              e["teams"]["home"]["logo"],
                                                                              width: 15,
                                                                              height: 15)
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10.h,
                                                                      ),
                                                                      Text(
                                                                        getGoals(
                                                                            e),
                                                                        style: AppStyle.text0.copyWith(
                                                                            color:
                                                                                AppColors.sonaBlack2,
                                                                            fontWeight: FontWeight.w400),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10.h,
                                                                      ),
                                                                      Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Image.network(
                                                                              e["teams"]["away"]["logo"],
                                                                              width: 15,
                                                                              height: 15),
                                                                          SizedBox(
                                                                            width:
                                                                                2.h,
                                                                          ),
                                                                          Text(
                                                                            // convert timestamp to date
                                                                            e["teams"]["away"]["name"].toString().length > 10
                                                                                ? e["teams"]["away"]["name"].toString().substring(0, 10) + "..."
                                                                                : e["teams"]["away"]["name"],

                                                                            style:
                                                                                AppStyle.text0.copyWith(color: AppColors.sonaBlack2, fontWeight: FontWeight.w400),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 20.h,
                                                              ),
                                                            ]),
                                                      ))
                                                  .toList()))
                                    ],
                                  )
                                : Container(
                                    child: Text("No matches found".tr()),
                                  ),
                          ),
                    const SizedBox(height: 40),
                  ],
                ))),
      ),
    ));
  }
}
