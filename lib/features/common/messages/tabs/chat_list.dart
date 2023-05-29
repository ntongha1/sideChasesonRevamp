import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/constants.dart';
import 'package:sonalysis/core/utils/helpers.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/features/common/cubit/common_cubit.dart';
import 'package:sonalysis/features/common/messages/misc/chat_conversation_list.dart';
import 'package:sonalysis/features/common/models/ChatRoomsListResponseModel.dart';
import 'package:sonalysis/model/chat/chat_list.dart';

class ChatListScreen extends StatefulWidget {
  ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<String> searchableList = [];
  List<ChatList>? chatLists;
  bool? isLoading = true;
  ChatRoomsListResponseModel? chatRoomsListResponseModel;
  RefreshController? _refreshController;
  UserResultData? userResultData;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  _onRefresh() async {
    // monitor network fetch
    await _getData();
    // if failed,use refreshFailed()
    _refreshController!.refreshCompleted();
  }

  _loadMessages() async {
    chatLists = [
      ChatList(
          name: "Jane Russel",
          messageText: "Awesome Setup",
          imageURL:
              "https://gravatar.com/avatar/beab2844dbcf1897c744bf5a4cff7f08?s=400&d=robohash&r=x",
          time: "Now"),
      ChatList(
          name: "Glady's Murphy",
          messageText: "That's Great",
          imageURL:
              "https://robohash.org/d9c42c29bb12c01359ba6e62d8acf857?set=set4&bgset=&size=400x400",
          time: "Yesterday"),
      ChatList(
          name: "Jorge Henry",
          messageText: "Hey where are you?",
          imageURL:
              "https://robohash.org/f1682eb8de52f66d862efe229f09beaa?set=set4&bgset=&size=400x400",
          time: "31 Mar"),
      ChatList(
          name: "Philip Fox",
          messageText: "Busy! Call me in 20 mins",
          imageURL:
              "https://gravatar.com/avatar/0a6c8050d63d0417d4625cab2c5134f5?s=400&d=robohash&r=x",
          time: "28 Mar"),
      ChatList(
          name: "Debra Hawkins",
          messageText: "Thankyou, It's awesome",
          imageURL:
              "https://gravatar.com/avatar/f4f4b55c1bd50c2e8fc4c7ee04dcc344?s=400&d=robohash&r=x",
          time: "23 Mar"),
      ChatList(
          name: "Jacob Pena",
          messageText: "will update you in evening",
          imageURL:
              "https://gravatar.com/avatar/77e8c3267df6d62f2382dd30cf6a1dcf?s=400&d=robohash&r=x",
          time: "17 Mar"),
      ChatList(
          name: "Andrey Jones",
          messageText: "Can you please share the file?",
          imageURL:
              "https://gravatar.com/avatar/ba0a9acb6f13bd37cbdfd87d1dc3e738?s=400&d=robohash&r=x",
          time: "24 Feb"),
      ChatList(
          name: "John Wick",
          messageText: "How are you?",
          imageURL:
              "https://robohash.org/ba0a9acb6f13bd37cbdfd87d1dc3e738?set=set4&bgset=&size=400x400",
          time: "18 Feb"),
    ];
  }

  _getData() async {
    userResultData = await serviceLocator.get<LocalStorage>().readSecureObject(LocalStorageKeys.kUserPrefs);
    _refreshController = RefreshController(initialRefresh: false);
    await serviceLocator<CommonCubit>().getRoomList();
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: serviceLocator.get<CommonCubit>(),
        listener: (_, state) {
          if (state is RoomListLoading) {
            context.loaderOverlay.show();
            isLoading = true;
            _refreshController!.loadComplete();
          }

          if (state is RoomListError) {
            context.loaderOverlay.hide();
            isLoading = false;
            _refreshController!.loadComplete();
            ResponseMessage.showErrorSnack(
                context: context, message: state.message);
          }

          if (state is RoomListSuccess) {
            context.loaderOverlay.hide();
            isLoading = false;
            _refreshController!.loadComplete();
            setState(() {
              chatRoomsListResponseModel =
                  serviceLocator.get<ChatRoomsListResponseModel>();
              //print("filename:::::: "+chatRoomsListResponseModel!.videoListResponseModelData!.dataList![0].toString());
            });
          }
        },
        child: isLoading!
            ? Container()
            : Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: WaterDropHeader(),
                    controller: _refreshController!,
                    onRefresh: _onRefresh,
                    onLoading: _getData,
                    child: chatRoomsListResponseModel!.data!.length == 0
                        ? Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Image.asset(
                        AppAssets.noChat,
                        fit: BoxFit.cover,
                        repeat: ImageRepeat.noRepeat,
                      ),
                    )
                        : ListView.builder(
                            itemCount: chatRoomsListResponseModel!.data!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              //print("::::"+chatRoomsListResponseModel!.data!.length.toString());
                              if (chatRoomsListResponseModel!.data![index].room!.participants!.length > 1) {
                                return ChatConversationList(
                                  name: chatRoomsListResponseModel!.data![index].room!.participants!.firstWhere((v) => v.id != userResultData!.user!.id).firstName! +" "+ chatRoomsListResponseModel!.data![index].room!.participants!.firstWhere((v) => v.id != userResultData!.user!.id).lastName! + " (" + capitalizeSentence(chatRoomsListResponseModel!.data![index].room!.participants!.firstWhere((v) => v.id != userResultData!.user!.id).role!) + ")",
                                  userID: chatRoomsListResponseModel!.data![index].room!.participants!.firstWhere((v) => v.id != userResultData!.user!.id).id!,
                                  messageText: chatRoomsListResponseModel!.data![index].room!.name!,
                                  imageUrl: chatRoomsListResponseModel!.data![index].room!.participants![1].photo == null ? AppConstants.defaultProfilePictures : chatRoomsListResponseModel!.data![index].room!.participants![1].photo!,
                                  livekitToken: chatRoomsListResponseModel!.data![index].livekitToken!,
                                  time: "Yesterday",
                                  count: (index == 0 || index == 3) ? 4 : 0,
                                  isMessageRead: (index == 0 || index == 3) ? true : false,
                                  isOnline: (index == 0 || index == 2) ? true : false,
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            },
                          ))));
  }
}
