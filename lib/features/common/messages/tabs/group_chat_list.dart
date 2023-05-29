
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/features/common/messages/misc/group_chat_conversation_list.dart';
import 'package:sonalysis/helpers/auth/shared_preferences_class.dart';
import 'package:sonalysis/lang/strings.dart';
import 'package:sonalysis/model/chat/chat_list.dart';
import 'package:sonalysis/model/response/UserLoginResultModel.dart';
import 'package:sonalysis/widgets/custom_search_texbox.dart';
import 'package:sonalysis/widgets/loader_widget.dart';

class GroupChatListScreen extends StatefulWidget {

  const GroupChatListScreen({Key? key}) : super(key: key);

  @override
  State<GroupChatListScreen> createState() => _GroupChatListScreenState();
}

class _GroupChatListScreenState extends State<GroupChatListScreen> {
  List<String> searchableList = [];
  List<ChatList>? chatLists;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _loadMessages() async {
    chatLists = [
      ChatList(name: "Under 21", messageText: "Jim: Tomorrow, 6pm", imageURL: "https://gravatar.com/avatar/beab2844dbcf1897c744bf5a4cff7f08?s=400&d=robohash&r=x", time: "Now"),
      ChatList(name: "Strikers Magic", messageText: "Scott: Box holding can be better...", imageURL: "https://robohash.org/d9c42c29bb12c01359ba6e62d8acf857?set=set4&bgset=&size=400x400", time: "Yesterday"),
      ChatList(name: "The Wall", messageText: "Victor: You all held up well unde...", imageURL: "https://robohash.org/f1682eb8de52f66d862efe229f09beaa?set=set4&bgset=&size=400x400", time: "31 Mar"),
    ];
  }

  Future<void> _getData() async {
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container(
        //   margin: const EdgeInsets.only(top: 20.0),
        //   child: CustomSearch(
        //   labelText: "Search group chat",
        //   searchableList: [], //searchableList
        //   )
        //   ),
        // const SizedBox(height: 5),
        if (chatLists!.isEmpty)
          Image.asset(
            AppAssets.noVideos,
            fit: BoxFit.cover,
            repeat: ImageRepeat.noRepeat,
          ),
        if (chatLists!.isNotEmpty)
          ListView.builder(
            itemCount: chatLists!.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return GroupChatConversationList(
                name: chatLists![index].name,
                messageText: chatLists![index].messageText,
                imageUrl: chatLists![index].imageURL,
                time: chatLists![index].time,
                count: (index == 0 || index == 3) ? 4 : 0,
                isMessageRead: (index == 0 || index == 3) ? true:false,
                isOnline: (index == 0 || index == 2) ? true:false,
              );
            },
          ),
        const SizedBox(height: 100),
      ],
    ));
  }
}
