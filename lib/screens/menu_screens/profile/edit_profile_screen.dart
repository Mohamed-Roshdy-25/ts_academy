// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:ts_academy/constants/string_constants.dart';
// import '/screens/menu_screens/change_password_screen.dart';
// import '../../../constants/color_constants.dart';
// import '../../../constants/font_constants.dart';
// import '../../../constants/image_constants.dart';
// import '../../../modules/modules.dart';
//
// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   _EditProfileScreenState createState() => _EditProfileScreenState();
// }
//
// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String? profilePhoto,
//       phoneNo,
//       fullName,
//       universityName,
//       collegeName,
//       className,
//       accountType,
//       bio;
//   bool checkboxValue = false;
//
//   headingText(String fieldHeading) {
//     return Text(
//       fieldHeading,
//       style: TextStyle(
//           fontSize: 13.sp,
//           color: Colors.grey,
//           fontWeight: FontWeight.w500,
//           fontFamily: FontConstants.poppins),
//     );
//   }
//
//   inputDecoration(String hintText) {
//     return InputDecoration(
//       enabled: false,
//       hintText: hintText,
//       hintStyle: TextStyle(
//           fontSize: 13.sp,
//           fontFamily: FontConstants.poppins,
//           color: Colors.black),
//       contentPadding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
//       disabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: ColorConstants.lightBlue, width: 1)),
//       focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: ColorConstants.lightBlue)),
//       enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: ColorConstants.lightBlue)),
//       errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Colors.red)),
//       focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: ColorConstants.lightBlue)),
//     );
//   }
//
//   String gender = "";
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: Modules().appBar('Edit Profile'),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 15.h),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 // select pic circle
//                 Material(
//                   elevation: 4,
//                   borderRadius: BorderRadius.circular(50),
//                   child: Container(
//                     width: 85,
//                     height: 85,
//                     decoration: BoxDecoration(
//                         image: const DecorationImage(
//                             image: AssetImage(ImagesConstants.camera)),
//                         color: Colors.grey.shade400.withOpacity(0.7),
//                         shape: BoxShape.circle,
//                         border: Border.all(color: ColorConstants.darkBlue)),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 // username field
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     headingText('Full Name'),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       cursorColor: ColorConstants.lightBlue,
//                       style: const TextStyle(
//                           fontSize: 14, fontFamily: FontConstants.poppins),
//                       enabled: false,
//                       initialValue: fullName ?? '',
//                       decoration: inputDecoration('Enter your name'),
//                     ),
//                     const SizedBox(height: 8),
//                     headingText('Mobile Number'),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       cursorColor: ColorConstants.lightBlue,
//                       style: const TextStyle(
//                           fontSize: 14, fontFamily: FontConstants.poppins),
//                       enabled: false,
//                       initialValue: phoneNo ?? '',
//                       decoration: inputDecoration('Enter your phone no.'),
//                     ),
//                     const SizedBox(height: 8),
//                     headingText('Gender'),
//                     Column(
//                       children: [
//                         Row(
//                           children: [
//                             headingText("Male"),
//                             Radio(
//                                 value: "male",
//                                 groupValue: gender,
//                                 activeColor: Colors.orange,
//                                 onChanged: (val) {
//                                   setState(() {
//                                     gender = val.toString();
//                                     print(val);
//                                   });
//                                 })
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             headingText("Female"),
//                             Radio(
//                                 value: "Female",
//                                 groupValue: gender,
//                                 activeColor: Colors.orange,
//                                 onChanged: (val) {
//                                   setState(() {
//                                     gender = val.toString();
//                                     print(val);
//                                   });
//                                 })
//                           ],
//                         )
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     headingText('Company Name'),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       cursorColor: ColorConstants.lightBlue,
//                       style: const TextStyle(
//                           fontSize: 14, fontFamily: FontConstants.poppins),
//                       enabled: false,
//                       initialValue: universityName ?? '',
//                       decoration: inputDecoration('Enter Company'),
//                     ),
//                     const SizedBox(height: 8),
//                     headingText('College Name'),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       cursorColor: ColorConstants.lightBlue,
//                       style: const TextStyle(
//                           fontSize: 14, fontFamily: FontConstants.poppins),
//                       enabled: false,
//                       initialValue: collegeName ?? '',
//                       decoration: inputDecoration('Enter your name'),
//                     ),
//                     const SizedBox(height: 8),
//                     headingText('Class'),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       cursorColor: ColorConstants.lightBlue,
//                       style: const TextStyle(
//                           fontSize: 14, fontFamily: FontConstants.poppins),
//                       enabled: false,
//                       initialValue: className ?? '',
//                       decoration: inputDecoration('Enter your Class'),
//                     ),
//                     const SizedBox(height: 8),
//                     headingText('Account Type'),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Row(
//                             children: [
//                               headingText("انتساب"),
//                               Radio(
//                                   value: "انتساب",
//                                   groupValue: accountType,
//                                   onChanged: (val) {
//                                     setState(() {
//                                       accountType = val.toString();
//                                     });
//                                   })
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           child: Row(
//                             children: [
//                               headingText("انتظام"),
//                               Radio(
//                                   value: "انتظام",
//                                   groupValue: accountType,
//                                   onChanged: (val) {
//                                     setState(() {
//                                       accountType = val.toString();
//                                     });
//                                   })
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                     // headingText('Bio'),
//                     // const SizedBox(height: 8),
//                     // TextFormField(
//                     //   cursorColor: ColorConstants.lightBlue,
//                     //   style: const TextStyle(
//                     //       fontSize: 14, fontFamily: FontConstants.poppins),
//                     //   decoration: InputDecoration(
//                     //     hintText: 'Add your Bio',
//                     //     hintStyle: const TextStyle(
//                     //         fontSize: 13, fontFamily: FontConstants.poppins),
//                     //     contentPadding:
//                     //         const EdgeInsets.fromLTRB(20, 18, 20, 18),
//                     //     disabledBorder: OutlineInputBorder(
//                     //         borderRadius: BorderRadius.circular(10),
//                     //         borderSide: BorderSide(
//                     //             color: ColorConstants.lightBlue, width: 1)),
//                     //     focusedBorder: OutlineInputBorder(
//                     //         borderRadius: BorderRadius.circular(10),
//                     //         borderSide:
//                     //             BorderSide(color: ColorConstants.lightBlue)),
//                     //     enabledBorder: OutlineInputBorder(
//                     //         borderRadius: BorderRadius.circular(10),
//                     //         borderSide:
//                     //             BorderSide(color: ColorConstants.lightBlue)),
//                     //     errorBorder: OutlineInputBorder(
//                     //         borderRadius: BorderRadius.circular(10),
//                     //         borderSide: const BorderSide(color: Colors.red)),
//                     //     focusedErrorBorder: OutlineInputBorder(
//                     //         borderRadius: BorderRadius.circular(10),
//                     //         borderSide:
//                     //             BorderSide(color: ColorConstants.lightBlue)),
//                     //   ),
//                     //   maxLines: 10,
//                     //   minLines: 8,
//                     //   onChanged: (value) {
//                     //     setState(() => bio = value);
//                     //   },
//                     //   validator: (value) {
//                     //     return value!.length > 3 ? null : 'Enter your Bio';
//                     //   },
//                     // ),
//                     // SizedBox(
//                     //   height: 10.h,
//                     // ),
//                     // GestureDetector(
//                     //   onTap: () {
//                     //     Navigator.push(
//                     //         context,
//                     //         MaterialPageRoute(
//                     //             builder: (context) =>
//                     //                 const ChangePasswordScreen()));
//                     //   },
//                     //   child: Container(
//                     //     alignment: Alignment.center,
//                     //     decoration: BoxDecoration(
//                     //         color: ColorConstants.darkBlue,
//                     //         borderRadius: BorderRadius.circular(12)),
//                     //     height: 55.h,
//                     //     width: MediaQuery.of(context).size.width,
//                     //     child: Text(
//                     //       tr(StringConstants.done),
//                     //       style: TextStyle(
//                     //           color: Colors.white,
//                     //           fontWeight: FontWeight.w600,
//                     //           fontSize: 16.sp),
//                     //     ),
//                     //   ),
//                     // ),
//                     Align(
//                       alignment: Alignment.center,
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       const ChangePasswordScreen()));
//                         },
//                         child: Text(
//                           tr(StringConstants.changePassword),
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.red,
//                               fontSize: 14.sp,
//                               fontFamily: FontConstants.poppins),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
