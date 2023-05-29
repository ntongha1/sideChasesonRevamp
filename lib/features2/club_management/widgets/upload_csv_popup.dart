import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path/path.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/enums/button.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/widgets/button.dart';
import 'package:sonalysis/features/common/cubit/common_cubit.dart';
import 'package:sonalysis/features/common/models/UploadVideoResponseModel.dart';
import 'package:sonalysis/helpers/helpers.dart';
import 'package:sonalysis/style/styles.dart';

import '../../../core/utils/colors.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';

class UploadCSVPopUpScreen extends StatefulWidget {
  String? teamId, userType;

  UploadCSVPopUpScreen({Key? key, this.teamId, this.userType}) : super(key: key);

  @override
  _UploadCSVPopUpScreenState createState() => _UploadCSVPopUpScreenState();
}

class _UploadCSVPopUpScreenState extends State<UploadCSVPopUpScreen> {
  bool canSubmit = false, isSubmitting = false;
  List<File>? selectedFiles;
  FilePickerResult? filePickerResult;
  bool _filePicked = false;
//
  UserResultData? userResultData;
  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();
  UploadVideoResponseModel? uploadVideoResponseModel;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    userResultData = await serviceLocator.get<LocalStorage>().readSecureObject(LocalStorageKeys.kUserPrefs);
  }

  handlePickFile() async {
    filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (filePickerResult != null) {
        _filePicked = true;
        canSubmit = true;
        selectedFiles = filePickerResult!.paths.map((path) => File(path!)).toList();
      setState(() {});
    } else {
      // User canceled the picker
    }
  }

  handleClearPickedFile(BuildContext context) {
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
              "You are about to clear a selected file. This cannot be undone.",
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
                            selectedFiles = null;
                            _filePicked = false;
                            canSubmit = false;
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


  Future<void> _processFileUpload() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      isSubmitting = true;
      canSubmit = false;
    });
    //File(filePickerResult!.files[0].path!)
    await serviceLocator<CommonCubit>().csvUpload(selectedFiles![0], userResultData!.user!.clubs![0].id, widget.userType);
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.normalRadius)),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: 500,
        child: Form(
            key: _formKey,
            onChanged: () {
              setState(() {
                canSubmit = _formKey.currentState!.validate();
              });
            },
            child: ListView(
                children: [
                  const SizedBox(height: 10),
                  InkWell(
                      onTap: () {
                        serviceLocator.get<NavigationService>().pop();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Boxicons.bx_x_circle,
                          color: AppColors.sonaBlack2,
                          size: 30,
                        ),
                      )),
                  const SizedBox(height: 10),
                  Text(
                    "upload_csv".tr(),
                    textAlign: TextAlign.center,
                    style:  AppStyle.text3.copyWith(fontSize: 18.sp, color: AppColors.sonaBlack2),
                  ),
                  const SizedBox(height: 20),
                  Text(
                      "upload_csv_exp".tr(),
                      textAlign: TextAlign.center,
                      style: AppStyle.text1),
                  SizedBox(height: 10.h),
                  _filePicked
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 35),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                      width: isSubmitting ? 150 : 250,
                                      height: 100,
                                      color: sonaLighterBlack,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(basename(selectedFiles![0].path), style: TextStyle(color: Colors.white)),
                                          const SizedBox(width: 5),
                                          isSubmitting
                                              ? const SizedBox.shrink()
                                              : const SizedBox(width: 10),
                                          isSubmitting
                                              ? const SizedBox.shrink()
                                              : InkWell(
                                                  onTap: () {
                                                    handlePickFile();
                                                  },
                                                  child: const FaIcon(
                                                    FontAwesomeIcons.pencilAlt,
                                                    color: Colors.white,
                                                    size: 20,
                                                  )),
                                          isSubmitting
                                              ? const SizedBox.shrink()
                                              : const SizedBox(width: 20),
                                          isSubmitting
                                              ? const SizedBox.shrink()
                                              : InkWell(
                                                  onTap: () {
                                                    handleClearPickedFile(context);
                                                  },
                                                  child: const FaIcon(
                                                    FontAwesomeIcons.trashAlt,
                                                    color: Colors.white,
                                                    size: 20,
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
                            handlePickFile();
                          },
                          child: Image.asset(
                            AppAssets.uploadVideoFromDevice,
                            fit: BoxFit.contain,
                            repeat: ImageRepeat.noRepeat,
                          ),
                        ),
                  SizedBox(height: 30),
                  Text(
                    "upload_csv_exp2".tr(),
                    textAlign: TextAlign.left,
                    style: AppStyle.text1,
                  ),
                  SizedBox(height: 30),
                  AppButton(
                      buttonText:
                      isSubmitting ? "submitting".tr() : "submit".tr(),
                      onPressed: canSubmit
                          ? () {
                        _formKey.currentState!.save();
                        if (canSubmit) {
                          _processFileUpload();
                        }
                      }
                          : null),
                  BlocConsumer(
                    bloc: serviceLocator.get<CommonCubit>(),
                    listener: (_, state) {
                      if (state is CSVUploadLoading) {
                        context.loaderOverlay.show();
                      }

                      if (state is CSVUploadError) {
                        context.loaderOverlay.hide();
                        setState(() {
                          isSubmitting = false;
                          canSubmit = true;
                        });
                        ResponseMessage.showErrorSnack(context: context, message: state.message);
                      }

                      if (state is CSVUploadSuccess) {
                        context.loaderOverlay.hide();
                        uploadVideoResponseModel = serviceLocator.get<UploadVideoResponseModel>();

                        if (uploadVideoResponseModel!.status!.toLowerCase() == "created") {
                          Navigator.of(context).pop(true);
                          ResponseMessage.showSuccessSnack(context: context, message: state.message);
                          // setState(() {
                          //   setState(() {
                          //     isSubmitting = false;
                          //     canSubmit = false;
                          //     _videoLinkController.clear();
                          //   });
                          //
                          // });
                        } else {
                          ResponseMessage.showErrorSnack(context: context, message: "video_upload_failed".tr());
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
                    onPressed: () => serviceLocator.get<NavigationService>().pop(),
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
