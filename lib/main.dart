import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setEnabledSystemUIOverlays([]);
  return runApp(SamgungRemoteController());
}

class SamgungRemoteController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlutterRemote',
      home: Scaffold(
        backgroundColor: Color(0XFF2e2e2e),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _keypadShown = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> connectTV() async {
    try {
      setState(() async {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.cast, size: 30, color: Colors.cyan),
                  onPressed: connectTV,
                ),
                IconButton(
                  icon: Icon(Icons.dialpad,
                      size: 30,
                      color: _keypadShown ? Colors.blue : Colors.white70),
                  onPressed: () {
                    setState(() {
                      _keypadShown = !_keypadShown;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.power_settings_new,
                      color: Colors.red, size: 30),
                  onPressed: () async {},
                ),
              ],
            ),
            SizedBox(height: 50),
            Visibility(
              visible: _keypadShown,
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ControllerButton(
                          child: Text(
                            "1",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70),
                          ),
                          onPressed: () async {},
                        ),
                        ControllerButton(
                          child: Text(
                            "2",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70),
                          ),
                          onPressed: () async {},
                        ),
                        ControllerButton(
                          child: Text(
                            "3",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70),
                          ),
                          onPressed: () async {},
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ControllerButton(
                          child: Text(
                            "4",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70),
                          ),
                          onPressed: () async {},
                        ),
                        ControllerButton(
                          child: Text(
                            "5",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70),
                          ),
                          onPressed: () async {},
                        ),
                        ControllerButton(
                          child: Text(
                            "6",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70),
                          ),
                          onPressed: () async {},
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ControllerButton(
                          child: Text(
                            "7",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70),
                          ),
                          onPressed: () async {},
                        ),
                        ControllerButton(
                          child: Text(
                            "8",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70),
                          ),
                          onPressed: () async {},
                        ),
                        ControllerButton(
                          child: Text(
                            "9",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70),
                          ),
                          onPressed: () async {},
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ControllerButton(
                          child: Text(
                            "Tools".toUpperCase(),
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70),
                          ),
                          onPressed: () async {},
                        ),
                        ControllerButton(
                          child: Text(
                            "0",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70),
                          ),
                          onPressed: () async {},
                        ),
                        ControllerButton(
                          child: Text(
                            "guide".toUpperCase(),
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70),
                          ),
                          onPressed: () async {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: !_keypadShown,
              child: Expanded(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: ControllerButton(
                        onPressed: () async {},
                        child: Text(
                          "SMART",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white54),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: ControllerButton(
                        child: Text(
                          "INPUT",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white54),
                        ),
                        onPressed: () async {},
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: ControllerButton(
                        child: Text(
                          "BACK",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white54),
                        ),
                        onPressed: () async {},
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ControllerButton(
                        child: Text(
                          "EXIT",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white54),
                        ),
                        onPressed: () async {},
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ControllerButton(
                        child: Text(
                          "OK",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        onPressed: () async {},
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, -0.6),
                      child: ControllerButton(
                        borderRadius: 10,
                        child: Icon(Icons.arrow_drop_up,
                            size: 30, color: Colors.white),
                        onPressed: () async {},
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, 0.6),
                      child: ControllerButton(
                        borderRadius: 10,
                        child: Icon(Icons.arrow_drop_down,
                            size: 30, color: Colors.white),
                        onPressed: () async {},
                      ),
                    ),
                    Align(
                      alignment: Alignment(0.6, 0),
                      child: ControllerButton(
                        borderRadius: 10,
                        child: Icon(Icons.arrow_right,
                            size: 30, color: Colors.white),
                        onPressed: () async {},
                      ),
                    ),
                    Align(
                      alignment: Alignment(-0.7, 0),
                      child: ControllerButton(
                        borderRadius: 10,
                        child: Icon(Icons.arrow_left,
                            size: 30, color: Colors.white),
                        onPressed: () async {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: ControllerButton(
                    color: Colors.red,
                    onPressed: () async {},
                  ),
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: ControllerButton(
                    color: Colors.green,
                    onPressed: () async {},
                  ),
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: ControllerButton(
                    color: Colors.yellow,
                    onPressed: () async {},
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: ControllerButton(
                    color: Colors.blue,
                    onPressed: () async {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ControllerButton(
                  borderRadius: 15,
                  child: Column(
                    children: [
                      MaterialButton(
                        height: 50,
                        minWidth: 50,
                        shape: CircleBorder(),
                        child: Icon(Icons.keyboard_arrow_up,
                            size: 20, color: Colors.white54),
                        onPressed: () async {},
                      ),
                      MaterialButton(
                        height: 50,
                        minWidth: 50,
                        shape: CircleBorder(),
                        child: Icon(Icons.volume_off,
                            size: 20, color: Colors.white70),
                        onPressed: () async {},
                      ),
                      MaterialButton(
                        height: 50,
                        minWidth: 50,
                        shape: CircleBorder(),
                        child: Icon(Icons.keyboard_arrow_down,
                            size: 20, color: Colors.white54),
                        onPressed: () async {},
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    ControllerButton(
                      borderRadius: 15,
                      child: Text(
                        "menu".toUpperCase(),
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white54),
                      ),
                      onPressed: () async {},
                    ),
                    SizedBox(height: 35),
                    ControllerButton(
                      borderRadius: 15,
                      child: Text(
                        "more".toUpperCase(),
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white54),
                      ),
                      onPressed: () async {},
                    ),
                  ],
                ),
                ControllerButton(
                  borderRadius: 15,
                  child: Column(
                    children: [
                      MaterialButton(
                        height: 40,
                        minWidth: 40,
                        shape: CircleBorder(),
                        child: Icon(Icons.keyboard_arrow_up,
                            size: 20, color: Colors.white54),
                        onPressed: () async {},
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text('P',
                            style:
                                TextStyle(fontSize: 15, color: Colors.white70)),
                      ),
                      MaterialButton(
                        height: 50,
                        minWidth: 50,
                        shape: CircleBorder(),
                        child: Icon(Icons.keyboard_arrow_down,
                            size: 20, color: Colors.white54),
                        onPressed: () async {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ControllerButton(
                  child:
                      Icon(Icons.fast_rewind, size: 20, color: Colors.white54),
                  onPressed: () async {},
                ),
                ControllerButton(
                  child: Icon(Icons.fiber_manual_record,
                      size: 20, color: Colors.red),
                  onPressed: () async {},
                ),
                ControllerButton(
                  child:
                      Icon(Icons.play_arrow, size: 20, color: Colors.white54),
                  onPressed: () async {},
                ),
                ControllerButton(
                  child: Icon(Icons.stop, size: 20, color: Colors.white54),
                  onPressed: () async {},
                ),
                ControllerButton(
                  child: Icon(Icons.pause, size: 20, color: Colors.white54),
                  onPressed: () async {},
                ),
                ControllerButton(
                  child:
                      Icon(Icons.fast_forward, size: 20, color: Colors.white54),
                  onPressed: () async {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ControllerButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double borderRadius;
  final Color color;
  const ControllerButton(
      {Key key, this.child, this.borderRadius = 30, this.color, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        color: Color(0XFF2e2e2e),
        boxShadow: const [
          BoxShadow(
            color: Color(0XFF1c1c1c),
            offset: Offset(5.0, 5.0),
            blurRadius: 10.0,
          ),
          BoxShadow(
            color: Color(0XFF404040),
            offset: Offset(-5.0, -5.0),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
            // shape: BoxShape.circle,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          child: MaterialButton(
            color: color,
            minWidth: 0,
            onPressed: onPressed,
            shape: CircleBorder(),
            child: child,
          ),
        ),
      ),
    );
  }
}
