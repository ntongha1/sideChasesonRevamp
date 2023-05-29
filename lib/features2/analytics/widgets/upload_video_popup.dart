import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as fileUtil;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:simple_s3/simple_s3.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/enums/button.dart';
import 'package:sonalysis/core/models/League.dart';
import 'package:sonalysis/core/models/Season.dart';
import 'package:sonalysis/core/models/response/TeamsListResponseModel.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/models/teams.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/network/keys.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/utils/styles.dart';
import 'package:sonalysis/core/utils/validator.dart';
import 'package:sonalysis/core/widgets/GradientProgressBar.dart';
import 'package:sonalysis/core/widgets/app_dropdown_modal.dart';
import 'package:sonalysis/core/widgets/app_textfield.dart';
import 'package:sonalysis/core/widgets/button.dart';
import 'package:sonalysis/features/common/cubit/common_cubit.dart';
import 'package:sonalysis/features/common/models/UploadVideoResponseModel.dart';
import 'package:sonalysis/helpers/helpers.dart';
import 'package:sonalysis/services/network_service.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:sonalysis/validators/registration_validation.dart';

import '../../../core/navigation/keys.dart';
import '../../../core/utils/constants.dart';

class UploadVideoPopUpScreen extends StatefulWidget {
  final Function onClose;
  List<Leagues> leagues = [];
  UploadVideoPopUpScreen(
      {Key? key, required this.onClose, required this.leagues})
      : super(key: key);

  @override
  _UploadVideoPopUpScreenState createState() => _UploadVideoPopUpScreenState();
}

class _UploadVideoPopUpScreenState extends State<UploadVideoPopUpScreen> {
  final TextEditingController _videoLinkController = TextEditingController();
  final TextEditingController _leagueController = TextEditingController();
  final TextEditingController _seasonController = TextEditingController();
  String? _homeTeam, _awayTeam;
  bool canSubmit = false, isSubmitting = false, wasFormSubmitted = false;
  XFile? selectedVideo, xFileForCropper;
  final ImagePicker _imagePicker = ImagePicker();
  bool _videoPicked = false;
  final SimpleS3 _simpleS3 = SimpleS3();

  Leagues selectedLeague = Leagues(name: "Euro Championship", id: 4);
  Season selectedSeason = Season(name: "2022");

  List<Leagues> leagues = [];
  List<Season> seasons = [];

  List<TeamsDropdown> leagsRaw = [
    TeamsDropdown(name: "1", id: "1"),
    TeamsDropdown(name: "2", id: "2"),
    TeamsDropdown(name: "3", id: "3"),
    TeamsDropdown(name: "4", id: "4"),
    TeamsDropdown(name: "5", id: "5"),
  ];

  List<TeamsDropdown> seasonsRaw = [
    TeamsDropdown(name: "1", id: "1"),
    TeamsDropdown(name: "2", id: "2"),
    TeamsDropdown(name: "3", id: "3"),
    TeamsDropdown(name: "4", id: "4"),
    TeamsDropdown(name: "5", id: "5"),
  ];

//
  UserResultData? userResultData;
  bool isLoading = true;
  TeamsListResponseModel? teamsListResponseModel;
  late List<String?> teamList;
  final _formKey = GlobalKey<FormState>();
  UploadVideoResponseModel? uploadVideoResponseModel;
  int percentageDone = 0;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
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
  }

  handlePickVideo() async {
    XFile? _imagePickerResult = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 7200));
    if (_imagePickerResult != null) {
      setState(() {
        selectedVideo = _imagePickerResult;
        _videoPicked = true;
        canSubmit = true;
        _videoLinkController.clear();
      });
    }
  }

  handleClearPickedVideo() {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Sure to proceed?",
            textAlign: TextAlign.center,
          ),
          content: Text(
              "You are about to clear a selected video. This cannot be undone.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0.sp,
                height: 1.57,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
              )),
          actions: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.33,
              alignment: Alignment.center,
              child: ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width * 0.32,
                  child: OutlinedButton(
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(5.0),
                    // ),
                    child: Text(
                      "No",
                      style: TextStyle(
                        color: sonaBlack,
                        fontSize: 18.0.sp,
                        height: 1.57,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                    //color: Colors.white,
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.33,
              alignment: Alignment.center,
              child: ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width * 0.32,
                  child: OutlinedButton(
                      // color: sonaPurple1,
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(5.0),
                      // ),
                      onPressed: () {},
                      child: InkWell(
                        child: Text(
                          "Yes",
                          style: TextStyle(
                            color: sonaPurple1,
                            fontSize: 18.0.sp,
                            height: 1.57,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            selectedVideo = null;
                            _videoPicked = false;
                            canSubmit = false;
                            _videoLinkController.clear();
                          });
                          Navigator.of(context).pop();
                        },
                      ))),
            ),
          ],
        );
      },
    );
  }

  Future<String> _uploadVideo(BuildContext context, String folder,
      String documentType, File fileToUpload) async {
    var result;

    //  context,
    // "sonalysisMobileApp",
    // "videosToBeAnalysed",
    // File(selectedVideo!.path)

    String awsRegion = AWSRegions.usEast1.region;
    String poolId = awsRegion + ":eefe909d-3fdf-43ab-b100-5f304bbf6837";
    String awsFolderPath = folder + "/" + documentType;
    String bucketName = "sonalysis-asset";
    String awsPath =
        "https://" + bucketName + ".s3." + awsRegion + ".amazonaws.com/";
    String videourl = "";

    try {
      setState(() {
        isSubmitting = true;
        canSubmit = false;
      });
      String url = ApiConstants.baseUrl + "users/upload-video";
      Map<String, String> payload = {};

      result = await callAPIFileDio(
          url: url,
          requestType: RequestType.POST,
          payload: payload,
          file: fileToUpload,
          field: 'video',
          onUploadProgress: (int total) {
            setState(() {
              percentageDone = total;
            });
          });

      setState(() {
        isSubmitting = false;
        canSubmit = true;
      });
      videourl = result.data['data']['uploadUrl'];
      debugPrint("Result:::::" + videourl);
    } on PlatformException {
      setState(() {
        isSubmitting = false;
        canSubmit = true;
      });
      // showSnackError(context, resul!);
      debugPrint("Result :'$result'.");
    }

    _processVideoUpload(videourl, fileToUpload: fileToUpload);
    return videourl;
  }

  // Future<String> _uploadVideo(BuildContext context, String folder,
  //     String documentType, File fileToUpload) async {
  //   String result;

  //   //  context,
  //   // "sonalysisMobileApp",
  //   // "videosToBeAnalysed",
  //   // File(selectedVideo!.path)

  //   String awsRegion = AWSRegions.usEast1.region;
  //   String poolId = awsRegion + ":eefe909d-3fdf-43ab-b100-5f304bbf6837";
  //   String awsFolderPath = folder + "/" + documentType;
  //   String bucketName = "sonalysis-asset";
  //   String awsPath =
  //       "https://" + bucketName + ".s3." + awsRegion + ".amazonaws.com/";

  //   try {
  //     setState(() {
  //       isSubmitting = true;
  //       canSubmit = false;
  //     });

  //     result = await _simpleS3.uploadFile(
  //         fileToUpload, bucketName, poolId, AWSRegions.usEast1,
  //         debugLog: false,
  //         s3FolderPath: awsFolderPath,
  //         fileName: fileToUpload.path.split('/').last,
  //         accessControl: S3AccessControl.publicRead,
  //         useTimeStamp: true,
  //         timeStampLocation: TimestampLocation.suffix);

  //     setState(() {
  //       isSubmitting = false;
  //       canSubmit = true;
  //     });
  //     debugPrint("Result:::::" +
  //         awsPath +
  //         awsFolderPath +
  //         "/" +
  //         fileToUpload.path.split('/').last);
  //   } on PlatformException {
  //     setState(() {
  //       isSubmitting = false;
  //       canSubmit = true;
  //     });
  //     // showSnackError(context, resul!);
  //     // debugPrint("Result :'$result'.");
  //   }

  //   print("Console::: server path " +
  //       awsPath +
  //       awsFolderPath +
  //       "/" +
  //       fileToUpload.path.split('/').last);
  //   // return awsPath + awsFolderPath + "/" + result;
  //   // print("Console::: server path " + result);
  //   //do video upload
  //   //_processVideoUpload(result, fileToUpload);
  //   _processVideoUpload(
  //       awsPath + awsFolderPath + "/" + fileToUpload.path.split('/').last,
  //       fileToUpload: fileToUpload);
  //   //return result;
  //   return awsPath + awsFolderPath + "/" + fileToUpload.path.split('/').last;
  // }

  Future<void> _processVideoUpload(String videoURL,
      {File? fileToUpload}) async {
    setState(() {
      isSubmitting = true;
      canSubmit = false;
    });
    print("I tried to save this video $videoURL ");
    await serviceLocator<CommonCubit>().videoUpload(
        videoURL,
        _videoLinkController.text.trim(),
        fileToUpload,
        userResultData!.user!.clubs![0].id,
        selectedLeague.id,
        _seasonController.text);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.normalRadius)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: AppColors.sonaWhite,
      content: Container(
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(AppConstants.normalRadius))),
        width: MediaQuery.of(context).size.width,
        constraints: new BoxConstraints(maxHeight: 580),
        child: Form(
            key: _formKey,
            onChanged: () {
              setState(() {
                print('canSubmit ' +
                    _formKey.currentState!.validate().toString());
                canSubmit = _formKey.currentState!.validate();
              });
            },
            child: ListView(children: [
              InkWell(
                  onTap: () {
                    widget.onClose(true);
                    serviceLocator.get<NavigationService>().pop();
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Boxicons.bx_x_circle,
                      color: AppColors.sonaBlack2,
                      size: 20,
                    ),
                  )),
              const SizedBox(height: 10),
              Text(
                "upload_video".tr(),
                textAlign: TextAlign.center,
                style: AppStyle.text3.copyWith(
                    fontSize: 20.sp,
                    color: AppColors.sonaBlack2,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 20),
              Text("upload_video_exp".tr(),
                  textAlign: TextAlign.center,
                  style: AppStyle.text1.copyWith(
                      fontWeight: FontWeight.w400, color: AppColors.sonaGrey2)),
              SizedBox(height: 30.h),
              !isSubmitting
                  ? Column(
                      children: [
                        _videoPicked
                            ? Stack(
                                children: [
                                  Image.asset(
                                    AppAssets.uploadVideoFromDevice,
                                    fit: BoxFit.contain,
                                    repeat: ImageRepeat.noRepeat,
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 20),
                                          StreamBuilder<dynamic>(
                                              stream:
                                                  _simpleS3.getUploadPercentage,
                                              builder: (context, snapshot) {
                                                return CircularPercentIndicator(
                                                  radius: 40.0,
                                                  lineWidth: 8.0,
                                                  percent: snapshot.data != null
                                                      ? snapshot.data
                                                              .toDouble() /
                                                          100
                                                      : 0 / 100,
                                                  center: Text(
                                                      snapshot.data != null
                                                          ? snapshot.data
                                                                  .toString() +
                                                              "%"
                                                          : isSubmitting
                                                              ? "Loading"
                                                              : "Ready",
                                                      style: const TextStyle(
                                                          color: Colors.white)),
                                                  progressColor:
                                                      snapshot.data != 100
                                                          ? sonaPurple1
                                                          : getColorHexFromStr(
                                                              "00BB4C"),
                                                );
                                              }),
                                          const SizedBox(height: 10),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            width: isSubmitting ? 150 : 175,
                                            color: sonaLighterBlack,
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  AppAssets.tinyFolder,
                                                  fit: BoxFit.cover,
                                                  repeat: ImageRepeat.noRepeat,
                                                  width: 20,
                                                ),
                                                const SizedBox(width: 5),
                                                SizedBox(
                                                  width: 80,
                                                  child: Text(
                                                      selectedVideo!.path
                                                          .split('/')
                                                          .last
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color:
                                                              getColorHexFromStr(
                                                                  "C4C4C4"),
                                                          fontSize: 13.sp)),
                                                ),
                                                isSubmitting
                                                    ? const SizedBox.shrink()
                                                    : const SizedBox(width: 10),
                                                isSubmitting
                                                    ? const SizedBox.shrink()
                                                    : InkWell(
                                                        onTap: () {
                                                          handlePickVideo();
                                                        },
                                                        child: const FaIcon(
                                                          FontAwesomeIcons
                                                              .pencilAlt,
                                                          color: Colors.white,
                                                          size: 13,
                                                        )),
                                                isSubmitting
                                                    ? const SizedBox.shrink()
                                                    : const SizedBox(width: 20),
                                                isSubmitting
                                                    ? const SizedBox.shrink()
                                                    : InkWell(
                                                        onTap: () {
                                                          handleClearPickedVideo();
                                                        },
                                                        child: const FaIcon(
                                                          FontAwesomeIcons
                                                              .trashAlt,
                                                          color: Colors.white,
                                                          size: 13,
                                                        ))
                                              ],
                                            ),
                                          )
                                        ],
                                      ))
                                ],
                              )
                            : InkWell(
                                onTap: () {
                                  handlePickVideo();
                                },
                                child: Image.asset(
                                  AppAssets.uploadVideoFromDevice,
                                  fit: BoxFit.contain,
                                  repeat: ImageRepeat.noRepeat,
                                ),
                              ),
                        SizedBox(height: 20.h),
                        Row(children: <Widget>[
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 15.0),
                                child: Divider(
                                  color: AppColors.sonaGrey3,
                                  height: 50,
                                )),
                          ),
                          Text("OR".tr(),
                              style: AppStyle.text2.copyWith(
                                  color: AppColors.sonaGrey2,
                                  fontWeight: FontWeight.w400)),
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: 15.0, right: 10.0),
                                child: Divider(
                                  color: AppColors.sonaGrey3,
                                  height: 50,
                                )),
                          ),
                        ]),
                        SizedBox(height: 20.h),
                        AppTextField(
                          headerText: "paste_link".tr(),
                          hintText: _videoPicked
                              ? "clear_selected_upload".tr()
                              : "insert_google_doc_link".tr(),
                          //hintText: "https://y.tube/drfv688hn",
                          validator:
                              _videoPicked ? null : Validator.validateLink,
                          readOnly: _videoPicked,
                          onChanged: (v) {
                            setState(() {});
                            // validateButton();
                          },
                          textInputType: TextInputType.url,
                          textInputFormatters: [
                            LengthLimitingTextInputFormatter(100),
                          ],
                          onSaved: (val) => _videoLinkController.text = val!,
                        ),
                        Row(children: <Widget>[
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 15.0),
                                child: Divider(
                                  color: AppColors.sonaGrey3,
                                  height: 50,
                                )),
                          ),
                          Text("AND".tr(),
                              style: AppStyle.text2.copyWith(
                                  color: AppColors.sonaGrey2,
                                  fontWeight: FontWeight.w400)),
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: 15.0, right: 10.0),
                                child: Divider(
                                  color: AppColors.sonaGrey3,
                                  height: 50,
                                )),
                          ),
                        ]),
                        SizedBox(height: 20.h),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.38,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppDropdownModal(
                                        options: leagues,
                                        value: selectedLeague == null
                                            ? ""
                                            : selectedLeague.name,
                                        hasSearch: true,
                                        onChanged: (val) {
                                          selectedLeague = val as Leagues;
                                          _leagueController.text =
                                              selectedLeague.name;
                                          setState(() {});
                                        },
                                        validator: Validator.requiredValidator,
                                        modalHeight:
                                            MediaQuery.of(context).size.height *
                                                0.7,
                                        // hint: 'Select an option',
                                        headerText: "",
                                        hintText: "Type here".tr(),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.38,
                                child: AppDropdownModal(
                                  options: seasons,
                                  value: selectedSeason == null
                                      ? ""
                                      : selectedSeason.name,
                                  hasSearch: true,
                                  onChanged: (val) {
                                    selectedSeason = val as Season;
                                    _seasonController.text =
                                        selectedSeason.name;
                                    setState(() {});
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
                        ),
                        if (_leagueController.text == '' ||
                            _seasonController.text == '')
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _leagueController.text == ''
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.38,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10.h),
                                            Text(
                                              "League is required".tr(),
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.sonaRed,
                                                height: 1.33,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                _seasonController.text == ''
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.38,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10.h),
                                            Text(
                                              "Season is required".tr(),
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.sonaRed,
                                                height: 1.33,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        SizedBox(
                          height: 20.h,
                        ),
                        // SizedBox(
                        //   width: MediaQuery.of(context).size.width,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       SizedBox(
                        //         width: 140,
                        //         child: CustomDropdownOutline(
                        //             isLoading: isLoading,
                        //             locked: isLoading,
                        //             items:  isLoading ? [] : teamList,
                        //             labelText: "Home Team",
                        //             error: '',
                        //             hint: 'Choose',
                        //             selected: _homeTeam,
                        //             textStyle: TextStyle(
                        //               color: getColorHexFromStr("C9D0CD"),
                        //               //fontFamily: generalFont,
                        //               fontSize: 13.0.sp,
                        //               fontWeight: FontWeight.w400,
                        //             ),
                        //             onChange: (selected) {
                        //               setState(() {
                        //                 _homeTeam = selected;
                        //               });
                        //             }),
                        //       ),
                        //       SizedBox(
                        //           width: 140,
                        //           child: CustomDropdownOutline(
                        //               isLoading: isLoading,
                        //               locked: isLoading,
                        //               items: isLoading ? [] : teamList,
                        //               labelText: "Away Team",
                        //               error: '',
                        //               hint: 'Choose',
                        //               selected: _awayTeam,
                        //               textStyle: TextStyle(
                        //                 color: getColorHexFromStr("C9D0CD"),
                        //                 //fontFamily: generalFont,
                        //                 fontSize: 13.0.sp,
                        //                 fontWeight: FontWeight.w400,
                        //               ),
                        //               onChange: (selected) {
                        //                 setState(() {
                        //                   _awayTeam = selected;
                        //                 });
                        //               })),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(height: 40.h),

                        AppButton(
                            buttonText: isSubmitting
                                ? "submitting".tr()
                                : "submit".tr(),
                            onPressed: (canSubmit)
                                ? () {
                                    _formKey.currentState!.save();
                                    if (canSubmit) {
                                      if (selectedVideo != null) {
                                        print(_seasonController.text);
                                        _uploadVideo(
                                            context,
                                            "sonalysisMobileApp",
                                            "videosToBeAnalysed",
                                            File(selectedVideo!.path));
                                      } else {
                                        _processVideoUpload(
                                            _videoLinkController.text);
                                      }
                                    } else {
                                      setState(() {
                                        wasFormSubmitted = true;
                                      });
                                    }
                                  }
                                : null),
                      ],
                    )
                  : Column(
                      children: [
                        SizedBox(height: 20.h),
                        Row(
                          // justifyContent: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Video uploading",
                                style: AppStyle.text1.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.sonaGrey3,
                                )),
                            Text("$percentageDone%",
                                style: AppStyle.text1.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.sonaBlack1,
                                ))
                          ],
                        ),
                        SizedBox(height: 10.h),
                        GradientProgressBar(
                          percent: percentageDone,
                          gradient: AppColors.sonalysisGradient,
                          backgroundColor: AppColors.sonaGrey6,
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/svgs/video_iconn.svg',
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              "some name here",
                              style: AppStyle.text2.copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppColors.sonaBlack1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40.h),
                        AppButton(
                          buttonType: ButtonType.secondary,
                          buttonText: "Cancel Upload".tr(),
                          onPressed: () {
                            widget.onClose(true);
                          },
                        )
                      ],
                    ),
              // Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     SizedBox(
              //       width: MediaQuery.of(context).size.width * 0.38,
              //       child: AppButton(
              //           buttonText:
              //               isSubmitting ? "submitting".tr() : "submit".tr(),
              //           onPressed: canSubmit
              //               ? () {
              //                   _formKey.currentState!.save();
              //                   if (canSubmit) {
              //                     if (selectedVideo != null) {
              //                       _uploadVideo(
              //                           context,
              //                           "sonalysisMobileApp",
              //                           "videosToBeAnalysed",
              //                           File(selectedVideo!.path));
              //                     } else {
              //                       _processVideoUpload(
              //                           _videoLinkController.text);
              //                     }
              //                   }
              //                 }
              //               : null),
              //     ),
              //     SizedBox(
              //         width: MediaQuery.of(context).size.width * 0.4,
              //         child: AppButton(
              //             buttonText: "cancel".tr(),
              //             buttonType: ButtonType.tertiary,
              //             onPressed: () {
              //               if (isSubmitting) {
              //                 _onCancelPressed(context, "Upload in progress...",
              //                     "Sure to exit upload?");
              //               } else {
              //                 serviceLocator.get<NavigationService>().pop();
              //               }
              //             })),
              //   ],
              // ),
              BlocConsumer(
                bloc: serviceLocator.get<CommonCubit>(),
                listener: (_, state) {
                  if (state is VideoUploadLoading) {
                    context.loaderOverlay.show();
                  }

                  if (state is VideoUploadError) {
                    context.loaderOverlay.hide();
                    setState(() {
                      isSubmitting = false;
                      canSubmit = true;
                    });
                    ResponseMessage.showErrorSnack(
                        context: context, message: state.message);
                  }

                  if (state is VideoUploadSuccess) {
                    context.loaderOverlay.hide();
                    uploadVideoResponseModel =
                        serviceLocator.get<UploadVideoResponseModel>();

                    if (uploadVideoResponseModel!.status!.toLowerCase() ==
                        "created") {
                      //show dialog page
                      Navigator.of(context).pop(true);
                      // serviceLocator.get<NavigationService>().toWithPameter(
                      //     routeName: RouteKeys.routePopUpPageScreen,
                      //     data: {
                      //       "title": "Success".tr(),
                      //       "subTitle": "Video uploaded successfully!".tr(),
                      //       "route": "pop",
                      //       "routeType": "pop",
                      //       "buttonText": "Proceed".tr()
                      //     });
                      // setState(() {
                      //   setState(() {
                      //     isSubmitting = false;
                      //     canSubmit = false;
                      //     _videoLinkController.clear();
                      //   });
                      // });
                    } else {
                      ResponseMessage.showErrorSnack(
                          context: context,
                          message: "video_upload_success".tr());
                    }
                  }
                },
                builder: (_, state) {
                  return const SizedBox();
                },
              ),
            ])),
      ),
    );
  }

  _onCancelPressed(BuildContext context, String title, String subTitle) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          content: Text(subTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0.sp,
                height: 1.57,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
              )),
          actions: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.33,
              alignment: Alignment.center,
              child: ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width * 0.32,
                  child: OutlinedButton(
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(5.0),
                    // ),
                    child: Text(
                      "No",
                      style: TextStyle(
                        color: sonaBlack,
                        fontSize: 18.0.sp,
                        height: 1.57,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onPressed: () =>
                        serviceLocator.get<NavigationService>().pop(),
                    //color: Colors.white,
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.33,
              alignment: Alignment.center,
              child: ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width * 0.32,
                  child: OutlinedButton(
                      //color: sonaPurple1,
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(5.0),
                      // ),
                      onPressed: () {},
                      child: InkWell(
                        child: Text(
                          "Yes",
                          style: TextStyle(
                            color: sonaPurple1,
                            fontSize: 18.0.sp,
                            height: 1.57,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        onTap: () {
                          serviceLocator.get<NavigationService>().pop();
                          serviceLocator.get<NavigationService>().pop();
                        },
                      ))),
            ),
          ],
        );
      },
    );
  }
}
