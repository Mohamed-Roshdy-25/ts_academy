import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/constants.dart';
import '../../../constants/font_constants.dart';
import '../../../constants/string_constants.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({Key? key}) : super(key: key);

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  final ImagePicker _picker = ImagePicker();
  XFile? profilePhoto;
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    print("===========================");
    print(stuPhoto);
    // profilePhoto = stuPhoto;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  Text(
            tr(StringConstants.profile),
            style: const TextStyle(
                color: Colors.white, fontFamily: FontConstants.poppins),
          ),
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          centerTitle: true,
          backgroundColor: ColorConstants.lightBlue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            children: [
              stuPhoto == ""
                  ? CircleAvatar(
                backgroundColor:ColorConstants.lightBlue,
                radius: 40,
                    child: Text("${myName?.toUpperCase()[0]??""}${myName?.toUpperCase()[1]??""}",
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                  )
                  : Container(
                      width: 130.w,
                      height: 130.h,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade400.withOpacity(0.7),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(stuPhoto!),
                              fit: BoxFit.cover),
                          border: Border.all(color: ColorConstants.darkBlue)),
                    ),
              SizedBox(
                height: 8.h,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "$myName",
                  style:
                      TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 6,
                        blurStyle: BlurStyle.outer)
                  ],
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(tr(StringConstants.universityIdKey),
                            style: TextStyle(
                                fontSize: 13.sp, fontWeight: FontWeight.w500)),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: Colors.grey[300]!)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 14),
                          child: Text(
                            universityName ?? "",
                            style:
                                TextStyle(color: Colors.black, fontSize: 12.sp),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(tr(StringConstants.student_phone),
                            style: TextStyle(
                                fontSize: 13.sp, fontWeight: FontWeight.w500)),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: Colors.grey[300]!)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 14),
                          child: Text(
                            "+20$stuPhone",
                            style:
                                TextStyle(color: Colors.black, fontSize: 12.sp),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(tr(StringConstants.student_id),
                            style: TextStyle(
                                fontSize: 13.sp, fontWeight: FontWeight.w500)),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 5.h,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: Colors.grey[300]!)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 14),
                          child: Text(
                            "$stuId",
                            style:
                                TextStyle(color: Colors.black, fontSize: 12.sp),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: headingText(tr(StringConstants.bio)),
                      // ),
                      // const SizedBox(height: 8),
                      // TextFormField(
                      //   initialValue:stuBio ,
                      //   cursorColor: ColorConstants.lightBlue,
                      //   style: const TextStyle(
                      //       fontSize: 14, fontFamily: FontConstants.poppins),
                      //   decoration: InputDecoration(
                      //     hintText:
                      //         stuBio == "" || stuBio == "null" || stuBio == null
                      //             ? tr(StringConstants.add_your_bio)
                      //             : stuBio,
                      //     hintStyle: const TextStyle(
                      //         color: Colors.black87,
                      //         fontSize: 15,
                      //         fontFamily: FontConstants.poppins),
                      //     contentPadding:
                      //         const EdgeInsets.fromLTRB(20, 18, 20, 18),
                      //     disabledBorder: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(10),
                      //         borderSide: BorderSide(
                      //             color: ColorConstants.lightBlue, width: 1)),
                      //     focusedBorder: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(10),
                      //         borderSide:
                      //             BorderSide(color: ColorConstants.lightBlue)),
                      //     enabledBorder: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(10),
                      //         borderSide:
                      //             BorderSide(color: ColorConstants.lightBlue)),
                      //     errorBorder: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(10),
                      //         borderSide: const BorderSide(color: Colors.red)),
                      //     focusedErrorBorder: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(10),
                      //         borderSide:
                      //             BorderSide(color: ColorConstants.lightBlue)),
                      //   ),
                      //   maxLines: 10,
                      //   minLines: 8,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       stuBio = value;
                      //     });
                      //   },
                      //   validator: (value) {
                      //     return value!.length > 3 ? null : tr(StringConstants.enter_your_bio);
                      //   },
                      // ),
                      // SizedBox(
                      //   height: 8.h,
                      // ),
                      // ElevatedButtonWidget(
                      //   onPressed: () async {
                      //     final sharedPref =
                      //         await SharedPreferences.getInstance();
                      //     sharedPref.setString('stuBio', stuBio ?? "");
                      //     setState(() {
                      //       stuBio = sharedPref.getString('stuBio');
                      //     });
                      //     ScaffoldMessenger.of(context)
                      //         .showSnackBar( SnackBar(
                      //       content: Text(tr(StringConstants.editSuccessful)),
                      //       backgroundColor: Colors.green,
                      //     ));
                      //   },
                      //   buttonText:  tr(StringConstants.save),
                      // ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
