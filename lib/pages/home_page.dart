// ignore_for_file: sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_const_constructors

// import 'dart:convert';

import 'package:airad/model/radio.dart';
import 'package:airad/utils/ai_utils.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MyRadio> radios = [];
  late MyRadio _selectedRadio = MyRadio(
      id: 4,
      name: "95",
      tagline: "London UK Asian Music",
      color: "0xff0d487d",
      desc: "",
      url: "http://icy-e-01-cr.sharp-stream.com/1458.mp3",
      icon: "https://static.radio.net/images/broadcasts/5d/9c/37907/1/c175.png",
      image:
          "https://static.radio.net/images/broadcasts/5d/9c/37907/1/c175.png",
      lang: "English",
      category: "jazz",
      order: 4);
  late Color _selectedColor;
  bool _isPlaying = false;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    setupAlan();
    fetchRadios();

    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.playing) {
        _isPlaying = true;
      } else {
        _isPlaying = false;
      }
      setState(() {});
    });
  }

  setupAlan() {
    AlanVoice.addButton(
        "d64fc429e076bf6873e682bd01da87d82e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT);
    AlanVoice.activate();
    AlanVoice.onCommand.add((command) => _handleCommand(command.data));
    // AlanVoice.onCommand.add((command) {
    //   debugPrint("got new command ${command.toString()}");
    // });
  }

  _handleCommand(Map<String, dynamic> response) {
    switch (response["command"]) {
      case "play":
        _playMusic(_selectedRadio.url);
        break;

      case "play_channel":
        final id = response["id"];
        // _audioPlayer.pause();
        MyRadio newRadio = radios.firstWhere((element) => element.id == id);
        radios.remove(newRadio);
        radios.insert(0, newRadio);
        _playMusic(newRadio.url);
        break;

      case "stop":
        _audioPlayer.stop();
        break;
      case "next":
        final index = _selectedRadio.id;
        MyRadio newRadio;
        if (index + 1 > radios.length) {
          newRadio = radios.firstWhere((element) => element.id == 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        } else {
          newRadio = radios.firstWhere((element) => element.id == index + 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        }
        _playMusic(newRadio.url);
        break;

      case "prev":
        final index = _selectedRadio.id;
        MyRadio newRadio;
        if (index - 1 <= 0) {
          newRadio = radios.firstWhere((element) => element.id == 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        } else {
          newRadio = radios.firstWhere((element) => element.id == index - 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        }
        _playMusic(newRadio.url);
        break;
      default:
        print("Command was ${response["command"]}");
        break;
    }
  }

  fetchRadios() async {
    final radioJson = await rootBundle.loadString("assets/radio.json");
    radios = MyRadioList.fromJson(radioJson).radios;
    setState(() {});
  }

  _playMusic(String url) {
    _audioPlayer.play(AssetSource(url));
    _selectedRadio = radios.firstWhere((element) => element.url == url);
    // print(_selectedRadio);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AIColors.primaryColor1, AIColors.primaryColor2],
          begin: Alignment.centerLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 243, 149, 240)),
                child: Text(
                  'AI-RAD',
                  style: TextStyle(
                    color: Color.fromARGB(255, 139, 54, 54),
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                title: Text(
                  'Profile',
                ),
                textColor: Colors.white,
                onTap: () {
                  // Navigate to Profile page
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title: Text('Sign Out'),
                textColor: Colors.white,
                onTap: () {
                  // Perform sign out action
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          primary: true,
          title: "Tunes".text.xl4.bold.white.make().shimmer(
              primaryColor: Vx.purple300, secondaryColor: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
        ).h(100).p(6).preferredSize(Size.fromHeight(100)),
        body: Stack(
          children: [
            VxAnimatedBox()
                .size(context.screenWidth, context.screenHeight)
                .make(),
            radios.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : VxSwiper.builder(
                    itemCount: radios.length,
                    aspectRatio: 1.0,
                    enlargeCenterPage: true,
                    itemBuilder: (context, index) {
                      final rad = radios[index];
                      return VxBox(
                        child: ZStack(
                          [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: VStack(
                                [
                                  rad.name.text.xl3.white.bold.make(),
                                  5.heightBox,
                                  rad.tagline.text.sm.white.semiBold.make(),
                                ],
                                crossAlignment: CrossAxisAlignment.center,
                              ),
                            ),
                            Positioned(
                                top: 0.0,
                                right: 0.0,
                                child: VxBox(
                                  child: rad.category.text.uppercase.white
                                      .make()
                                      .px16(),
                                )
                                    .height(40)
                                    .black
                                    .alignCenter
                                    .withRounded(value: 5)
                                    .make()),
                            Align(
                                alignment: Alignment.center,
                                child: [
                                  Icon(CupertinoIcons.play_circle_fill,
                                      color: Colors.white),
                                  10.heightBox,
                                  "Double tap to play".text.gray300.make()
                                ].vStack()),
                          ],
                        ),
                      )
                          .clip(Clip.antiAlias)
                          .bgImage(
                            DecorationImage(
                                image: NetworkImage(rad.image),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.3),
                                    BlendMode.darken)),
                          )
                          .border(color: Colors.black, width: 4.0)
                          .withRounded(value: 60.0)
                          .make()
                          .onInkDoubleTap(() {
                        // if (radios.isNotEmpty) _playMusic('getlucky.mp3');
                        if (_isPlaying) {
                          // print('hello world\n\n\n\n\n');
                          _audioPlayer
                              .stop()
                              .then((value) => _playMusic(rad.url));
                          _playMusic(rad.url);
                        } else {
                          _playMusic(rad.url);
                        }
                        // _playMusic('getlucky.mp3');
                      }).p(16);
                    },
                  ).centered(),
            Align(
              alignment: Alignment.bottomCenter,
              child: [
                if (_isPlaying)
                  "Playing Now - ${_selectedRadio.name} FM"
                      .text
                      .white
                      .makeCentered(),
                Icon(
                        _isPlaying
                            ? CupertinoIcons.stop_circle_fill
                            : CupertinoIcons.play_circle_fill,
                        color: Colors.white,
                        size: 40.0)
                    .onInkTap(() {
                  if (_isPlaying) {
                    // print('hello world\n\n\n\n\n');
                    _audioPlayer.pause();
                  } else {
                    //  _playMusic(rad.url);
                  }
                })
              ].vStack(),
            ).pOnly(bottom: context.percentHeight * 4)
          ],
          fit: StackFit.expand,
          clipBehavior: Clip.antiAlias,
        ),
      ),
    );
  }
}
