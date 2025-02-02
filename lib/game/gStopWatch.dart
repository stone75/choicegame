import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';


class StopWatch extends StatefulWidget {
  const StopWatch({Key? key}) : super(key: key);

  @override
  _StopWatchState createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  double targetTime = 0.0;
  double elapsedTime = 0.0;
  bool isRunning = false;
  bool showGo = false;
  String message = '';
  Timer? timer;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    targetTime = (Random().nextDouble() * 10).clamp(0, 10);
    targetTime = double.parse(targetTime.toStringAsFixed(2));
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        showGo = true;
      });
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          showGo = false;
          startTimer();
        });
      });
    });
  }

  void startTimer() {
    isRunning = true;
    timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        elapsedTime += 0.1;
        if (elapsedTime >= 10) stopTimer();
      });
    });
  }

  void stopTimer() {
    if (timer != null) timer!.cancel();
    setState(() {
      isRunning = false;
      if (elapsedTime.toStringAsFixed(2) == targetTime.toStringAsFixed(2)) {
        message = 'Excellent!!!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stop Watch Game')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('목표시간: $targetTime 초', style: TextStyle(fontSize: 24)),
              SizedBox(height: 20),
              if (showGo)
                Text('Go!!!', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.green)),
              if (!showGo)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 250, // 크기 확대
                      height: 250, // 크기 확대
                      child: CircularProgressIndicator(
                        value: 1 - (elapsedTime / 10),
                        strokeWidth: 20, // 두께 증가
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                    Text(
                      elapsedTime.toStringAsFixed(2),
                      style: TextStyle(fontSize: 40),
                    ),
                  ],
                ),
              SizedBox(height: 20),
              if (message.isNotEmpty)
                Text(
                  message,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.red),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isRunning ? stopTimer : null,
                child: Text('Stop !!!'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



/*
class StopWatch extends StatefulWidget {
  const StopWatch({Key? key}) : super(key: key);

  @override
  _StopWatchState createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  double targetTime = 0.0;
  double currentTime = 10.0;
  bool showGoText = false;
  bool isRunning = false;
  bool showResult = false;
  String resultMessage = "";
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    // 목표 시간 설정 (0.00 ~ 10.00초 사이)
    targetTime = double.parse((Random().nextDouble() * 10).toStringAsFixed(2));

    // 1초 후 "Go!!!" 표시
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        showGoText = true;
      });

      // 1초 후 "Go!!!" 삭제 후 타이머 시작
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          showGoText = false;
          isRunning = true;
        });

        _startTimer();
      });
    });
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      setState(() {
        currentTime -= 0.1;
        if (currentTime <= 0) {
          currentTime = 0;
          _stopTimer();
        }
      });
    });
  }

  void _stopTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      showResult = true;
      resultMessage = (targetTime - currentTime).abs() < 0.05
          ? "Excellent!!!"
          : "Try Again!";
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stop Watch Game"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("목표시간 :", style: TextStyle(fontSize: 20)),
            Text("$targetTime 초",
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),

            const SizedBox(height: 20),

            // "Go!!!" 메시지 표시
            showGoText
                ? const Text("Go!!!",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.red))
                : _buildProgressIndicator(),

            const SizedBox(height: 20),

            if (showResult)
              Text(
                resultMessage,
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.green),
              ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: isRunning ? _stopTimer : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text("Stop !!!", style: TextStyle(fontSize: 25, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // 진행률 표시기 (타이머 게이지)
  Widget _buildProgressIndicator() {
    return SizedBox(
      height: 300,
      width: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: currentTime / 10.0, // 10초에서 점점 줄어듦
            strokeWidth: 8,
            backgroundColor: Colors.grey[300],
            color: Colors.blue,
          ),
          Text(
            currentTime.toStringAsFixed(2),
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
*/