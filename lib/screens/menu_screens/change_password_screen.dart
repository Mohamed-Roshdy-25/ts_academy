import '/constants/string_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/color_constants.dart';
import '../../constants/font_constants.dart';
import '../../modules/elevated_button.dart';
import '../../modules/modules.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool showPassword = false;
  bool oldShowPassword = false;
  TextEditingController oldPasswordTextEditingController =
      TextEditingController();
  TextEditingController newPasswordTextEditingController =
      TextEditingController();
  TextEditingController confirmNewPasswordTextEditingController =
      TextEditingController();
  bool confirmShowPassword = false;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  headingText(String fieldHeading) {
    return Text(
      fieldHeading,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          fontFamily: FontConstants.poppins),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Modules().appBar(

          tr(StringConstants.changePassword)),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 50.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headingText( tr(StringConstants.oldPassword)),
                const SizedBox(height: 8),
                CustomTextFormField(
                    hintText:  tr(StringConstants.enterOldPassword),
                    obscure: oldShowPassword,
                    controller: oldPasswordTextEditingController),
                const SizedBox(height: 15),
                // new password field
                headingText( tr(StringConstants.newPassword)),
                const SizedBox(height: 8),
                CustomTextFormField(
                  hintText:  tr(StringConstants.enterNewPassword),
                  obscure: showPassword,
                  controller: newPasswordTextEditingController,
                ),
                const SizedBox(height: 15),
                // confirm new password field
                headingText( tr(StringConstants.confirmNewPassword)),
                const SizedBox(height: 8),
                CustomTextFormField(
                    hintText:  tr(StringConstants.enterYourPassword),
                    controller: confirmNewPasswordTextEditingController,
                    obscure: confirmShowPassword),
                const Spacer(),

                ElevatedButtonWidget(
                  onPressed: () async {
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignInScreen()));
                    if (_formKey.currentState!.validate()) {
                    } else {
                      Modules().toast(
                        tr(StringConstants.enterAllDetails)
                      );
                    }
                  },
                  buttonText: tr(StringConstants.done
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField(
      {Key? key,
      required this.hintText,
      required this.obscure,
      required this.controller})
      : super(key: key);

  final String hintText;
  final bool obscure;
  final TextEditingController controller;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState(
      hintText: hintText, obscure: obscure, controller: controller);
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final String hintText;
  bool obscure;
  final TextEditingController controller;

  _CustomTextFormFieldState(
      {required this.controller,
      required this.hintText,
      required this.obscure});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: ColorConstants.lightBlue,
      style: const TextStyle(fontSize: 14, fontFamily: FontConstants.poppins),
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              obscure = !obscure;
            });
          },
          icon: obscure
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility_off),
        ),
        hintStyle:
            const TextStyle(fontSize: 13, fontFamily: FontConstants.poppins),
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
      controller: controller,
      validator: (value) {
        return value.toString() == controller.text
            ? null
            : tr(StringConstants.enterNewPassword);
      },
    );
  }
}
