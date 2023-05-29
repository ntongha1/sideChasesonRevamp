import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sonalysis/core/datasource/local_data_cubit.dart';
import 'package:sonalysis/core/enums/user_type.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/navigation/keys.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/helpers/auth/shared_preferences_class.dart';
import 'package:sonalysis/helpers/helpers.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:sonalysis/widgets/newCallContactListModalWidget.dart';
import 'package:sonalysis/widgets/newChatContactListModalWidget.dart';
import 'package:sonalysis/widgets/newGroupChatContactListModalWidget.dart';

import '../../../core/widgets/appBar/appbarUnauth.dart';
import 'tabs/call_list.dart';
import 'tabs/chat_list.dart';
import 'tabs/group_chat_list.dart';

class MessagesScreen extends StatefulWidget {

  const MessagesScreen(
      {Key? key})
      : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> with SingleTickerProviderStateMixin {
  SharedPreferencesClass sharedPreferencesClass = SharedPreferencesClass();
  TabController? tabController;
  int _selectedIndex = 0;
  UserResultData? userResultData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    await serviceLocator<LocalDataCubit>().getLocallyStoredUserData();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: serviceLocator.get<LocalDataCubit>(),
        listener: (_, state) {
          if (state is GetLocallyStoredUserDataLoading) {
            context.loaderOverlay.show();
            isLoading = true;
            setState(() {});
          }

          if (state is GetLocallyStoredUserDataError) {
            context.loaderOverlay.hide();
            isLoading = false;
            ResponseMessage.showErrorSnack(context: context, message: state.message);
            setState(() {});
          }

          if (state is GetLocallyStoredUserDataSuccess) {
            context.loaderOverlay.hide();
            setState(() {
              userResultData = serviceLocator.get<UserResultData>();
              isLoading = false;
              //print("filename:::::: "+videoListResponseModel!.data!.videosListResponseModelData![0].filename.toString());
            });
            // print("Token: "+userResultData!.authToken.toString());
            // print("id: "+userResultData!.user!.id.toString());
            // print("clubId: "+userResultData!.user!.clubs!.length.toString());
            // print("photo: "+userResultData!.user!.photo.toString());
            // Create TabController for getting the index of current tab
            tabController = TabController(length: 3, vsync: this);
            tabController!.addListener(() {
              setState(() {
                _selectedIndex = tabController!.index;
              });
              print("Selected Index: " + tabController!.index.toString());
            });
          }
        },
        child: isLoading
            ? Container()
            : Scaffold(
      appBar: AppBarUnauth(photoUrl: userResultData!.user!.photo, firstName: userResultData!.user!.firstName!,lastName: userResultData!.user!.lastName!, club: userResultData!.user!.clubs!.length == 0 ? "" : userResultData!.user!.clubs![0].name!, role: userResultData!.user!.role!, action: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Boxicons.bxs_search_alt_2,
              size: 30,
            ),
          ),
          userResultData!.user!.role!.toLowerCase() == UserType.player.type
              ? SizedBox.shrink()
              : InkWell(
            onTap: () {
              serviceLocator.get<NavigationService>().to(RouteKeys.routeSettingsScreen);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Boxicons.bx_cog,
                size: 30,
              ),
            ),
          ),
        ],
      )),
      backgroundColor: AppColors.sonaBlack,
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(0))),
            child: TabBar(
              controller: tabController,
              automaticIndicatorColorAdjustment: true,
              indicatorWeight: 1,
              indicatorColor: Colors.black,
              onTap: (index) {
                // Tab index when user select it, it start from zero
              },
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: AppColors.sonaPurple1),
              tabs: [
                Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 15),
                    child: Text("Chats",
                        style: TextStyle(fontWeight: _selectedIndex == 0
                            ? FontWeight.w800
                            : FontWeight.w600, color: Colors.white)),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 10),
                    child: Text("Groups",
                        style: TextStyle(fontWeight: _selectedIndex == 1
                            ? FontWeight.w800
                            : FontWeight.w600, color: Colors.white)),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 10),
                    child: Text("Calls",
                        style: TextStyle(fontWeight: _selectedIndex == 2
                            ? FontWeight.w800
                            : FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
              child: TabBarView(
                controller: tabController,
                children: [
                  ChatListScreen(),
                  const SingleChildScrollView(
                    child: GroupChatListScreen(),
                  ),
                  const SingleChildScrollView(
                    child: CallListScreen(),
                  ),
                ],
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          elevation: 0.0,
        icon: Icon(
              _selectedIndex == 0 ? Boxicons.bx_chat : _selectedIndex == 1 ? Boxicons.bxs_chat : Boxicons.bxs_phone_call,
              size: 30),
          backgroundColor: sonaPurple1,
          onPressed: () {
            //widget.onScreenHideButtonPressed();
            bottomSheet(context,
                _selectedIndex == 0
                    ? const NewChatContactListModalWidget()
                    : _selectedIndex == 1
                        ? NewGroupChatContactListModalWidget(name: '', isOnline: false, imageUrl: "")
                        : const NewCallContactListModalWidget()
            );
          },
        label: Text(_selectedIndex == 0 ? "new_chat".tr() : _selectedIndex == 1 ? "new_group_chat".tr() : "new_audio_video_call".tr(),
      )),
      bottomSheet: const Padding(padding: EdgeInsets.only(bottom: 100)),
    ));
  }
}
