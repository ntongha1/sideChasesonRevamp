import 'dart:async';

import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonalysis/core/config/config.dart';
import 'package:sonalysis/helpers/helpers.dart';
import 'package:sonalysis/lang/strings.dart';
import 'package:sonalysis/services/api.dart';
import 'package:sonalysis/style/styles.dart';

import '../../components/CallTimerContainer.dart';
import '../../size_config.dart';
import '../components/audio_call_active_card.dart';
import '../components/user_calling_card.dart';


class GroupCallAudioScreen extends StatefulWidget {

  String name;
  String imageUrl;
  bool isOnline;

  GroupCallAudioScreen({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.isOnline
  }) : super(key: key);

  @override
  _GroupCallAudioScreenState createState() => _GroupCallAudioScreenState();
}

class _GroupCallAudioScreenState extends State<GroupCallAudioScreen> {
  bool isPicked = false;
  bool speakerActive = true;
  bool cameraOff = false;
  bool muteToggle = false;
  bool speakerToggle = false;
  DateTime now = DateTime.now();
  double? maxSecondsUseable;
  int secondsPassed = 0;
  static const duration = Duration(seconds: 1);
  int seconds = 00, minutes = 00, hours = 00;
  Timer? _timer;

  late var _users;
  final _infoStrings = <String>[];
  RoomOptions? roomOptions;
  late final EventsListener<RoomEvent> _listener;
  late Room _room;
  bool iJoined = false;

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initLiveKit();
  }

  Future<void> initLiveKit() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    roomOptions = RoomOptions(
      adaptiveStream: true,
      dynacast: true,
      // ... your room options
    );

    //create the engine
    _room = await LiveKitClient.connect(AppConfig.liveKitUrl, AppConfig.liveKitToken, roomOptions: roomOptions);
    // try {
    //   // video will fail when running in ios simulator
    //   await room.localParticipant?.setCameraEnabled(true);
    // } catch (error) {
    //   print('Could not publish video, error: $error');
    // }
    _listener = _room.createListener();

    _users = _room.participants;

    // used for generic change updates
    _room.addListener(_onChange);

    // used for specific events
    _listener
      ..on<RoomDisconnectedEvent>((_) {
        // handle disconnect
      })
      ..on<ParticipantConnectedEvent>((e) {
        print("participant joined: ${e.participant.identity}");
      })
      ..on<ParticipantDisconnectedEvent>((e) {
        print("participant left: ${e.participant.identity}");
      });
  }

  @override
  void dispose() {
    // be sure to dispose listener to stop listening to further updates
    if (_timer != null) _timer!.cancel();
    _listener.dispose();
    _room.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() {
    // perform computations and then call setState
    // setState will trigger a build
    setState(() {
      // your updates here
    });
  }

  void _onToggleMute() async {
    setState(()  {
      muteToggle = !muteToggle;
      showToast(muteToggle ? "Mic Muted" : "Mic Unmuted", "success");
    });
    await _room.localParticipant!.setMicrophoneEnabled(muteToggle);
  }

  void _onToggleSpeaker() {
    setState(() {
      speakerToggle = !speakerToggle;
      //_engine!.setEnableSpeakerphone(speakerToggle);
    });
  }

  void handleTick() {
    setState(() {
      secondsPassed = secondsPassed + 1;
      //seconds = secondsPassed * 60;
      if (secondsPassed > 59) {
        seconds = secondsPassed % 60;
      } else {
        seconds = secondsPassed;
      }
      minutes = secondsPassed ~/ 60;
      hours = secondsPassed ~/ (60 * 60);
    });
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: sonaBlack,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: sonaBlack,
        flexibleSpace: SafeArea(
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios,
                    color: Colors.white, size: 20),
              ),
              Expanded(
                child: Text(widget.name,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.white)),
              ),
              Image.asset(
                imagesDir + '/person_add_alt_1.png',
                width: 30,
                fit: BoxFit.contain,
                repeat: ImageRepeat.noRepeat,
              ),
              const SizedBox(width: 13),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          if (isPicked)
          Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(vertical: 2),
              width: 70,
              decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: const BorderRadius.all(
                      Radius.circular(16))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CallTimerContainer(
                      label: 'HRS',
                      value: hours != null
                          ? (hours).toString().padLeft(2, '0')
                          : '00'),
                  CallTimerContainer(label: ':', value: ':'),
                  CallTimerContainer(
                      label: 'MIN',
                      value: minutes != null
                          ? (minutes).toString().padLeft(2, '0')
                          : '00'),
                  CallTimerContainer(label: ':', value: ':'),
                  CallTimerContainer(
                      label: 'SEC',
                      value: seconds != null
                          ? (seconds).toString().padLeft(2, '0')
                          : '00'),
                ],
              )),
          if (isPicked)
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              itemCount: demoData.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.53,
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) => demoData[index]["isCalling"]
                  ? UserCallingCard(
                name: demoData[index]["name"],
                image: demoData[index]['image'],
              )
                  : isPicked
                  ? AudioCallActiveCard(
                name: demoData[index]["name"],
                image: demoData[index]['image'],
              )
              : UserCallingCard(
                name: demoData[index]["name"],
                image: demoData[index]['image'],
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.only(top: 7, bottom: 2),
              decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius:
                  const BorderRadius.all(Radius.circular(16))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  isPicked
                      ? InkWell(
                      onTap: () {

                      },
                      child: Image.asset(
                        imagesDir + '/video_cam.png',
                        width: 30,
                        fit: BoxFit.contain,
                        repeat: ImageRepeat.noRepeat,
                      ))
                      : AnimatedOpacity(
                      opacity: 0.3,
                      duration: const Duration(seconds: 3),
                      child: Image.asset(
                        imagesDir + '/video_cam.png',
                        width: 30,
                        fit: BoxFit.contain,
                        repeat: ImageRepeat.noRepeat,
                      )),
                  InkWell(
                      onTap: () {
                        if (isPicked) _onToggleMute();
                      },
                      child: AnimatedOpacity(
                          opacity: !isPicked ? 0.3 : 1,
                          duration: const Duration(seconds: 3),
                          child: Image.asset(
                            imagesDir + '/mic.png',
                            width: 27,
                            fit: BoxFit.contain,
                            repeat: ImageRepeat.noRepeat,
                          ))),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        imagesDir + '/end_call.png',
                        width: 50,
                        fit: BoxFit.contain,
                        repeat: ImageRepeat.noRepeat,
                      )),
                  isPicked
                      ? InkWell(
                      onTap: () {},
                      child: Image.asset(
                        imagesDir + '/chat.png',
                        width: 25,
                        fit: BoxFit.contain,
                        repeat: ImageRepeat.noRepeat,
                      ))
                      : AnimatedOpacity(
                      opacity: 0.3,
                      duration: const Duration(seconds: 3),
                      child: Image.asset(
                        imagesDir + '/chat.png',
                        width: 25,
                        fit: BoxFit.contain,
                        repeat: ImageRepeat.noRepeat,
                      )),
                  isPicked
                      ? InkWell(
                      onTap: () {},
                      child: Image.asset(
                        imagesDir + '/3dots.png',
                        width: 28,
                        fit: BoxFit.contain,
                        repeat: ImageRepeat.noRepeat,
                      ))
                      : AnimatedOpacity(
                      opacity: 0.3,
                      duration: const Duration(seconds: 3),
                      child: Image.asset(
                        imagesDir + '/3dots.png',
                        width: 25,
                        fit: BoxFit.contain,
                        repeat: ImageRepeat.noRepeat,
                      )),
                ],
              )),
        ],
      ),
    );
  }


  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    list.add(VideoTrackRenderer(_room.participants[1]!.trackPublications[0]!.track  as VideoTrack));
    for (var uid in _users) {
      list.add(VideoTrackRenderer(_room.participants[1]!.trackPublications[0]!.track  as VideoTrack));
    }
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(
        child: Container(
            //child: view
          child: UserCallingCard(
            name: demoData[0]["name"],
            image: demoData[0]['image'],
          ),
        ));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
              children: <Widget>[
                _videoView(views[0]),
                Container(
                    padding: const EdgeInsets.only(top: 7, bottom: 2),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(16))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        isPicked
                            ? InkWell(
                            onTap: () {

                            },
                            child: Image.asset(
                              imagesDir + '/video_cam.png',
                              width: 30,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            ))
                            : AnimatedOpacity(
                            opacity: 0.3,
                            duration: const Duration(seconds: 3),
                            child: Image.asset(
                              imagesDir + '/video_cam.png',
                              width: 30,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            )),
                        InkWell(
                            onTap: () {
                              if (isPicked) _onToggleMute();
                            },
                            child: AnimatedOpacity(
                                opacity: !isPicked ? 0.3 : 1,
                                duration: const Duration(seconds: 3),
                                child: Image.asset(
                                  imagesDir + '/mic.png',
                                  width: 27,
                                  fit: BoxFit.contain,
                                  repeat: ImageRepeat.noRepeat,
                                ))),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              imagesDir + '/end_call.png',
                              width: 50,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            )),
                        isPicked
                            ? InkWell(
                            onTap: () {},
                            child: Image.asset(
                              imagesDir + '/chat.png',
                              width: 25,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            ))
                            : AnimatedOpacity(
                            opacity: 0.3,
                            duration: const Duration(seconds: 3),
                            child: Image.asset(
                              imagesDir + '/chat.png',
                              width: 25,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            )),
                        isPicked
                            ? InkWell(
                            onTap: () {},
                            child: Image.asset(
                              imagesDir + '/3dots.png',
                              width: 28,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            ))
                            : AnimatedOpacity(
                            opacity: 0.3,
                            duration: const Duration(seconds: 3),
                            child: Image.asset(
                              imagesDir + '/3dots.png',
                              width: 25,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            )),
                      ],
                    )),
              ],
            ));
      case 2:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow([views[0]]),
                _expandedVideoRow([views[1]]),
                Container(
                    padding: const EdgeInsets.only(top: 7, bottom: 2),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(16))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        isPicked
                            ? InkWell(
                            onTap: () {

                            },
                            child: Image.asset(
                              imagesDir + '/video_cam.png',
                              width: 30,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            ))
                            : AnimatedOpacity(
                            opacity: 0.3,
                            duration: const Duration(seconds: 3),
                            child: Image.asset(
                              imagesDir + '/video_cam.png',
                              width: 30,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            )),
                        InkWell(
                            onTap: () {
                              if (isPicked) _onToggleMute();
                            },
                            child: AnimatedOpacity(
                                opacity: !isPicked ? 0.3 : 1,
                                duration: const Duration(seconds: 3),
                                child: Image.asset(
                                  imagesDir + '/mic.png',
                                  width: 27,
                                  fit: BoxFit.contain,
                                  repeat: ImageRepeat.noRepeat,
                                ))),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              imagesDir + '/end_call.png',
                              width: 50,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            )),
                        isPicked
                            ? InkWell(
                            onTap: () {},
                            child: Image.asset(
                              imagesDir + '/chat.png',
                              width: 25,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            ))
                            : AnimatedOpacity(
                            opacity: 0.3,
                            duration: const Duration(seconds: 3),
                            child: Image.asset(
                              imagesDir + '/chat.png',
                              width: 25,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            )),
                        isPicked
                            ? InkWell(
                            onTap: () {},
                            child: Image.asset(
                              imagesDir + '/3dots.png',
                              width: 28,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            ))
                            : AnimatedOpacity(
                            opacity: 0.3,
                            duration: const Duration(seconds: 3),
                            child: Image.asset(
                              imagesDir + '/3dots.png',
                              width: 25,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            )),
                      ],
                    )),
              ],
            ));
      case 3:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 3)),
                Container(
                    padding: const EdgeInsets.only(top: 7, bottom: 2),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(16))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        isPicked
                            ? InkWell(
                            onTap: () {

                            },
                            child: Image.asset(
                              imagesDir + '/video_cam.png',
                              width: 30,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            ))
                            : AnimatedOpacity(
                            opacity: 0.3,
                            duration: const Duration(seconds: 3),
                            child: Image.asset(
                              imagesDir + '/video_cam.png',
                              width: 30,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            )),
                        InkWell(
                            onTap: () {
                              if (isPicked) _onToggleMute();
                            },
                            child: AnimatedOpacity(
                                opacity: !isPicked ? 0.3 : 1,
                                duration: const Duration(seconds: 3),
                                child: Image.asset(
                                  imagesDir + '/mic.png',
                                  width: 27,
                                  fit: BoxFit.contain,
                                  repeat: ImageRepeat.noRepeat,
                                ))),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              imagesDir + '/end_call.png',
                              width: 50,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            )),
                        isPicked
                            ? InkWell(
                            onTap: () {},
                            child: Image.asset(
                              imagesDir + '/chat.png',
                              width: 25,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            ))
                            : AnimatedOpacity(
                            opacity: 0.3,
                            duration: const Duration(seconds: 3),
                            child: Image.asset(
                              imagesDir + '/chat.png',
                              width: 25,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            )),
                        isPicked
                            ? InkWell(
                            onTap: () {},
                            child: Image.asset(
                              imagesDir + '/3dots.png',
                              width: 28,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            ))
                            : AnimatedOpacity(
                            opacity: 0.3,
                            duration: const Duration(seconds: 3),
                            child: Image.asset(
                              imagesDir + '/3dots.png',
                              width: 25,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            )),
                      ],
                    )),
              ],
            ));
      case 4:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 4)),
                Container(
                    padding: const EdgeInsets.only(top: 7, bottom: 2),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(16))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        isPicked
                            ? InkWell(
                            onTap: () {

                            },
                            child: Image.asset(
                              imagesDir + '/video_cam.png',
                              width: 30,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            ))
                            : AnimatedOpacity(
                            opacity: 0.3,
                            duration: const Duration(seconds: 3),
                            child: Image.asset(
                              imagesDir + '/video_cam.png',
                              width: 30,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            )),
                        InkWell(
                            onTap: () {
                              if (isPicked) _onToggleMute();
                            },
                            child: AnimatedOpacity(
                                opacity: !isPicked ? 0.3 : 1,
                                duration: const Duration(seconds: 3),
                                child: Image.asset(
                                  imagesDir + '/mic.png',
                                  width: 27,
                                  fit: BoxFit.contain,
                                  repeat: ImageRepeat.noRepeat,
                                ))),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              imagesDir + '/end_call.png',
                              width: 50,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            )),
                        isPicked
                            ? InkWell(
                            onTap: () {},
                            child: Image.asset(
                              imagesDir + '/chat.png',
                              width: 25,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            ))
                            : AnimatedOpacity(
                            opacity: 0.3,
                            duration: const Duration(seconds: 3),
                            child: Image.asset(
                              imagesDir + '/chat.png',
                              width: 25,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            )),
                        isPicked
                            ? InkWell(
                            onTap: () {},
                            child: Image.asset(
                              imagesDir + '/3dots.png',
                              width: 28,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            ))
                            : AnimatedOpacity(
                            opacity: 0.3,
                            duration: const Duration(seconds: 3),
                            child: Image.asset(
                              imagesDir + '/3dots.png',
                              width: 25,
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.noRepeat,
                            )),
                      ],
                    )),
              ],
            ));
      default:
    }
    return Container();
  }

}




List<Map<String, dynamic>> demoData = [
  {
    "isCalling": false,
    "name": "Zlatan Shakur",
    "image": "https://cdn-prod.medicalnewstoday.com/content/images/articles/317/317443/nice-man-smiling.jpg",
  }
];

