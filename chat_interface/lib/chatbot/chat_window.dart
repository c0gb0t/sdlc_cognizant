import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mhi_pred_app/chatbot/models/user_main.dart';
import '../../paginate_firestore/paginate_firestore.dart';
import 'package:mhi_pred_app/chatbot/chat_services.dart';
import 'package:mhi_pred_app/chatbot/models/message_model.dart';
import 'package:mhi_pred_app/chatbot/widgets/animated_wave.dart';
import 'package:mhi_pred_app/chatbot/widgets/chat_appbar.dart';
import 'package:mhi_pred_app/chatbot/widgets/messages/text_format.dart';

class ChatWindowPage extends StatefulWidget {
  final UserModel? user;

  const ChatWindowPage({Key? key, this.user}) : super(key: key);

  @override
  _ChatWindowPageState createState() => _ChatWindowPageState();
}

class _ChatWindowPageState extends State<ChatWindowPage> {
  initState() {
    super.initState();
    //
    // sendMessage(widget.user!, "context",
    //     "Hi ,Please paste the paragraph in the context window and then type you question in the below text field...", "0");
  }

  bool isExpanded = false;
  double composeHeight = 150000;
  TextEditingController messageTextController = new TextEditingController();
  TextEditingController contextTextController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    var collName = 'mhi_pred_app';
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double bottomBarHeight = MediaQuery.of(context).padding.bottom;
    // ScreenUtil.init(
    //     BoxConstraints(maxHeight: 650,maxWidth: 330),orientation: Orientation.portrait,designSize: Size(750, 1334)
    // );

    Size size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height - statusBarHeight - bottomBarHeight;
    final sheight = size.height;
    final swidth = size.width;

    // final sheight=ScreenUtil().screenHeight;
    composeHeight = height * 0.1;
    ScrollController _scrollController =
        new ScrollController(keepScrollOffset: true);

    debugPrint(statusBarHeight.toString());
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  height: sheight,
                  width: width,
                  color: Color.fromRGBO(227, 216, 255, 1),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      Container(height: sheight * 0.1, child: AppBarView()),
                      SizedBox(
                        height: 20,
                      ),
                     
                      SizedBox(
                        height: 10,
                      ),

                      Expanded(
                        child:Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [ SizedBox(width:0),Container(
                           width:swidth*0.4,
                                        height:sheight,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(40),
                                    // topLeft: Radius.circular(40)
                                    )),
                            child:   Padding(
                                  padding: EdgeInsets.only(top: 20,),
                                  child: SizedBox(
                                    //height: MediaQuery.of(context).size.height - 250,
                                    child: SizedBox(
                                      // width:swidth*0.4,
                                        // height:sheight,

                                      child: TextField(
                                       maxLines :null,
                                       keyboardType: TextInputType.multiline,
                                        controller: contextTextController,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        onChanged: (value) {},
                                        // onSubmitted: (value) {
                                        //   messageTextController.clear();
                                        //   String context = "context";
                                        //   sendMessage(widget.user!, context,
                                        //       value, "1");
                                        // },
                                        decoration:
                                            const InputDecoration.collapsed(
                                          hintText: 'Enter context',
                                        ),
                                      ),
                                    ),
                                  )),),
                                  const SizedBox(width:10),
                                  
                                  
                                  Container(
                                    height: sheight,
                                    width: swidth*0.59,
                          
                          
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(40),
                                    topLeft: Radius.circular(40))),
                            child:   Column(children: [  SizedBox(
                                      // width:swidth*0.6,
                                      height: sheight*0.7,
                                      child:                      Padding(
                                  padding: EdgeInsets.only(top: 20,right: 20,left: 20),
                                  child: PaginateFirestore(
                                    // itemsPerPage: 15,
                                    query: FirebaseFirestore.instance
                                        .collection(collName)
                                        .doc(widget.user!.uid)
                                        // .doc('mhi_pred')

                                        .collection('allMessages')
                                        .orderBy('timestamp', descending: true),
                                    //Change types accordingly
                                    itemBuilderType:
                                        PaginateBuilderType.listView,
                                    // to fetch real-time data
                                    isLive: true,
                                    reverse: true,
                                    // stream: streamMessages(widget.user),
                                    // builder: (context, snapshot) {
                                    //   if (snapshot.hasData) {
                                    //     List<MessageModel> messages =
                                    //         snapshot.data;
                                    //     return ListView.builder(
                                    //       reverse: true,
                                    //       controller: _scrollController,
                                    //       shrinkWrap: true,
                                    //       itemCount: messages.length,
                                    //       itemBuilder: (BuildContext context,
                                    //           int index) {
                                    itemBuilder:
                                        (context, documentSnapshots, index) {
                                     
                                      DocumentSnapshot doc =
                                          documentSnapshots[index];
                                      final MessageModel message =
                                          MessageModel.fromFirestore(doc);
                                      
                                      final bool isMe = message.senderId ==
                                          widget.user!.name!.split(' ')[0] +
                                              "@red";
                                     
                                      return TextFormat(message, isMe);
                                    },
                                  )
                                     
                                      )
                        ),
                        SizedBox(
                          width:swidth*0.6,
                          height:sheight*0.1,
                          child: _buildMessageComposer()
                        
                        )
                        ,])
                        ,)
                      

                    ],
                  ),
                ),
                
              ],
            ),
          ),
        ],
           ))
           
           
        ]
           
           ) );




  }

  _buildMessageComposer() {
    // return Consumer<ReplyProvider>(
    //   builder: (context, value, child) {
    // if (value.replyMessage.isText ||
    //     value.replyMessage.isDocument ||
    //     value.replyMessage.isAudio ||
    //     value.replyMessage.isContact ||
    //     value.replyMessage.isVideo) {
    //   if(composeHeight==70 ||composeHeight==180){
    //   setState(() {
    //     composeHeight=composeHeight+100;
    //   });
    //   }
    // }

    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      color: Colors.white,
      height: composeHeight,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        decoration: BoxDecoration(
            color: Color.fromRGBO(243, 242, 247, 1),
            //Color.fromRGBO(42, 15, 113, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            )),
        padding: EdgeInsets.symmetric(horizontal: 0.0),
        height: composeHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (value) {},
                        onSubmitted: (value) {
                          messageTextController.clear();
                          String context = contextTextController.text;
                          sendMessage(widget.user!, context, value, "1");
                        },
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Type a message',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset("assets/svgs/send.svg",
                          height: 23,
                          color: const Color.fromRGBO(42, 15, 113, 1),
                          semanticsLabel: 'A red up arrow'),
                      iconSize: 25.0,
                      onPressed: () {
                        String value = messageTextController.text;
                        // String context= contextTextController.text;
                        String context = contextTextController.text;
                        messageTextController.clear();
                        sendMessage(widget.user!, context, value, "1");
                      },
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: AnimatedWave(
                    height: 10,
                    speed: 1.5,
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: AnimatedWave(
                    height: 10,
                    speed: 1.3,
                    offset: 3.14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
