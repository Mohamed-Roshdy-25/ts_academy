import 'package:flutter/material.dart';
import '/constants/color_constants.dart';
import '/constants/font_constants.dart';

// ignore: must_be_immutable
class ElevatedButtonWidget extends StatelessWidget {
  final String? buttonText;
  // final double? width;
  final Function? onPressed;

  ElevatedButtonWidget({
    Key? key,
    required this.buttonText,
    // @required this.width,
    required this.onPressed,
  }) : super(key: key);

  double borderRadiusValue = 10;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 2), blurRadius: 5.0)
          ],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 1.0],
            colors: [
              ColorConstants.darkBlue,
              ColorConstants.lightBlue,
            ],
          ),
          color: Colors.deepPurple.shade300,
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadiusValue),
              ),
            ),
            minimumSize: MaterialStateProperty.all(
                Size(MediaQuery.of(context).size.width, 50)),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            // elevation: MaterialStateProperty.all(3),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
          ),
          onPressed: () {
            onPressed!();
          },
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Text(
              buttonText!,
              style: const TextStyle(
                fontSize: 15,
                fontFamily: FontConstants.poppins,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
