import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mhs_pred_app/chatbot/models/user_main.dart';
import 'package:mhs_pred_app/chatbot/widgets/UnicornOutlineButton.dart';
import 'package:mhs_pred_app/chatbot/widgets/audio_recorder.dart';
import 'package:mhs_pred_app/chatbot/widgets/loading_text.dart';
import 'package:mhs_pred_app/utils/string_extensions.dart';
import '../../paginate_firestore/paginate_firestore.dart';
import 'package:mhs_pred_app/chatbot/chat_services.dart';
import 'package:mhs_pred_app/chatbot/models/content_model.dart';
import 'package:mhs_pred_app/chatbot/widgets/animated_wave.dart';
import 'package:mhs_pred_app/chatbot/widgets/chat_appbar.dart';
import 'package:mhs_pred_app/chatbot/widgets/messages/text_format.dart';

double sheight = 0.0;
double swidth = 0.0;

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
    // sendComplaint(widget.user!, "context",
    //     "Hi ,Please paste the paragraph in the context window from which the code snippets need to be extracted...", "0");
  }

  String audioFilePath = '';
  String lcid = '';
  bool processingData = false;
  bool isExpanded = false;
  double composeHeight = 150000;
  TextEditingController filePathsTextController = new TextEditingController();
  TextEditingController fileUrlsTextController = new TextEditingController();
  List<String> filePaths = [];
  List<PlatformFile> files = [];

  @override
  Widget build(BuildContext context) {
    var collName = 'sdlc_cognizant';
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double bottomBarHeight = MediaQuery.of(context).padding.bottom;
    // ScreenUtil.init(
    //     BoxConstraints(maxHeight: 650,maxWidth: 330),orientation: Orientation.portrait,designSize: Size(750, 1334)
    // );

    Size size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height - statusBarHeight - bottomBarHeight;
    sheight = size.height;
    swidth = size.width;

    // final sheight=ScreenUtil().screenHeight;
    composeHeight = height * 0.1;
    ScrollController _scrollController =
        new ScrollController(keepScrollOffset: true);

    debugPrint(statusBarHeight.toString());
    return Scaffold(
        body: Stack(children: [
      SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            height: sheight,
            width: width,
            color: Color.fromRGBO(227, 216, 255, 1),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Container(height: sheight * 0.13, child: AppBarView()),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(
                              20,
                            ),
                            width: swidth * 0.4,
                            height: sheight * 0.35,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            child: Padding(
                                padding: EdgeInsets.only(
                                  top: 20,
                                ),
                                child: Row(children: [
                                  SizedBox(
                                    width: swidth * 0.3,
                                    height: sheight * 0.5,
                                    child: TextField(
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      controller: filePathsTextController,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      onChanged: (value) {},
                                      decoration:
                                          const InputDecoration.collapsed(
                                        // border: InputBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                                        hintText:
                                            'Selected files to upload will appear here',
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        FilePickerResult? result =
                                            await FilePicker.platform
                                                .pickFiles(allowMultiple: true);

                                        if (result != null) {
                                          // files = result.paths
                                          //     .map((path) => File(path!))
                                          //     .toList();
                                          files = result.files;
                                          print(files.length);
                                          files.forEach((f) {
                                            filePaths.add(f.name);
                                          });
                                          print(
                                              "------------------------------------\n got file:${filePaths}");
                                          filePathsTextController.value =
                                              TextEditingValue(
                                                  text: filePaths.join('\n'));
                                          setState(() {});
                                        } else {
                                          // User canceled the picker
                                        }
                                      },
                                      icon: Icon(
                                        Icons.cloud_upload,
                                        size: swidth * 0.05,
                                        color: Colors.blue,
                                      ))
                                  // ElevatedButton(child:Text("upload files"),onPressed: (){},),
                                ])),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(
                              20,
                            ),
                            width: swidth * 0.3,
                            height: sheight * 0.35,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            child: Padding(
                                padding: EdgeInsets.only(
                                  top: 20,
                                ),
                                child: Row(children: [
                                  SizedBox(
                                    width: swidth * 0.27,
                                    height: sheight * 0.5,
                                    child: TextField(
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      controller: fileUrlsTextController,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      onChanged: (value) {},
                                      decoration:
                                          const InputDecoration.collapsed(
                                        // border: InputBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                                        hintText:
                                            'Add urls of files that need to be processed',
                                      ),
                                    ),
                                  ),
                                ])),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        width: swidth * 0.35,
                        child: _buildSubmitButton(),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        // height: sheight*0.18,
                        width: swidth * 0.4,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(40))),
                        child: Column(children: [
                          StreamBuilder(
                            stream: streamContents(widget.user),
                            builder: (context, snapshots) {
                              ContentModel? pc, tc;
                              // lcid='1712420879057';
                              print(snapshots);
                              print(
                                  "snapshot data-----------${snapshots.hasData}");
                              if (snapshots.hasData &&
                                  snapshots.data?.length != 0) {
                                tc = snapshots.data?.first;
                                debugPrint(
                                    "------------------got tc ${tc?.getMap()['id']}");
                                debugPrint(
                                    "-----------------------lcid =${lcid}");
                              }
                              if (tc != null && tc.id == lcid) {
                                pc = tc;
                              }

                              if (pc != null && processingData == true) {
                                // if (pc?.audioURL != '') {
                                //   complaintTextController.value = TextEditingValue(
                                //       text:
                                //           "IndicWav2Vec output:${pc?.audioText}\n${pc.lang == 'english' ? '' : "IndicTrans2 output:${pc?.transText}"}");
                                // } else {
                                //   complaintTextController.value = TextEditingValue(
                                //       text:
                                //           "Complaint:${pc?.complaintText}\n${pc.lang == 'english' ? '' : "IndicTrans2 output:${pc?.transText}"}");
                                // }
                                // categoryTextController.value = TextEditingValue(
                                //     text: pc!.output.replaceAll(',', '\n'));

                                if (processingData == true) {
                                  Navigator.pop(context);
                                  processingData = false;
                                  Future.delayed(Duration.zero, () async {
                                    setState(() {});
                                  });
                                }
                              }

                              return Container(
                                padding: const EdgeInsets.all(30),
                                width: swidth * 0.6,
                                height: sheight * 0.18,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FloatingActionButton.extended(
                                        label: Text(
                                          'View Summary',
                                          style: TextStyle(color: Colors.white),
                                        ), // <-- Text
                                        backgroundColor: Colors.blue,
                                        icon: Icon(
                                          // <-- Icon
                                          Icons.remove_red_eye,
                                          size: 50.0,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          pc == null
                                              ? ContentModel(
                                                  timestamp: Timestamp.now())
                                              : pc;
                                          showSummary(pc!);
                                        },
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      FloatingActionButton.extended(
                                        label: Text(
                                          'Download Summary (PDF)',
                                          style: TextStyle(color: Colors.white),
                                        ), // <-- Text
                                        backgroundColor: Colors.blue,
                                        icon: Icon(
                                          // <-- Icon
                                          Icons.download,
                                          size: 50.0,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ]),
                              );
                            },
                          ),
                        ]),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ))
    ]));
  }

  showSummary(ContentModel? pc) {
    showDialog(
        context: context,
        // barrierColor: Colors.white,
        builder: (BuildContext context) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            elevation: 16,
            child: Container(
              decoration: BoxDecoration(
                // border: Border.all(
                //   color: Colors.red[500],
                // ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              // color: Colors.white,
              height: sheight,
              width: swidth * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: sheight * 0.2,
                    width: swidth,
                    child: ListView.builder(
                        physics: ClampingScrollPhysics(),
                        itemCount: 3,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                      width: index == 1 ? 150.0 : 100.0,
                                      height: index == 1 ? 200.0 : 60.0,
                                      child: Image.asset(
                                        index == 0
                                            ? "assets/azure.png"
                                            : index == 1
                                                ? "assets/cognizant.jpg"
                                                : "assets/azure.png",
                                        fit: BoxFit.cover,
                                      ))),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.all(
                      20,
                    ),
                    width: swidth * 0.4,
                    height: sheight * 0.65,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                      ),
                      child: SizedBox(
                        width: swidth * 0.3,
                        height: sheight * 0.5,
                        child: TextFormField(
                          initialValue: pc?.output,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          // controller: complaintTextController,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (value) {},

                          decoration: const InputDecoration.collapsed(
                            // border: InputBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                            hintText: 'Summary will appear here...',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  _buildSubmitButton() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      color: Color.fromRGBO(227, 216, 255, 1),
      height: composeHeight,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        height: composeHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // SizedBox(width: 0,),

                    Container(
                      alignment: Alignment.center,
                      // padding: EdgeInsets.all(30),
                      // width:swidth*0.2,
                      child: UnicornOutlineButton(
                        strokeWidth: 20,
                        radius: 24,
                        gradient: LinearGradient(
                          colors: [
                            Colors.pinkAccent.shade100,
                            Colors.blueAccent.shade100
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        child: Text('      Process Files      ',
                            style: TextStyle(fontSize: 30)),
                        onPressed: () async {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return LoadingText(
                                    loadingText: "Uploading Data");
                              });
                          List<String> upFileUrls =
                              filePaths == [] ? [] : await uploadFiles(files);
                          List<String> fileUrls =
                              fileUrlsTextController.text.split('\n');
                          fileUrls = fileUrls.where((x) {
                            return x != '';
                          }).toList();

                          lcid = await sendContent(widget.user!,
                              fileUrls: upFileUrls + fileUrls);
                          Navigator.pop(context);

                          print("data uploaded-------------------");
                          Flushbar(
                            title: 'Data Uploaded',
                            message: 'Data Uploaded successfully',
                            duration: Duration(seconds: 3),
                          ).show(context);

                          // setState(() {
                          processingData = true;
                          // });
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return LoadingText(
                                    loadingText:
                                        "Processing files using Azure AI Services");
                              });
                        },
                      ),
                    ),
                  ],
                ),
                // Positioned(
                //   bottom: 0.0,
                //   left: 0.0,
                //   right: 0.0,
                //   child: AnimatedWave(
                //     height: 10,
                //     speed: 1.5,
                //   ),
                // ),
                // Positioned(
                //   bottom: 0.0,
                //   left: 0.0,
                //   right: 0.0,
                //   child: AnimatedWave(
                //     height: 10,
                //     speed: 1.3,
                //     offset: 3.14,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
