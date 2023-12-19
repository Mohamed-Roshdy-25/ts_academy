import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ts_academy/components/compnenets.dart';
import 'package:ts_academy/screens/home/reply_screen.dart';
import 'package:ts_academy/screens/home/widgets.dart';
import '../../modules/modules.dart';
import '/constants/string_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../constants/color_constants.dart';
import '../../constants/constants.dart';
import '../../constants/font_constants.dart';
import '../../controller/student_posts/student_posts_cubit.dart';
import '../../controller/student_posts_comments/comments.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({Key? key, required this.postId}) : super(key: key);
  final String postId;

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController commentTextEditingController = TextEditingController();

  String commentPost = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          tr(StringConstants.comments),
          style: const TextStyle(color: Colors.black, fontFamily: FontConstants.poppins),
        ),
      ),
      body: BlocConsumer<CommentsCubit, CommentsState>(
        listener: (context, state) {
          if (state is GetCommentsFailure) {
            Modules().toast(state.message, Colors.red);
          } else if (state is InsertPostCommentsFailure) {
            Modules().toast(state.message, Colors.red);
          } else if (state is InsertPostCommentsLoaded) {
            Modules().toast(state.message, Colors.green);
          }
        },
        builder: (context, state) {
          CommentsCubit commentsCubit = BlocProvider.of(context);
          return state is GetCommentsLoadingState
              ? Center(
                  child: CircularProgressIndicator(
                    color: ColorConstants.purpal,
                  ),
                )
              : Column(mainAxisSize: MainAxisSize.max, children: [
                  commentsCubit.newCommentsModel!.massage!.isEmpty
                      ? Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Lottie.asset('assets/lottie/nothing.json'),
                                  Text(tr(StringConstants.there_is_no_comments_until_now))
                                ],
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.separated(
                            separatorBuilder: (ctx, index) {
                              return SizedBox(
                                height: 10,
                              );
                            },
                            reverse: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: commentsCubit.newCommentsModel!.massage!.length,
                            itemBuilder: (context, index) {
                              commentsCubit.newCommentsModel!.massage!.sort((a, b) => b.date!.compareTo(a.date!));
                              final isCommentByMe =
                                  commentsCubit.newCommentsModel!.massage![index].ownerData!.studentId == stuId;
                              return ListTile(
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                commentsCubit.newCommentsModel!.massage![index].ownerData!.studentName??"",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              PopupMenuButton<int>(
                                                padding: EdgeInsets.zero,
                                                itemBuilder: (context) => [
                                                  if (!isCommentByMe)
                                                    PopupMenuItem(
                                                      value: 1,
                                                      height: 30,
                                                      onTap: () {
                                                        if (!commentsCubit
                                                            .newCommentsModel!.massage![index].reported!) {
                                                          commentsCubit.reportComment(
                                                            commentId: commentsCubit
                                                                .newCommentsModel!.massage![index].commentId!,
                                                            postId: widget.postId,
                                                          );
                                                        }
                                                      },
                                                      child: Center(
                                                          child: Text(
                                                              !commentsCubit.newCommentsModel!.massage![index].reported!
                                                                  ? "Report"
                                                                  : "Already Reported",
                                                              style: Theme.of(context).textTheme.labelLarge)),
                                                    ),
                                                  if (isCommentByMe)
                                                    PopupMenuItem(
                                                      value: 2,
                                                      height: 30,
                                                      onTap: () {},
                                                      child: Center(
                                                        child: Text("Edit",
                                                            style: Theme.of(context).textTheme.labelLarge),
                                                      ),
                                                    ),
                                                  if (isCommentByMe)
                                                    PopupMenuItem(
                                                      value: 3,
                                                      height: 30,
                                                      onTap: () async {
                                                        await commentsCubit.deleteComment(
                                                            commentId: commentsCubit
                                                                .newCommentsModel!.massage![index].commentId!,
                                                            postId: widget.postId);
                                                      },
                                                      child: Center(
                                                          child: Text("Delete",
                                                              style: Theme.of(context).textTheme.labelLarge)),
                                                    ),
                                                ],
                                                offset: const Offset(0, 30),
                                                color: Colors.white,
                                                onSelected: (int value) {
                                                  if(value == 2){
                                                    commentsCubit.newCommentController.text = commentsCubit.newCommentsModel!.massage![index].commentDetails??"";
                                                    showEditCommentDialog(
                                                        context: context,
                                                        onPressConfirm: () async {
                                                          await commentsCubit.editComment(commentId: commentsCubit.newCommentsModel!.massage![index].commentId!, postId: widget.postId);
                                                          navigatorKey.currentState?.pop();
                                                    });
                                                  }
                                                },
                                                elevation: 2,
                                                shape: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  borderSide: BorderSide.none,
                                                ),
                                                child: Icon(
                                                  FontAwesomeIcons.ellipsisVertical,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              commentsCubit.newCommentsModel!.massage![index].commentDetails??"",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await commentsCubit
                                            .getReplies(
                                                commentID: commentsCubit.newCommentsModel!.massage![index].commentId!)
                                            .then((value) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => ReplyPage(
                                                commentData: commentsCubit.newCommentsModel!.massage![index],
                                                mainCommentId:
                                                    commentsCubit.newCommentsModel!.massage![index].commentId!,
                                                userMentioned: commentsCubit
                                                    .newCommentsModel!.massage![index].ownerData!.studentName!,
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                      child: Text(
                                          commentsCubit.newCommentsModel!.massage![index].replysCount! == 0
                                              ? "Reply"
                                              : "view replies",
                                          style: TextStyle(color: ColorConstants.lightBlue)),
                                    ),
                                  ],
                                ),
                                leading: commentsCubit.newCommentsModel!.massage![index].ownerData!.studentPhoto == ""
                                    ? const Icon(Icons.person)
                                    : CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(3),
                                            child: Image.network(
                                              commentsCubit.newCommentsModel!.massage![index].ownerData!.studentPhoto!,
                                              scale: 2.5,
                                            ),
                                          ),
                                        ),
                                      ),
                              );
                            },
                          ),
                        ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: TextFormField(
                              controller: commentTextEditingController,
                              onChanged: (v) {
                                setState(() {
                                  commentPost = v;
                                });
                              },
                              cursorColor: ColorConstants.lightBlue,
                              style: const TextStyle(fontSize: 13, fontFamily: FontConstants.poppins),
                              decoration: InputDecoration(
                                hintText: tr(StringConstants.write_a_comment),
                                hintStyle: const TextStyle(fontSize: 13, fontFamily: FontConstants.poppins),
                                contentPadding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: ColorConstants.lightBlue, width: 5)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: ColorConstants.lightBlue)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: ColorConstants.lightBlue)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Colors.red)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: ColorConstants.lightBlue)),
                              ),
                              validator: (value) {
                                return value!.length >= 6 ? null : tr(StringConstants.enter_6_digit_password);
                              },
                            )),
                      ),
                      state is InsertPostCommentsLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: ColorConstants.darkBlue,
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () {
                                if (commentTextEditingController.text.isEmpty) {
                                  return;
                                } else {
                                  BlocProvider.of<CommentsCubit>(context)
                                      .addCommentInPosts(
                                    comment: commentTextEditingController.text,
                                    controller: commentTextEditingController,
                                    postId: widget.postId,
                                    studentId: stuId!,
                                  )
                                      .then((value) {
                                    BlocProvider.of<StudentPostsCubit>(context).getAllPosts(stuId: stuId!);
                                    commentsCubit.getCommentsNew(postID: widget.postId);
                                  });
                                }
                              },
                              color: commentTextEditingController.text.isEmpty ? Colors.grey : ColorConstants.lightBlue,
                            )
                    ],
                  ),
                ]);
        },
      ),
    );
  }
}
