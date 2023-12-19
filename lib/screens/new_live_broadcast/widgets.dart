import 'package:flutter/material.dart';

class BuildComment extends StatefulWidget {
  final String username;
  final String comment;
  final String userImage;
  final BuildContext context;
  final String userId;
  const BuildComment({
    super.key,
    required this.username,
    required this.comment,
    required this.context,
    required this.userImage,
    required this.userId,
  });

  @override
  State<BuildComment> createState() => _BuildCommentState();
}

class _BuildCommentState extends State<BuildComment> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(widget.userImage),
            ),
            SizedBox(width: 10,),
            Text(widget.username, style: TextStyle(color: Colors.white)),
          ],
        ),
        SizedBox(height: 6,),
        Padding(
          padding: EdgeInsetsDirectional.only(start: 35),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Text(
              widget.comment,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}