// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:ts_academy/screens/menu_screens/tickets_screen.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
//
// import '../../constants/color_constants.dart';
// import '../../constants/font_constants.dart';
// class TicketsChat extends StatefulWidget {
//   const TicketsChat({Key? key, required this.ticketNo}) : super(key: key);
//   final String? ticketNo;
//
//   @override
//   _TicketsChatState createState() => _TicketsChatState();
// }
//
// class _TicketsChatState extends State<TicketsChat> {
//   TextEditingController messageTextEditingController = TextEditingController();
//   XFile? selectedImage;
//   bool isSending = false;
//   var channel;
//
//   Widget chatMessages() {
//     return StreamBuilder(
//       stream: channel.stream,
//       builder: (context, snapshot) {
//         return Text(snapshot.hasData ? '${snapshot.data}' : 'No data to show');
//       },
//     );
//   }
//
//   messageTile(BuildContext context, String message, imageUrl, videoUrl,
//       audioUrl, bool isSendByMe, String time) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 5),
//       width: MediaQuery.of(context).size.width,
//       alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
//       padding: EdgeInsets.only(
//           left: isSendByMe ? 40 : 10, right: isSendByMe ? 10 : 40),
//       child: GestureDetector(
//         child: Column(
//           crossAxisAlignment:
//           isSendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             Container(
//               // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
//               padding: imageUrl != '' && message != ''
//                   ? const EdgeInsets.fromLTRB(2, 2, 2, 10)
//                   : imageUrl != '' && message == ''
//                   ? const EdgeInsets.fromLTRB(2, 2, 2, 2)
//                   : imageUrl != '' && message == '(Image File)'
//                   ? const EdgeInsets.fromLTRB(2, 2, 2, 2)
//                   : videoUrl != '' && message == ''
//                   ? const EdgeInsets.fromLTRB(2, 2, 2, 2)
//                   : videoUrl != '' && message == '(Video File)'
//                   ? const EdgeInsets.fromLTRB(2, 2, 2, 2)
//                   : videoUrl != '' && message != ''
//                   ? const EdgeInsets.fromLTRB(2, 2, 2, 10)
//                   : audioUrl != '' && message == ''
//                   ? const EdgeInsets.fromLTRB(
//                   2, 2, 2, 2)
//                   : audioUrl != '' &&
//                   message == '(Audio File)'
//                   ? const EdgeInsets.fromLTRB(
//                   2, 2, 2, 2)
//                   : audioUrl != '' && message != ''
//                   ? const EdgeInsets.fromLTRB(
//                   2, 2, 2, 10)
//                   : const EdgeInsets.symmetric(
//                   vertical: 10,
//                   horizontal: 14),
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   border:
//                   Border.all(color: ColorConstants.lightBlue, width: 1.5),
//                   borderRadius: const BorderRadius.only(
//                       bottomRight: Radius.circular(18),
//                       topLeft: Radius.circular(18),
//                       topRight: Radius.circular(18),
//                       bottomLeft: Radius.circular(18))),
//               child: imageUrl != '' && message != ''
//                   ? Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>
//                                   PhotoViewScreen(imgUrl: imageUrl)));
//                     },
//                     child: Container(
//                       height: MediaQuery.of(context).size.height / 5,
//                       width: MediaQuery.of(context).size.width / 1.8,
//                       decoration: BoxDecoration(
//                           borderRadius: const BorderRadius.only(
//                               bottomRight: Radius.circular(18),
//                               topLeft: Radius.circular(18),
//                               topRight: Radius.circular(18),
//                               bottomLeft: Radius.circular(18)),
//                           image: DecorationImage(
//                               image: NetworkImage(imageUrl),
//                               fit: BoxFit.cover)),
//                     ),
//                   ),
//                   imageUrl != ''
//                       ? SizedBox(
//                       height: message == '(Image File)' ? 0 : 8)
//                       : Container(),
//                   Padding(
//                     padding: imageUrl != ''
//                         ? const EdgeInsets.symmetric(horizontal: 8)
//                         : const EdgeInsets.all(0),
//                     child: Text(
//                       message,
//                       overflow: TextOverflow.fade,
//                       maxLines: 4,
//                       style: TextStyle(
//                           color: isSendByMe ? Colors.white : Colors.black,
//                           fontSize: message == '(Image File)'
//                               ? 0
//                               : MediaQuery.of(context).size.width / 22),
//                     ),
//                   ),
//                 ],
//               )
//                   : message == '' && imageUrl != null
//                   ? GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               PhotoViewScreen(imgUrl: imageUrl)));
//                 },
//                 child: Container(
//                   height: MediaQuery.of(context).size.height / 5,
//                   width: MediaQuery.of(context).size.width / 1.8,
//                   decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(18),
//                           topRight: Radius.circular(18),
//                           bottomLeft: Radius.circular(18),
//                           bottomRight: Radius.circular(18)),
//                       image: DecorationImage(
//                           image: NetworkImage(imageUrl),
//                           fit: BoxFit.cover)),
//                 ),
//               )
//                   : message != '' && videoUrl != null
//                   ? Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       // Navigator.push(
//                       //     context,
//                       //     MaterialPageRoute(
//                       //         builder: (context) => PlayVideoScreen(
//                       //             videoURL: videoUrl)));
//                     },
//                     child: Container(
//                       height:
//                       MediaQuery.of(context).size.height / 5,
//                       width:
//                       MediaQuery.of(context).size.width / 1.8,
//                       decoration: BoxDecoration(
//                           color: Colors.pink.withOpacity(0.5),
//                           borderRadius: const BorderRadius.only(
//                               topLeft: Radius.circular(18),
//                               topRight: Radius.circular(18),
//                               bottomLeft: Radius.circular(18),
//                               bottomRight: Radius.circular(18)),
//                           image: const DecorationImage(
//                               fit: BoxFit.cover,
//                               colorFilter: ColorFilter.mode(
//                                   Colors.pink, BlendMode.overlay),
//                               image: AssetImage(
//                                   'assets/images/video_image.jpg'))),
//                       child: const Center(
//                         child: Icon(
//                           Icons.play_circle_fill,
//                           color: Colors.white,
//                           size: 30,
//                         ),
//                       ),
//                     ),
//                   ),
//                   videoUrl != ''
//                       ? SizedBox(
//                       height:
//                       message == '(Video File)' ? 0 : 8)
//                       : Container(),
//                   Padding(
//                     padding: videoUrl != ''
//                         ? const EdgeInsets.symmetric(
//                         horizontal: 8)
//                         : const EdgeInsets.all(0),
//                     child: Text(
//                       message,
//                       overflow: TextOverflow.fade,
//                       maxLines: 4,
//                       style: TextStyle(
//                           color: isSendByMe
//                               ? Colors.white
//                               : Colors.black,
//                           fontSize: message == '(Video File)'
//                               ? 0
//                               : MediaQuery.of(context)
//                               .size
//                               .width /
//                               22),
//                     ),
//                   ),
//                 ],
//               )
//                   : message != '' && audioUrl != null
//                   ? Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // MusicTile(musicURL: audioUrl),
//                   audioUrl != ''
//                       ? SizedBox(
//                       height: message == '(Audio File)'
//                           ? 0
//                           : 8)
//                       : Container(),
//                   Padding(
//                     padding: audioUrl != ''
//                         ? const EdgeInsets.symmetric(
//                         horizontal: 8)
//                         : const EdgeInsets.all(0),
//                     child: Text(
//                       message == '(Audio File)'
//                           ? ''
//                           : message,
//                       overflow: TextOverflow.fade,
//                       maxLines: 4,
//                       style: TextStyle(
//                           color: isSendByMe
//                               ? Colors.white
//                               : Colors.black,
//                           fontSize: message == '(Audio File)'
//                               ? 0
//                               : MediaQuery.of(context)
//                               .size
//                               .width /
//                               22),
//                     ),
//                   ),
//                 ],
//               )
//                   : Padding(
//                 padding: imageUrl != ''
//                     ? const EdgeInsets.symmetric(
//                     horizontal: 8)
//                     : const EdgeInsets.fromLTRB(8, 6, 8, 0),
//                 child: Text(
//                   message,
//                   overflow: TextOverflow.fade,
//                   maxLines: 4,
//                   style: TextStyle(
//                       color: isSendByMe
//                           ? Colors.white
//                           : Colors.black,
//                       fontSize:
//                       MediaQuery.of(context).size.width /
//                           22),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
//               child: Text(
//                 time,
//                 style: TextStyle(fontSize: 10),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   createTicketChat() async {
//     // setState(() => isLoading = true);
//
//     // var formData = FormData.fromMap({
//     //   'ticket_name': userNameTextEditingController.text,
//     //   'ticket_reason': ticketReason,
//     //   'ticket_issue': issueTextEditingController.text,
//     //   'ticket_status': 'initiated',
//     //   'ticket_image': await MultipartFile.fromFile(ticketPhoto!.path)
//     // });
//     //
//     // Response response = await dio.post(APIConstants.baseUrl + APIConstants.createTicket, data: formData,);
//     //
//     // if(response.statusCode == 200){
//     //   print(response.data);
//     //   print(response);
//     //   // Modules().toast('Sign Up Successfully!');
//     //   // setState(()=> isLoading = false);
//     //   // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SignInScreen()));
//     // } else if(response.data == 'User already exit'){
//     //   setState(()=> isLoading = false);
//     //   Modules().toast('Phone No. Already Exist');
//     // } else {
//     //   setState(()=> isLoading = false);
//     //   Modules().toast('Unknown Error Occurred. Please Try Again');
//     // }
//   //
//   //   var url = Uri.parse(APIConstants.baseUrl + APIConstants.createTicketChat);
//   //   print(
//   //       '--------------------------------------------------------------------------');
//   //   print(myAccessToken);
//   //   try {
//   //     var response = await http.post(url, headers: {
//   //       'Authorization': 'Bearer $myAccessToken',
//   //     }, body: {
//   //       'tchat_ticket': widget.ticketNo!.toString(),
//   //       'tchat_text': messageTextEditingController.text,
//   //       'tchat_img': '',
//   //       'tchat_user': ''
//   //     });
//   //
//   //     var data = json.decode(response.body);
//   //     if (response.statusCode == 200) {
//   //       print(response.statusCode);
//   //       print(data);
//   //       // setState(() => isLoading = false);
//   //       Modules().toast('Ticket Created!');
//   //       Navigator.pop(context);
//   //     } else {
//   //       print(response.statusCode);
//   //       print(data);
//   //       // setState(() => isLoading = false);
//   //     }
//   //   } catch (e) {
//   //     print(e.toString());
//   //     // setState(() => isLoading = false);
//   //   }
//   // }
//
//   @override
//   void initState() {
//     // channel = WebSocketChannel.connect(
//     //   Uri.parse(
//     //       'ws://127.0.0.1:8000/app/ticket/chat/${widget.ticketNo!}/?token=$tok'),
//     // );
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Ticket: ${widget.ticketNo!}",
//           style: const TextStyle(
//             fontFamily: FontConstants.poppins,
//             color: Colors.white,
//           ),
//         ),
//         leading: GestureDetector(
//           onTap: () async {
//             Navigator.pop(context);
//           },
//           child: const Padding(
//             padding: EdgeInsets.all(10.0),
//             child: Icon(Icons.arrow_back_ios_rounded),
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: ColorConstants.lightBlue,
//       ),
//       body: Stack(
//         children: [
//           Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 70),
//                 child: chatMessages(),
//               )),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   selectedImage != null
//                       ? Stack(
//                     children: [
//                       Container(
//                         width: MediaQuery
//                             .of(context)
//                             .size
//                             .width,
//                         height: MediaQuery
//                             .of(context)
//                             .size
//                             .height / 4,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(14),
//                             color: Colors.white,
//                             image: DecorationImage(
//                                 image:
//                                 FileImage(File(selectedImage!.path)),
//                                 fit: BoxFit.cover)),
//                       ),
//                       isSending == true
//                           ? const Center(
//                           child: CircularProgressIndicator())
//                           : Container()
//                     ],
//                   )
//                       : Container(),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       SizedBox(
//                         height: 50,
//                         width: MediaQuery
//                             .of(context)
//                             .size
//                             .width / 1.25,
//                         child: TextFormField(
//                           controller: messageTextEditingController,
//                           textAlignVertical: TextAlignVertical.center,
//                           style: const TextStyle(
//                               color: Colors.black, fontSize: 17),
//                           cursorColor: Colors.white,
//                           textAlign: TextAlign.left,
//                           minLines: 1,
//                           maxLines: 5,
//                           decoration: InputDecoration(
//                             // filled: true,
//                             // fillColor: Colors.grey[300],
//                             hintText: 'Type your message',
//                             hintStyle: TextStyle(
//                                 color: Colors.black.withOpacity(0.5),
//                                 fontSize: 14),
//                             contentPadding: const EdgeInsets.all(15),
//                             enabledBorder: const OutlineInputBorder(
//                                 borderRadius:
//                                 BorderRadius.all(Radius.circular(24))),
//                             focusedErrorBorder: const OutlineInputBorder(
//                                 borderRadius:
//                                 BorderRadius.all(Radius.circular(24))),
//                             disabledBorder: const OutlineInputBorder(
//                                 borderRadius:
//                                 BorderRadius.all(Radius.circular(24))),
//                             focusedBorder: const OutlineInputBorder(
//                                 borderRadius:
//                                 BorderRadius.all(Radius.circular(24))),
//                           ),
//                           showCursor: true,
//                         ),
//                       ),
//                       GestureDetector(
//                           onTap: () async {
//                             if (isSending == false) {
//                               if (messageTextEditingController
//                                   .text.isNotEmpty) {
//                                 print('------------------------');
//                                 await createTicketChat();
//                               } else if (selectedImage != null) {
//                                 print('---------0000000000000000---');
//                                 await createTicketChat();
//                               }
//                             }
//                           },
//                           child: Icon(Icons.send,
//                               color: ColorConstants.lightBlue, size: 25))
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }}
//
//
// }
//
// import 'package:flutter/material.dart';
// import 'package:agora_chat_sdk/agora_chat_sdk.dart';
//
// // Replaces <#Your app key#>, <#Your created user#>, and <#User Token#> and with your own App Key, user ID, and user token generated in Agora Console.
// class AgoraChatConfig {
//   static const String appKey = "71993967#1160000";
//   static const String userId = "A-h-m-e-d";
//   static const String agoraToken =
//       "007eJxTYNh16oqh7GHhxhD1e4+5jvNm1P9YuG2TlZ/k5Emt75bHpB5VYDC2TElNNDczMbJINDExTEmxMEhLtjBKNUo1SzY0M0kx4vdZktIQyMjAGpHBCCQZGIEQxFdhSDFMMzFPMzHQNUy0sNA1NExN1U1KtTDUNQKamJpmlmJpYJgMAINFJzs=";
// }
//
// class ChatScreen extends StatefulWidget {
//   const ChatScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   ScrollController scrollController = ScrollController();
//   String? _messageContent, _chatId;
//   final List<String> _logText = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _initSDK();
//     _addChatListener();
//   }
//
//   @override
//   void dispose() {
//     ChatClient.getInstance.chatManager.removeMessageEvent("UNIQUE_HANDLER_ID");
//     ChatClient.getInstance.chatManager.removeEventHandler("UNIQUE_HANDLER_ID");
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Chat Screen"),
//       ),
//       body: Container(
//         padding: const EdgeInsets.only(left: 10, right: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             const SizedBox(height: 10),
//             const Text("login userId: ${AgoraChatConfig.userId}"),
//             const Text("agoraToken: ${AgoraChatConfig.agoraToken}"),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: TextButton(
//                     onPressed: _signIn,
//                     style: ButtonStyle(
//                       foregroundColor: MaterialStateProperty.all(Colors.white),
//                       backgroundColor:
//                           MaterialStateProperty.all(Colors.lightBlue),
//                     ),
//                     child: const Text("SIGN IN"),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: TextButton(
//                     onPressed: _signOut,
//                     style: ButtonStyle(
//                       foregroundColor: MaterialStateProperty.all(Colors.white),
//                       backgroundColor:
//                           MaterialStateProperty.all(Colors.lightBlue),
//                     ),
//                     child: const Text("SIGN OUT"),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               decoration: const InputDecoration(
//                 hintText: "Enter recipient's userId",
//               ),
//               onChanged: (chatId) => _chatId = chatId,
//             ),
//             TextField(
//               decoration: const InputDecoration(
//                 hintText: "Enter message",
//               ),
//               onChanged: (msg) => _messageContent = msg,
//             ),
//             const SizedBox(height: 10),
//             TextButton(
//               onPressed: _sendMessage,
//               style: ButtonStyle(
//                 foregroundColor: MaterialStateProperty.all(Colors.white),
//                 backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
//               ),
//               child: const Text("SEND TEXT"),
//             ),
//             Flexible(
//               child: ListView.builder(
//                 controller: scrollController,
//                 itemBuilder: (_, index) {
//                   return Text(_logText[index]);
//                 },
//                 itemCount: _logText.length,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _initSDK() async {
//     ChatOptions options = ChatOptions(
//       appKey: AgoraChatConfig.appKey,
//       autoLogin: false,
//     );
//     await ChatClient.getInstance.init(options);
//     // Notify the SDK that the UI is ready. After the following method is executed, callbacks within `ChatRoomEventHandler`, ` ChatContactEventHandler`, and `ChatGroupEventHandler` can be triggered.
//     await ChatClient.getInstance.startCallback();
//   }
//
//   void _addChatListener() {
//     // Adds message status changed event.
//     ChatClient.getInstance.chatManager.addMessageEvent(
//         "UNIQUE_HANDLER_ID",
//         ChatMessageEvent(
//           onSuccess: (msgId, msg) {
//             _addLogToConsole("send message succeed");
//           },
//           onProgress: (msgId, progress) {
//             _addLogToConsole("send message succeed");
//           },
//           onError: (msgId, msg, error) {
//             _addLogToConsole(
//               "send message failed, code: ${error.code}, desc: ${error.description}",
//             );
//           },
//         ));
//     // Adds receive new messages event.
//     ChatClient.getInstance.chatManager.addEventHandler(
//       "UNIQUE_HANDLER_ID",
//       ChatEventHandler(onMessagesReceived: onMessagesReceived),
//     );
//   }
//
//   void onMessagesReceived(List<ChatMessage> messages) {
//     for (var msg in messages) {
//       switch (msg.body.type) {
//         case MessageType.TXT:
//           {
//             ChatTextMessageBody body = msg.body as ChatTextMessageBody;
//             _addLogToConsole(
//               "receive text message: ${body.content}, from: ${msg.from}",
//             );
//           }
//           break;
//         case MessageType.IMAGE:
//           {
//             _addLogToConsole(
//               "receive image message, from: ${msg.from}",
//             );
//           }
//           break;
//         case MessageType.VIDEO:
//           {
//             _addLogToConsole(
//               "receive video message, from: ${msg.from}",
//             );
//           }
//           break;
//         case MessageType.LOCATION:
//           {
//             _addLogToConsole(
//               "receive location message, from: ${msg.from}",
//             );
//           }
//           break;
//         case MessageType.VOICE:
//           {
//             _addLogToConsole(
//               "receive voice message, from: ${msg.from}",
//             );
//           }
//           break;
//         case MessageType.FILE:
//           {
//             _addLogToConsole(
//               "receive image message, from: ${msg.from}",
//             );
//           }
//           break;
//         case MessageType.CUSTOM:
//           {
//             _addLogToConsole(
//               "receive custom message, from: ${msg.from}",
//             );
//           }
//           break;
//         case MessageType.CMD:
//           {
//             // Receiving command messages does not trigger the `onMessagesReceived` event, but triggers the `onCmdMessagesReceived` event instead.
//           }
//           break;
//       }
//     }
//   }
//
//   void _signIn() async {
//     try {
//       await ChatClient.getInstance.loginWithAgoraToken(
//         AgoraChatConfig.userId,
//         AgoraChatConfig.agoraToken,
//       );
//       _addLogToConsole("login succeed, userId: ${AgoraChatConfig.userId}");
//     } on ChatError catch (e) {
//       _addLogToConsole("login failed, code: ${e.code}, desc: ${e.description}");
//     }
//   }
//
//   void _signOut() async {
//     try {
//       await ChatClient.getInstance.logout(true);
//       _addLogToConsole("sign out succeed");
//     } on ChatError catch (e) {
//       _addLogToConsole(
//           "sign out failed, code: ${e.code}, desc: ${e.description}");
//     }
//   }
//
//   void _sendMessage() async {
//     if (_chatId == null || _messageContent == null) {
//       _addLogToConsole("single chat id or message content is null");
//       return;
//     }
//
//     var msg = ChatMessage.createTxtSendMessage(
//       targetId: _chatId!,
//       content: _messageContent!,
//     );
//
//     ChatClient.getInstance.chatManager.sendMessage(msg);
//   }
//
//   void _addLogToConsole(String log) {
//     _logText.add("$_timeString: $log");
//     setState(() {
//       scrollController.jumpTo(scrollController.position.maxScrollExtent);
//     });
//   }
//
//   String get _timeString {
//     return DateTime.now().toString().split(".").first;
//   }
// }
