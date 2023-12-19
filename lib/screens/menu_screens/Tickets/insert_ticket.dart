import 'dart:io';

import '/constants/string_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/font_constants.dart';
import '../../../controller/student_ticket/struden_ticket_cubit.dart';
import '../../../modules/elevated_button.dart';
import '../../../modules/modules.dart';

class NewTicket extends StatefulWidget {
  const NewTicket({Key? key}) : super(key: key);

  @override
  State<NewTicket> createState() => _NewTicketState();
}

class _NewTicketState extends State<NewTicket> {
  final ImagePicker _picker = ImagePicker();
  XFile? ticketPhoto;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController issuesController = TextEditingController();
  String reason = "";
  final _formKey = GlobalKey<FormState>();
  var selectedTicket;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr(StringConstants.createTicket),
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: FontConstants.poppins,
                  color: ColorConstants.lightBlue,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 17.h,
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headingText(tr(StringConstants.fullName)),
                  SizedBox(
                    height: 8.h,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: tr(StringConstants.enterYourFullName),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.blue)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.blue)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.blue)),
                    ),
                    controller: fullNameController,
                    cursorColor: ColorConstants.lightBlue,
                    style: const TextStyle(
                        fontSize: 14, fontFamily: FontConstants.poppins),
                    validator: (value) {
                      return value!.length > 3
                          ? null
                          : tr(StringConstants.enterYourFullName);
                    },
                  ),
                  const SizedBox(height: 20),
                  // reason field
                  headingText(tr(StringConstants.selectReason)),
                  const SizedBox(height: 8),

                  DropdownButtonFormField(
                    isExpanded: true,
                    iconDisabledColor: Colors.grey,
                    iconEnabledColor: Colors.black,
                    value: selectedTicket,
                    items: ['Reason 1', 'Reason 2', 'Reason 3']
                        .map((reasons) => DropdownMenuItem(
                              value: reasons,
                              child: Text(reasons),
                            ))
                        .toList(),
                    validator: (val) {
                      return val != null
                          ? null
                          : tr(StringConstants.selectTicketReason);
                    },
                    dropdownColor: Colors.white,
                    decoration:
                        inputDecoration(tr(StringConstants.selectReason)),
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    onChanged: (value) {
                      setState(() {
                        selectedTicket = value;
                        if (value == "Reason 1") {
                          reason = "Reason 1";
                        } else if (value == "Reason 2") {
                          reason = "Reason 2";
                        }
                        if (value == "Reason 3") {
                          reason = "Reason 3";
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  // issue field
                  headingText(tr(StringConstants.writeIssue)),
                  const SizedBox(height: 8),
                  TextFormField(
                    cursorColor: ColorConstants.lightBlue,
                    controller: issuesController,
                    maxLines: 8,
                    style: const TextStyle(
                        fontSize: 14, fontFamily: FontConstants.poppins),
                    decoration: inputDecoration(
                      tr(StringConstants.enterYourIssue),
                    ),
                    validator: (value) {
                      return value!.length > 3
                          ? null
                          : tr(StringConstants.enterYourIssue);
                    },
                  ),
                  const SizedBox(height: 15),
                  // select pic circle
                  ticketPhoto == null
                      ? GestureDetector(
                          onTap: () async {
                            await _picker
                                .pickImage(source: ImageSource.gallery)
                                .then((value) {
                              setState(() => ticketPhoto = value);
                            });
                            print(ticketPhoto!.path.toString());
                          },
                          child: Container(
                            height: 110.h,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1.2),
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                height: double.infinity,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1.2),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  tr(StringConstants
                                      .clickToBrowseImagesOrFiles),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.grey),
                                )),
                          ))
                      : Center(
                          child: Stack(
                            children: [
                              Image.file(
                                File(ticketPhoto!.path),
                                height: 100.h,
                                width: 100.w,
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                child: CircleAvatar(
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          ticketPhoto = null;
                                        });
                                      },
                                      icon: const Icon(Icons.clear)),
                                ),
                              )
                            ],
                          ),
                        ),
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            BlocConsumer<StudentTickerCubit, StudentTicketState>(
              listener: (context, state) {
                if (state is InsertStudentTicketFailure) {
                  Modules().toast(state.message,Colors.red);
                } else if (state is InsertStudentTicketLoaded) {
                  Modules().toast(state.message,Colors.green);

                }
              },
              builder: (context, state) {
                return state is InsertStudentTicketLoading ||
                        state is GetImagePathLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: ColorConstants.darkBlue,
                        ),
                      )
                    : ElevatedButtonWidget(
                        buttonText: tr(StringConstants.createTicket),
                        onPressed: () async {
                          BlocProvider.of<StudentTickerCubit>(context)
                              .getImagePath(ticketPhoto)
                              .then((value) {
                            BlocProvider.of<StudentTickerCubit>(context)
                                .insertTicket(
                              photo:
                                  BlocProvider.of<StudentTickerCubit>(context)
                                          .ticketPhoto ??
                                      "",
                              fullName: fullNameController.text.toString(),
                              reason: reason.toString(),
                              issues: issuesController.text.toString(),
                            );
                            debugPrint(
                                BlocProvider.of<StudentTickerCubit>(context)
                                        .ticketPhoto ??
                                    "");
                            debugPrint(fullNameController.text.toString());
                            debugPrint(reason.toString());
                            debugPrint(issuesController.text.toString());
                          });

                          //     .then((value) {
                          //   BlocProvider.of<StudentTickerCubit>(context)
                          //       .getAllTicket(stuId: stuId!);
                          // });
                        });
              },
            ),
          ],
        ),
      ),
    );
  }
}
