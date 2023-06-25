import 'package:flutter/material.dart';
import 'dart:async';
import 'congratulation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PomodoroTimer extends StatefulWidget {
  final String breakTime;
  final String workTime;
  final String sessionTime;

  PomodoroTimer({
    Key? key,
    required this.breakTime,
    required this.workTime,
    required this.sessionTime,
  }) : super(key: key);

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  bool _isBreak = false;
  bool _isRunning = false;
  bool _isPaused = false;
  int currentDuration = 0;
  int completedRounds = 0;
  int totalRounds = 0;
  Timer? _timer;
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    totalRounds = int.parse(widget.sessionTime);
    _isBreak = false;
    currentDuration = int.parse(widget.workTime);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> speak(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(0.84);
    await flutterTts.setSpeechRate(0.73);
    await flutterTts.setVolume(0.6);
    await flutterTts.speak(text);
  }

  void startTimer() {
    int work = int.parse(widget.workTime); // Convert to seconds
    int breakTime = int.parse(widget.breakTime); // Convert to seconds

    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (!_isPaused) {
          if (currentDuration > 0) {
            currentDuration--;
          } else {
            if (_isBreak) {
              speak('Work Start');
              completedRounds++;

              if (completedRounds == totalRounds) {
                stopTimer();
                speak('Work Done');
                navigateToNextPage();
                return;
              }
            } else {
              speak("Break Start");
            }

            _isBreak = !_isBreak;
            currentDuration = _isBreak ? breakTime : work;
          }
        }
      });
    });
  }

  void stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void resetTimer() {
    setState(() {
      if (_isRunning) {
        stopTimer();
      }
      completedRounds = 0;
      _isPaused = false;
    });
  }

  void toggleStartPause() {
    if (_isRunning) {
      if (_isPaused) {
        resumeTimer();
      } else {
        pauseTimer();
      }
    } else {
      startTimer();
    }
  }

  void pauseTimer() {
    setState(() {
      _isPaused = true;
    });
    _timer?.cancel();
  }

  void resumeTimer() {
    setState(() {
      _isPaused = false;
    });
    startTimer();
  }

  String formatDuration(int duration) {
    int minutes = duration ~/ 60;
    int seconds = duration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double calculateProgress() {
    int work = int.parse(widget.workTime); // Convert to seconds
    return currentDuration / work;
  }

  void navigateToNextPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Timer',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 40,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              resetTimer();
            },
            icon: const Icon(
              Icons.restart_alt,
              color: Colors.black,
              size: 40,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 349,
                  width: 350,
                  child: CircularProgressIndicator(
                    value: calculateProgress(),
                    color: Color.fromARGB(255, 124, 192, 226),
                    backgroundColor: Colors.white,
                    strokeWidth: 13,
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: _isBreak ? 'Break' : 'Work',
                                style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: _isBreak
                                      ? Color.fromARGB(143, 221, 4, 4)
                                      : Color.fromARGB(160, 24, 174, 29),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          formatDuration(currentDuration),
                          style: const TextStyle(fontSize: 48),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '$completedRounds / $totalRounds',
                          style: const TextStyle(fontSize: 35),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          color: Colors.grey.withOpacity(0.2),
          padding: EdgeInsets.symmetric(vertical: 90),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Container(
                  width: 100,
                  height: 100,
                  child: IconButton(
                    onPressed: toggleStartPause,
                    icon: Icon(
                      _isRunning && !_isPaused
                          ? Icons.pause_outlined
                          : Icons.play_arrow,
                      size: 90,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
