import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ts_academy/constants/constants.dart';
import 'package:ts_academy/models/new_comments_model.dart';
import 'package:ts_academy/screens/home/widgets.dart';
import '../../modules/modules.dart';
import '/constants/string_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/color_constants.dart';
import '../../constants/font_constants.dart';
import '../../controller/student_posts_comments/comments.dart';

class ReplyPage extends StatefulWidget {
  final String userMentioned;
  final String mainCommentId;
  final CommentData commentData;
  const ReplyPage({Key? key, required this.userMentioned, required this.mainCommentId, required this.commentData})
      : super(key: key);

  @override
  State<ReplyPage> createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage> {
  String userMentioned = '';
  String commentToReplyId = '';
  TextEditingController commentTextEditingController = TextEditingController();

  @override
  void initState() {
    setState(() {
      userMentioned = widget.userMentioned;
      commentToReplyId = widget.mainCommentId;
    });
    super.initState();
  }

  String commentPost = "";
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            title: Text(
              "Replies",
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
              final isMainCommentByMe = widget.commentData.ownerData!.studentId == stuId;
              return state is GetCommentsLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: ColorConstants.purpal,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ListTile(
                            title: Column(
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
                                            widget.commentData.ownerData!.studentName!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          PopupMenuButton<int>(
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (context) => [
                                              if (!isMainCommentByMe)
                                                PopupMenuItem(
                                                  value: 1,
                                                  height: 30,
                                                  onTap: () {
                                                    if (!widget.commentData.reported!) {
                                                      commentsCubit.reportComment(
                                                        commentId: widget.commentData.commentId!,
                                                        postId: widget.commentData.postId!,
                                                      );
                                                    }
                                                  },
                                                  child: Center(
                                                      child: Text(
                                                          !widget.commentData.reported! ? "Report" : "Already Reported",
                                                          style: Theme.of(context).textTheme.labelLarge)),
                                                ),
                                              if (isMainCommentByMe)
                                                PopupMenuItem(
                                                  value: 2,
                                                  height: 30,
                                                  onTap: () {},
                                                  child: Center(
                                                      child:
                                                          Text("Edit", style: Theme.of(context).textTheme.labelLarge)),
                                                ),
                                              if (isMainCommentByMe)
                                                PopupMenuItem(
                                                  value: 3,
                                                  height: 30,
                                                  onTap: () async {
                                                    await commentsCubit
                                                        .deleteComment(
                                                      commentId: widget.commentData.commentId!,
                                                      postId: widget.commentData.postId!,
                                                    )
                                                        .then((value) {
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: Center(
                                                    child: Text(
                                                      "Delete",
                                                      style: Theme.of(context).textTheme.labelLarge,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                            offset: const Offset(0, 30),
                                            color: Colors.white,
                                            onSelected: (int value) {
                                              if(value == 2){
                                                commentsCubit.newCommentController.text = widget.commentData.commentDetails!;
                                                showEditCommentDialog(
                                                    context: context,
                                                    onPressConfirm: () async {
                                                      await commentsCubit.editComment(commentId: widget.commentData.commentId!, postId: widget.commentData.postId!);
                                                      navigatorKey.currentState?.pop();
                                                      navigatorKey.currentState?.pop();
                                                    },
                                                );
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
                                          widget.commentData.commentDetails!,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      userMentioned = widget.commentData.ownerData!.studentName!;
                                      commentToReplyId = widget.commentData.commentId!;
                                    });
                                  },
                                  child: Text("Reply", style: TextStyle(color: ColorConstants.lightBlue)),
                                ),
                              ],
                            ),
                            leading: widget.commentData.ownerData!.studentPhoto! == ""
                                ? const Icon(Icons.person)
                                : CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: Image.network(
                                          widget.commentData.ownerData!.studentPhoto!,
                                          scale: 2.5,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(start: 16),
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final isCommentByMe = commentsCubit.replyModel!.massage![index].studentId == stuId;
                                return ListTile(
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(10)),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  commentsCubit.replyModel!.massage![index].ownerReplyData!.studentName!,
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
                                                          if (!commentsCubit.replyModel!.massage![index].reported!) {
                                                            commentsCubit.reportReply(
                                                              replyId: commentsCubit.replyModel!.massage![index].replyId!,
                                                              mainCommentId: widget.mainCommentId,
                                                            );
                                                          }
                                                        },
                                                        child: Center(
                                                            child: Text(
                                                          !commentsCubit.replyModel!.massage![index].reported!
                                                              ? "Report"
                                                              : "Already Reported",
                                                          style: Theme.of(context).textTheme.labelLarge,
                                                        )),
                                                      ),
                                                    if (isCommentByMe)
                                                      PopupMenuItem(
                                                        value: 2,
                                                        height: 30,
                                                        onTap: () {},
                                                        child: Center(
                                                            child: Text("Edit",
                                                                style: Theme.of(context).textTheme.labelLarge)),
                                                      ),
                                                    if (isCommentByMe)
                                                      PopupMenuItem(
                                                        value: 3,
                                                        height: 30,
                                                        onTap: () {
                                                          commentsCubit.deleteReply(
                                                            replyId: commentsCubit.replyModel!.massage![index].replyId!,
                                                            mainCommentId: widget.mainCommentId,
                                                          );
                                                        },
                                                        child: Center(
                                                          child: Text(
                                                            "Delete",
                                                            style: Theme.of(context).textTheme.labelLarge,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                  offset: const Offset(0, 30),
                                                  color: Colors.white,
                                                  onSelected: (int value) {
                                                    if(value == 2){
                                                      commentsCubit.newReplyController.text = commentsCubit.replyModel!.massage![index].replyText!.split("**").last;
                                                      showEditReplyDialog(
                                                          context: context,
                                                          onPressConfirm: () async {
                                                            await commentsCubit.editReply(replyId: commentsCubit.replyModel!.massage![index].replyId!, mainCommentId: widget.mainCommentId,userMentioned: commentsCubit.replyModel!.massage![index].replyText!.split("**").first);
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
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    commentsCubit.replyModel!.massage![index].replyText!
                                                        .split("**")
                                                        .first,
                                                    style: TextStyle(color: Colors.blue),
                                                  ),
                                                  Text(
                                                    commentsCubit.replyModel!.massage![index].replyText!
                                                        .split("**")
                                                        .last,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            userMentioned =
                                                commentsCubit.replyModel!.massage![index].ownerReplyData!.studentName!;
                                            commentToReplyId = commentsCubit.replyModel!.massage![index].commentId!;
                                          });
                                        },
                                        child: Text("Reply", style: TextStyle(color: ColorConstants.lightBlue)),
                                      ),
                                    ],
                                  ),
                                  leading: commentsCubit.replyModel!.massage![index].ownerReplyData!.studentPhoto! == ""
                                      ? const Icon(Icons.person)
                                      : CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(3),
                                              child: Image.network(
                                                commentsCubit.replyModel!.massage![index].ownerReplyData!.studentPhoto!,
                                                scale: 2.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(height: 10),
                              itemCount: commentsCubit.replyModel!.massage!.length,
                            ),
                          ),
                        ],
                      ),
                    );
            },
          ),
          bottomNavigationBar: Transform.translate(
            offset: Offset(0, isKeyboardVisible ? -MediaQuery.of(context).viewInsets.bottom : 0),
            child: BlocConsumer<CommentsCubit, CommentsState>(
              listener: (context, state) {},
              builder: (context, state) {
                CommentsCubit commentsCubit = BlocProvider.of(context);
                return Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 16),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            color: ColorConstants.lightBlue,
                          ),
                          child: Text(
                            "@${userMentioned}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 4),
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
                                    hintText: "make a reply",
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
                                  onPressed: () async {
                                    if (commentTextEditingController.text.isEmpty) {
                                      return;
                                    } else {
                                      await commentsCubit.makeReply(
                                        reply: "@$userMentioned ** ${commentTextEditingController.text}",
                                        commentId: commentToReplyId,
                                        mainCommentId: widget.mainCommentId,
                                      );
                                      FocusScope.of(context).unfocus();
                                      commentTextEditingController.clear();
                                    }
                                  },
                                  color: commentTextEditingController.text.isEmpty
                                      ? Colors.grey
                                      : ColorConstants.lightBlue,
                                )
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
