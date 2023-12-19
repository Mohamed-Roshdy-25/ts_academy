import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/constants/constants.dart';
import '../animations/dialog_animation.dart';
import '../constants/color_constants.dart';
import '../constants/font_constants.dart';
import '../constants/image_constants.dart';
import '../constants/string_constants.dart';
import '../controller/add_card/add_card_cubit.dart';
import '../controller/student_courses/student_course_cubit.dart';

class CardTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String enteredData = newValue.text;
    StringBuffer buffer = StringBuffer();

    if (enteredData.isNotEmpty && !isNumeric(enteredData[0])) {
      // If the first character is not a number, remove it
      return oldValue;
    }

    // Remove any non-digit characters from the input
    enteredData = enteredData.replaceAll(RegExp(r'[^0-9]'), '');

    for (int i = 0; i < enteredData.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(" "); // Insert a space after every fourth character
      }
      buffer.write(enteredData[i]);
    }
    if (enteredData.length >= 16) {
      // Add a space after the 12th character
      buffer.write(" ");
    }

    return TextEditingValue(
      text: buffer.toString(),
      composing: TextSelection.collapsed(offset: buffer.toString().length),
    );
  }

  bool isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }
}

class Modules {
  toast(String toastText,[ Color color= Colors.black]) {
    return Fluttertoast.showToast(
        msg: toastText,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        backgroundColor: color,
        fontSize: 16.0);
  }

  errorToast(String toastText) {
    return Fluttertoast.showToast(
        msg: toastText,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        backgroundColor: Colors.red,
        fontSize: 16.0);
  }

  appBar(String title) {
    TextEditingController addCardController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: FontConstants.poppins,
          color: Colors.white,
        ),
      ),
      leading: GestureDetector(
        onTap: () async {
          // await Modules().getTrackPosts();
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: CircleAvatar(
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
        ),
      ),
      // actions: [
      //   PopupMenuButton(
      //       itemBuilder: (context) => [
      //         PopupMenuItem(
      //             child: TextButton(
      //                 onPressed: () {
      //                   showDialog(
      //                       context: (context),
      //                       builder: (_) {
      //                         return AnimatedDialog(
      //                           child: Padding(
      //                             padding: const EdgeInsets.symmetric(
      //                                 vertical: 15, horizontal: 20),
      //                             child: Column(
      //                               mainAxisSize: MainAxisSize.min,
      //                               children: [
      //                                 Text(
      //                                   tr(StringConstants.enterInformation),
      //                                   style: const TextStyle(
      //                                       color: Colors.black87,
      //                                       fontWeight: FontWeight.w600,
      //                                       fontSize: 14),
      //                                 ),
      //                                 SizedBox(
      //                                   height: MediaQuery.of(context)
      //                                       .size
      //                                       .height *
      //                                       0.01,
      //                                 ),
      //                                 Form(
      //                                   key: formKey,
      //                                   child: TextFormField(
      //                                     keyboardType: TextInputType.number,
      //                                     inputFormatters: [
      //                                       LengthLimitingTextInputFormatter(
      //                                           14),
      //                                       FilteringTextInputFormatter
      //                                           .digitsOnly
      //                                       // CardTextFormatter()
      //                                     ],
      //                                     controller: addCardController,
      //                                     validator: (value) {
      //                                       return value!.length == 14
      //                                           ? null
      //                                           : tr(StringConstants.enterValidCardCode);
      //                                     },
      //                                     decoration: InputDecoration(
      //                                         filled: true,
      //                                         hintText:
      //                                         tr(StringConstants.enterCode),
      //                                         hintStyle: TextStyle(
      //                                             color: Colors.grey[400],
      //                                             fontSize: 17,
      //                                             fontWeight:
      //                                             FontWeight.w800),
      //                                         fillColor: Colors.white,
      //                                         border:
      //                                         const OutlineInputBorder(
      //                                           borderSide: BorderSide(
      //                                               color: Colors.white),
      //                                         ),
      //                                         enabledBorder:
      //                                         const OutlineInputBorder(
      //                                           borderSide: BorderSide(
      //                                               color: Colors.white),
      //                                         ),
      //                                         focusedBorder:
      //                                         const OutlineInputBorder(
      //                                           borderSide: BorderSide(
      //                                               color: Colors.white),
      //                                         )),
      //                                   ),
      //                                 ),
      //                                 SizedBox(
      //                                   height: MediaQuery.of(context)
      //                                       .size
      //                                       .height *
      //                                       0.02,
      //                                 ),
      //                                 BlocConsumer<AddCardCubit,
      //                                     AddCardState>(
      //                                     listener: (ctx, st) {},
      //                                     builder: (ctx, st) {
      //                                       return st is AddCardLoading
      //                                           ? Center(
      //                                           child:
      //                                           CircularProgressIndicator(
      //                                             color: ColorConstants
      //                                                 .darkBlue,
      //                                           ))
      //                                           : MaterialButton(
      //                                           minWidth: MediaQuery.of(
      //                                               context)
      //                                               .size
      //                                               .width *
      //                                               0.5,
      //                                           height: MediaQuery.of(
      //                                               context)
      //                                               .size
      //                                               .height *
      //                                               0.06,
      //                                           color: ColorConstants
      //                                               .darkBlue,
      //                                           shape: OutlineInputBorder(
      //                                               borderRadius:
      //                                               BorderRadius
      //                                                   .circular(
      //                                                   12)),
      //                                           onPressed: () {
      //                                             if (formKey
      //                                                 .currentState!
      //                                                 .validate()) {
      //                                               BlocProvider
      //                                                   .of<
      //                                                   AddCardCubit>(
      //                                                   context)
      //                                                   .addCard(
      //                                                   cardCode: addCardController
      //                                                       .text,
      //                                                   stuId:
      //                                                   stuId!)
      //                                                   .then((value) {
      //                                                 print(
      //                                                     "====================================");
      //                                                 print(addCardController
      //                                                     .text
      //                                                     .replaceAll(
      //                                                     " ", "")
      //                                                     .split('')
      //                                                     .reversed
      //                                                     .join(''));
      //                                                 print(addCardController
      //                                                     .text
      //                                                     .replaceAll(
      //                                                     " ", "")
      //                                                     .split('')
      //                                                     .reversed
      //                                                     .join('')
      //                                                     .length);
      //                                                 print(value);
      //                                                 print(
      //                                                     "====================================");
      //                                                 showDialog(
      //                                                     context:
      //                                                     context,
      //                                                     builder: (x) {
      //                                                       return AnimatedDialog(
      //                                                           child: DialogAfterAdded(
      //                                                               message:
      //                                                               value));
      //                                                     });
      //                                               });
      //                                             }
      //                                           },
      //                                           child:  Text(
      //                                             tr(StringConstants.add),
      //                                             style: const TextStyle(
      //                                                 color:
      //                                                 Colors.white,
      //                                                 fontSize: 15,
      //                                                 fontWeight:
      //                                                 FontWeight
      //                                                     .w600),
      //                                           ));
      //                                     })
      //                               ],
      //                             ),
      //                           ),
      //                         );
      //                       });
      //                 },
      //                 child: Text(
      //                   tr(StringConstants.enterCardCode),
      //                   style: const TextStyle(color: Colors.black, fontSize: 14),
      //                 )))
      //       ]),
      // ],
      centerTitle: true,
      backgroundColor: ColorConstants.lightBlue,
    );
  }
}

headingText(String fieldHeading) {
  return Text(
    fieldHeading,
    style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        fontFamily: FontConstants.poppins),
  );
}

inputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(fontSize: 14, fontFamily: FontConstants.poppins),
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
  );
}

class DialogAfterAdded extends StatelessWidget {
  const DialogAfterAdded({Key? key, required this.message}) : super(key: key);

  final String message;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddCardCubit, AddCardState>(
  listener: (context, state) {
    // if(state is AddCardLoaded){
    //   BlocProvider.of<StudentCourseCubit>(context)
    //       .getAllStudentCourses(stuId!);
    // }
  },
  builder: (context, state) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(StringConstants.appName,
              style: TextStyle(
                  color:ColorConstants.lightBlue,
                  fontWeight: FontWeight.w700,
                  fontSize: 17)),
          const Divider(
            thickness: 1.2,
            color: Colors.black87,
          ),
          Text(
            message,
            style:  TextStyle(color: ColorConstants.lightBlue),
          ),
          const Divider(
            thickness: 1.2,
            color: Colors.black87,
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:  Text(tr(StringConstants.ok),
                  style: TextStyle(color:ColorConstants.lightBlue)))
        ],
      ),
    );
  },
);
  }
}
