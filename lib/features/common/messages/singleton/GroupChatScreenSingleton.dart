import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sonalysis/helpers/helpers.dart';
import 'package:sonalysis/lang/strings.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../call/groupCall/outgoing/group_call_audio_screen.dart';
import '../../call/groupCall/outgoing/group_call_video_screen.dart';
import '../pop_up/attach_what_modal.dart';
import '../pop_up/more_option_modal.dart';
import 'profile/group_chat_profile_singleton.dart';

class GroupChatScreenSingleton extends StatefulWidget {
  String name;
  String imageUrl;
  bool isOnline;

  GroupChatScreenSingleton(
      {Key? key,
      required this.name,
      required this.imageUrl,
      required this.isOnline})
      : super(key: key);

  @override
  _GroupChatScreenSingletonState createState() =>
      _GroupChatScreenSingletonState();
}

class _GroupChatScreenSingletonState extends State<GroupChatScreenSingleton> {
  List<types.Message> _messages = [];
  final _user = const types.User(id: '06c33e8b-e835-4736-80f4-63f44b66666c');
  bool emojiShowing = false;
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  _onBackspacePressed() {
    _textController
      ..text = _textController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _textController.text.length));
    setState(() {
      _textController = _textController;
    });
  }

  void _handleAtachmentPressed() {
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

    _addMessage(textMessage);
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/chat.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      _messages = messages;
    });
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
                          screen: GroupChatSingletonScreen(
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
                        backgroundImage: NetworkImage(widget.imageUrl),
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
                            screen: GroupChatSingletonScreen(
                                name: widget.name,
                                imageUrl: widget.imageUrl,
                                isOnline: widget.isOnline),
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
                            Text(widget.name,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                            const SizedBox(height: 3),
                            Image.asset(
                              imagesDir + "/groupDps.png",
                              width: 50,
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
                          screen: GroupCallVideoScreen(
                              name: widget.name,
                              imageUrl: widget.imageUrl,
                              isOnline: widget.isOnline),
                          withNavBar: false, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      child: Image.asset(
                        imagesDir + '/videoCall.png',
                        width: 23,
                        fit: BoxFit.contain,
                        repeat: ImageRepeat.noRepeat,
                      )),
                  const SizedBox(width: 13),
                  InkWell(
                      onTap: () {
                        setState(() {
                          emojiShowing = false;
                        });
                        pushNewScreen(
                          context,
                          screen: GroupCallAudioScreen(
                              name: widget.name,
                              imageUrl: widget.imageUrl,
                              isOnline: widget.isOnline),
                          withNavBar: false, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      child: Image.asset(
                        imagesDir + '/audioCall.png',
                        width: 20,
                        fit: BoxFit.contain,
                        repeat: ImageRepeat.noRepeat,
                      )),
                  const SizedBox(width: 5),
                  InkWell(
                      onTap: () {
                        setState(() {
                          emojiShowing = false;
                        });
                        bottomSheet(context, const MoreChatOptionsModal());
                      },
                      child: Image.asset(
                        imagesDir + '/3dots.png',
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
                userNameTextStyle: TextStyle(color: sonaPurple1, fontSize: 14),
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
                          decoration: InputDecoration(
                            hintText: "Write message...",
                            hintStyle: const TextStyle(
                                color: Colors.white, fontSize: 12),
                            focusColor: Colors.white,
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  emojiShowing = !emojiShowing;
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
                            imagesDir + '/mic.png',
                            width: 25,
                            fit: BoxFit.contain,
                            repeat: ImageRepeat.noRepeat,
                          ),
                          const SizedBox(width: 10),
                          Image.asset(
                            imagesDir + '/addAPhoto.png',
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
            onAttachmentPressed: _handleAtachmentPressed,
            onMessageTap: _handleMessageTap,
            onPreviewDataFetched: _handlePreviewDataFetched,
            onSendPressed: _handleSendPressed,
            user: _user,
            showUserAvatars: true,
            showUserNames: true,
          ),
        ));
  }
}
