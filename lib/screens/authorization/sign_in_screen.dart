import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_data/sim_data.dart';
import 'package:ts_academy/constants/constants.dart';
import 'package:ts_academy/modules/modules.dart';
import '/constants/color_constants.dart';
import '/constants/font_constants.dart';
import '/constants/image_constants.dart';
import '/constants/string_constants.dart';
import '/controller/auth_cubit/auth_states.dart';
import '/controller/auth_cubit/phone_cubit.dart';
import '/modules/elevated_button.dart';
import '/screens/authorization/sign_up_screen.dart';
import '../home/home_page.dart';
import 'dart:ui' as ui;

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String phoneNumber = '';
  final _formKey = GlobalKey<FormState>();
  bool showPassword = false;
  TextEditingController passwordTextEditingController = TextEditingController();
  bool isLoading = false;
  bool _isLoading = true;
  SimData? _simData;
  List<String> simStrings = [
    "vodafone",
    "Vodafone",
    "Orange EG",
    "orange",
    "we",
    "etisalat",
    "mobinil",
    "te"
  ];

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
    );
  }

  @override
  void initState() {
      init();
    super.initState();
  }

  Future<void> init() async {
    SimData simData;
    try {
      var status = await Permission.phone.status;
      if (!status.isGranted) {
        bool isGranted = await Permission.phone.request().isGranted;
        if (!isGranted){
          return;
        }

      }
      simData = await SimDataPlugin.getSimData();
      setState(() {
        _isLoading = false;
        _simData = simData;
      });
      void printSimCardsData() async {
        try {
          SimData simData = await SimDataPlugin.getSimData();
          for (var s in simData.cards) {
            BlocProvider.of<PhoneCubit>(context).changeSimCard(true);
            //todo: put update sim card method here


             simStrings.forEach((element) {
               if(s.carrierName.split(" ")[0].toString() == element)  {
                 BlocProvider.of<PhoneCubit>(context).changeSimCard(true);
                 return ;
               }
             });
            print('Serial number: ${s.carrierName}');
          }
        } on PlatformException catch (e) {
          debugPrint("error! code: ${e.code} - message: ${e.message}");
        }
      }

      printSimCardsData();
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        _isLoading = false;
        _simData = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<PhoneCubit, AuthStates>(listener: (ctx, state) {
        if (state is PhoneAuthFailure &&
            state.errorMessage != StringConstants.errorWhenResponse) {
          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  contentPadding: const EdgeInsets.all(8),
                  title: Text(
                    tr(StringConstants.failed),
                    style: const TextStyle(color: Colors.red),
                  ),
                  content: Text(
                    state.errorMessage,
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(tr(StringConstants.ok)))
                  ],
                );
              });
        }
        if (state is PhoneAuthSuccessExist) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        } else if (state is PhoneAuthSuccessNew) {
          debugPrint("this phone number from sign in $phoneNumber");

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SignUpScreen(
                        phoneNumber: phoneNumber,
                      )));
        } else if (state is GetDeviceIdFailure) {
          Modules().toast(state.errorMessage, Colors.red);
        } else if (state is PhoneAuthFailure) {
          if (state.errorMessage == StringConstants.errorWhenResponse) {
            Modules().toast(state.errorMessage, Colors.red);
          }
        }
      }, builder: (context, state) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    ImagesConstants.rightCircle,
                    scale: 2.5,
                  )),
            ),
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 90),

                    SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: Image.asset(ImagesConstants.logo)),

                    const SizedBox(height: 45),

                    // create account text
                    Center(
                      child: Text(
                        tr(StringConstants.login),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontFamily: FontConstants.poppins,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // phone number field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr(StringConstants.mobile_number),
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: FontConstants.poppins),
                          ),
                          const SizedBox(height: 8),
                          Directionality(
                            textDirection: ui.TextDirection.ltr,
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(
                                    11), // Limit to 10 characters
                              ],
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 13),
                              decoration: InputDecoration(
                                prefixIcon: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "  🇪🇬  +20  ",
                                      style: TextStyle(fontSize: 16),
                                    )
                                  ],
                                ),
                                counterText: ' ',
                                // hintTextDirection: arabicLang ? TextDirection.rtl : TextDirection.ltr,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.indigo[900]!),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.indigo[900]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.indigo[900]!),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.indigo[900]!),
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                              ),
                              onChanged: (val) {
                                phoneNumber = val;
                              },
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "*";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    // create account button
                    state is PhoneAuthLoading
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 20),
                            child: CircularProgressIndicator(
                              color: ColorConstants.darkBlue,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: ElevatedButtonWidget(
                              onPressed: () async{
                                if (phoneNumber.length < 10) {
                                  Modules().toast(tr(StringConstants.validNumber), Colors.red);
                                } else if (_formKey.currentState!.validate()) {
                                  if(phoneNumber.length == 10){
                                    print("=========");
                                    if(phoneNumber.startsWith("1")){
                                      debugPrint(phoneNumber);
                                      BlocProvider.of<PhoneCubit>(context).checkPhoneNumber(
                                          phoneNumber: phoneNumber,
                                          serialNumber: deviceToken??'');
                                    }else{
                                      Modules().toast(tr(StringConstants.validNumber), Colors.red);
                                    }
                                  }else if(phoneNumber.length == 11){
                                    print("==***********===");
                                    if(phoneNumber.startsWith("0")){
                                      debugPrint(phoneNumber);
                                      BlocProvider.of<PhoneCubit>(context).checkPhoneNumber(
                                          phoneNumber: phoneNumber.substring(1),
                                          serialNumber: deviceToken??'');
                                    }else{
                                      Modules().toast(tr(StringConstants.validNumber), Colors.red);
                                    }
                                  }
                                }
                              },
                              buttonText: tr(StringConstants.login),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({Key? key, required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(message),
      ),
    );
  }
}
