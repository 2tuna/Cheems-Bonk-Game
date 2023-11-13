import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class BonkGame extends StatefulWidget {
  const BonkGame({Key? key}) : super(key: key);

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

    Future.delayed(const Duration(milliseconds: 5), () {
      setState(() {
        isBonking = false;
      });

      Future.delayed(const Duration(milliseconds: 20), () {
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
    return SafeArea(
      child: Scaffold(
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
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Positioned(
                // top: 16.0,
                bottom: 16.0,
                // left: 16.0,
                child: IconButton(
                  icon:
                  const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
