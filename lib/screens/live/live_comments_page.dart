import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:ts_academy/constants/constants.dart';
import 'package:ts_academy/modules/modules.dart';
import '../../constants/color_constants.dart';
import '../../constants/font_constants.dart';
import '../../constants/string_constants.dart';
import '../../controller/live_comments/live_comments_cubit.dart';
import '../../models/live_comments_model.dart';
class LiveCommentPage extends StatefulWidget {
  const LiveCommentPage({Key? key}) : super(key: key);

  @override
  State<LiveCommentPage> createState() => _LiveCommentPageState();
}

class _LiveCommentPageState extends State<LiveCommentPage> {
  TextEditingController controller=TextEditingController();
  String commentPost="";
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      BlocProvider.of<LiveCommentsCubit>(context).getLiveComments(stuId!);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(
            tr(StringConstants.comments),
            style: const TextStyle(
                color: Colors.black, fontFamily: FontConstants.poppins),
          ),
        ),
        body: BlocConsumer<LiveCommentsCubit, LiveCommentsState>(
          listener: (context, state) {
            if (state is GetLiveCommentsFailure) {
              Modules().toast(state.message,Colors.red);
            } else if (state is InsertLiveCommentsFailure) {
              Modules().toast(state.message,Colors.red);
            } else if (state is InsertLiveCommentsLoaded) {
              Modules().toast(state.message,Colors.green);
            }
          },
          builder: (context, state) {
            return state is GetLiveCommentsLoading
                ? Center(
              child: CircularProgressIndicator(
                color: ColorConstants.purpal,
              ),
            )
                : Column(mainAxisSize: MainAxisSize.max, children: [
              BlocProvider.of<LiveCommentsCubit>(context).commentsList.isEmpty
                  ? Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Lottie.asset('assets/lottie/nothing.json'),
                        Text(tr(StringConstants
                            .there_is_no_comments_until_now))
                      ],
                    ),
                  ),
                ),
              )
                  : Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: BlocProvider.of<LiveCommentsCubit>(context)
                      .commentsList
                      .length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListTile(
                        title:  Text(
                            "${myName}"),
                        subtitle: Text(
                            BlocProvider.of<LiveCommentsCubit>(context)
                                .commentsList[index]
                                .comment),

                      ),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: TextFormField(
                          controller: controller,
                          onChanged: ( v ) {
                            setState(() {
                              commentPost = v;
                            });
                          },
                          cursorColor: ColorConstants.lightBlue,
                          style: const TextStyle(
                              fontSize: 13,
                              fontFamily: FontConstants.poppins),
                          decoration: InputDecoration(
                            hintText: tr(StringConstants.write_a_comment),
                            hintStyle: const TextStyle(
                                fontSize: 13,
                                fontFamily: FontConstants.poppins),
                            contentPadding:
                            const EdgeInsets.fromLTRB(20, 18, 20, 18),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: ColorConstants.lightBlue,
                                    width: 5)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: ColorConstants.lightBlue)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: ColorConstants.lightBlue)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                const BorderSide(color: Colors.red)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: ColorConstants.lightBlue)),
                          ),
                          validator: (value) {
                            return value!.length >= 6
                                ? null
                                : tr(StringConstants
                                .enter_6_digit_password);
                          },
                        )),
                  ),
                  state is InsertLiveCommentsLoading
                      ? Center(
                    child: CircularProgressIndicator(
                      color: ColorConstants.darkBlue,
                    ),
                  )
                      : IconButton(
                    icon: const Icon(Icons.send),
                    onPressed:controller.text.isEmpty?null: () {
                      BlocProvider.of<LiveCommentsCubit>(context)
                          .addCommentInLive(comment: commentPost, controller: controller, liveId: "110", studentId: stuId!)
                          .then((value) {

                        BlocProvider.of<LiveCommentsCubit>(context).addCommentToList(LiveCommentModel(commentId: "", liveId: "", comment: commentPost, stuID: stuId!, date: "")
                        );
                      }
                      );
                    },
                    color: ColorConstants.lightBlue,
                  )
                ],
              ),
            ]);
          },
        ));
  }
}
