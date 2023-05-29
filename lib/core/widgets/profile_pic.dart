import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/helpers.dart';
import 'package:sonalysis/core/utils/images.dart';


class ProfilePic extends StatefulWidget {
  final bool isEditable;
  const ProfilePic({Key? key, this.isEditable = true}) : super(key: key);

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {

  XFile? capturedPhoto, xFileForCropper;
  File? _croppedFile;
  final ImagePicker _imagePicker = ImagePicker();
  bool _imagePicked = false, isSubmittingProfilePicture = false;
  UserResultData? userResultData;


  @override
  void initState() {
    super.initState();
    //_getData();
  }

  // Future<void> _getData() async {
  //   await sharedPreferencesClass.getUserModel().then((value) async {
  //     setState(() {
  //       userLoginResultModel = value;
  //     });
  //   });
  // }




  handleTakePhoto() async {
    XFile? _imagePickerResult = await _imagePicker.pickImage(
        source: ImageSource.gallery,//ImageSource.camera,
        maxHeight: 675,
        maxWidth: 960,
        preferredCameraDevice: CameraDevice.front);
    if (_imagePickerResult != null) {
      setState(() {
        capturedPhoto = _imagePickerResult;
      });
      cropImage(capturedPhoto);
    }
  }

  cropImage(XFile? documentImages) async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: documentImages!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop selected image',
            toolbarColor: AppColors.sonaPurple1.withOpacity(0.7),
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: AppColors.sonaLightBlack,
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
        //handleSubmitProfilePicture();
    }
  }

  // handleSubmitProfilePicture() async {
  //   setState(() {
  //     isSubmittingProfilePicture = true;
  //   });
  //   String profilePictureURl = await uploadToAWS(context, "sonalysisMobileApp", "profilePicture_"+userLoginResultModel.data.user.role, _croppedFile);
  //   if (profilePictureURl != null) {
  //     UserLoginResultModel userLoginResultModel2 = await UsersController().doProfilePictureUpload(context, profilePictureURl, userLoginResultModel.data.user.sId);
  //
  //
  //       if (userLoginResultModel2.status == "success") {
  //         setState(() {
  //           isSubmittingProfilePicture = false;
  //         });
  //         userLoginResultModel.data.user.role.toLowerCase() == "owner"
  //             ? Navigator.of(context).pushNamedAndRemoveUntil(routeClubDashboardScreen, (Route<dynamic> route) => false)
  //             : userLoginResultModel.data.user.role.toLowerCase() == "coach"
  //             ? Navigator.of(context).pushNamedAndRemoveUntil(routeCoachDashboardScreen, (Route<dynamic> route) => false)
  //             : Navigator.of(context).pushNamedAndRemoveUntil(routePlayerDashboardScreen, (Route<dynamic> route) => false);
  //         //store user details
  //         //sharedPreferencesClass.setUser(json.encode(userLoginResultModel2));
  //       }
  //       else {
  //         setState(() {
  //           isSubmittingProfilePicture = false;
  //         });
  //         showSnackError(context, userLoginResultModel2.message);
  //       }
  //
  //
  //   }
  //   }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 100,
            child: ClipOval(
              child: SizedBox(
                  width: 300.0,
                  height: 300.0,
                  child: _croppedFile != null
                      ? Stack(
                    children: [
                      Image.file(_croppedFile!, fit: BoxFit.cover),
                      isSubmittingProfilePicture ? Center(
                        child: Stack(
                          children: [
                            Container(
                              height: 30.0,
                              width: 30.0,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50.0),
                                    topRight: Radius.circular(50.0),
                                    bottomLeft: Radius.circular(50.0),
                                    bottomRight: Radius.circular(50.0),
                                  )),
                            ),
                            Container(
                              height: 30.0,
                              width: 30.0,
                              padding: const EdgeInsets.all(5),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.sonaPurple1),
                              ),
                              // Image.asset(
                              //   imagesDir+"/loader.gif",
                              //   height: 50.0,
                              //   width: 50.0,
                              // ),
                            )
                          ],
                        ),
                      ) : const SizedBox.shrink()
                    ],
                  )
                      : userResultData != null && userResultData!.user!.photo != ""
                      ? Image.network(
                    userResultData!.user!.photo!,
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.noRepeat,
                  )
                      : Image.asset(AppAssets.profileImage)
              ),
            )
          ),
          widget.isEditable
          ? Positioned(
            right: 0,
            bottom: 5,
            child: SizedBox(
              width: 30,
              height: 30,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                  primary: Colors.white,
                  backgroundColor: AppColors.sonaPurple1,
                ),
                onPressed: () {
                  handleTakePhoto();
                },
                child: const Icon(
                  Icons.edit,
                  size: 16,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),
          )
          : Container()
        ],
      ),
    );
  }
}
