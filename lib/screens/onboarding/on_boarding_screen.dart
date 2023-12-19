import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ts_academy/constants/color_constants.dart';
import 'package:ts_academy/controller/about_us/about_us_cubit.dart';
import 'package:ts_academy/modules/modules.dart';

import '/constants/string_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '/constants/font_constants.dart';
import '/modules/elevated_button.dart';
import '/screens/authorization/sign_in_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  bool screenRecordingDetected = false;

  @override
  void initState() {
    BlocProvider.of<AbutUsCubit>(context).makeOnBoarding();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: BlocConsumer<AbutUsCubit, AbutUsState>(
          listener: (context, state) {
            if (state is OnBoardingFailure) {
              Modules().toast(state.message, Colors.red);
            }
          },
          builder: (context, state) {
            return state is OnBoardingLoaded
                ? ListView(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // const Spacer(),
                      Center(
                          child: CachedNetworkImage(
                        height: MediaQuery.of(context).size.height * 0.5,
                        imageUrl: BlocProvider.of<AbutUsCubit>(context).onBoardings[0].image_url,
                        errorWidget: (c, x, s) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                          );
                        },
                        placeholder: (c, x) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                          );
                        },
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          tr(StringConstants.welcomeToCxAcademy),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            letterSpacing: 2,
                            fontWeight: FontWeight.w700,
                            fontFamily: FontConstants.inter,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          BlocProvider.of<AbutUsCubit>(context).onBoardings[0].text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: FontConstants.poppins,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        child: ElevatedButtonWidget(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
                          },
                          buttonText: tr(StringConstants.getStarted),
                        ),
                      )
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: ColorConstants.lightBlue,
                    ),
                  );
          },
        ),
      ),
    );
  }
}
