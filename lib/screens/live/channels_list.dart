/*
import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';
import 'Create_Live.dart';
import 'live_video.dart';

class ChannelList extends StatefulWidget {
  const ChannelList({super.key});

  @override
  State<ChannelList> createState() => _ChannelListState();
}

class _ChannelListState extends State<ChannelList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Channel List",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorConstants.purpal,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Create New Channel ",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 8,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CreateLiveScreen()));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                      color: ColorConstants.purpal,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Text(
                    "Create New Channel",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                )),
            const SizedBox(
              height: 25,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Latest Channels",
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
                child: ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: Colors.black87,
                        thickness: 0.8,
                      );
                    },
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: const Text("Math Channel"),
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return const LiveStream();
                          }));
                        },
                        leading: const Icon(
                          Icons.live_tv,
                          color: Colors.red,
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
*/
