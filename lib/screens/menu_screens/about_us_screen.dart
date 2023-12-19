import 'package:ts_academy/modules/modules.dart';

import '/constants/string_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/color_constants.dart';
import '../../constants/font_constants.dart';
import '../../controller/about_us/about_us_cubit.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      BlocProvider.of<AbutUsCubit>(context).getAboutUsMessage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr(StringConstants.about),
          style:
              const TextStyle(color: Colors.white, fontFamily: FontConstants.poppins),
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
      body: BlocConsumer<AbutUsCubit, AbutUsState>(
        listener: (context, state) {
          if (state is AbutUsFailure) {
           Modules().toast(state.message, Colors.red);
          }
        },
        builder: (context, state) {
          return state is AbutUsLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: ColorConstants.darkBlue,
                  ),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        tr(StringConstants.aboutCxAcademy),
                        style: const TextStyle(
                            fontFamily: FontConstants.poppins,
                            fontSize: 17,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        BlocProvider.of<AbutUsCubit>(context).message,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontFamily: FontConstants.poppins),
                      )
                    ],
                  ),
                );
        },
      ),
    );
  }
}
