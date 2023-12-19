import 'dart:async';

import '/constants/string_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../constants/color_constants.dart';
import '../../constants/font_constants.dart';
import '../../controller/auth_cubit/auth_states.dart';
import '../../controller/auth_cubit/registeration.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  // bool isLoading = false;
  //
  // getSubscriptions() {
  //   setState(()=> isLoading = true);
  //
  //   Timer.periodic(const Duration(seconds: 1), (timer)=> setState(()=> isLoading = false));
  // }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      BlocProvider.of<RegistrationCubit>(context).getUniversities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr(StringConstants.subscription),
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
          padding: const EdgeInsets.all(15),
          child: BlocConsumer<RegistrationCubit, AuthStates>(
            listener: (context, state) {
              if (state is GetUniversitiesFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                ));
              }
            },
            builder: (context, state) {
              return state is GetUniversitiesLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: ColorConstants.darkBlue,
                      ),
                    )
                  : BlocProvider.of<RegistrationCubit>(context)
                          .universities
                          .isEmpty
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            children: [
                              Lottie.asset('assets/lottie/nothing.json'),
                              Text(tr(StringConstants.noSubscription))
                            ],
                          ),
                        )
                      : ListView.separated(
                          separatorBuilder: (ctx, n) {
                            return SizedBox(
                              height: 20.h,
                            );
                          },
                          itemCount: BlocProvider.of<RegistrationCubit>(context)
                              .universities
                              .length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            return CustomSubscriptionCard(
                              facultyName:
                                  BlocProvider.of<RegistrationCubit>(context)
                                      .universities[index]
                                      .universityName,
                              universityName:
                                  BlocProvider.of<RegistrationCubit>(context)
                                      .universities[index]
                                      .collegeName,
                            );
                          });
            },
          )),
    );
  }
}

class CustomSubscriptionCard extends StatelessWidget {
  const CustomSubscriptionCard(
      {Key? key, required this.universityName, required this.facultyName})
      : super(key: key);

  final String universityName;
  final String facultyName;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorConstants.lightBlue, width: 1),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                spreadRadius: 3,
                blurRadius: 5,
                color: Colors.grey.withOpacity(0.2)),
          ]),
      child: Wrap(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  tr(StringConstants.tracks),
                  style: TextStyle(
                      fontFamily: FontConstants.poppins,
                      color: ColorConstants.lightBlue,
                      fontSize: 17,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Divider(
                thickness: 1,
                height: 1,
                color: ColorConstants.lightBlue,
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  "$universityName --> ${tr(StringConstants.facultyOf)} $facultyName --> ${tr(StringConstants.facultyName)}--> CS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: FontConstants.poppins,
                      color: ColorConstants.lightBlue,
                      fontSize: 14),
                ),
              ),
              Divider(
                thickness: 1,
                height: 1,
                color: ColorConstants.lightBlue,
              ),
              const SizedBox(height: 20),
              Text(
                "$universityName --> ${tr(StringConstants.facultyOf)} $facultyName --> ${tr(StringConstants.facultyName)} --> CS",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: FontConstants.poppins,
                    color: ColorConstants.lightBlue,
                    fontSize: 14),
              ),
              Divider(
                thickness: 1,
                height: 1,
                color: ColorConstants.lightBlue,
              ),
              SizedBox(
                height: 20.h,
              )
            ],
          )
        ],
      ),
    );
  }
}
