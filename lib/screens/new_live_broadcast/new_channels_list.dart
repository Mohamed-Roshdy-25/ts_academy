import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ts_academy/components/compnenets.dart';
import 'package:ts_academy/constants/color_constants.dart';
import 'package:ts_academy/constants/constants.dart';
import 'package:ts_academy/controller/auth_cubit/registeration.dart';
import 'package:ts_academy/screens/new_live_broadcast/cubit/cubit.dart';
import 'package:ts_academy/screens/new_live_broadcast/cubit/states.dart';
import 'utils/permission.dart';
import 'live_page.dart';

class NewChannelsList extends StatefulWidget {
  const NewChannelsList({Key? key, required this.localUserID, required this.localUserName}) : super(key: key);

  final String localUserID;
  final String localUserName;

  @override
  State<NewChannelsList> createState() => _NewChannelsListState();
}

class _NewChannelsListState extends State<NewChannelsList> {
  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ZegoCloudCubit, ZegoCloudStates>(
      listener: (context, state) async {
        if (state is CreateRoomInBackendSuccessState) {
          await ZegoCloudCubit.get(context).getRoomDetails(roomId: state.roomId).then((value) {
            Navigator.pop(context);
            jumpToLivePage(
              context,
              isHost: true,
              localUserID: widget.localUserID,
              localUserName: widget.localUserName,
              roomID: state.roomId,
            );
          });
        }
      },
      builder: (context, state) {
        ZegoCloudCubit zegoCloudCubit = BlocProvider.of(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "live_list".tr(),
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.purple,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "create_live".tr(),
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 8,
                ),
                GestureDetector(
                    onTap: () {
                      showMyBottomSheet(
                        context: context,
                        bgColor: Colors.white,
                        child: CreateRoomBottomSheet(),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        "create_button".tr(),
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    )),
                const SizedBox(
                  height: 25,
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    "active_lives".tr(),
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                if (zegoCloudCubit.selectRoomsDorAdmin != null)
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: Colors.black87,
                          thickness: 0.8,
                        );
                      },
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(zegoCloudCubit.selectRoomsDorAdmin!.message![index].roomName!),
                          subtitle: Text(zegoCloudCubit.selectRoomsDorAdmin!.message![index].description!),
                          onTap: () async {
                            await ZegoCloudCubit.get(context)
                                .getRoomDetails(roomId: zegoCloudCubit.selectRoomsDorAdmin!.message![index].roomId!)
                                .then((value) {
                              if (zegoCloudCubit.selectRoomsDorAdmin!.message![index].userData!.studentId == stuId) {
                                jumpToLivePage(
                                  context,
                                  isHost: true,
                                  localUserID: widget.localUserID,
                                  localUserName: widget.localUserName,
                                  roomID: zegoCloudCubit.selectRoomsDorAdmin!.message![index].roomId!,
                                );
                              } else {
                                jumpToLivePage(
                                  context,
                                  isHost: false,
                                  localUserID: widget.localUserID,
                                  localUserName: widget.localUserName,
                                  roomID: zegoCloudCubit.selectRoomsDorAdmin!.message![index].roomId!,
                                );
                              }
                            });
                          },
                          leading: const Icon(
                            Icons.live_tv,
                            color: Colors.red,
                          ),
                        );
                      },
                      itemCount: zegoCloudCubit.selectRoomsDorAdmin!.message!.length,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void jumpToLivePage(
  BuildContext context, {
  required String roomID,
  required bool isHost,
  required String localUserID,
  required String localUserName,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => LivePage(
        isHost: isHost,
        localUserID: localUserID,
        localUserName: localUserName,
        roomID: roomID,
      ),
    ),
  );
}

class CreateRoomBottomSheet extends StatefulWidget {
  const CreateRoomBottomSheet({super.key});

  @override
  State<CreateRoomBottomSheet> createState() => _CreateRoomBottomSheetState();
}

class _CreateRoomBottomSheetState extends State<CreateRoomBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController channelNameController = TextEditingController();
  final TextEditingController channelDesController = TextEditingController();
  List<String> roomVisibility = ['For all Students'.tr(), "For university's students".tr()];
  String selectedRoomVisibility = "";
  String selectedUniversities = "";
  @override
  void initState() {
    BlocProvider.of<RegistrationCubit>(context).getUniversities();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ZegoCloudCubit, ZegoCloudStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ZegoCloudCubit zegoCloudCubit = BlocProvider.of(context);
        return Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Live Name".tr(), style: Theme.of(context).textTheme.bodyMedium),
                SizedBox(
                  height: 10,
                ),
                myTextFormField(
                  controller: channelNameController,
                  context: context,
                  radius: 8,
                  fillColor: ColorConstants.semiWhite,
                  hint: "Enter Live Name".tr(),
                  validate: (String? value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Live Name'.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Live Description".tr(), style: Theme.of(context).textTheme.bodyMedium),
                SizedBox(
                  height: 10,
                ),
                myTextFormField(
                  controller: channelDesController,
                  context: context,
                  radius: 8,
                  fillColor: ColorConstants.semiWhite,
                  hint: "Enter Live Description".tr(),
                  validate: (String? value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Live Description'.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                myDropDownButton(
                    context: context,
                    dropMenuItems: roomVisibility,
                    selectedValue: selectedRoomVisibility,
                    hintText: "choose live visibility".tr(),
                    onChange: (value) {
                      setState(() {
                        selectedRoomVisibility = value.toString();
                      });
                    }),
                SizedBox(
                  height: 10,
                ),
                if (selectedRoomVisibility == "For university's students".tr())
                  myDropDownButton(
                      context: context,
                      dropMenuItems: BlocProvider.of<RegistrationCubit>(context).universitiesName,
                      selectedValue: selectedUniversities,
                      hintText: "choose university".tr(),
                      onChange: (value) {
                        setState(() {
                          selectedUniversities = value.toString();
                        });
                      }),
                SizedBox(
                  height: 20,
                ),
                if(state is! CreateRoomInBackendLoadingState)
                  myMaterialButton(
                    context: context,
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        if(selectedRoomVisibility == 'For all Students'.tr()){
                          await zegoCloudCubit.createRoomInBackend(
                            context: context,
                            description: channelDesController.text,
                            roomName: channelNameController.text,
                            roomType: "all",
                          );
                        }else{
                          await zegoCloudCubit.createRoomInBackend(
                            context: context,
                            description: channelDesController.text,
                            roomName: channelNameController.text,
                            roomType: "custom_university",
                            universityId: BlocProvider.of<RegistrationCubit>(context).universities.firstWhere((element) => element.universityName == selectedUniversities).universityId,
                          );
                        }
                      }
                    },
                    radius: 24,
                    height: 48,
                    bgColor: ColorConstants.lightBlue,
                    borderColor: ColorConstants.lightBlue,
                    labelWidget: Text("Create Live".tr(), style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white)),
                  ),
                if(state is CreateRoomInBackendLoadingState)
                  Center(child: CircularProgressIndicator(),),
              ],
            ),
          ),
        );
      },
    );
  }
}
