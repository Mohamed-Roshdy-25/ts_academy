import 'dart:io';
import '/constants/string_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '/constants/color_constants.dart';

import '../constants/image_constants.dart';

Future<bool> showExitPopup(context) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 18,
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Image.asset(
                        ImagesConstants.logo,
                        scale: 2.5,
                      ),
                    )),
                  ),
                  const SizedBox(width: 10),
                   Text(
                    tr(StringConstants.confirmExit),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 13),
               Text(tr(StringConstants.wantToExit)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        exit(0);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(ColorConstants.lightBlue)
                      ),
                      child:  Text(tr(StringConstants.yes)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {
                      print('no selected');
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                    ),
                    child:  Text(tr(StringConstants.no),
                        style: const TextStyle(color: Colors.black)),
                  ))
                ],
              )
            ],
          ),
        );
      });
}
