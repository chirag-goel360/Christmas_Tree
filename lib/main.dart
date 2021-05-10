import 'dart:math';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Christmas Tree',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          body1: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: MyTree(),
    );
  }
}

class MyTree extends StatefulWidget {
  @override
  _MyTreeState createState() => _MyTreeState();
}

class _MyTreeState extends State<MyTree> {
  AudioPlayer audioPlayer;
  AudioCache audioCache = AudioCache();

  @override
  void initState() {
    super.initState();
    playMusic();
  }

  playMusic() async {
    audioPlayer = await audioCache.loop(
      "jingle.mp3",
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  static final _offsets = _generateOffsets(100, 0.05).toList(
    growable: false,
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 600,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 40,
          horizontal: 8,
        ),
        child: ListView(
          children: <Widget>[
            Center(
              child: Icon(
                Icons.star,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            for (final x in _offsets)
              Light(
                x: x,
              ),
            SizedBox(
              height: 8,
            ),
            Center(
              child: Text(
                "Merry Christmas",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                audioPlayer.stop();
              },
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.teal,
                      Colors.teal[200],
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(
                        5,
                        5,
                      ),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Close Music',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Iterable<double> _generateOffsets(int count, double acceleration) sync* {
    double x = 0;
    yield x;
    double ax = acceleration;
    for (int i = 0; i < count; i++) {
      x += ax;
      ax *= 1.5;
      final maxLateral = min(1, i/count);
      if (x.abs() > maxLateral) {
        x = maxLateral*x.sign;
        ax = x >= 0 ? -acceleration : acceleration;
      }
      yield x;
    }
  }
}

class Light extends StatefulWidget {
  static final festiveColors = [
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.yellow,
    Colors.pink,
    Colors.teal,
    Colors.purple,
    Colors.blue,
  ];

  final double x;
  final int period;
  final Color color;

  Light({
    Key key,
    this.x,
  })  : period = 500 + (x.abs() * 4000).floor(),
        color = festiveColors[Random().nextInt(festiveColors.length)],
        super(key: key);

  @override
  _LightState createState() => _LightState();
}

class _LightState extends State<Light> {
  Color _newColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      child: Align(
        alignment: Alignment(
          widget.x,
          0.0,
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: TweenAnimationBuilder(
            duration: Duration(
              milliseconds: widget.period,
            ),
            tween: ColorTween(
              begin: widget.color,
              end: _newColor,
            ),
            onEnd: () {
              setState(() {
                _newColor = _newColor == Colors.white ? widget.color : Colors.white;
              });
            },
            builder: (_, color, __) {
              return Container(
                color: color,
              );
            },
          ),
        ),
      ),
    );
  }
}