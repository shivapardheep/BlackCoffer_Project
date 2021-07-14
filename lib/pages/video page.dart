import 'package:blackcoffer_project/json/home_video.dart';
import 'package:blackcoffer_project/location%20Pages/location_access.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:video_player/video_player.dart';

class VideoOpen extends StatefulWidget {
  final String thumnail;
  final String title;
  final String name;
  final String date;
  final String subscribecount;
  final String profile;
  final String likecount;
  final String unlikecount;
  final String videourl;
  final String viewcount;

  const VideoOpen(
      {Key? key,
      required this.thumnail,
      required this.title,
      required this.name,
      required this.date,
      required this.subscribecount,
      required this.profile,
      required this.likecount,
      required this.unlikecount,
      required this.videourl,
      required this.viewcount})
      : super(key: key);

  @override
  _VideoOpenState createState() => _VideoOpenState();
}

class _VideoOpenState extends State<VideoOpen> {
  bool isSwitched = true;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  // late int _playBackTime;

  @override
  void initState() {
    super.initState();
    print('Link Is : ' + widget.videourl);
    super.initState();
    _controller = VideoPlayerController.network(
        'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LocationPage()));
        },
        backgroundColor: Colors.green,
        child: Icon(
          Icons.location_on,
          color: Colors.deepOrange,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _controller.value.isInitialized
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 200,
                          width: _size.width,
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                        _controller.value.isBuffering
                            ? Positioned(
                                left: (_size.width - 40) / 2,
                                top: (_size.height - 600) / 2,
                                child: CircularProgressIndicator())
                            : Container(),
                      ],
                    ),
                  )
                : Container(
                    child: Padding(
                      padding: const EdgeInsets.all(70),
                      child: CircularProgressIndicator(),
                    ),
                  ),
            // : Container(
            //     height: 200,
            //     width: _size.width,
            //     decoration: BoxDecoration(
            //         image: DecorationImage(
            //             fit: BoxFit.cover,
            //             image: AssetImage(widget.thumnail.toString()))),
            //   ),
            Expanded(
                child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 15, right: 15, bottom: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: _size.width - 80,
                                child: Text(
                                  widget.title.toString(),
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    LineIcons.angleDown,
                                    size: 18,
                                    color: Colors.white70,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                widget.viewcount.toString() + ' views',
                                style: TextStyle(
                                    color: Colors.white38, fontSize: 12),
                              ),
                              Text(
                                '  -  ' + widget.date.toString(),
                                style: TextStyle(
                                    color: Colors.white38, fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Icon(
                                      // LineIcons.thumbsUp,
                                      Icons.thumb_up,
                                      color: Colors.white38,
                                      size: 26,
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      widget.likecount,
                                      style: TextStyle(
                                          color: Colors.white38, fontSize: 14),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(
                                      // LineIcons.thumbsUp,
                                      Icons.thumb_down,
                                      color: Colors.white38,
                                      size: 26,
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      widget.unlikecount,
                                      style: TextStyle(
                                          color: Colors.white38, fontSize: 14),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(
                                      // LineIcons.thumbsUp,
                                      Icons.share,
                                      color: Colors.white38,
                                      size: 26,
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      'Share',
                                      style: TextStyle(
                                          color: Colors.white38, fontSize: 14),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(
                                      // LineIcons.thumbsUp,
                                      Icons.download_sharp,
                                      color: Colors.white38,
                                      size: 26,
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      'Download',
                                      style: TextStyle(
                                          color: Colors.white38, fontSize: 14),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(
                                      // LineIcons.thumbsUp,
                                      Icons.add,
                                      color: Colors.white38,
                                      size: 26,
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      'Save',
                                      style: TextStyle(
                                          color: Colors.white38, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 10,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(widget.profile))),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.name,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.subscribecount,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white38,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Text(
                                        ' Subscribers',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white38,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              child: Text(
                                'SUBSCRIBE',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Divider(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 15, right: 10, bottom: 20),
                          child: Container(
                            child: Text(
                              'Up next',
                              style: TextStyle(color: Colors.white38),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Text(
                                'Autoplay',
                                style: TextStyle(color: Colors.white38),
                              ),
                              Switch(
                                  activeColor: Colors.blue,
                                  value: isSwitched,
                                  onChanged: (value) {
                                    setState(() {
                                      isSwitched = value;
                                    });
                                  })
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: List.generate(home_video.length, (index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  width: (_size.width - 50) / 2,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      // color: Colors.deepOrange,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(home_video[index]
                                              ['thumnail_img'])),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        bottom: 10,
                                        right: 12,
                                        child: Container(
                                          color: Colors.black45,
                                          height: 20,
                                          width: 45,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 2,
                                                bottom: 4,
                                                left: 4,
                                                right: 4),
                                            child: Text(
                                              '04:30',
                                              style: TextStyle(
                                                  color: Colors.white38),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        home_video[index]['title'],
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            home_video[index]['username'],
                                            style: TextStyle(
                                                color: Colors.white38,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            home_video[index]['view_count'],
                                            style: TextStyle(
                                                color: Colors.white38,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(LineIcons.verticalEllipsis),
                              )
                            ],
                          );
                        }),
                      ),
                    )
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
