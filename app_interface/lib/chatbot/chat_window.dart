import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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
import 'package:mhs_pred_app/chatbot/models/complaint_model.dart';
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
  TextEditingController complaintTextController = new TextEditingController();
  TextEditingController categoryTextController = new TextEditingController();
  String selectedLang = 'english';
  List<String> langs = [
    'Hindi',
    'English',
    'Assamese',
    'Bengali',
    'Bodo',
    'Dogri',
    'Konkani',
    'Gujarati',
    'Kannada',
    'Kashmiri',
    'Maithili',
    'Malayalam',
    'Marathi',
    'Manipuri',
    'Nepali',
    'Odia',
    'Punjabi',
    'Sanskrit',
    'Santali',
    'Sindhi',
    'Tamil',
    'Telugu',
    'Urdu'
  ].map((e) => e.toLowerCase()).toList();
  List<String> asr_langs = [
    'Bengali',
    'English',
    'Gujarati',
    'Hindi',
    'Marathi',
    'Nepali',
    'Odia',
    'Tamil',
    'Telugu',
    'Sinhala',
    'Kannada',
    'Malayalam'
  ].map((e) => e.toLowerCase()).toList();
  bool sttEnabled = true;

  @override
  Widget build(BuildContext context) {
    var collName = 'mh_bhasha3';
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
                      _buildLanguagePickerWidget((val) {
                        setState(() {
                          selectedLang = val!;
                          sttEnabled =
                              asr_langs.contains(selectedLang.toLowerCase());
                        });
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(
                          20,
                        ),
                        width: swidth * 0.7,
                        height: sheight * 0.3,
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
                                width: swidth * 0.5,
                                height: sheight * 0.5,
                                child: TextField(
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  controller: complaintTextController,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  onChanged: (value) {},
                                  // onSubmitted: (value) {
                                  //   complaintTextController.clear();
                                  //   String context = "context";
                                  //   sendComplaint(widget.user!, context,
                                  //       value, "1");
                                  // },
                                  decoration: const InputDecoration.collapsed(
                                    // border: InputBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                                    hintText:
                                        'Enter complaint in any of 22 scheduled languages or use voice to submit complaint.',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: swidth * 0.17,
                                child: sttEnabled
                                    ? Recorder(
                                        onStop: (path) {
                                          // if (kDebugMode)
                                          print('Recorded file path: $path');

                                          setState(() {
                                            complaintTextController.value =
                                                TextEditingValue(
                                                    text:
                                                        "recorded at path:${path}");
                                            audioFilePath = path;
                                            // audioPath = path;
                                            // showPlayer = true;
                                          });
                                        },
                                      )
                                    : Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.mic_off,
                                            size: swidth * 0.05,
                                          ),
                                          Text(
                                              "Speech to text is not \navailable for ${selectedLang}")
                                        ],
                                      ),
                              )

                              // IconButton(
                              //     iconSize: 50,
                              //     onPressed: () {
                              //       print("record voice");
                              //     },
                              //     icon: const Icon(Icons.mic_none_rounded))
                            ])),
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
                        width: swidth * 0.15,
                        child: _buildSubmitButton(),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        // height: sheight*0.3,
                        width: swidth * 0.59,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(40))),
                        child: Column(children: [
                          StreamBuilder(
                            stream: streamComplaints(widget.user),
                            builder: (context, snapshots) {
                              ComplaintModel? pc, tc;
                              // lcid='1712420879057';
                              if (snapshots.hasData &&
                                  snapshots.data?.length != 0) {
                                tc = snapshots.data?.first;
                                debugPrint(
                                    "------------------got tc ${tc?.getMap()}");
                                debugPrint(
                                    "-----------------------lcid =${lcid}");
                              }
                              if (tc != null && tc.id == lcid) {
                                pc = tc;
                              }

                              if (pc != null && processingData == true) {
                                if (pc?.audioURL != '') {
                                  complaintTextController.value = TextEditingValue(
                                      text:
                                          "IndicWav2Vec output:${pc?.audioText}\n${pc.lang == 'english' ? '' : "IndicTrans2 output:${pc?.transText}"}");
                                } else {
                                  complaintTextController.value = TextEditingValue(
                                      text:
                                          "Complaint:${pc?.complaintText}\n${pc.lang == 'english' ? '' : "IndicTrans2 output:${pc?.transText}"}");
                                }
                                categoryTextController.value = TextEditingValue(
                                    text: pc!.output.replaceAll(',', '\n'));

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
                                height: sheight * 0.2,
                                child: TextFormField(
                                  // initialValue: pc != null ? pc.output : '',
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  controller: categoryTextController,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  onChanged: (value) {},
                                  // onSubmitted: (value) {
                                  //   complaintTextController.clear();
                                  //   String context = "context";
                                  //   sendComplaint(widget.user!, context,
                                  //       value, "1");
                                  // },
                                  decoration: const InputDecoration.collapsed(
                                    // border: InputBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                                    hintText:
                                        'model output will appear here...',
                                  ),
                                ),
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

  Widget _buildLanguagePickerWidget(Function(String?)? onTap) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Row(
          children: [
            Icon(
              Icons.list,
              size: 16,
              color: Colors.yellow,
            ),
            SizedBox(
              width: 4,
            ),
            Expanded(
              child: Text(
                selectedLang.toCapitalized(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: langs
            .map((String item) => DropdownMenuItem<String>(
                  value: item.toCapitalized(),
                  child: Text(
                    item.toCapitalized(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        // value: selectedValue,
        onChanged: onTap,
        buttonStyleData: ButtonStyleData(
          height: 50,
          width: 160,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.black26,
            ),
            color: Colors.redAccent,
          ),
          elevation: 2,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_forward_ios_outlined,
          ),
          iconSize: 14,
          iconEnabledColor: Colors.yellow,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.redAccent,
          ),
          offset: const Offset(-20, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all(6),
            thumbVisibility: MaterialStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }

  _buildSubmitButton() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      color: Color.fromRGBO(227, 216, 255, 1),
      height: composeHeight,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        // decoration: BoxDecoration(
        //     color: Color.fromRGBO(243, 242, 247, 1),
        //     //Color.fromRGBO(42, 15, 113, 1),
        //     borderRadius: BorderRadius.only(
        //       topLeft: Radius.circular(30),
        //       topRight: Radius.circular(30),
        //       bottomLeft: Radius.circular(30),
        //       bottomRight: Radius.circular(30),
        //     )),
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
                  children: <Widget>[
                    // SizedBox(width: 0,),

                    Container(
                      alignment: Alignment.center,
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
                        child: Text('      Submit Complaint      ',
                            style: TextStyle(fontSize: 16)),
                        onPressed: () async {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return LoadingText(
                                    loadingText: "Uploading Data");
                              });
                          String audioFileUrl = audioFilePath == ''
                              ? ''
                              : await uploadAudioFile(audioFilePath);
                          String complaintText = complaintTextController.text;
                          lcid = await sendComplaint(widget.user!,
                              lang: selectedLang.toLowerCase(),
                              complaintText: complaintText,
                              audioURL: audioFileUrl);
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
                                        "Processing feedback using finetuned LLM");
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
