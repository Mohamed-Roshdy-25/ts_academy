import 'package:cached_network_image/cached_network_image.dart';
import 'package:ts_academy/modules/modules.dart';
import '/constants/string_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/color_constants.dart';
import '../../constants/constants.dart';
import '../../constants/font_constants.dart';
import '../../constants/image_constants.dart';
import '../../controller/comments/comment_cubit.dart';

class CommentsList extends StatefulWidget {
  const CommentsList({Key? key, required this.courseId}) : super(key: key);

  final String courseId;
  @override
  State<CommentsList> createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  TextEditingController controller = TextEditingController();
  final ScrollController controller2 = ScrollController();

  @override
  void initState() {
    super.initState();
    print(widget.courseId);
    Future.delayed(Duration.zero, () {
      BlocProvider.of<CommentCubit>(context).getComments(widget.courseId);
    });
  }

  String textValue = "";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<CommentCubit, CommentState>(
        listener: (context, state) {
          if (state is CommentFailure) {
            Modules().toast(state.message, Colors.red);
          } else if (state is InsertCourseCommentFailure) {
            Modules().toast(state.message, Colors.red);
          } else if (state is InsertCourseCommentLoaded) {
            Modules().toast(state.message, Colors.green);
          }
        },
        builder: (context, state) {
          return state is CommentLoading
              ? Center(
                  child:
                      CircularProgressIndicator(color: ColorConstants.darkBlue))
              : Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  // child: Form(
                  //   child: Column(
                  //     children: [
                  //       Expanded(
                  //         child: ListView.builder(
                  //             reverse: true,
                  //             physics: BouncingScrollPhysics(),
                  //             controller: controller2,
                  //             itemCount: BlocProvider.of<CommentCubit>(context)
                  //                 .commentsList
                  //                 .length,
                  //             itemBuilder: (ctx, index) {
                  //               return Padding(
                  //                 padding: const EdgeInsets.only(bottom: 15),
                  //                 child: Row(
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.start,
                  //                   children: [
                  //                     BlocProvider.of<CommentCubit>(context)
                  //                                 .commentsList[BlocProvider.of<
                  //                                                 CommentCubit>(
                  //                                             context)
                  //                                         .commentsList
                  //                                         .length -
                  //                                     index -
                  //                                     1]
                  //                                 .studentPhoto ==
                  //                             ""
                  //                         ? const Icon(Icons.person)
                  //                         : SizedBox(
                  //                             height: 60.h,
                  //                             width: 60.w,
                  //                             child: ClipOval(
                  //                               child: CachedNetworkImage(
                  //                                 imageUrl: BlocProvider.of<
                  //                                         CommentCubit>(context)
                  //                                     .commentsList[BlocProvider
                  //                                                 .of<CommentCubit>(
                  //                                                     context)
                  //                                             .commentsList
                  //                                             .length -
                  //                                         index -
                  //                                         1]
                  //                                     .studentPhoto,
                  //                                 placeholder: (ctx, builder) {
                  //                                   return const SizedBox();
                  //                                 },
                  //                                 errorWidget: (a, b, c) {
                  //                                   return const Icon(
                  //                                       Icons.error,
                  //                                       color: Colors.red);
                  //                                 },
                  //                               ),
                  //                             ),
                  //                           ),
                  //                     const SizedBox(width: 10),
                  //                     Expanded(
                  //                       child: Container(
                  //                         padding: const EdgeInsets.all(10),
                  //                         decoration: BoxDecoration(
                  //                           borderRadius:
                  //                               BorderRadius.circular(10),
                  //                           color: Colors.grey[300]!
                  //                               .withOpacity(0.5),
                  //                         ),
                  //                         child: Column(
                  //                           crossAxisAlignment:
                  //                               CrossAxisAlignment.start,
                  //                           children: [
                  //                             BlocProvider.of<CommentCubit>(
                  //                                             context)
                  //                                         .commentsList[BlocProvider
                  //                                                     .of<CommentCubit>(
                  //                                                         context)
                  //                                                 .commentsList
                  //                                                 .length -
                  //                                             index -
                  //                                             1]
                  //                                         .studentName ==
                  //                                     ""
                  //                                 ? Text(tr(
                  //                                     StringConstants.userName))
                  //                                 : SizedBox(
                  //                                     width: size.width / 2,
                  //                                     child: Text(
                  //                                         BlocProvider.of<CommentCubit>(
                  //                                                 context)
                  //                                             .commentsList[BlocProvider.of<
                  //                                                             CommentCubit>(
                  //                                                         context)
                  //                                                     .commentsList
                  //                                                     .length -
                  //                                                 index -
                  //                                                 1]
                  //                                             .studentName,
                  //                                         maxLines: 5,
                  //                                         overflow: TextOverflow
                  //                                             .ellipsis,
                  //                                         style: const TextStyle(
                  //                                             fontWeight:
                  //                                                 FontWeight
                  //                                                     .w700,
                  //                                             fontFamily:
                  //                                                 FontConstants
                  //                                                     .poppins,
                  //                                             fontSize: 13)),
                  //                                   ),
                  //                             const SizedBox(height: 3),
                  //                             SizedBox(
                  //                               width: size.width / 1.55,
                  //                               child: Text(
                  //                                   BlocProvider.of<CommentCubit>(
                  //                                           context)
                  //                                       .commentsList[BlocProvider
                  //                                                   .of<CommentCubit>(
                  //                                                       context)
                  //                                               .commentsList
                  //                                               .length -
                  //                                           index -
                  //                                           1]
                  //                                       .commentDetails,
                  //                                   maxLines: 5,
                  //                                   overflow:
                  //                                       TextOverflow.ellipsis,
                  //                                   style: const TextStyle(
                  //                                       fontFamily:
                  //                                           FontConstants
                  //                                               .poppins,
                  //                                       fontSize: 13)),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ),
                  //                     )
                  //                   ],
                  //                 ),
                  //               );
                  //             }),
                  //       ),
                  //       Row(
                  //         children: [
                  //           CircleAvatar(
                  //             backgroundColor: Colors.white,
                  //             child: Center(
                  //               child: Padding(
                  //                 padding: const EdgeInsets.all(3),
                  //                 child: Image.asset(
                  //                   ImagesConstants.logo,
                  //                   scale: 2.5,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //           SizedBox(
                  //             width: 7.w,
                  //           ),
                  //           // Expanded(
                  //           //     child: TextFormField(
                  //           //         onTapOutside: (event) {
                  //           //           FocusManager.instance.primaryFocus
                  //           //               ?.unfocus();
                  //           //         },
                  //           //         controller: controller,
                  //           //         onChanged: (val) {
                  //           //           setState(() {
                  //           //             textValue = val;
                  //           //           });
                  //           //         },
                  //           //         decoration: InputDecoration(
                  //           //           hintText:
                  //           //               tr(StringConstants.write_a_comment),
                  //           //           contentPadding: const EdgeInsets.fromLTRB(
                  //           //               20, 18, 20, 18),
                  //           //           suffixIcon: state
                  //           //                   is InsertCourseCommentLoading
                  //           //               ? Padding(
                  //           //                   padding: EdgeInsets.all(8.0.h),
                  //           //                   child: CircularProgressIndicator(
                  //           //                     color: ColorConstants.darkBlue,
                  //           //                   ),
                  //           //                 )
                  //           //               : IconButton(
                  //           //                   onPressed: () {
                  //           //                     if (controller.text.isEmpty) {
                  //           //                       return;
                  //           //                     }
                  //           //                     BlocProvider.of<CommentCubit>(
                  //           //                             context)
                  //           //                         .addComment(
                  //           //                             courseId:
                  //           //                                 widget.courseId,
                  //           //                             commentDetails:
                  //           //                                 controller.text,
                  //           //                             stuId: stuId!)
                  //           //                         .then((value) {
                  //           //                       BlocProvider.of<CommentCubit>(
                  //           //                               context)
                  //           //                           .clearTextField(
                  //           //                               controller);
                  //           //                     });
                  //           //                   },
                  //           //                   icon: Icon(Icons.send,
                  //           //                       color: controller.text.isEmpty
                  //           //                           ? Colors.grey
                  //           //                           : ColorConstants
                  //           //                               .darkBlue),
                  //           //                 ),
                  //           //           disabledBorder: OutlineInputBorder(
                  //           //               borderRadius:
                  //           //                   BorderRadius.circular(10),
                  //           //               borderSide: BorderSide(
                  //           //                   color: ColorConstants.darkBlue,
                  //           //                   width: 5)),
                  //           //           focusedBorder: OutlineInputBorder(
                  //           //               borderRadius:
                  //           //                   BorderRadius.circular(10),
                  //           //               borderSide: BorderSide(
                  //           //                   color: ColorConstants.darkBlue)),
                  //           //           enabledBorder: OutlineInputBorder(
                  //           //               borderRadius:
                  //           //                   BorderRadius.circular(10),
                  //           //               borderSide: BorderSide(
                  //           //                   color: ColorConstants.darkBlue)),
                  //           //           errorBorder: OutlineInputBorder(
                  //           //               borderRadius:
                  //           //                   BorderRadius.circular(10),
                  //           //               borderSide: const BorderSide(
                  //           //                   color: Colors.red)),
                  //           //           focusedErrorBorder: OutlineInputBorder(
                  //           //               borderRadius:
                  //           //                   BorderRadius.circular(10),
                  //           //               borderSide: BorderSide(
                  //           //                   color: ColorConstants.darkBlue)),
                  //           //         ))),
                  //         ],
                  //       )
                  //     ],
                  //   ),
                  // ),
                );
        },
      ),
    );
  }
}
