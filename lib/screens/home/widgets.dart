import 'package:flutter/material.dart';
import 'package:ts_academy/components/compnenets.dart';
import 'package:ts_academy/constants/color_constants.dart';
import 'package:ts_academy/controller/student_posts_comments/comments.dart';

void showEditCommentDialog({
  required BuildContext context,
  required Function onPressConfirm,
}) {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Edit Comment", style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 20),
            myTextFormField(
              context: context,
              fillColor: Colors.white,
              radius: 8,
              hint: "Enter new comment",
              controller: CommentsCubit.get(context).newCommentController,
            ),
          ],
        ),
        actions: [
          myMaterialButton(
            context: context,
            height: 50,
            radius: 8,
            labelWidget: Text(
              "Done",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white),
            ),
            onPressed: () {
              onPressConfirm();
            },
          ),
          SizedBox(height: 20,),
          myMaterialButton(
            context: context,
            height: 50,
            bgColor: ColorConstants.lightBlue,
            borderColor: ColorConstants.lightBlue,
            radius: 8,
            labelWidget: Text(
              "Cancel",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

void showEditReplyDialog({
  required BuildContext context,
  required Function onPressConfirm,
}) {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Edit Comment", style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 20),
            myTextFormField(
              context: context,
              fillColor: Colors.white,
              radius: 8,
              hint: "Enter new reply",
              controller: CommentsCubit.get(context).newReplyController,
            ),
          ],
        ),
        actions: [
          myMaterialButton(
            context: context,
            height: 50,
            radius: 8,
            labelWidget: Text(
              "Done",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white),
            ),
            onPressed: () {
              onPressConfirm();
            },
          ),
          SizedBox(height: 20,),
          myMaterialButton(
            context: context,
            height: 50,
            bgColor: ColorConstants.lightBlue,
            borderColor: ColorConstants.lightBlue,
            radius: 8,
            labelWidget: Text(
              "Cancel",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}