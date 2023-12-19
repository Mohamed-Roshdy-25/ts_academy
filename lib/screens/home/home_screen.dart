// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '/constants/string_constants.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '/constants/color_constants.dart';
// import '/constants/font_constants.dart';
// import '/constants/image_constants.dart';
// import '/controller/student_posts/student_posts_cubit.dart';
// import '/modules/description_text.dart';
// import '/modules/modules.dart';
// import '../../constants/constants.dart';
// import 'package:lottie/lottie.dart';
// import '../../modules/exit_popup.dart';
// import 'create_post_screen.dart';
// import 'all_Post_photo_screen.dart';
// import 'package:timeago/timeago.dart' as timeAgo;
// import 'comments_page.dart';
// import 'image_post.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       BlocProvider.of<StudentPostsCubit>(context).getAllPosts(stuId: stuId!);
//     });
//   }
//
//   List<String> studentsIds = [];
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return WillPopScope(
//       onWillPop: () => showExitPopup(context),
//       child: Scaffold(
//         appBar: Modules().appBar(tr(StringConstants.home)),
//         body: SizedBox(
//             width: size.width,
//             height: size.height,
//             child: BlocConsumer<StudentPostsCubit, StudentPostsState>(
//               listener: (context, state) {
//                 debugPrint(
//                     "list of Likes  =  ${BlocProvider.of<StudentPostsCubit>(context).stdPostLikes.toString()}");
//                 if (state is StudentPostsFailure) {
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: Text(state.message),
//                     backgroundColor: Colors.red,
//                   ));
//                 }
//               },
//               builder: (context, state) {
//                 return state is StudentPostsLoading
//                     ? Center(
//                         child: CircularProgressIndicator(
//                           color: ColorConstants.purpal,
//                         ),
//                       )
//                     : BlocProvider.of<StudentPostsCubit>(context)
//                             .stdPost
//                             .isEmpty
//                         ? Align(
//                             alignment: Alignment.center,
//                             child: SingleChildScrollView(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Lottie.asset('assets/lottie/nothing.json'),
//                                   Text(tr(StringConstants
//                                       .there_is_no_posts_until_now)),
//                                 ],
//                               ),
//                             ),
//                           )
//                         : Column(
//                             children: [
//                               GestureDetector(
//                                 onTap: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               const CreatePostScreen()));
//                                 },
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(13, 13, 13, 0),
//                                   child: Material(
//                                     elevation: 4,
//                                     borderRadius: BorderRadius.circular(10),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(16),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Image.asset(
//                                                 ImagesConstants.editPost,
//                                                 scale: 2.5,
//                                               ),
//                                               const SizedBox(width: 10),
//                                               Text(
//                                                 tr(StringConstants.create_post),
//                                                 style: const TextStyle(
//                                                     fontSize: 10,
//                                                     fontFamily:
//                                                         FontConstants.poppins),
//                                               )
//                                             ],
//                                           ),
//                                           Row(
//                                             children: [
//                                               Image.asset(
//                                                 ImagesConstants.video,
//                                                 scale: 2.5,
//                                               ),
//                                               const SizedBox(width: 10),
//                                               Image.asset(
//                                                 ImagesConstants.image,
//                                                 scale: 3.5,
//                                               ),
//                                               const SizedBox(width: 10),
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: ListView.builder(
//                                     itemCount:
//                                         BlocProvider.of<StudentPostsCubit>(
//                                                 context)
//                                             .stdPost
//                                             .length,
//                                     // shrinkWrap: true,
//                                     physics: const BouncingScrollPhysics(),
//                                     itemBuilder: (context, index) {
//                                       int count = int.parse(
//                                           BlocProvider.of<StudentPostsCubit>(
//                                                   context)
//                                               .stdPost[index]
//                                               .likesCount);
//                                       print("count post ${index + 1} $count");
//                                       DateTime dt = DateTime.now();
//                                       String hourString =
//                                           BlocProvider.of<StudentPostsCubit>(
//                                                   context)
//                                               .stdPost[index]
//                                               .postDate;
//                                       Duration diff = dt.difference(
//                                           DateTime.parse(hourString));
//                                       final time = DateTime.now().subtract(Duration(
//                                           minutes: diff.inMinutes -
//                                               300)); // -300 to convert utc to our timezone
//                                       final finalTime = timeAgo.format(time);
//
//                                       return Padding(
//                                         padding: const EdgeInsets.fromLTRB(
//                                             13, 13, 13, 0),
//                                         child: Material(
//                                           elevation: 4,
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(10),
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 PostHeader(
//                                                   finalTime: finalTime,
//                                                 ),
//                                                 DescriptionTextWidget(
//                                                     text: BlocProvider.of<
//                                                                 StudentPostsCubit>(
//                                                             context)
//                                                         .stdPost[index]
//                                                         .postContent),
//                                                 BlocProvider.of<StudentPostsCubit>(
//                                                                 context)
//                                                             .stdPost[index]
//                                                             .postsImage
//                                                             .length ==
//                                                         1
//                                                     ? SizedBox(
//                                                         height: 200.h,
//                                                         width: MediaQuery.of(
//                                                                 context)
//                                                             .size
//                                                             .width,
//                                                         child: ImagePost(
//                                                           onTap: () {
//                                                             Navigator.of(context).push(
//                                                                 MaterialPageRoute(
//                                                                     builder:
//                                                                         (context) =>
//                                                                             OpenImage(
//                                                                               imageUrl: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage[0].imageUrl,
//                                                                             )));
//                                                           },
//                                                           imageUrl: BlocProvider
//                                                                   .of<StudentPostsCubit>(
//                                                                       context)
//                                                               .stdPost[index]
//                                                               .postsImage[0]
//                                                               .imageUrl,
//                                                         ),
//                                                       )
//                                                     : BlocProvider.of<StudentPostsCubit>(
//                                                                     context)
//                                                                 .stdPost[index]
//                                                                 .postsImage
//                                                                 .length ==
//                                                             2
//                                                         ? SizedBox(
//                                                             height: 200.h,
//                                                             width:
//                                                                 MediaQuery.of(
//                                                                         context)
//                                                                     .size
//                                                                     .width,
//                                                             child: Row(
//                                                               children: [
//                                                                 Expanded(
//                                                                     child: ImagePost(
//                                                                         imageUrl: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage[0].imageUrl,
//                                                                         onTap: () {
//                                                                           Navigator.of(context).push(MaterialPageRoute(
//                                                                               builder: (context) => AllPostsPhoto(
//                                                                                     postImages: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage,
//                                                                                     postImagesCount: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage.length,
//                                                                                   )));
//                                                                         })),
//                                                                 Expanded(
//                                                                     child: ImagePost(
//                                                                         imageUrl: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage[1].imageUrl,
//                                                                         onTap: () {
//                                                                           Navigator.of(context).push(MaterialPageRoute(
//                                                                               builder: (context) => AllPostsPhoto(
//                                                                                     postImages: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage,
//                                                                                     postImagesCount: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage.length,
//                                                                                   )));
//                                                                         }))
//                                                               ],
//                                                             ),
//                                                           )
//                                                         : BlocProvider.of<StudentPostsCubit>(
//                                                                         context)
//                                                                     .stdPost[
//                                                                         index]
//                                                                     .postsImage
//                                                                     .length ==
//                                                                 3
//                                                             ? SizedBox(
//                                                                 width: MediaQuery.of(
//                                                                         context)
//                                                                     .size
//                                                                     .width,
//                                                                 height: 200.h,
//                                                                 child: Row(
//                                                                   children: [
//                                                                     Expanded(
//                                                                       child:
//                                                                           Column(
//                                                                         children: [
//                                                                           Expanded(
//                                                                             child: ImagePost(
//                                                                                 imageUrl: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage[0].imageUrl,
//                                                                                 onTap: () {
//                                                                                   Navigator.of(context).push(MaterialPageRoute(
//                                                                                       builder: (context) => AllPostsPhoto(
//                                                                                             postImages: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage,
//                                                                                             postImagesCount: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage.length,
//                                                                                           )));
//                                                                                 }),
//                                                                           ),
//                                                                           Expanded(
//                                                                             child: ImagePost(
//                                                                                 imageUrl: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage[1].imageUrl,
//                                                                                 onTap: () {
//                                                                                   Navigator.of(context).push(MaterialPageRoute(
//                                                                                       builder: (context) => AllPostsPhoto(
//                                                                                             postImages: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage,
//                                                                                             postImagesCount: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage.length,
//                                                                                           )));
//                                                                                 }),
//                                                                           )
//                                                                         ],
//                                                                       ),
//                                                                     ),
//                                                                     Expanded(
//                                                                         child: ImagePost(
//                                                                             imageUrl: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage[2].imageUrl,
//                                                                             onTap: () {
//                                                                               Navigator.of(context).push(MaterialPageRoute(
//                                                                                   builder: (context) => AllPostsPhoto(
//                                                                                         postImages: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage,
//                                                                                         postImagesCount: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage.length,
//                                                                                       )));
//                                                                             }))
//                                                                   ],
//                                                                 ),
//                                                               )
//                                                             : BlocProvider.of<StudentPostsCubit>(
//                                                                             context)
//                                                                         .stdPost[
//                                                                             index]
//                                                                         .postsImage
//                                                                         .length ==
//                                                                     4
//                                                                 ? SizedBox(
//                                                                     width: MediaQuery.of(
//                                                                             context)
//                                                                         .size
//                                                                         .width,
//                                                                     height:
//                                                                         200.h,
//                                                                     child: Row(
//                                                                       children: [
//                                                                         Expanded(
//                                                                           child:
//                                                                               Column(
//                                                                             children: [
//                                                                               Expanded(
//                                                                                 child: ImagePost(
//                                                                                     imageUrl: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage[0].imageUrl,
//                                                                                     onTap: () {
//                                                                                       Navigator.of(context).push(MaterialPageRoute(
//                                                                                           builder: (context) => AllPostsPhoto(
//                                                                                                 postImages: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage,
//                                                                                                 postImagesCount: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage.length,
//                                                                                               )));
//                                                                                     }),
//                                                                               ),
//                                                                               Expanded(
//                                                                                 child: ImagePost(
//                                                                                     imageUrl: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage[1].imageUrl,
//                                                                                     onTap: () {
//                                                                                       Navigator.of(context).push(MaterialPageRoute(
//                                                                                           builder: (context) => AllPostsPhoto(
//                                                                                                 postImages: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage,
//                                                                                                 postImagesCount: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage.length,
//                                                                                               )));
//                                                                                     }),
//                                                                               )
//                                                                             ],
//                                                                           ),
//                                                                         ),
//                                                                         Expanded(
//                                                                           child:
//                                                                               Column(
//                                                                             children: [
//                                                                               Expanded(
//                                                                                 child: ImagePost(
//                                                                                     imageUrl: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage[2].imageUrl,
//                                                                                     onTap: () {
//                                                                                       Navigator.of(context).push(MaterialPageRoute(
//                                                                                           builder: (context) => AllPostsPhoto(
//                                                                                                 postImages: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage,
//                                                                                                 postImagesCount: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage.length,
//                                                                                               )));
//                                                                                     }),
//                                                                               ),
//                                                                               Expanded(
//                                                                                 child: ImagePost(
//                                                                                     imageUrl: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage[3].imageUrl,
//                                                                                     onTap: () {
//                                                                                       Navigator.of(context).push(MaterialPageRoute(
//                                                                                           builder: (context) => AllPostsPhoto(
//                                                                                                 postImages: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage,
//                                                                                                 postImagesCount: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage.length,
//                                                                                               )));
//                                                                                     }),
//                                                                               )
//                                                                             ],
//                                                                           ),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                   )
//                                                                 : BlocProvider.of<StudentPostsCubit>(context)
//                                                                             .stdPost[
//                                                                                 index]
//                                                                             .postsImage
//                                                                             .length ==
//                                                                         5
//                                                                     ? SizedBox(
//                                                                         width: MediaQuery.of(context)
//                                                                             .size
//                                                                             .width,
//                                                                         height:
//                                                                             200.h,
//                                                                         child:
//                                                                             Row(
//                                                                           children: [
//                                                                             Expanded(
//                                                                               child: Column(
//                                                                                 children: [
//                                                                                   Expanded(
//                                                                                     child: ImagePost(
//                                                                                         imageUrl: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage[0].imageUrl,
//                                                                                         onTap: () {
//                                                                                           Navigator.of(context).push(MaterialPageRoute(
//                                                                                               builder: (context) => AllPostsPhoto(
//                                                                                                     postImages: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage,
//                                                                                                     postImagesCount: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage.length,
//                                                                                                   )));
//                                                                                         }),
//                                                                                   ),
//                                                                                   Expanded(
//                                                                                     child: ImagePost(
//                                                                                         imageUrl: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage[1].imageUrl,
//                                                                                         onTap: () {
//                                                                                           Navigator.of(context).push(MaterialPageRoute(
//                                                                                               builder: (context) => AllPostsPhoto(
//                                                                                                     postImages: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage,
//                                                                                                     postImagesCount: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage.length,
//                                                                                                   )));
//                                                                                         }),
//                                                                                   )
//                                                                                 ],
//                                                                               ),
//                                                                             ),
//                                                                             Expanded(
//                                                                               child: Column(
//                                                                                 children: [
//                                                                                   Expanded(
//                                                                                     child: ImagePost(
//                                                                                       onTap: () {
//                                                                                         Navigator.of(context).push(MaterialPageRoute(
//                                                                                             builder: (context) => AllPostsPhoto(
//                                                                                                   postImages: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage,
//                                                                                                   postImagesCount: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage.length,
//                                                                                                 )));
//                                                                                       },
//                                                                                       imageUrl: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage[2].imageUrl,
//                                                                                     ),
//                                                                                   ),
//                                                                                   Expanded(
//                                                                                     child: ImagePost(
//                                                                                       onTap: () {
//                                                                                         Navigator.of(context).push(MaterialPageRoute(
//                                                                                             builder: (context) => AllPostsPhoto(
//                                                                                                   postImages: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage,
//                                                                                                   postImagesCount: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage.length,
//                                                                                                 )));
//                                                                                       },
//                                                                                       imageUrl: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage[3].imageUrl,
//                                                                                     ),
//                                                                                   ),
//                                                                                   Expanded(
//                                                                                     child: ImagePost(
//                                                                                       onTap: () {
//                                                                                         Navigator.of(context).push(MaterialPageRoute(
//                                                                                             builder: (context) => AllPostsPhoto(
//                                                                                                   postImages: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage,
//                                                                                                   postImagesCount: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage.length,
//                                                                                                 )));
//                                                                                       },
//                                                                                       imageUrl: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage[4].imageUrl,
//                                                                                     ),
//                                                                                   ),
//                                                                                 ],
//                                                                               ),
//                                                                             ),
//                                                                           ],
//                                                                         ),
//                                                                       )
//                                                                     : BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage.length >
//                                                                             5
//                                                                         ? SizedBox(
//                                                                             width:
//                                                                                 MediaQuery.of(context).size.width,
//                                                                             height:
//                                                                                 200.h,
//                                                                             child:
//                                                                                 Row(
//                                                                               children: [
//                                                                                 Expanded(
//                                                                                   child: Column(
//                                                                                     children: [
//                                                                                       Expanded(
//                                                                                         child: ImagePost(
//                                                                                           onTap: () {
//                                                                                             Navigator.of(context).push(MaterialPageRoute(
//                                                                                                 builder: (context) => AllPostsPhoto(
//                                                                                                       postImages: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage,
//                                                                                                       postImagesCount: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage.length,
//                                                                                                     )));
//                                                                                           },
//                                                                                           imageUrl: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage[0].imageUrl,
//                                                                                         ),
//                                                                                       ),
//                                                                                       Expanded(
//                                                                                         child: ImagePost(
//                                                                                           onTap: () {
//                                                                                             Navigator.of(context).push(MaterialPageRoute(
//                                                                                                 builder: (context) => AllPostsPhoto(
//                                                                                                       postImages: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage,
//                                                                                                       postImagesCount: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage.length,
//                                                                                                     )));
//                                                                                           },
//                                                                                           imageUrl: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage[1].imageUrl,
//                                                                                         ),
//                                                                                       ),
//                                                                                     ],
//                                                                                   ),
//                                                                                 ),
//                                                                                 Expanded(
//                                                                                   child: Column(
//                                                                                     children: [
//                                                                                       Expanded(
//                                                                                         child: ImagePost(
//                                                                                           onTap: () {
//                                                                                             Navigator.of(context).push(MaterialPageRoute(
//                                                                                                 builder: (context) => AllPostsPhoto(
//                                                                                                       postImages: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage,
//                                                                                                       postImagesCount: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage.length,
//                                                                                                     )));
//                                                                                           },
//                                                                                           imageUrl: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage[2].imageUrl,
//                                                                                         ),
//                                                                                       ),
//                                                                                       Expanded(
//                                                                                         child: ImagePost(
//                                                                                           onTap: () {
//                                                                                             Navigator.of(context).push(MaterialPageRoute(
//                                                                                                 builder: (context) => AllPostsPhoto(
//                                                                                                       postImages: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage,
//                                                                                                       postImagesCount: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage.length,
//                                                                                                     )));
//                                                                                           },
//                                                                                           imageUrl: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage[3].imageUrl,
//                                                                                         ),
//                                                                                       ),
//                                                                                       // ImagePost(size.width / 2.45, 70.0, BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage[3].imageUrl),
//                                                                                       Expanded(
//                                                                                         child: GestureDetector(
//                                                                                           onTap: () {
//                                                                                             Navigator.of(context).push(MaterialPageRoute(
//                                                                                                 builder: (context) => AllPostsPhoto(
//                                                                                                       postImages: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage,
//                                                                                                       postImagesCount: BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage.length,
//                                                                                                     )));
//                                                                                           },
//                                                                                           child: Container(
//                                                                                             margin: const EdgeInsets.symmetric(horizontal: 5),
//                                                                                             decoration: BoxDecoration(
//                                                                                               color: Colors.transparent,
//                                                                                               borderRadius: BorderRadius.circular(12),
//                                                                                               image: DecorationImage(image: NetworkImage(BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage[4].imageUrl), fit: BoxFit.cover),
//                                                                                             ),
//                                                                                             child: Center(
//                                                                                                 child: Text(
//                                                                                               "+ ${BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postsImage.length - 5}",
//                                                                                               style: const TextStyle(color: Colors.white, fontSize: 15),
//                                                                                             )),
//                                                                                           ),
//                                                                                         ),
//                                                                                       )
//                                                                                     ],
//                                                                                   ),
//                                                                                 ),
//                                                                               ],
//                                                                             ),
//                                                                           )
//                                                                         : Container(),
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.fromLTRB(
//                                                           7, 12, 7, 0),
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       GestureDetector(
//                                                           onTap: () {
//                                                             debugPrint(BlocProvider
//                                                                     .of<StudentPostsCubit>(
//                                                                         context)
//                                                                 .numberLikes
//                                                                 .toString());
//                                                             debugPrint(BlocProvider
//                                                                     .of<StudentPostsCubit>(
//                                                                         context)
//                                                                 .stdPostLikes
//                                                                 .toString());
//                                                             debugPrint(
//                                                                 "_______________________________________________________________");
//                                                             BlocProvider.of<
//                                                                         StudentPostsCubit>(
//                                                                     context)
//                                                                 .changeLike(
//                                                                     index);
//                                                             debugPrint(BlocProvider
//                                                                     .of<StudentPostsCubit>(
//                                                                         context)
//                                                                 .numberLikes
//                                                                 .toString());
//                                                             debugPrint(BlocProvider
//                                                                     .of<StudentPostsCubit>(
//                                                                         context)
//                                                                 .stdPostLikes
//                                                                 .toString());
//                                                             BlocProvider.of<
//                                                                         StudentPostsCubit>(
//                                                                     context)
//                                                                 .changeLikeCount(
//                                                                     studentId:
//                                                                         stuId!,
//                                                                     postId: BlocProvider.of<StudentPostsCubit>(
//                                                                             context)
//                                                                         .stdPost[
//                                                                             index]
//                                                                         .postId)
//                                                                 .then((value) {
//                                                               print(BlocProvider
//                                                                       .of<StudentPostsCubit>(
//                                                                           context)
//                                                                   .changeLikeStatus);
//                                                               print(BlocProvider
//                                                                       .of<StudentPostsCubit>(
//                                                                           context)
//                                                                   .postId);
//                                                               print(BlocProvider
//                                                                       .of<StudentPostsCubit>(
//                                                                           context)
//                                                                   .stdPost[
//                                                                       index]
//                                                                   .postId);
//                                                             });
//                                                           },
//                                                           child: BlocProvider.of<
//                                                                               StudentPostsCubit>(
//                                                                           context)
//                                                                       .stdPostLikes[index] ==
//                                                                   false
//                                                               ? Row(
//                                                                   children: [
//                                                                     const CircleAvatar(
//                                                                       backgroundColor:
//                                                                           Colors
//                                                                               .white,
//                                                                       radius:
//                                                                           13,
//                                                                       child: Icon(
//                                                                           Icons
//                                                                               .thumb_up_alt,
//                                                                           color: Colors
//                                                                               .grey,
//                                                                           size:
//                                                                               22),
//                                                                     ),
//                                                                     Text(
//                                                                       "${BlocProvider.of<StudentPostsCubit>(context).numberLikes[index]} ${tr(StringConstants.likes)}",
//                                                                       style: const TextStyle(
//                                                                           color: Colors
//                                                                               .grey,
//                                                                           fontSize:
//                                                                               12),
//                                                                     )
//                                                                   ],
//                                                                 )
//                                                               : Row(
//                                                                   children: [
//                                                                     const CircleAvatar(
//                                                                       radius:
//                                                                           13,
//                                                                       child: Icon(
//                                                                           Icons
//                                                                               .thumb_up_alt_outlined,
//                                                                           color: Colors
//                                                                               .white,
//                                                                           size:
//                                                                               16),
//                                                                     ),
//                                                                     const SizedBox(
//                                                                         width:
//                                                                             8),
//                                                                     Text(
//                                                                       '${BlocProvider.of<StudentPostsCubit>(context).numberLikes[index]} ${tr(StringConstants.likes)}',
//                                                                       style: const TextStyle(
//                                                                           fontFamily: FontConstants
//                                                                               .poppins,
//                                                                           fontSize:
//                                                                               12,
//                                                                           fontWeight:
//                                                                               FontWeight.w700),
//                                                                     )
//                                                                   ],
//                                                                 )),
//                                                       InkWell(
//                                                         onTap: () {
//                                                           Navigator.of(context).push(
//                                                               MaterialPageRoute(
//                                                                   builder:
//                                                                       (context) =>
//                                                                           CommentsPage(
//                                                                             postId:
//                                                                                 BlocProvider.of<StudentPostsCubit>(context).stdPost[index].postId,
//                                                                           )));
//                                                         },
//                                                         child: Row(
//                                                           children: [
//                                                             Image.asset(
//                                                               ImagesConstants
//                                                                   .comment,
//                                                               scale: 2.8,
//                                                             ),
//                                                             const SizedBox(
//                                                                 width: 8),
//                                                             Text(
//                                                               '${BlocProvider.of<StudentPostsCubit>(context).stdPost[index].commentsCount} ${tr(StringConstants.comments)}',
//                                                               style: const TextStyle(
//                                                                   fontFamily:
//                                                                       FontConstants
//                                                                           .poppins,
//                                                                   fontSize: 12,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w700),
//                                                             )
//                                                           ],
//                                                         ),
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     }),
//                               ),
//                             ],
//                           );
//               },
//             )),
//       ),
//     );
//   }
// }
//
// class PostHeader extends StatefulWidget {
//   const PostHeader({Key? key, required this.finalTime}) : super(key: key);
//   final String finalTime;
//
//   @override
//   State<PostHeader> createState() => _PostHeaderState();
// }
//
// class _PostHeaderState extends State<PostHeader> {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         CircleAvatar(
//           backgroundColor: Colors.white,
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.all(3),
//               child: Image.asset(
//                 ImagesConstants.logo,
//                 scale: 2.5,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(
//           width: 10,
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               // trackPosts[index]['studentobj']
//               // ['student_name']
//               ''' ${StringConstants.postHeadName}''',
//               style: TextStyle(
//                   fontFamily: FontConstants.poppins,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 13),
//             ),
//             Text(
//               widget.finalTime,
//               style: TextStyle(
//                   fontFamily: FontConstants.poppins,
//                   color: Colors.grey[400],
//                   fontSize: 11),
//             )
//           ],
//         ),
//         const Spacer(),
//         const SizedBox(width: 7),
//       ],
//     );
//   }
// }
