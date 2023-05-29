
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sonalysis/controller/dashboard_controller.dart';
import 'package:sonalysis/features/common/messages/misc/new_group_chat_all_list.dart';
import 'package:sonalysis/features/common/messages/singleton/GroupChatScreenSingleton.dart';
import 'package:sonalysis/helpers/auth/shared_preferences_class.dart';
import 'package:sonalysis/helpers/helpers.dart';
import 'package:sonalysis/lang/strings.dart';
import 'package:sonalysis/model/response/PlayersListResponseModel.dart';
import 'package:sonalysis/model/response/UserLoginResultModel.dart';
import 'package:sonalysis/model/response/VideoUploadedByIDResponseModel.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:sonalysis/validators/registration_validation.dart';
import 'package:sonalysis/widgets/custom_button.dart';
import 'package:sonalysis/widgets/custom_search_texbox.dart';
import 'package:sonalysis/widgets/loading_overlay_widget.dart';
import 'package:sonalysis/widgets/textfield.dart';

class NewGroupChatContactListModalWidget extends StatefulWidget {

  String name;
  String imageUrl;
  bool isOnline;

  NewGroupChatContactListModalWidget({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.isOnline
  }) : super(key: key);

  @override
  _NewGroupChatContactListModalWidgetState createState() => _NewGroupChatContactListModalWidgetState();
}

class _NewGroupChatContactListModalWidgetState extends State<NewGroupChatContactListModalWidget> {

  List<String> searchableList = [];
  SharedPreferencesClass sharedPreferencesClass = SharedPreferencesClass();
  UserLoginResultModel? userLoginResultModel;
  VideoUploadedByIDResponseModel? videoUploadedByIDResponseModel;
  bool isLoading = true, isInitialScreen = true;
  PlayerListResponseModel? playersListResponseModel;
  final TextEditingController _groupNameController = TextEditingController();

  XFile? selectedPhoto, xFileForCropper;
  File? _croppedFile;
  final ImagePicker _imagePicker = ImagePicker();
  bool _imagePicked = false, canSubmit = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    await sharedPreferencesClass.getUserModel().then((value) async {
      setState(() {
        userLoginResultModel = value;
      });
    });

    //load all players
    await DashboardController().getPlayerList(context, userLoginResultModel!.data!.user!.clubId!).then((value) {
      setState(() {
        isLoading = false;
        playersListResponseModel = value;
        searchableList = playersListResponseModel!.playerListResponseModelData!.map((el) => el.firstname! + " " + el.lastname!)
            .toList(); //.filename
      });
    });
  }

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
      cropImage(selectedPhoto);
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
      //_validate(context);
    }
  }

  Future<void> _validate(context, [bool isSubmit = false]) async {
    String groupName = _groupNameController.text.trim();

    //print(email);

    if (!requiredValidator(groupName)) {
      setState(() {
        canSubmit = false;
      });
      if (isSubmit) showSnackError(context, teamName_error);
      return;
    }

    if (!requiredValidator(_croppedFile!.path)) {
      setState(() {
        canSubmit = false;
      });
      if (isSubmit) showSnackError(context, abbrClubName_error);
      return;
    }

    if (!_imagePicked) {
      setState(() {
        canSubmit = false;
      });
      return;
    }

    setState(() {
      canSubmit = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Material(
        child: CupertinoPageScaffold(
          backgroundColor: Colors.transparent.withOpacity(0.9),
    child: !isLoading
        ? Container(
      decoration: BoxDecoration(
          color: sonaBlack,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          )
      ),
      //height: 640.h,
      height: isInitialScreen
          ? 480
          : MediaQuery.of(context).size.height * 0.9,
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: isInitialScreen
          ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("New Group Details",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 17.sp)),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Image.asset(
                        imagesDir + '/modal_close_btn.png',
                        fit: BoxFit.cover,
                        repeat: ImageRepeat.noRepeat,
                        width: 25,
                      ))
                ],
              ),
              const SizedBox(height: 30),
          InkWell(
            onTap:() {
              handlePickPhoto();
            },
            child: CircleAvatar(
                  backgroundColor: sonaBlack,
                  radius: 70,
                  child: ClipOval(
                    child: SizedBox(
                        width: 150.0,
                        height: 150.0,
                        child: _croppedFile != null
                            ? Image.file(_croppedFile!, fit: BoxFit.cover)
                            : Image.asset(imagesDir + "/placeholder.png",
                            fit: BoxFit.contain,
                            repeat: ImageRepeat.noRepeat)
                    ),
                  )
              )),
              const SizedBox(height: 5),
              InkWell(
                onTap:() {
                  handlePickPhoto();
                },
                child: Text(
                  "Group Logo",
                  style: TextStyle(
                      color: getColorHexFromStr("5597FF"),
                      fontSize: 12.sp,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                  margin: const EdgeInsets.all(10),
                  child: MyCustomTextField(
                    fieldType: FieldType.REQUIRED_FIELD,
                    labelText: "Group Name",
                    onChange: () {
                      _validate(context);
                    },
                    textInputType: TextInputType.text,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter(RegExp("[a-zA-ZÄäÖöÜü]"), allow: true) //Only Text as input
                    ],
                    controller: _groupNameController,
                  )),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomButton(
                    text: "Next",
                  color: canSubmit
                      ? sonaPurple1
                      : sonaPurpleDisabled,
                  action: () async {
                    if (canSubmit) {
                      setState(() {
                        isInitialScreen = false;
                      });
                    }
                  },
                  )),
                ],
              )
          : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Select Contacts",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 17.sp)),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Image.asset(
                        imagesDir + '/modal_close_btn.png',
                        fit: BoxFit.cover,
                        repeat: ImageRepeat.noRepeat,
                        width: 25,
                      ))
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: CustomSearch(
                  labelText: "Search for staff or players",
                  searchableList: searchableList,
                ),
              ),
              const SizedBox(height: 20),
              if (playersListResponseModel!.playerListResponseModelData!.isNotEmpty)
              ListView.builder(
                  itemCount: playersListResponseModel!.playerListResponseModelData!.length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 16),
                  itemBuilder: (context, index){
                    return NewGroupChatAllList(
                      name: playersListResponseModel!.playerListResponseModelData![index].firstname! + " " + playersListResponseModel!.playerListResponseModelData![index].lastname!,
                      imageUrl: playersListResponseModel!.playerListResponseModelData![index].photo!.isEmpty
                          ? displayPicture
                          : playersListResponseModel!.playerListResponseModelData![index].photo!,
                      role: "Player",
                      isOnline: (index == 0 || index == 2) ? true:false,
                    );
                  },
                ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                color: sonaBlack.withOpacity(0.7),
                child: CustomButton(
                  text: "Create group",
                  color: sonaPurple1,
                  action: () async {
                    Navigator.of(context).pop();
                    pushNewScreen(
                      context,
                      screen: GroupChatScreenSingleton(name: widget.name, imageUrl: widget.imageUrl, isOnline: widget.isOnline),
                      withNavBar: false,
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      )
          : SizedBox(
              height: 420,
              child: LoadingOverlayWidget(
                  loading: isLoading,
                  child: Container())),
    ));
  }


}
