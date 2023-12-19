import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ts_academy/constants/color_constants.dart';
import 'package:ts_academy/constants/font_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Required'.tr(),  style: TextStyle(fontFamily: FontConstants.poppins, fontSize: 17, fontWeight: FontWeight.w700),),
        centerTitle: true,
        backgroundColor: ColorConstants.lightBlue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Update Required Des".tr(),
              style: TextStyle(fontFamily: FontConstants.poppins, fontSize: 17, fontWeight: FontWeight.w700),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(ColorConstants.lightBlue),
              ),
              onPressed: () {
                _launchUrl();
              },
              child: Text('Update Now'.tr(), style: TextStyle(fontFamily: FontConstants.poppins, fontSize: 17, fontWeight: FontWeight.w700),),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl() async {
    final Uri _url = Uri.parse('https://play.google.com/store/apps/details?id=com.ts_academy.ts_academy');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
