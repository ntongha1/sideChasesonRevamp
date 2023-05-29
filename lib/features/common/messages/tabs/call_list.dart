
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/features/common/messages/misc/call_main_list.dart';
import 'package:sonalysis/helpers/auth/shared_preferences_class.dart';
import 'package:sonalysis/helpers/helpers.dart';
import 'package:sonalysis/lang/strings.dart';
import 'package:sonalysis/model/call/call_list.dart';
import 'package:sonalysis/model/response/UserLoginResultModel.dart';
import 'package:sonalysis/widgets/custom_search_texbox.dart';
import 'package:sonalysis/widgets/loader_widget.dart';

import '../../../../core/startup/app_startup.dart';

class CallListScreen extends StatefulWidget {

  const CallListScreen({Key? key}) : super(key: key);

  @override
  State<CallListScreen> createState() => _CallListScreenState();
}

class _CallListScreenState extends State<CallListScreen> {
  bool isLoading = true;
  UserLoginResultModel? userLoginResultModel;
  List<String> searchableList = [];
  List<CallList>? callList;
  UserResultData? userResultData;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _loadMessages() async {
    callList = [
      CallList(name: "Jane Russel", callType: audioCall, callActivityType: incomingCall, imageURL: "https://gravatar.com/avatar/beab2844dbcf1897c744bf5a4cff7f08?s=400&d=robohash&r=x", timeAgo: "Now", time: "21:03"),
      CallList(name: "Glady's Murphy", callType: videoCall, callActivityType: outgoingCall, imageURL: "https://gravatar.com/avatar/beab2844dbcf1897c744bf5a4cff7f08?s=400&d=robohash&r=x", timeAgo: "Yesterday", time: "21:03"),
      CallList(name: "Jorge Henry", callType: audioCall, callActivityType: incomingCall, imageURL: "https://gravatar.com/avatar/beab2844dbcf1897c744bf5a4cff7f08?s=400&d=robohash&r=x", timeAgo: "5 Minutes Ago", time: "21:03"),
      CallList(name: "Philip Fox", callType: videoCall, callActivityType: outgoingCall, imageURL: "https://gravatar.com/avatar/0a6c8050d63d0417d4625cab2c5134f5?s=400&d=robohash&r=x", timeAgo: "Yesterday", time: "21:03"),
      CallList(name: "Debra Hawkins", callType: audioCall, callActivityType: missedCall, imageURL: "https://gravatar.com/avatar/f4f4b55c1bd50c2e8fc4c7ee04dcc344?s=400&d=robohash&r=x", timeAgo: "Now", time: "21:03"),
      ];
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _getData() async {
    userResultData = await serviceLocator.get<LocalStorage>().readSecureObject(LocalStorageKeys.kUserPrefs);
    print("Token: "+userResultData!.authToken.toString());
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoaderWidget()
        : Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container(
        //   margin: const EdgeInsets.only(top: 20.0),
        //   child: CustomSearch(
        //   labelText: "Search call logs",
        //   searchableList: [], //searchableList,
        //   )
        //   ),
        //const SizedBox(height: 5),
        if (callList!.isEmpty)
          Image.asset(
            AppAssets.noVideos,
            fit: BoxFit.cover,
            repeat: ImageRepeat.noRepeat,
          ),
        if (callList!.isNotEmpty)
          ListView.builder(
            itemCount: callList!.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return CallMainList(
                name: callList![index].name,
                callType: callList![index].callType,
                userId: callList![index].name,
                callActivityType: callList![index].callActivityType,
                imageURL: callList![index].imageURL,
                timeAgo: callList![index].timeAgo,
                time: callList![index].time,
                isOnline: (index == 0 || index == 2) ? true:false,
              );
            },
          ),
        const SizedBox(height: 100),
      ],
    ));
  }
}
