
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/enums/user_type.dart';
import 'package:sonalysis/core/models/response/PlayerListResponseModel.dart';
import 'package:sonalysis/core/models/response/StaffListResponseModel.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/core/widgets/custom_search_texbox.dart';
import 'package:sonalysis/features/common/cubit/common_cubit.dart';
import 'package:sonalysis/features/common/messages/misc/new_chat_all_list.dart';
import 'package:sonalysis/style/styles.dart';

class NewChatContactListModalWidget extends StatefulWidget {

  const NewChatContactListModalWidget({Key? key, this.teamType, this.selectedVideoID}) : super(key: key);

  final String? teamType, selectedVideoID;

  @override
  _NewChatContactListModalWidgetState createState() => _NewChatContactListModalWidgetState();
}

class _NewChatContactListModalWidgetState extends State<NewChatContactListModalWidget> {

  List<String?> searchableList = [];
  bool isLoading = true;
  String? firstName, lastName, userID, imageUrl, role;


  late UserResultData userResultData;
  PlayerListResponseModel? playersListResponseModel;
  StaffListResponseModel? staffListResponseModel;
  //late List<String?> searchableList;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    userResultData = (await serviceLocator.get<LocalStorage>().readSecureObject(LocalStorageKeys.kUserPrefs))!;
     // print("Token::: "+userResultData.user!.role!);
     // print("Token2::: "+userResultData.user!.clubs!.length.toString());
    if (userResultData.user!.role!.toLowerCase() == UserType.player.type) {
      //TODO
      await serviceLocator<CommonCubit>().getStaffList("c2e4ad7d-f12b-4974-8f0a-22e1123093e7");
    } else if (userResultData.user!.role!.toLowerCase() == UserType.manager.type) {
      await serviceLocator<CommonCubit>().getPlayerList("c2e4ad7d-f12b-4974-8f0a-22e1123093e7");
    } else {
      await serviceLocator<CommonCubit>().getPlayerList(userResultData.user!.clubs![0].id!);
    }
    print("here::: "+userResultData.user!.role!);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {

    return Material(
        child: CupertinoPageScaffold(
          backgroundColor: Colors.transparent.withOpacity(0.9),
    child: BlocListener(
        bloc: serviceLocator.get<CommonCubit>(),
        listener: (_, state) {
          if (state is PlayerListLoading || state is StaffListLoading) {
            setState(() {
              isLoading = true;
            });
            context.loaderOverlay.show();
          }

          if (state is PlayerListError || state is StaffListError) {
            setState(() {
              isLoading = false;
            });
            context.loaderOverlay.hide();
            ResponseMessage.showErrorSnack(context: context, message: AppConstants.serverConnectionMessage);
          }

          if (state is PlayerListSuccess || state is StaffListSuccess) {
            context.loaderOverlay.hide();
            setState(() {
              isLoading = false;
              if (userResultData.user!.role! == UserType.player.type) {
                staffListResponseModel = serviceLocator.get<StaffListResponseModel>();
                searchableList =  staffListResponseModel!.staffListResponseModelData!.map((el) => el.user!.firstName).toList();
              } else {
                playersListResponseModel = serviceLocator.get<PlayerListResponseModel>();
                searchableList =  playersListResponseModel!.playerListResponseModelData!.map((el) => el.firstName).toList();
              }
              //print("filename:::::: "+videoListResponseModel!.data!.videosListResponseModelData![0].filename.toString());
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
          )
      ),
      //height: 640.h,
      height: MediaQuery.of(context).size.height * 0.9,
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("New Chat",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 17.sp)),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                          Boxicons.bx_x,
                          size: 30,
                        color: Colors.white,
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
              userResultData.user!.role! == UserType.player.type
              ? Column(
                children: [
                  if (staffListResponseModel!.staffListResponseModelData!.isNotEmpty)
                    ListView.builder(
                      itemCount: staffListResponseModel!.staffListResponseModelData!.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 16),
                      itemBuilder: (context, index){
                          firstName = staffListResponseModel!.staffListResponseModelData![index].user!.firstName;
                          lastName = staffListResponseModel!.staffListResponseModelData![index].user!.lastName;
                          userID = staffListResponseModel!.staffListResponseModelData![index].user!.id;
                          imageUrl = staffListResponseModel!.staffListResponseModelData![index].user!.photo == null
                              ? AppConstants.defaultProfilePictures
                              : staffListResponseModel!.staffListResponseModelData![index].user!.photo;
                          role = UserType.coach.type;
                        return NewChatAllList(
                          name:  firstName! + " " + lastName!,
                          userID: userID!,
                          imageUrl: imageUrl!,
                          role: role!,
                          isOnline: (index == 0 || index == 2) ? true:false,
                        );
                      },
                    ),
                  if (staffListResponseModel!.staffListResponseModelData!.isEmpty)
                    Image.asset(AppAssets.noPlayerStaff,
                        fit: BoxFit.cover,
                        repeat: ImageRepeat.noRepeat),
                ],
              )
              : Column(
                children: [
                  if (playersListResponseModel!.playerListResponseModelData!.isNotEmpty)
                    ListView.builder(
                      itemCount: playersListResponseModel!.playerListResponseModelData!.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 16),
                      itemBuilder: (context, index){
                          firstName = playersListResponseModel!.playerListResponseModelData![index].firstName;
                          lastName = playersListResponseModel!.playerListResponseModelData![index].lastName;
                          userID = playersListResponseModel!.playerListResponseModelData![index].userId;
                          imageUrl = playersListResponseModel!.playerListResponseModelData![index].photo == null
                              ? AppConstants.defaultProfilePictures
                              : playersListResponseModel!.playerListResponseModelData![index].photo;
                          role = UserType.player.type;
                        return NewChatAllList(
                          name:  firstName! + " " + lastName!,
                          userID: userID!,
                          imageUrl: imageUrl!,
                          role: role!,
                          isOnline: (index == 0 || index == 2) ? true:false,
                        );
                      },
                    ),
                  if (playersListResponseModel!.playerListResponseModelData!.isEmpty)
                    Image.asset(AppAssets.noPlayerStaff,
                        fit: BoxFit.cover,
                        repeat: ImageRepeat.noRepeat),
                ],
              ),

                const SizedBox(height: 110),
            ],
          ),
        ),
      ),
      )),
    ));
  }


}
