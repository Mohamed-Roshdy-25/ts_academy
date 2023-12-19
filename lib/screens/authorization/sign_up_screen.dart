import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_academy/screens/home/home_page.dart';
import 'package:ts_academy/screens/menu_screens/privacy_policy_screen.dart';
import '../../constants/constants.dart';
import '/constants/color_constants.dart';
import '/constants/font_constants.dart';
import '/constants/image_constants.dart';
import '/constants/string_constants.dart';
import '/controller/auth_cubit/auth_states.dart';
import '/modules/elevated_button.dart';
import 'package:image_picker/image_picker.dart';
import '../../controller/auth_cubit/registeration.dart';
import '../../modules/modules.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key, required this.phoneNumber}) : super(key: key);

  final String phoneNumber;
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController gradeTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool checkboxValue = false;
  // String? stdGrade;
  List gradeTypes = ['male', 'female'];
  final ImagePicker _picker = ImagePicker();
  XFile? profilePhoto;
  String? universityId;
  bool done = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<RegistrationCubit>(context).getUniversities();
    // BlocProvider.of<PhoneCubit>(context, listen: false)
    //     .getDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<RegistrationCubit, AuthStates>(listener: (ctx, state) {
          if (state is GetUniversitiesFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(backgroundColor: ColorConstants.errorsColor, content: Text(state.errorMessage)));
          } else if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text(state.message)));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) {
              return const HomePage();
            }));
          } else if (state is RegisterFailure) {
            print(state.errorMessage);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(backgroundColor: ColorConstants.errorsColor, content: Text(state.errorMessage)));
          }
        }, builder: (context, state) {
          return state is GetUniversitiesLoading || state is GetImagePathLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: ColorConstants.darkBlue,
                  ),
                )
              : SingleChildScrollView(
                  child: Stack(
                    children: [
                      Align(
                          alignment: Alignment.topRight,
                          child: Image.asset(
                            ImagesConstants.rightCircle,
                            scale: 2.5,
                          )),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 45),

                            // create account text
                            Center(
                              child: Text(
                                '${tr(StringConstants.create_a)}\n${tr(StringConstants.new_account)}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: FontConstants.poppins,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),

                            // select pic circle
                            GestureDetector(
                              onTap: () async {
                                final shared = await SharedPreferences.getInstance();
                                await _picker.pickImage(source: ImageSource.gallery,requestFullMetadata: false,).then((value) {
                                  setState(() {
                                    profilePhoto = value;
                                  });
                                  // BlocProvider.of<RegistrationCubit>(context)
                                  //     .getImagePath(profilePhoto!)
                                  //     .then((value) {
                                  //   shared.setString(
                                  //       "studentImage",
                                  //       BlocProvider.of<RegistrationCubit>(
                                  //               context)
                                  //           .studentImage);
                                  //   stuPhoto = shared.getString("studentImage");
                                  // });
                                  // setState(() => profilePhoto = value);
                                });
                              },
                              child: Material(
                                elevation: 4,
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  width: 85,
                                  height: 85,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade400.withOpacity(0.7),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: ColorConstants.darkBlue)),
                                  child: profilePhoto != null
                                      ? GestureDetector(
                                          onTap: () async {
                                            final shared = await SharedPreferences.getInstance();
                                            await _picker.pickImage(source: ImageSource.gallery).then((value) {
                                              setState(() {
                                                profilePhoto = value;
                                              });
                                              // BlocProvider.of<
                                              //             RegistrationCubit>(
                                              //         context)
                                              //     .getImagePath(profilePhoto!)
                                              //     .then((value) {
                                              //   shared.setString(
                                              //       "studentImage",
                                              //       BlocProvider.of<
                                              //                   RegistrationCubit>(
                                              //               context)
                                              //           .studentImage);
                                              //   stuPhoto = shared
                                              //       .getString("studentImage");
                                              // });
                                            });
                                          },
                                          child: Container(
                                            width: 85,
                                            height: 85,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade400.withOpacity(0.7),
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: FileImage(File(profilePhoto!.path)), fit: BoxFit.cover),
                                                border: Border.all(color: ColorConstants.darkBlue)),
                                          ),
                                        )
                                      : Center(
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.add,
                                              color: ColorConstants.darkBlue,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),

                            // upload photo text
                            Text(
                              tr(StringConstants.uploadYourPhoto),
                              style: TextStyle(color: Colors.blue, fontSize: 10, fontFamily: FontConstants.poppins),
                            ),
                            // username field
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  headingText(tr(StringConstants.fullName)),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    cursorColor: ColorConstants.lightBlue,
                                    style: const TextStyle(fontSize: 14, fontFamily: FontConstants.poppins),
                                    decoration: inputDecoration(tr(StringConstants.enterYourName)),
                                    controller: userNameTextEditingController,
                                    validator: (value) {
                                      return value!.length > 3 ? null : tr(StringConstants.enter_valid_username);
                                    },
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 15.h),
                            // university name drop down field
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  headingText(tr("University Name")),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField(
                                    isExpanded: true,
                                    iconDisabledColor: Colors.grey,
                                    iconEnabledColor: Colors.black,
                                    // value: "tanta",
                                    items: BlocProvider.of<RegistrationCubit>(context).universities.map((universities) {
                                      return DropdownMenuItem(
                                        value: universities,
                                        child: Text(universities.universityName),
                                      );
                                    }).toList(),
                                    dropdownColor: Colors.white,
                                    style: const TextStyle(color: Colors.black, fontSize: 14),
                                    decoration: inputDecoration(tr("select university name")),
                                    onChanged: (value) {
                                      // getSelectedUniversityId(value as Map);
                                      // setState(()=> collegeName = null);

                                      BlocProvider.of<RegistrationCubit>(context).universities.forEach((element) {
                                        if (element == value) {
                                          universityId = element.universityId;
                                        }
                                      });
                                    },
                                    validator: (val) {
                                      return val != null ? null : tr("select university name");
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15.h),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       headingText(tr(StringConstants.gender)),
                            //       Row(
                            //         crossAxisAlignment: CrossAxisAlignment.center,
                            //         children: [
                            //           Radio(
                            //               value: tr(StringConstants.male),
                            //               groupValue: stdGrade,
                            //               activeColor: Colors.deepOrange,
                            //               onChanged: (val) {
                            //                 setState(() {
                            //                   stdGrade = val as String;
                            //                 });
                            //               }),
                            //           Text(
                            //             tr(StringConstants.male),
                            //             // maxLines: 2,
                            //           )
                            //         ],
                            //       ),
                            //       Row(
                            //         crossAxisAlignment: CrossAxisAlignment.center,
                            //         children: [
                            //           Radio(
                            //               value: tr(StringConstants.female),
                            //               groupValue: stdGrade,
                            //               activeColor: Colors.deepOrange,
                            //               onChanged: (val) {
                            //                 setState(() {
                            //                   stdGrade = val as String;
                            //                 });
                            //               }),
                            //           Text(
                            //             tr(StringConstants.female),
                            //             // maxLines: 2,
                            //           )
                            //         ],
                            //       ),
                            //       if (stdGrade == null && done == true)
                            //         Text(
                            //           tr(StringConstants.genderRequired),
                            //           style: const TextStyle(color: Colors.red),
                            //         )
                            //     ],
                            //   ),
                            // ),
                            const SizedBox(height: 15),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                    value: checkboxValue,
                                    activeColor: Colors.deepOrange,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                    onChanged: (val) {
                                      setState(() {
                                        checkboxValue = val!;
                                      });
                                    }),
                                Expanded(
                                  child: SizedBox(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()));
                                      },
                                      child: Text(
                                        tr(StringConstants.policy),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),

                            if (checkboxValue == false && done == true)
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    tr(
                                      StringConstants.agreementToTermsIsRequired,
                                    ),
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            state is RegisterLoading
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                                    child: CircularProgressIndicator(
                                      color: ColorConstants.darkBlue,
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                    child: state is RegisterLoading
                                        ? Center(
                                            child: CircularProgressIndicator(
                                            color: ColorConstants.darkBlue,
                                          ))
                                        : ElevatedButtonWidget(
                                            onPressed: () async {
                                              setState(() {
                                                done = true;
                                              });
                                              // Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignInScreen()));
                                              if (_formKey.currentState!.validate() &&
                                                  checkboxValue == true
                                                  // &&
                                                  // stdGrade != null
                                              ) {
                                                BlocProvider.of<RegistrationCubit>(context)
                                                    .getImagePath(profilePhoto)
                                                    .then((value) {
                                                  BlocProvider.of<RegistrationCubit>(context).register(
                                                      studentPhoto:
                                                          BlocProvider.of<RegistrationCubit>(context).studentImage,
                                                      // studentGender: stdGrade!,
                                                      phoneNumber: widget.phoneNumber,
                                                      studentSerial: deviceToken??"",
                                                      studentToken: deviceToken ?? "",
                                                      studentGrade: gradeTextEditingController.text,
                                                      universityId: universityId!,
                                                      studentName: userNameTextEditingController.text);
                                                  debugPrint(
                                                      "image : ${BlocProvider.of<RegistrationCubit>(context).studentImage}");
                                                });

                                                // stuPhoto=shared.getString("studentImage");
                                              }
                                            },
                                            buttonText: tr(StringConstants.createAccount),
                                          ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
