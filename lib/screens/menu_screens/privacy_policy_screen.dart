import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/color_constants.dart';
import '../../constants/font_constants.dart';
import '../../constants/string_constants.dart';
import '../../controller/privacy_policy/privacy_policy_cubit.dart';
import '../../modules/modules.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  void initState() {
    BlocProvider.of<PrivacyPolicyCubit>(context).getPrivacyMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          tr(StringConstants.privacyPolicy),
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
      body: BlocConsumer<PrivacyPolicyCubit, PrivacyPolicyState>(
        listener: (context, state) {
          if (state is PrivacyPolicyFailure) {
            Modules().toast(state.message, Colors.red);

          }
        },
        builder: (context, state) {
          return state is PrivacyPolicyLoading
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
                        tr(StringConstants.privacyPolicy),
                        style: const TextStyle(
                            fontFamily: FontConstants.poppins,
                            fontSize: 17,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        BlocProvider.of<PrivacyPolicyCubit>(context).message,
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
