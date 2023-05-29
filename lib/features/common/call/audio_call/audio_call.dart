import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonalysis/core/config/config.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/enums/messaging_type.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/navigation/keys.dart';
import 'package:sonalysis/core/navigation/navigation_service.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/helpers.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/features/common/cubit/common_cubit.dart';
import 'package:sonalysis/features/common/models/AddParticipantsModel.dart';
import 'package:sonalysis/style/styles.dart';

import '../components/CallTimerContainer.dart';
import '../components/audio_user_pic.dart';
import '../size_config.dart';

class AudioCall extends StatefulWidget {
  final Map? data;

  const AudioCall({Key? key, this.data}) : super(key: key);

  @override
  _AudioCallState createState() => _AudioCallState();
}

class _AudioCallState extends State<AudioCall> {
  bool isPicked = false;
  bool speakerActive = true;
  bool cameraOff = false;
  bool muteToggle = false;
  bool speakerToggle = false;
  bool iJoined = false;
  DateTime now = DateTime.now();
  double? maxSecondsUseable;
  int secondsPassed = 0;
  static const duration = Duration(seconds: 1);
  int seconds = 00, minutes = 00, hours = 00;
  Timer? _timer;
  //IncallManager incallManager = new IncallManager();
  late final EventsListener<RoomEvent> _listener;
  UserResultData? userResultData;
  AddParticipantsModel? addParticipantsModel;
  late Room _room;
  RoomOptions? roomOptions = RoomOptions(
  adaptiveStream: true,
  dynacast: true,
  );


  @override
  void initState() {
    super.initState();
    if (widget.data!["isOutgoing"]) {
      doOutgoingData();
    } else {
      doReceivingData();
    }
  }

  Future<void> doReceivingData() async {
print("doReceivingData: "+widget.data!["livekitToken"]);
    //create the engine
    _room = await LiveKitClient.connect(AppConfig.liveKitUrl, widget.data!["livekitToken"], roomOptions: roomOptions);
    setState(() {
      isPicked = true;
    });
print("doReceivingData2");
// try {
    //   // video will fail when running in ios simulator
    //   await room.localParticipant?.setCameraEnabled(true);
    // } catch (error) {
    //   print('Could not publish video, error: $error');
    // }
    _listener = _room.createListener();

    // used for generic change updates
    _room.addListener(_onChange);

    // used for specific events
    _listener
      ..on<RoomDisconnectedEvent>((_) {
        // handle disconnect
        print("you left room");
      })
      ..on<ParticipantConnectedEvent>((e) {
        print("participant joined: ${e.participant.identity}");
        //check that its not me
        isPicked = true;
        handleTick();
      })
      ..on<ParticipantDisconnectedEvent>((e) {
        print("participant left: ${e.participant.identity}");
      });
    handleTick();
  }

  Future<void> doOutgoingData() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();
    
    userResultData = await serviceLocator.get<LocalStorage>().readSecureObject(LocalStorageKeys.kUserPrefs);

    //create and add caller to room
    await serviceLocator<CommonCubit>().createPrivateRoomAddParticipant(userResultData!.user!.id!, widget.data!["userId"], MessagingType.audioCall.type);
    print("done with: createPrivateRoomAddParticipant");

    addParticipantsModel = serviceLocator.get<AddParticipantsModel>();


    //create the engine
    _room = await LiveKitClient.connect(AppConfig.liveKitUrl, addParticipantsModel!.data!.livekitToken!, roomOptions: roomOptions);

    // try {
      //   // video will fail when running in ios simulator
      //   await room.localParticipant?.setCameraEnabled(true);
      // } catch (error) {
      //   print('Could not publish video, error: $error');
      // }
    _listener = _room.createListener();

    // used for generic change updates
    _room.addListener(_onChange);

    // used for specific events
    _listener
      ..on<RoomDisconnectedEvent>((_) {
        // handle disconnect
        print("you left room");
      })
      ..on<ParticipantConnectedEvent>((e) {
        print("participant joined: ${e.participant.identity}");
        //check that its not me
        isPicked = true;
        handleTick();
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


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: BlocListener(
        bloc: serviceLocator.get<CommonCubit>(),
        listener: (_, state) {
          if (state is CreatePrivateRoomAddParticipantLoading) {
            //context.loaderOverlay.show();
          }

          if (state is CreatePrivateRoomAddParticipantError) {
            //context.loaderOverlay.hide();
            // Navigator.pop(context);
            // if (_listener != null) _listener.dispose();
            // if (_room != null) _room.removeListener(_onChange);
            // ResponseMessage.showErrorSnack(context: context, message: state.message);
          }

          if (state is CreatePrivateRoomAddParticipantSuccess) {
            //context.loaderOverlay.hide();
            setState(() {
              addParticipantsModel = serviceLocator.get<AddParticipantsModel>();
              //print("filename:::::: "+videoListResponseModel!.data!.videosListResponseModelData![0].filename.toString());

            });
          }
        },
        child: Stack(
        fit: StackFit.expand,
        children: [
          if (!isPicked)
            Image.network(
              widget.data!["imageUrl"],
              fit: BoxFit.cover,
            ),
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
                  if ( isPicked)
                    Text(
                      widget.data!["name"],
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
                                  Expanded(
                                    child: Container(),
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
                          Text(widget.data!["name"],
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
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
                          const SizedBox(height: 100),
                          SizedBox(
                              width: 180,
                              child: Stack(
                                children: [
                                  AudioUserPic(
                                    size: 200,
                                    image: widget.data!["imageUrl"],
                                  ),
                                  if (muteToggle)
                                    Positioned(
                                        left: 140,
                                        top: 130,
                                        child: Image.asset(
                                          AppAssets.muteIndicator,
                                          width: 35.w,
                                          height: 35.w,
                                        ))
                                ],
                              ))
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
                                //_onToggleCamera();
                              },
                              child: AnimatedOpacity(
                                  opacity: !isPicked ? 0.3 : 1,
                                  duration: const Duration(seconds: 3),
                                  child: const Icon(
                                    Icons.videocam_off_sharp,
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
                                serviceLocator.get<LocalStorage>().clearOnly(LocalStorageKeys.kUserIncomingCallPrefsNameCaller);
                                serviceLocator.get<LocalStorage>().clearOnly(LocalStorageKeys.kUserIncomingCallPrefsId);
                                serviceLocator.get<LocalStorage>().clearOnly(LocalStorageKeys.kUserIncomingCallPrefsAvatar);
                                serviceLocator.get<LocalStorage>().clearOnly(LocalStorageKeys.kUserIncomingCallPrefsCallType);
                                Navigator.pop(context);
                                if (!widget.data!["isOutgoing"]) {
                                  serviceLocator.get<NavigationService>().clearAllTo(RouteKeys.routeSplash);
                                }
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
    ));
  }
}
