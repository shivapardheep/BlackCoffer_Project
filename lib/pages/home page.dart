import 'dart:io';

import 'package:blackcoffer_project/json/home_video.dart';
import 'package:blackcoffer_project/pages/login%20page.dart';
import 'package:blackcoffer_project/pages/video%20page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  int index = 0;
  //
  File? _video;
  final picker = ImagePicker();
  bool _retakevideo = false;
  VideoPlayerController? _videoPlayerController;

  _pickvideo() async {
    final video = await picker.getVideo(source: ImageSource.gallery);

    _video = File(video!.path);

    _videoPlayerController = VideoPlayerController.file(_video!)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController!.play();
      });
  }

  String currentAddress = 'My Address';
  Position? currentposition;
  Placemark? _placeuse;

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Please enable Your Location Service');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print(
          'Location permissions are permanently denied, we cannot request permissions');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];

      setState(() {
        currentposition = position;
        _placeuse = place;
        currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
    // return null;
  }

  _createvideo() async {
    _determinePosition();
    final video = await picker.getVideo(source: ImageSource.camera);

    _video = File(video!.path);

    _videoPlayerController = VideoPlayerController.file(_video!)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController!.play();
      });
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _video != null
          ? _videoPlayerController!.value.isInitialized
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _videoPlayerController!.value.isPlaying
                              ? _videoPlayerController!.pause()
                              : _videoPlayerController!.play();
                        });
                      },
                      child: Center(
                        child: Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          child: AspectRatio(
                            aspectRatio:
                                _videoPlayerController!.value.aspectRatio,
                            child: VideoPlayer(_videoPlayerController!),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _retakevideo != true
                                        ? _pickvideo()
                                        : _createvideo();
                                  },
                                  icon: Icon(Icons.flip_camera_android)),
                              Text('retake'),
                            ],
                          ),
                          RaisedButton(
                            onPressed: () {},
                            child: Text('Upload'),
                            color: Colors.green,
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : Container()
          : SafeArea(child: getBody()),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (current_index) {
          setState(() {
            index = current_index;
            current_index == 0
                ? Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false)
                : current_index == 1
                    ? showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Create',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ListTile(
                                leading: new Icon(Icons.photo),
                                title: new Text('Upload Video'),
                                onTap: () {
                                  setState(() {
                                    _retakevideo = false;
                                  });
                                  _pickvideo();
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: new Icon(Icons.camera_alt),
                                title: new Text('Create a Shot'),
                                onTap: () {
                                  setState(() {
                                    _retakevideo = true;
                                  });
                                  Navigator.pop(context);
                                  _createvideo();
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          );
                        })
                    : Container();
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Upload'),
        ],
      ),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return ListView(
      // padding: EdgeInsets.only(left: 20, right: 20),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                "assetts/youtube.svg",
                width: 35,
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.videocam,
                        color: Colors.white,
                        size: 28,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        LineIcons.search,
                        color: Colors.white,
                        size: 27,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        LineIcons.bell,
                        color: Colors.white,
                        size: 28,
                      )),
                  IconButton(
                      onPressed: () {
                        _auth.signOut().then((value) =>
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                                (route) => false));
                      },
                      icon: Icon(
                        Icons.exit_to_app_sharp,
                        color: Colors.white,
                        size: 28,
                      )),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Recomended...',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Column(
          children: List.generate(home_video.length, (index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    print('guest Clicked');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VideoOpen(
                                  profile: home_video[index]['profile_img'],
                                  name: home_video[index]['username'],
                                  unlikecount: home_video[index]
                                      ['unlike_count'],
                                  subscribecount: home_video[index]
                                      ['subscriber_count'],
                                  videourl: home_video[index]['video_url'],
                                  date: home_video[index]['day_ago'],
                                  likecount: home_video[index]['like_count'],
                                  title: home_video[index]['title'],
                                  thumnail: home_video[index]['thumnail_img'],
                                  viewcount: home_video[index]['view_count'],
                                )));
                  },
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                          image: AssetImage(home_video[index]['thumnail_img']),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: NetworkImage(
                                    home_video[index]['profile_img']),
                                fit: BoxFit.cover)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: size.width - 120,
                        child: Column(
                          children: [
                            Text(
                              home_video[index]['title'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.3),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  home_video[index]['username'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white38,
                                      fontSize: 10,
                                      height: 1.5),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  home_video[index]['day_ago'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white38,
                                      fontSize: 10,
                                      height: 1.5),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  home_video[index]['view_count'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white38,
                                      fontSize: 10,
                                      height: 1.5),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        LineIcons.verticalEllipsis,
                        color: Colors.white38,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
