/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ts_academy/constants/color_constants.dart';

import 'live_video.dart';

class CreateLiveScreen extends StatefulWidget {
  const CreateLiveScreen({super.key});

  @override
  State<CreateLiveScreen> createState() => _CreateLiveScreenState();
}

class _CreateLiveScreenState extends State<CreateLiveScreen> {
  List subjects = ['Meth', 'Arabic', 'English'];
  List dropDownTypeList = ['for all Student', "for students in same subject"];
  String? dropDownChoose, subjectNameChoose;

  headingText(String fieldHeading) {
    return Text(
      fieldHeading,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
    );
  }

  subjectsDropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headingText(''
            'Subject Name'),
        const SizedBox(
          height: 4,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: DropdownButtonFormField(
            isExpanded: true,
            iconDisabledColor: Colors.grey,
            iconEnabledColor: Colors.black,
            value: subjectNameChoose,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                    )),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                    ))),
            items: subjects.map((subject) {
              return DropdownMenuItem(
                value: subject,
                child: Text(
                  "$subject",
                ),
              );
            }).toList(),
            dropdownColor: Colors.white,
            style: const TextStyle(color: Colors.black, fontSize: 14),
            onChanged: (value) {
              setState(() {
                subjectNameChoose = value.toString();
              });
            },
            validator: (val) {
              return val != null ? null : "Select subject name";
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.purpal,
        title: const Text(
          "Choose Live",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headingText("choose one from this list"),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: DropdownButtonFormField(
                isExpanded: true,
                iconDisabledColor: Colors.grey,
                iconEnabledColor: Colors.black,
                value: dropDownChoose,
                items: dropDownTypeList.map((dropdownType) {
                  return DropdownMenuItem(
                    value: dropdownType,
                    child: Text("$dropdownType"),
                  );
                }).toList(),
                dropdownColor: Colors.white,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.black87,
                        )),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.black87,
                        ))),
                style: const TextStyle(color: Colors.black, fontSize: 14),
                onChanged: (value) {
                  setState(() {
                    dropDownChoose = value.toString();
                  });
                },
                validator: (val) {
                  return val != null ? null : "Select channels Type";
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            dropDownChoose == "for students in same subject"
                ? subjectsDropDown()
                : const SizedBox(),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LiveStream()));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                        color: ColorConstants.purpal,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text(
                      "go to live",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
*/
