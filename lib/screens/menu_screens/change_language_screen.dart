import '/constants/constants.dart';
import '/constants/string_constants.dart';
import '/screens/home/home_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/color_constants.dart';
import '../../constants/font_constants.dart';
import '../../modules/elevated_button.dart';
import '../../modules/modules.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({Key? key}) : super(key: key);

  @override
  _ChangeLanguageScreenState createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  int languageChange=  local =="en"?1:2;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr(StringConstants.language),
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
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 25.h),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr(StringConstants.changeLanguage),
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFamily: FontConstants.poppins),
                      ),
                      const SizedBox(height: 10),
                      RadioListTile(
                        value: 1,
                        activeColor: Colors.deepOrange,
                        groupValue: languageChange,
                        onChanged: (value) {
                          setState(() {
                            languageChange = value as int;
                            print(languageChange);
                          });
                        },
                        title: const Text(
                          "English",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: FontConstants.poppins),
                        ),
                      ),
                      RadioListTile(
                        value: 2,

                        activeColor: Colors.deepOrange,
                        groupValue: languageChange,
                        onChanged: (value) {
                          setState(() {
                            languageChange = value as int;

                            print(languageChange);
                          });
                        },
                        title: const Text(
                          "اللغة العربية",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: FontConstants.poppins),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: ElevatedButtonWidget(
                  onPressed: () async {
                    final sharedPref = await SharedPreferences.getInstance();

                    if (languageChange == 1) {
                      EasyLocalization.of(context)
                          ?.setLocale(const Locale("en"));
                      await sharedPref.setString("locale","en" );
                      local = sharedPref.getString("locale")!;
                      setState(() {

                      });
                    } else {
                      EasyLocalization.of(context)
                          ?.setLocale(const Locale("ar"));
                      await sharedPref.setString("locale","ar" );
                      local = sharedPref.getString("locale")!;
                      setState(() {

                      });
                      setState(() {

                      });
                    }
                    restartApp(context);
                    Modules().toast(tr(StringConstants.languageChanged));
                  },
                  buttonText: tr(StringConstants.done),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void restartApp(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
        builder: (BuildContext context) =>
            const RestartWidget(child: HomePage())),
    (Route<dynamic> route) => false,
  );
}

class RestartWidget extends StatefulWidget {
  final Widget child;

  const RestartWidget({Key? key,  required this.child}) : super(key: key);

  static void restartApp(BuildContext context) {
    final _RestartWidgetState? state =
        context.findAncestorStateOfType<_RestartWidgetState>();
    if (state != null) {
      state.restartApp();
    }
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
