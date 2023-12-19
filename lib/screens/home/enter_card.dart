import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:ts_academy/constants/image_constants.dart';
import 'package:ts_academy/controller/about_us/about_us_cubit.dart';
import 'package:ts_academy/modules/modules.dart';

import '../../animations/dialog_animation.dart';
import '../../constants/color_constants.dart';
import '../../constants/constants.dart';
import '../../constants/string_constants.dart';
import '../../controller/add_card/add_card_cubit.dart';

class EnterCardScreen extends StatefulWidget {
  const EnterCardScreen({Key? key}) : super(key: key);

  @override
  State<EnterCardScreen> createState() => _EnterCardScreenState();
}

class _EnterCardScreenState extends State<EnterCardScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController addCardController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () =>
          BlocProvider.of<AbutUsCubit>(context).changeIndex(0),
      child: Scaffold(
        appBar: Modules().appBar("Enter Card".tr()),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tr(StringConstants.enterInformation),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
              SizedBox(
                height: MediaQuery.of(context)
                    .size
                    .height *
                    0.01,
              ),
              Form(
                key: formKey,
                child: TextFormField(
                  onTapOutside: (e) {
                    FocusManager.instance.primaryFocus?.unfocus();

                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(14),
                    FilteringTextInputFormatter
                        .digitsOnly
                    // CardTextFormatter()
                  ],
                  controller: addCardController,
                  validator: (value) {
                    return value!.length == 14
                        ? null
                        : tr(StringConstants.enterValidCardCode);
                  },
                  maxLength: 14,
                  decoration: InputDecoration(
                      filled: true,
                      hintText:
                      tr(StringConstants.enterCode),
                      hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                          fontWeight:
                          FontWeight.w800),
                      fillColor: Colors.white,
                      border:
                      OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorConstants.darkBlue),
                      ),
                      enabledBorder:
                      OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorConstants.darkBlue,),
                      ),
                      focusedBorder:
                      OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorConstants.darkBlue),
                      )),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context)
                    .size
                    .height *
                    0.02,
              ),
              BlocConsumer<AddCardCubit, AddCardState>(
                  listener: (ctx, st) {
                    if(st is AddCardFailure) {
                      // Modules().toast(st.errorMessage,Colors.red);
                      showDialog(
                          context:
                          context,
                          builder: (x) {
                            if(st!= AddCardLoaded) {
                              return AnimatedDialog(
                                  child: DialogAfterAdded(
                                      message:
                                      st.errorMessage));
                            }else{
                              return SizedBox();
                            }
                          }

                      );
                    }

                  else if(st is AddCardLoaded) {
                      // Modules().toast(st.message, Colors.green);



                      showDialog(context: context, builder: (ctx)  {

                        return  Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(

                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(StringConstants.appName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: ColorConstants.darkBlue,
                                  ),
                                ),
                                SizedBox(height: 20,),

Lottie.asset(ImagesConstants.doneLottie),
                                SizedBox(height: 20,),
                                Text(tr(StringConstants.doneSubscription,),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstants.darkBlue,
                                ),
                                )
                              ],
                            ),
                          ),
                        );
                      });

                      addCardController.clear();

                    }
                  },
                  builder: (ctx, st) {
                    return st is AddCardLoading
                        ? Center(
                        child:
                        CircularProgressIndicator(
                          color: ColorConstants
                              .darkBlue,
                        ))
                        : MaterialButton(
                        minWidth: MediaQuery.of(
                            context)
                            .size
                            .width *
                            0.5,
                        height: MediaQuery.of(
                            context)
                            .size
                            .height *
                            0.06,
                        color: ColorConstants
                            .darkBlue,
                        shape: OutlineInputBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                                12)),
                        onPressed: () {
                          if (formKey
                              .currentState!
                              .validate()) {
                            BlocProvider
                                .of<
                                AddCardCubit>(
                                context)
                                .addCard(
                                cardCode: addCardController
                                    .text,
                                stuId:
                                stuId!);
                          }
                        },
                        child:  Text(
                          tr(StringConstants.add),
                          style: const TextStyle(
                              color:
                              Colors.white,
                              fontSize: 15,
                              fontWeight:
                              FontWeight
                                  .w600),
                        ));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
