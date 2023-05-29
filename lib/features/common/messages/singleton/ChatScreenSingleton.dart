import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sonalysis/core/config/config.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/enums/messaging_type.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/navigation/keys.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/features/common/call/video_call/outgoing_video_call.dart';
import 'package:sonalysis/features/common/cubit/common_cubit.dart';
import 'package:sonalysis/features/common/messages/pop_up/attach_what_modal.dart';
import 'package:sonalysis/features/common/messages/pop_up/more_option_modal.dart';
import 'package:sonalysis/features/common/models/CreateRoomModel.dart'
    as myRoom;
import 'package:sonalysis/helpers/helpers.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'profile/user_chat_profile_singleton.dart';

class ChatScreenSingleton extends StatefulWidget {
  final String? name;
  final String? userID;
  final String? livekitToken;
  final String? imageUrl;
  final bool? isOnline;

  const ChatScreenSingleton(
      {Key? key,
      this.name,
      this.userID,
      this.livekitToken,
      this.imageUrl,
      this.isOnline})
      : super(key: key);

  @override
  _ChatScreenSingletonState createState() => _ChatScreenSingletonState();
}

class _ChatScreenSingletonState extends State<ChatScreenSingleton> {
  List<types.Message> _messages = [];
  final _user = const types.User(id: '06c33e8b-e835-4736-80f4-63f44b66666c');
  bool emojiShowing = false;
  TextEditingController _textController = TextEditingController();
  UserResultData? userResultData;
  myRoom.CreateRoomModel? createRoomModel;
  Room? _room;
  RoomOptions? roomOptions = RoomOptions(
    adaptiveStream: true,
    dynacast: true,
  );
  EventsListener<RoomEvent>? _listener;
  String? joinedParticipant;

  @override
  void initState() {
    super.initState();
    _getData();
    _connectChat();
    _loadMessages();
  }

  Future<void> _getData() async {
    userResultData = await serviceLocator
        .get<LocalStorage>()
        .readSecureObject(LocalStorageKeys.kUserPrefs);
    setState(() {});
    print("Token::: " + userResultData!.user!.id!.toString());
  }

  void _connectChat() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //check if we are connected
    await serviceLocator<CommonCubit>().checkIfWeAreConnected(
        userResultData!.user!.id!, widget.userID, MessagingType.chat.type);

    //create and add caller to room
    // await serviceLocator<CommonCubit>().createPrivateRoomAddParticipant(userResultData!.user!.id!, widget.userID, MessagingType.chat.type);
    // //print("done with: createPrivateRoomAddParticipant");
    // createRoomModel = serviceLocator.get<myRoom.CreateRoomModel>();
    //
    String? liveKitToken = widget.livekitToken;
    try {
      //create the engine
      _room = await LiveKitClient.connect(AppConfig.liveKitUrl, liveKitToken!,
          roomOptions: roomOptions);
    } catch (error) {
      print('Could not connect to room, error: $error');
    }

    print('connected to room, success!');

    try {
      _listener = _room!.createListener();

      _setUpListeners();
      // used for generic change updates
      _room!.addListener(_onChange);
    } catch (e) {
      print('Could not setup listener, error: $e');
    }
  }

// used for specific events
  void _setUpListeners() => _listener!
    ..on<RoomDisconnectedEvent>((_) {
      // handle disconnect
      print("you left room");
    })
    ..on<ParticipantConnectedEvent>((e) {
      setState(() {
        joinedParticipant = e.participant.identity;
      });
      print("participant joined: ${e.participant.identity}");
    })
    ..on<ParticipantDisconnectedEvent>((e) {
      setState(() {
        joinedParticipant = e.participant.identity;
      });
      print("participant left: ${e.participant.identity}");
    })
    ..on<DataReceivedEvent>((event) {
      String decoded = 'Failed to decode';
      try {
        decoded = utf8.decode(event.data);
        print(decoded);
      } catch (_) {
        print(decoded + ': $_');
      }
    });

  @override
  void dispose() {
    // always dispose listener
    (() async {
      _room!.removeListener(_onChange);
      await _listener!.dispose();
      await _room!.dispose();
    })();
    super.dispose();
  }

  void _onChange() {
    // perform computations and then call setState
    // setState will trigger a build
    setState(() {
      // your updates here
    });
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/others/chat.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      _messages = messages;
    });
  }

  void _addMessage(types.Message message) {
    // publish reliable data to a set of participants
    setState(() {
      _messages.insert(0, message);
    });
  }

  // _onEmojiSelected(Emoji emoji) {
  //   _textController
  //     ..text += emoji.emoji
  //     ..selection = TextSelection.fromPosition(
  //         TextPosition(offset: _textController.text.length));
  //   setState(() {
  //     _textController = _textController;
  //   });
  // }

  _onBackspacePressed() {
    _textController
      ..text = _textController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _textController.text.length));
    setState(() {
      _textController = _textController;
    });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: 144,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImageSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Photo'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleFileSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('File'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext context, types.Message message) async {
    if (message is types.FileMessage) {
      await OpenFile.open(message.uri);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    //final updatedMessage = _messages[index].copyWith(previewData: previewData);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        //_messages[index] = updatedMessage;
      });
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    try {
      //_room!.localParticipant!.publishData(utf8.encode(message.text));
      _room!.localParticipant!.publishData(utf8.encode(message.text),
          reliability: Reliability.reliable,
          destinationSids: [joinedParticipant!]);
    } catch (e) {
      print("error sending data: $e");
    }

    _addMessage(textMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: sonaBlack,
          flexibleSpace: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  InkWell(
                      onTap: () {
                        pushNewScreen(
                          context,
                          screen: UserChatSingletonScreen(
                              name: widget.name,
                              imageUrl: widget.imageUrl,
                              isOnline: widget.isOnline),
                          withNavBar: false, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(widget.imageUrl!),
                        maxRadius: 20,
                      )),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: InkWell(
                        onTap: () {
                          pushNewScreen(
                            context,
                            screen: const UserChatSingletonScreen(),
                            withNavBar:
                                false, // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(widget.name!,
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                            Text(
                              widget.isOnline! ? "online" : "Last seen 8:25PM",
                              style: TextStyle(
                                  color: widget.isOnline!
                                      ? getColorHexFromStr("2E9B8D")
                                      : Colors.grey,
                                  fontSize: 13),
                            ),
                          ],
                        )),
                  ),
                  InkWell(
                      onTap: () {
                        setState(() {
                          emojiShowing = false;
                        });
                        pushNewScreen(
                          context,
                          screen: OutGoingVideocall(
                              name: widget.name!,
                              imageUrl: widget.imageUrl!,
                              isOnline: widget.isOnline!),
                          withNavBar: false, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      child: Image.asset(
                        AppAssets.videoCall,
                        width: 28,
                        fit: BoxFit.contain,
                        repeat: ImageRepeat.noRepeat,
                      )),
                  const SizedBox(width: 20),
                  InkWell(
                      onTap: () {
                        setState(() {
                          emojiShowing = false;
                        });
                        serviceLocator
                            .get<NavigationService>()
                            .replaceWithPameter(
                                routeName: RouteKeys.routeAudioCallScreen,
                                data: {
                              "name": widget.name,
                              "userId": widget.userID,
                              "imageUrl": widget.imageUrl,
                              "isOnline": widget.isOnline,
                              "isOutgoing": true
                            });
                      },
                      child: Image.asset(
                        AppAssets.audioCall,
                        width: 25,
                        fit: BoxFit.contain,
                        repeat: ImageRepeat.noRepeat,
                      )),
                  const SizedBox(width: 10),
                  InkWell(
                      onTap: () {
                        setState(() {
                          emojiShowing = false;
                        });
                        bottomSheet(context, const MoreChatOptionsModal());
                      },
                      child: Image.asset(
                        AppAssets.threeDots,
                        width: 25,
                        fit: BoxFit.contain,
                        repeat: ImageRepeat.noRepeat,
                      ))
                ],
              ),
            ),
          ),
        ),
        backgroundColor: sonaBlack,
        body: SafeArea(
          bottom: false,
          child: Chat(
            theme: DefaultChatTheme(
                secondaryColor: sonaLighterBlack,
                primaryColor: sonaPurple1,
                receivedMessageBodyTextStyle:
                    const TextStyle(color: Colors.white, fontSize: 14),
                sentMessageBodyTextStyle:
                    const TextStyle(color: Colors.white, fontSize: 14),
                sentMessageLinkTitleTextStyle:
                    const TextStyle(color: Colors.white, fontSize: 14),
                sentMessageCaptionTextStyle:
                    const TextStyle(color: Colors.white, fontSize: 14),
                inputBackgroundColor: Colors.white,
                backgroundColor: sonaBlack,
                inputTextColor: Colors.black),
            customBottomWidget: Container(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, bottom: 15, top: 0),
              height: emojiShowing ? 280 : 80,
              width: double.infinity,
              color: sonaBlack,
              child: Column(
                children: [
                  Expanded(child: Container()),
                  Offstage(
                      offstage: !emojiShowing,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox())),
                  const SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            emojiShowing = false;
                          });
                          bottomSheet(context, const AttachWhatModal());
                        },
                        child: Container(
                          height: 25,
                          width: 25,
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: getColorHexFromStr("811AFF"),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _textController,
                          onChanged: (String value) {
                            setState(() {
                              _textController = _textController;
                            });
                          },
                          style:
                              TextStyle(color: Colors.white, fontSize: 12.sp),
                          decoration: InputDecoration(
                            hintText: "Write message...",
                            hintStyle:
                                TextStyle(color: Colors.white, fontSize: 12.sp),
                            focusColor: Colors.white,
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  if (_textController.text.isEmpty) {
                                    emojiShowing = !emojiShowing;
                                  } else {
                                    _handleSendPressed(types.PartialText(
                                        text: _textController.text));
                                  }
                                });
                              },
                              child: Icon(
                                  _textController.text.isNotEmpty
                                      ? Icons.send
                                      : Icons.tag_faces,
                                  color: Colors.white),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 10),
                            fillColor: sonaLighterBlack,
                            filled: true,
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: getColorHexFromStr("5E5E5E"),
                                  width: 0.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          Image.asset(
                            AppAssets.mic,
                            width: 25,
                            fit: BoxFit.contain,
                            repeat: ImageRepeat.noRepeat,
                          ),
                          const SizedBox(width: 10),
                          Image.asset(
                            AppAssets.addAPhoto,
                            width: 25,
                            fit: BoxFit.contain,
                            repeat: ImageRepeat.noRepeat,
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            messages: _messages,
            onAttachmentPressed: _handleAttachmentPressed,
            onMessageTap: _handleMessageTap,
            onPreviewDataFetched: _handlePreviewDataFetched,
            onSendPressed: _handleSendPressed,
            user: _user,
          ),
        ));
  }
}
