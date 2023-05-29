
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sonalysis/core/datasource/key.dart';
import 'package:sonalysis/core/datasource/local_storage.dart';
import 'package:sonalysis/core/models/response/PlayerListResponseModel.dart';
import 'package:sonalysis/core/models/response/UserResultModel.dart';
import 'package:sonalysis/core/startup/app_startup.dart';
import 'package:sonalysis/core/utils/helpers.dart';
import 'package:sonalysis/core/utils/images.dart';
import 'package:sonalysis/core/utils/response_message.dart';
import 'package:sonalysis/features/common/call/misc/new_call_all_list.dart';
import 'package:sonalysis/features/common/cubit/common_cubit.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:sonalysis/widgets/custom_search_texbox.dart';

class NewCallContactListModalWidget extends StatefulWidget {

  const NewCallContactListModalWidget({Key? key}) : super(key: key);

  @override
  _NewCallContactListModalWidgetState createState() => _NewCallContactListModalWidgetState();
}

class _NewCallContactListModalWidgetState extends State<NewCallContactListModalWidget> {

  List<String?> searchableList = [];
  bool isLoading = true;

  late UserResultData userResultData;
  PlayerListResponseModel? playersListResponseModel;
  //late List<String?> searchableList;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    userResultData = (await serviceLocator.get<LocalStorage>().readSecureObject(LocalStorageKeys.kUserPrefs))!;
    // print("Token::: "+userResultData!.user!.clubs!.length.toString());
    // print("Token2::: "+userResultData!.user!.clubs![0].id.toString());
    await serviceLocator<CommonCubit>().getPlayerList(userResultData.user!.clubs![0].id!);
    setState(() {});


    // await DashboardController().getPlayerList(context, userLoginResultModel!.data!.user!.clubId!).then((value) {
    //   setState(() {
    //     isLoading = false;
    //   });
    //   playersListResponseModel = value;
    //   if (playersListResponseModel != null) {
    //     searchableList =  playersListResponseModel!.playerListResponseModelData!.map((el) => el.firstname).toList();
    //   }
    // });
  }


  @override
  Widget build(BuildContext context) {

    return Material(
        child: CupertinoPageScaffold(
          backgroundColor: Colors.transparent.withOpacity(0.9),
    child: BlocListener(
        bloc: serviceLocator.get<CommonCubit>(),
        listener: (_, state) {
          if (state is PlayerListLoading) {
            setState(() {
              isLoading = true;
            });
            context.loaderOverlay.show();
          }

          if (state is PlayerListError) {
            setState(() {
              isLoading = false;
            });
            context.loaderOverlay.hide();
            ResponseMessage.showErrorSnack(context: context, message: state.message);
          }

          if (state is PlayerListSuccess) {
            context.loaderOverlay.hide();
            setState(() {
              isLoading = false;
              playersListResponseModel = serviceLocator.get<PlayerListResponseModel>();
              searchableList =  playersListResponseModel!.playerListResponseModelData!.map((el) => el.firstName).toList();
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
                  Text("New Call",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 17.sp)),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Boxicons.bx_x))
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
              if (playersListResponseModel!.playerListResponseModelData!.isNotEmpty)
              ListView.builder(
                  itemCount: playersListResponseModel!.playerListResponseModelData!.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 16),
                  itemBuilder: (context, index){
                    return NewCallAllList(
                      name: playersListResponseModel!.playerListResponseModelData![index].firstName! + " " + playersListResponseModel!.playerListResponseModelData![index].lastName!,
                      userId: playersListResponseModel!.playerListResponseModelData![index].userId!,
                      imageUrl: displayPicture,
                      role: "Player",
                      isOnline: (index == 0 || index == 2) ? true:false,
                    );
                  },
                ),
              if (playersListResponseModel!.playerListResponseModelData!.isEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Image.asset(
                    AppAssets.noPlayer,
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.noRepeat,
                  ),
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
