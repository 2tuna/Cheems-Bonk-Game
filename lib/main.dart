import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BonkGame(),
    );
  }
}

class BonkGame extends StatefulWidget {
  @override
  _BonkGameState createState() => _BonkGameState();
}

class _BonkGameState extends State<BonkGame> {
  int bonkCount = 0;
  bool isBonking = false;
  bool isImage2Visible = false;
  late Soundpool _soundpool;
  late int _soundId;

  @override
  void initState() {
    super.initState();
    _soundpool = Soundpool.fromOptions();
    _loadSound();
  }

  Future<void> _loadSound() async {
    const assetPath = 'assets/sounds/bonk.mp3';
    final soundId = await rootBundle.load(assetPath);
    _soundId = await _soundpool.load(soundId);
  }

  void bonk() {
    _soundpool.play(_soundId);
    setState(() {
      bonkCount++;
      isBonking = true;
      isImage2Visible = true;
    });

    Future.delayed(Duration(milliseconds: 5), () {
      setState(() {
        isBonking = false;
      });

      Future.delayed(Duration(milliseconds: 20), () {
        setState(() {
          isImage2Visible = false;
        });
      });
    });
  }

  @override
  void dispose() {
    _soundpool.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          bonk();
        },
        child: Stack(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isImage2Visible
                      ? Image.asset('assets/bonk2.png')
                      : Image.asset('assets/bonk1.png'),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Bonk count: $bonkCount",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
