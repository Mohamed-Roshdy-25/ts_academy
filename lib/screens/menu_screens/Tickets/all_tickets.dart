import '/constants/string_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/font_constants.dart';
import '../../../controller/student_ticket/struden_ticket_cubit.dart';

class AllTickets extends StatefulWidget {
  const AllTickets({Key? key}) : super(key: key);

  @override
  State<AllTickets> createState() => _AllTicketsState();
}

class _AllTicketsState extends State<AllTickets> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      BlocProvider.of<StudentTickerCubit>(context).getAllTicket();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentTickerCubit, StudentTicketState>(
      listener: (context, state) {
        if (state is StudentTicketFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red,
          ));
        }
      },
      builder: (context, state) {
        return state is StudentTicketLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.darkBlue,
                ),
              )
            : BlocProvider.of<StudentTickerCubit>(context).allTicket.isEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Lottie.asset('assets/lottie/nothing.json'),
                         Text(tr(StringConstants.thereIsNoTicketsUntilNow))
                      ],
                    ),
                  )
                : ListView.builder(
                    padding:
                        EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemCount: BlocProvider.of<StudentTickerCubit>(context)
                        .allTicket
                        .length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const ChatScreen()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: ColorConstants.lightBlue, width: 1),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 1.5,
                                    blurRadius: 2,
                                    color:
                                        ColorConstants.purpal.withOpacity(0.4)),
                              ]),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Text(
                                        "${tr(StringConstants.ticketNumber)} - ${BlocProvider.of<StudentTickerCubit>(context).allTicket[index].ticketId}",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: FontConstants.poppins),
                                      ),
                                    ),
                                  ),
                                  // BlocProvider.of<StudentTickerCubit>(context)
                                  //             .allTicket[index]
                                  //             .status ==
                                  //         'active'
                                  //     ?
                                   Text(
                                    BlocProvider.of<StudentTickerCubit>(context).allTicket[index].status,
                                    // BlocProvider.of<StudentTickerCubit>(
                                    //         context)
                                    //     .allTicket[index]
                                    //     .status,
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                        fontFamily: FontConstants.poppins),
                                  )
                                  // : Text(
                                  //     BlocProvider.of<StudentTickerCubit>(
                                  //             context)
                                  //         .allTicket[index]
                                  //         .status,
                                  //     style: const TextStyle(
                                  //         color: Colors.green,
                                  //         fontSize: 12,
                                  //         fontFamily:
                                  //             FontConstants.poppins),
                                  //   ),
                                ],
                              ),
                              // Text(BlocProvider.of<StudentTickerCubit>(context)
                              //     .allTicket[index]
                              //     .reason)
                            ],
                          ),
                        ),
                      );
                    });
      },
    );
  }
}
