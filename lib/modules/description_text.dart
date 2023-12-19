import '/constants/string_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '/constants/color_constants.dart';
import '/constants/font_constants.dart';

class DescriptionTextWidget extends StatefulWidget {
  final String? text;
  final Color? textColor;

  const DescriptionTextWidget({required this.text,this.textColor});

  @override
  _DescriptionTextWidgetState createState() => _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String? firstHalf;
  String? secondHalf;
  int minimumTextLength = 150;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text!.length > minimumTextLength) {
      firstHalf = widget.text!.substring(0, minimumTextLength);
      secondHalf = widget.text!.substring(minimumTextLength, widget.text!.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: secondHalf!.isEmpty
          ? Text(
              firstHalf!,
              style: TextStyle(
                  fontFamily: FontConstants.poppins, fontSize: 14, fontWeight: FontWeight.w800, color: widget.textColor ?? Colors.black),
            )
          : Column(
              children: <Widget>[
                Text(
                  flag ? (firstHalf! + "...") : (firstHalf! + secondHalf!),
                  style: TextStyle(fontFamily: FontConstants.poppins, fontSize: 11.5, color: Colors.grey[900]),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: Text(
                      flag ? tr(StringConstants.showMore) : tr(StringConstants.showLess),
                      style:
                          TextStyle(fontFamily: FontConstants.poppins, fontSize: 11, color: ColorConstants.lightBlue),
                    ),
                    onPressed: () {
                      setState(() {
                        flag = !flag;
                      });
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
