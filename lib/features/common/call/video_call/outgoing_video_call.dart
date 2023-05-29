import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonalysis/core/config/config.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/helpers/helpers.dart';
import 'package:sonalysis/lang/strings.dart';
import 'package:sonalysis/services/api.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:sonalysis/widgets/loader_widget.dart';

import '../components/CallTimerContainer.dart';
import '../size_config.dart';

class OutGoingVideocall extends StatefulWidget {
  final String? name;
  final String? userId;
  final String? imageUrl;
  final bool? isOnline;

  const OutGoingVideocall(
      {Key? key,
        this.name,
        this.userId,
        this.imageUrl,
        this.isOnline})
      : super(key: key);

  @override
  _OutGoingVideocallState createState() => _OutGoingVideocallState();
}

class _OutGoingVideocallState extends State<OutGoingVideocall> {
  bool isPicked = false;
  bool speakerActive = true;
  bool cameraOff = false;
  bool muteToggle = false;
  bool speakerToggle = false;
  bool cameraToggle = false;
  bool iJoined = false;
  DateTime now = DateTime.now();
  double? maxSecondsUseable;
  int secondsPassed = 0;
  static const duration = Duration(seconds: 1);
  int seconds = 00, minutes = 00, hours = 00;
  Timer? _timer;
  //IncallManager incallManager = IncallManager();
  int? _remoteUid;
  RoomOptions? roomOptions;
  late final EventsListener<RoomEvent> _listener;
  late Room _room;
  late LocalVideoTrack _localVideoTrack;

  @override
  void initState() {
    super.initState();
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
    try {
      // video will fail when running in ios simulator
      await _room.localParticipant?.setCameraEnabled(true);
    } catch (error) {
      print('Could not publish video, error: $error');
    }

    _localVideoTrack = await LocalVideoTrack.createCameraTrack();


    _listener = _room.createListener();

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
  void dispose() {
    // be sure to dispose listener to stop listening to further updates
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

  Future<void> _onToggleMute() async {
    setState(() {
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

  Future<void> _onToggleCamera() async {
    setState(() {
      cameraToggle = !cameraToggle;
    });
    await _room.localParticipant!.setCameraEnabled(cameraToggle);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (!iJoined)
            Container(
                height: MediaQuery.of(context).size.height,
                color: sonaBlack,
                child: Center(
                  child: LoaderWidget(),
                )),
          if (iJoined)
            Container(
                height: MediaQuery.of(context).size.height,
                color: sonaBlack,
                child: VideoTrackRenderer(_localVideoTrack)),
          DecoratedBox(
            decoration: BoxDecoration(
                color: !isPicked ? sonaBlack.withOpacity(0.3) : sonaBlack),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isPicked)
                    Text(
                      widget.name!,
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          !.copyWith(color: Colors.white),
                    ),
                  if (!isPicked) const VerticalSpacing(of: 10),
                  if (!isPicked)
                    Text(
                      "Calling...".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  if (!isPicked) const Spacer(),
                  if (isPicked)
                    Expanded(
                        child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppBar(
                            elevation: 0,
                            automaticallyImplyLeading: false,
                            backgroundColor: sonaBlack,
                            flexibleSpace: SafeArea(
                              child: Row(
                                children: <Widget>[
                                  if (!isPicked)
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.arrow_back_ios,
                                          color: Colors.white, size: 20),
                                    ),
                                  if (isPicked) const SizedBox(width: 35),
                                  Expanded(
                                    child: Center(
                                      child: Text(widget.name!,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white)),
                                    ),
                                  ),
                                  Image.asset(
                                    AppAssets.person_add_alt_1,
                                    width: 30,
                                    fit: BoxFit.contain,
                                    repeat: ImageRepeat.noRepeat,
                                  ),
                                  const SizedBox(width: 13),
                                ],
                              ),
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.65,
                              child: Stack(
                                children: [
                                  Container(
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                        child: VideoTrackRenderer(_room.participants[1]!.trackPublications[0]!.track  as VideoTrack)),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          top: 20, right: 40),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2),
                                              width: 70,
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  border: Border.all(
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(16))),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  CallTimerContainer(
                                                      label: 'HRS',
                                                      value: hours != null
                                                          ? (hours)
                                                              .toString()
                                                              .padLeft(2, '0')
                                                          : '00'),
                                                  CallTimerContainer(
                                                      label: ':', value: ':'),
                                                  CallTimerContainer(
                                                      label: 'MIN',
                                                      value: minutes != null
                                                          ? (minutes)
                                                              .toString()
                                                              .padLeft(2, '0')
                                                          : '00'),
                                                  CallTimerContainer(
                                                      label: ':', value: ':'),
                                                  CallTimerContainer(
                                                      label: 'SEC',
                                                      value: seconds != null
                                                          ? (seconds)
                                                              .toString()
                                                              .padLeft(2, '0')
                                                          : '00'),
                                                ],
                                              )),
                                          AnimatedOpacity(
                                              opacity: muteToggle ? 1 : 0.0,
                                              duration:
                                                  const Duration(seconds: 1),
                                              child: Image.asset(
                                                AppAssets.muteIndicator,
                                                width: 35.w,
                                                height: 35.w,
                                              ))
                                        ],
                                      )),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: SizedBox(
                                      width: 120,
                                      height: 150,
                                      child: Center(
                                          child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.zero,
                                            topRight: Radius.zero,
                                            bottomLeft: Radius.zero,
                                            bottomRight: Radius.circular(32.0)),
                                        child: Stack(
                                          children: [
                                            VideoTrackRenderer(_room.participants[1]!.trackPublications[0]!.track  as VideoTrack),
                                            if (cameraToggle)
                                              Container(
                                                child: Center(
                                                  child: AnimatedOpacity(
                                                      opacity:
                                                      0.3,
                                                      duration: Duration(
                                                          seconds: 3),
                                                      child: Icon(
                                                        Icons.videocam_off_sharp,
                                                        color: Colors.white,
                                                        size: 40,
                                                      )),
                                                )),
                                            if (cameraToggle)
                                              DecoratedBox(
                                              decoration: BoxDecoration(
                                                  color: sonaBlack.withOpacity(0.7)),
                                            )
                                          ],
                                        ),
                                      )),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    )),
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
                          InkWell(
                              onTap: () {
                                _onToggleCamera();
                              },
                              child: AnimatedOpacity(
                                  opacity: !isPicked ? 0.3 : 1,
                                  duration: const Duration(seconds: 3),
                                  child: Icon(
                                    cameraToggle
                                        ? Icons.videocam
                                        : Icons.videocam_off_sharp,
                                    color: Colors.white,
                                    size: 26,
                                  ))),
                          InkWell(
                              onTap: () {
                                if (isPicked) _onToggleMute();
                              },
                              child: AnimatedOpacity(
                                  opacity: !isPicked ? 0.3 : 1,
                                  duration: const Duration(seconds: 3),
                                  child: Icon(
                                    muteToggle ? Icons.mic : Icons.mic_off,
                                    color: Colors.white,
                                    size: 26,
                                  ))),
                          InkWell(
                              onTap: () {
                                // incallManager.stopRingback();
                                // incallManager.stop(busytone: "_DTMF_");
                                Navigator.pop(context);
                                _listener.dispose();
                                _room.removeListener(_onChange);
                              },
                              child: Image.asset(
                                AppAssets.endCall,
                                width: 50,
                                fit: BoxFit.contain,
                                repeat: ImageRepeat.noRepeat,
                              )),
                          InkWell(
                              onTap: () {
                                _onToggleSpeaker();
                              },
                              child: Icon(
                                speakerToggle
                                    ? Icons.volume_up
                                    : Icons.volume_off,
                                color: Colors.white,
                                size: 26,
                              )),
                          InkWell(
                              onTap: () {},
                              child: AnimatedOpacity(
                                  opacity: !isPicked ? 0.3 : 1,
                                  duration: const Duration(seconds: 3),
                                  child: Image.asset(
                                    AppAssets.chat,
                                    width: 25,
                                    fit: BoxFit.contain,
                                    repeat: ImageRepeat.noRepeat,
                                  ))),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
