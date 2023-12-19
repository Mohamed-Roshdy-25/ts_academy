import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/font_constants.dart';
import '../../../constants/string_constants.dart';
import 'all_tickets.dart';
import 'insert_ticket.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({Key? key}) : super(key: key);
  @override
  _TicketsScreenState createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () {
    //   BlocProvider.of<StudentTickerCubit>(context).getAllTicket(stuId: stuId!);
    // });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'tickets'.tr(),
            style: TextStyle(
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
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              TabBar(
                indicatorColor: ColorConstants.lightBlue,
                labelColor: ColorConstants.lightBlue,
                labelStyle: TextStyle(
                    fontFamily: FontConstants.poppins,
                    color: ColorConstants.lightBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
                tabs:  [
                  Tab(text: tr(StringConstants.createTicket)),
                  Tab(text: tr(StringConstants.tickets)),
                ],
              ),
              Expanded(
                child: const TabBarView(
                  children: [
                    NewTicket(),
                    AllTickets(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
