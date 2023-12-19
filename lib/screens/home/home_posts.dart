import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ts_academy/components/compnenets.dart';
import 'package:ts_academy/components/functions.dart';
import 'package:ts_academy/controller/student_posts_comments/comments.dart';
import 'package:ts_academy/screens/new_live_broadcast/cubit/cubit.dart';
import 'package:ts_academy/screens/new_live_broadcast/cubit/states.dart';
import 'package:ts_academy/screens/new_live_broadcast/key_center.dart';
import 'package:ts_academy/screens/new_live_broadcast/new_channels_list.dart';
import 'package:ts_academy/screens/new_live_broadcast/utils/permission.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import '../../controller/permission_cubit/permission_cubit.dart';
import '../../models/stutent_posts.dart';
import '../../modules/exit_popup.dart';
import '/constants/string_constants.dart';
import '/modules/description_text.dart';
import '/modules/modules.dart';
import '../../constants/constants.dart';
import '../../constants/color_constants.dart';
import '../../constants/font_constants.dart';
import '../../constants/image_constants.dart';
import '../../controller/student_posts/student_posts_cubit.dart';
import 'all_Post_photo_screen.dart';
import 'comments_page.dart';
import 'create_post_screen.dart';

class PostHeader extends StatefulWidget {
  const PostHeader({Key? key, required this.finalTime}) : super(key: key);
  final String finalTime;

  @override
  State<PostHeader> createState() => _PostHeaderState();
}

class _PostHeaderState extends State<PostHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Image.asset(
                ImagesConstants.logo,
                scale: 2.5,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              ''' ${StringConstants.appName}''',
              style: TextStyle(fontFamily: FontConstants.poppins, fontWeight: FontWeight.w700, fontSize: 13),
            ),
            Text(
              widget.finalTime,
              style: TextStyle(fontFamily: FontConstants.poppins, color: Colors.grey[400], fontSize: 11),
            )
          ],
        ),
        const Spacer(),
        const SizedBox(width: 7),
      ],
    );
  }
}

class MyImageWidget extends StatefulWidget {
  final List<ImagePostModel> imageUrl;
  final int index;

  const MyImageWidget({required this.imageUrl, required this.index});

  @override
  _MyImageWidgetState createState() => _MyImageWidgetState();
}

class _MyImageWidgetState extends State<MyImageWidget> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Call super.build(context) to enable the AutomaticKeepAliveClientMixin

    return InkWell(
      onTap: () {
        widget.imageUrl.length == 1
            ? Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => OpenImage(imageUrl: widget.imageUrl[0].imageUrl)))
            : Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AllPostsPhoto(
                    postImages: widget.imageUrl,
                    postImagesCount: 1,
                  ),
                ),
              );
      },
      child: widget.imageUrl.length > 4 && widget.index == 3
          ? Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl[widget.index].imageUrl,
                    placeholder: (ctx, builder) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: ColorConstants.lightBlue,
                      ));
                    },
                    errorWidget: (a, b, c) {
                      return const Icon(Icons.error, color: Colors.red);
                    },
                  ),
                ),
                Positioned(
                  bottom: 30,
                  right: 30,
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    elevation: 5,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        "+${widget.imageUrl.length - 4}",
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            )
          : Container(
              height: 50.h,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl[widget.index].imageUrl,
                height: 50.h,
                placeholder: (ctx, builder) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: ColorConstants.lightBlue,
                  ));
                },
                errorWidget: (a, b, c) {
                  return const Icon(Icons.error, color: Colors.red);
                },
              ),
            ),
    );
  }
}

class HomeScreenPosts extends StatefulWidget {
  const HomeScreenPosts({Key? key}) : super(key: key);

  @override
  _HomeScreenPostsState createState() => _HomeScreenPostsState();
}

class _HomeScreenPostsState extends State<HomeScreenPosts> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PermissionCubit>(context).getUserPermission(stuId!);
    requestPermission();
    Future.delayed(Duration.zero, () {
      BlocProvider.of<StudentPostsCubit>(context).getAllPosts(stuId: stuId!);
      BlocProvider.of<PermissionCubit>(context).getUserPermission(stuId!);
    });
  }

  String postId = "1";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        appBar: Modules().appBar(tr(StringConstants.home)),
        body: BlocConsumer<ZegoCloudCubit, ZegoCloudStates>(
          listener: (context, state) {},
          builder: (context, state) {
            ZegoCloudCubit zegoCloudCubit = BlocProvider.of(context);
            return BlocConsumer<CommentsCubit, CommentsState>(
              listener: (context, state) {},
              builder: (context, state) {
                CommentsCubit commentsCubit = BlocProvider.of(context);
                return BlocConsumer<StudentPostsCubit, StudentPostsState>(
                  listener: (context, state) {
                    debugPrint(
                        "list of Likes  =  ${BlocProvider.of<StudentPostsCubit>(context).stdPostLikes.toString()}");
                    if (state is StudentPostsFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ));
                    }
                  },
                  builder: (context, state) {
                    return state is StudentPostsLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: ColorConstants.purpal,
                            ),
                          )
                        : SingleChildScrollView(
                          child: Column(
                              children: [
                                if(BlocProvider.of<PermissionCubit>(context).postLivePermission.contains("post"))
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const CreatePostScreen(),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(13, 13, 13, 0),
                                      child: Material(
                                        elevation: 4,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    ImagesConstants.editPost,
                                                    scale: 2.5,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    tr(StringConstants.create_post),
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontFamily: FontConstants.poppins,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    ImagesConstants.video,
                                                    scale: 2.5,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Image.asset(
                                                    ImagesConstants.image,
                                                    scale: 3.5,
                                                  ),
                                                  const SizedBox(width: 10),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                if(BlocProvider.of<PermissionCubit>(context).postLivePermission.contains("post"))
                                  SizedBox(height: 12,),
                                if(BlocProvider.of<PermissionCubit>(context).postLivePermission.contains("live"))
                                  GestureDetector(
                                    onTap: () async {
                                      await createEngine();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NewChannelsList(
                                            localUserID: stuId!,
                                            localUserName: myName!,
                                          ),
                                        ),
                                      );
                                    },
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Material(
                                        // borderRadius: BorderRadius.circular(8),
                                        color: Colors.red[800],
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 13),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                ImagesConstants.liveVideo,
                                                scale: 3,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                tr(StringConstants.liveStreaming),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: FontConstants.poppins,
                                                  fontSize: 12,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (zegoCloudCubit.selectRoomsForStudents != null)
                                  ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      DateTime postDate = DateTime.parse(zegoCloudCubit.selectRoomsForStudents!.message![index].createDate!);
                                      String formattedTimeDifference = formatTimeDifference(postDate);
                                      return Card(
                                        margin: EdgeInsets.symmetric(vertical: 16),
                                        elevation: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor: Colors.white,
                                                    child: Center(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(3),
                                                        child: Image.asset(
                                                          ImagesConstants.logo,
                                                          scale: 2.5,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Text(
                                                        '''${StringConstants.appName}''',
                                                        style: TextStyle(
                                                            fontFamily: FontConstants.poppins,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 13),
                                                      ),
                                                      Text(
                                                        formattedTimeDifference,
                                                        style: TextStyle(
                                                            fontFamily: FontConstants.poppins,
                                                            color: Colors.grey[400],
                                                            fontSize: 11),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              DescriptionTextWidget(
                                                text: zegoCloudCubit.selectRoomsForStudents!.message![index].roomName!,
                                                textColor: Colors.black,
                                              ),
                                              DescriptionTextWidget(
                                                text: zegoCloudCubit.selectRoomsForStudents!.message![index].description!,
                                                textColor: Colors.grey,
                                              ),
                                              Stack(
                                                alignment: Alignment.bottomLeft,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.all(Radius.circular(6)),
                                                    child: Image.asset("assets/images/live poster.jpg"),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        bottom: 80, left: 22),
                                                    child: SizedBox(
                                                      width: 120,
                                                      child: Text(
                                                        zegoCloudCubit
                                                            .selectRoomsForStudents!.message![index].roomName!,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              myMaterialButton(
                                                context: context,
                                                height: 40,
                                                radius: 6,
                                                onPressed: () async {
                                                  requestPermission();
                                                  await createEngine();
                                                  await zegoCloudCubit
                                                      .getRoomDetails(
                                                      roomId: zegoCloudCubit
                                                          .selectRoomsForStudents!.message![index].roomId!)
                                                      .then((value) {
                                                    if (zegoCloudCubit.selectRoomsForStudents!.message![index]
                                                        .userData!.studentId ==
                                                        stuId) {
                                                      jumpToLivePage(
                                                        context,
                                                        isHost: true,
                                                        localUserID: stuId!,
                                                        localUserName: myName!,
                                                        roomID: zegoCloudCubit
                                                            .selectRoomsForStudents!.message![index].roomId!,
                                                      );
                                                    } else {
                                                      jumpToLivePage(
                                                        context,
                                                        isHost: false,
                                                        localUserID: stuId!,
                                                        localUserName: myName!,
                                                        roomID: zegoCloudCubit
                                                            .selectRoomsForStudents!.message![index].roomId!,
                                                      );
                                                    }
                                                  });
                                                },
                                                labelWidget: Text(
                                                  "Join_Live".tr(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) => SizedBox(
                                      height: 10,
                                    ),
                                    itemCount: zegoCloudCubit.selectRoomsForStudents!.message!.length,
                                  ),
                                BlocProvider.of<StudentPostsCubit>(context).stdPost.isEmpty
                                    ? Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Lottie.asset('assets/lottie/nothing.json'),
                                        Text(tr(StringConstants.there_is_no_posts_until_now)),
                                      ],
                                    )
                                    : Column(
                                      children: [
                                        ListView.separated(
                                          physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: BlocProvider.of<StudentPostsCubit>(context).stdPost.length,
                                          itemBuilder: (context, index) {
                                            DateTime postDate = DateTime.parse(BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postDate);
                                            String formattedTimeDifference = formatTimeDifference(postDate);
                                            return Material(
                                              elevation: 4,
                                              borderRadius: BorderRadius.circular(10),
                                              child: Padding(
                                                padding: const EdgeInsets.all(10),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    PostHeader(
                                                      finalTime: formattedTimeDifference,
                                                    ),
                                                    DescriptionTextWidget(
                                                      text: BlocProvider.of<StudentPostsCubit>(context)
                                                          .stdPost[index]
                                                          .postContent,
                                                    ),
                                                    BlocProvider.of<StudentPostsCubit>(context)
                                                            .stdPost[index]
                                                            .postsImage
                                                            .isEmpty
                                                        ? const SizedBox()
                                                        : SizedBox(
                                                            height: 250.h,
                                                            child: GridView.builder(
                                                              itemCount: BlocProvider.of<StudentPostsCubit>(
                                                                              context)
                                                                          .stdPost[index]
                                                                          .postsImage
                                                                          .length >
                                                                      4
                                                                  ? 4
                                                                  : BlocProvider.of<StudentPostsCubit>(context)
                                                                      .stdPost[index]
                                                                      .postsImage
                                                                      .length,
                                                              itemBuilder: (context, i) {
                                                                return MyImageWidget(
                                                                  index: i,
                                                                  imageUrl:
                                                                      BlocProvider.of<StudentPostsCubit>(context)
                                                                          .stdPost[index]
                                                                          .postsImage,
                                                                );
                                                              },
                                                              physics: const NeverScrollableScrollPhysics(),
                                                              gridDelegate:
                                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    BlocProvider.of<StudentPostsCubit>(context)
                                                                                .stdPost[index]
                                                                                .postsImage
                                                                                .length ==
                                                                            1
                                                                        ? 1
                                                                        : 2,
                                                                crossAxisSpacing: 8,
                                                                childAspectRatio:
                                                                    BlocProvider.of<StudentPostsCubit>(context)
                                                                                    .stdPost[index]
                                                                                    .postsImage
                                                                                    .length ==
                                                                                1 ||
                                                                            BlocProvider.of<StudentPostsCubit>(
                                                                                        context)
                                                                                    .stdPost[index]
                                                                                    .postsImage
                                                                                    .length ==
                                                                                2
                                                                        ? 1
                                                                        : 1.5,
                                                                mainAxisSpacing: 8,
                                                              ),
                                                            ),
                                                          ),
                                                    Padding(
                                                      padding: const EdgeInsets.fromLTRB(7, 12, 7, 0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          GestureDetector(
                                                              onTap: () {
                                                                debugPrint(
                                                                    BlocProvider.of<StudentPostsCubit>(context)
                                                                        .numberLikes
                                                                        .toString());
                                                                debugPrint(
                                                                    BlocProvider.of<StudentPostsCubit>(context)
                                                                        .stdPostLikes
                                                                        .toString());
                                                                debugPrint(
                                                                    "_______________________________________________________________");
                                                                BlocProvider.of<StudentPostsCubit>(context)
                                                                    .changeLike(index);
                                                                debugPrint(
                                                                    BlocProvider.of<StudentPostsCubit>(context)
                                                                        .numberLikes
                                                                        .toString());
                                                                debugPrint(
                                                                    BlocProvider.of<StudentPostsCubit>(context)
                                                                        .stdPostLikes
                                                                        .toString());
                                                                BlocProvider.of<StudentPostsCubit>(context)
                                                                    .changeLikeCount(
                                                                        studentId: stuId!,
                                                                        postId:
                                                                            BlocProvider.of<StudentPostsCubit>(
                                                                                    context)
                                                                                .stdPost[index]
                                                                                .postId)
                                                                    .then((value) {
                                                                  print(
                                                                      BlocProvider.of<StudentPostsCubit>(context)
                                                                          .changeLikeStatus);
                                                                  print(
                                                                      BlocProvider.of<StudentPostsCubit>(context)
                                                                          .postId);
                                                                  print(
                                                                      BlocProvider.of<StudentPostsCubit>(context)
                                                                          .stdPost[index]
                                                                          .postId);
                                                                });
                                                              },
                                                              child: BlocProvider.of<StudentPostsCubit>(context)
                                                                          .stdPostLikes[index] ==
                                                                      false
                                                                  ? Row(
                                                                      children: [
                                                                        const CircleAvatar(
                                                                          backgroundColor: Colors.white,
                                                                          radius: 13,
                                                                          child: Icon(Icons.thumb_up_alt,
                                                                              color: Colors.grey, size: 22),
                                                                        ),
                                                                        Text(
                                                                          "${BlocProvider.of<StudentPostsCubit>(context).numberLikes[index]} ${tr(StringConstants.likes)}",
                                                                          style: const TextStyle(
                                                                              color: Colors.grey, fontSize: 12),
                                                                        )
                                                                      ],
                                                                    )
                                                                  : Row(
                                                                      children: [
                                                                        const CircleAvatar(
                                                                          radius: 13,
                                                                          child: Icon(Icons.thumb_up_alt_outlined,
                                                                              color: Colors.white, size: 16),
                                                                        ),
                                                                        const SizedBox(width: 8),
                                                                        Text(
                                                                          '${BlocProvider.of<StudentPostsCubit>(context).numberLikes[index]} ${tr(StringConstants.likes)}',
                                                                          style: const TextStyle(
                                                                              fontFamily: FontConstants.poppins,
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w700),
                                                                        )
                                                                      ],
                                                                    )),
                                                          InkWell(
                                                            onTap: () async {
                                                              showProgressIndicator(
                                                                  context: context, text: "انتظر");
                                                              setState(() {
                                                                postId =
                                                                    BlocProvider.of<StudentPostsCubit>(context)
                                                                        .stdPost[index]
                                                                        .postId;
                                                              });
                                                              await commentsCubit
                                                                  .getCommentsNew(
                                                                      postID: BlocProvider.of<StudentPostsCubit>(
                                                                              context)
                                                                          .stdPost[index]
                                                                          .postId)
                                                                  .then((value) {
                                                                Navigator.pop(context);
                                                                Navigator.of(context).push(
                                                                  MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        CommentsPage(postId: postId),
                                                                  ),
                                                                );
                                                              });
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                  ImagesConstants.comment,
                                                                  scale: 2.8,
                                                                ),
                                                                const SizedBox(width: 8),
                                                                Text(
                                                                  '${BlocProvider.of<StudentPostsCubit>(context).stdPost[index].commentsCount} ${tr(StringConstants.comments)}',
                                                                  style: const TextStyle(
                                                                      fontFamily: FontConstants.poppins,
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.w700),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          separatorBuilder: (BuildContext context, int index) {
                                            return SizedBox(
                                              height: 12.h,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                              ],
                            ),
                        );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> createEngine() async {
    WidgetsFlutterBinding.ensureInitialized();
    await ZegoExpressEngine.createEngineWithProfile(ZegoEngineProfile(
      appID,
      ZegoScenario.Broadcast,
      appSign: kIsWeb ? null : appSign,
    ));
  }
}
