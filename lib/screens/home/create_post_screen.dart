import 'dart:io';
import 'package:ts_academy/screens/new_live_broadcast/new_channels_list.dart';
import '../../controller/permission_cubit/permission_cubit.dart';
import '/controller/student_posts/student_posts_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/constants.dart';
import '../../constants/string_constants.dart';
import '/constants/image_constants.dart';
import '/modules/elevated_button.dart';
import '../../constants/color_constants.dart';
import '../../constants/font_constants.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  TextEditingController postTextEditingController = TextEditingController();

  String? universityName, collegeName, className, accountType;
  // List universitiesList = ['University 1', 'University 2', 'University 3'];
  final _formKey = GlobalKey<FormState>();
  List colleges = [];
  List classes = [];
  FilePickerResult? result;
  List images = [];
  bool isLoading = false;
  String? file1;

  @override
  void initState() {
    BlocProvider.of<PermissionCubit>(context).getUserPermission(stuId!);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorConstants.lightBlue,
        title: Text(
          tr(StringConstants.create_post),
          style: const TextStyle(
            fontFamily: FontConstants.poppins,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocConsumer<StudentPostsCubit, StudentPostsState>(
        listener: (context, state) {
          if (state is UploadFilesFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(state.errorMessage)));
          } else if (state is CreatePostsLoaded) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text(tr(StringConstants.done))));
            Navigator.pop(context);
            BlocProvider.of<StudentPostsCubit>(context).getAllPosts(stuId: stuId!);
          } else if (state is CreatePostsFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 1.3,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    BlocProvider.of<PermissionCubit>(context).postLivePermission.contains("live")
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => NewChannelsList(
                                                      localUserID: stuId!,
                                                      localUserName: myName!,
                                                    )))
                                        : showDialog(
                                            context: context,
                                            builder: (context) =>
                                                const AlertDialog(content: Text("You can't create A live Stream")));
                                  },
                                  child: Image.asset(
                                    ImagesConstants.liveVideo,
                                    color: Colors.red,
                                    scale: 3,
                                  )),
                              const SizedBox(width: 20),
                              GestureDetector(
                                  onTap: () async {
                                    result = await FilePicker.platform
                                        .pickFiles(allowMultiple: true, type: FileType.image)
                                        .then((value) {
                                      if (value != null) {
                                        setState(() {
                                          images.addAll(value.files);
                                          file1 = value.files.first.path;
                                        });
                                      }
                                      return null;
                                    });
                                  },
                                  child: Image.asset(
                                    ImagesConstants.image,
                                    scale: 3,
                                  )),
                              const SizedBox(width: 20),
                            ],
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            cursorColor: ColorConstants.lightBlue,
                            style: const TextStyle(fontSize: 13, fontFamily: FontConstants.poppins),
                            maxLines: 7,
                            decoration: InputDecoration(
                              hintText: tr(StringConstants.whatsInYourMind),
                              hintStyle: const TextStyle(fontSize: 11, fontFamily: FontConstants.poppins),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 10,
                                  child: stuPhoto == null || stuPhoto == ""
                                      ? const Icon(Icons.person)
                                      : Image.network(
                                          stuPhoto!,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              contentPadding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Colors.grey, width: 5)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Colors.grey)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Colors.grey)),
                            ),
                            controller: postTextEditingController,
                            validator: (value) {
                              return value!.length >= 6 ? null : tr(StringConstants.writeSomethingHere);
                            },
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            child: images.isNotEmpty
                                ? SingleChildScrollView(
                                    child: Wrap(
                                      children: images.map((imageone) {
                                        return Stack(
                                          children: [
                                            Card(
                                              child: SizedBox(
                                                height: 50,
                                                width: 50,
                                                child: Image.file(
                                                  File(imageone.path.toString()),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.indigo,
                                              child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    images.removeAt(images.indexOf(imageone));
                                                  });
                                                },
                                                icon: const Icon(Icons.remove),
                                                iconSize: 17,
                                              ),
                                            )
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  )
                                : Container(),
                          ),
                          const Spacer(),
                          // const SizedBox(height: 15),
                          GestureDetector(
                            onTap: () {
                              BlocProvider.of<PermissionCubit>(context).postLivePermission == "live" ||
                                      BlocProvider.of<PermissionCubit>(context).postLivePermission == "post*live"
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NewChannelsList(
                                                localUserID: stuId!,
                                                localUserName: myName!,
                                              )))
                                  : showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const AlertDialog(content: Text("You can't create A live Stream")));
                              ;
                            },
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 1.4,
                              child: Material(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[200],
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 13),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        ImagesConstants.liveVideo,
                                        scale: 3,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        tr(StringConstants.liveStreaming),
                                        style: TextStyle(
                                          color: Colors.grey[900],
                                          fontFamily: FontConstants.poppins,
                                          fontSize: 12,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          state is CreatePostsLoading || state is UploadFilesLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButtonWidget(
                                  buttonText: tr(StringConstants.done),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      BlocProvider.of<StudentPostsCubit>(context)
                                          .uploadFilesToServer(images, context, postTextEditingController.text);
                                    }
                                  })
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
