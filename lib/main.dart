import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:typed_data';

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

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

enum _DeviceAvailability {
  no,
  maybe,
  yes,
}

class _DeviceWithAvailability extends BluetoothDevice {
  BluetoothDevice device;
  _DeviceAvailability availability;
  int rssi;

  _DeviceWithAvailability(this.device, this.availability, [this.rssi]);
}

class MyHomePage extends StatefulWidget {
  final bool checkAvailability = true;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _keypadShown = false;
  BluetoothConnection connection;
  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;
  bool isDisconnecting = false;
  List<_Message> messages = List<_Message>();
  String _messageBuffer = '';
  final address = "00:20:12:08:92:A1";
  static final clientID = 0;

  @override
  void initState() {
    super.initState();
    connectBT();
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }
    print("dispose is called");
    super.dispose();
  }

  void connectBT() {
    BluetoothConnection.toAddress(address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection.input.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    print(dataString);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();

    if (text.length > 0) {
      try {
        connection.output.add(utf8.encode(text + "\r\n"));
        await connection.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isConnected
        ? Text('connecting bluetooth to ..')
        : SafeArea(
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
                        onPressed: connectBT,
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
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white70)),
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
                        child: Icon(Icons.fast_rewind,
                            size: 20, color: Colors.white54),
                        onPressed: () async {},
                      ),
                      ControllerButton(
                        child: Icon(Icons.fiber_manual_record,
                            size: 20, color: Colors.red),
                        onPressed: () async {},
                      ),
                      ControllerButton(
                        child: Icon(Icons.play_arrow,
                            size: 20, color: Colors.white54),
                        onPressed: () async {},
                      ),
                      ControllerButton(
                        child:
                            Icon(Icons.stop, size: 20, color: Colors.white54),
                        onPressed: () async {},
                      ),
                      ControllerButton(
                        child:
                            Icon(Icons.pause, size: 20, color: Colors.white54),
                        onPressed: () async {},
                      ),
                      ControllerButton(
                        child: Icon(Icons.fast_forward,
                            size: 20, color: Colors.white54),
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
