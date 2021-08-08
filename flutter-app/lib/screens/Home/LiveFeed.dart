import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:pim/screens/Home/homepage.dart';

import 'dart:math' as math;
import 'package:tflite/tflite.dart';

typedef void Callback(List<dynamic> list, int h, int w);

class CameraLiveScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  int imageHeight;
  int imageWidth;
  List<dynamic> recognitions;

  CameraLiveScreen(
      this.cameras, this.imageHeight, this.imageWidth, this.recognitions);

  @override
  _CameraLiveScreenState createState() => _CameraLiveScreenState(
      imageHeight: imageHeight,
      imageWidth: imageWidth,
      recognitions: recognitions);
}

class _CameraLiveScreenState extends State<CameraLiveScreen> {
  int totaltime = 0;
  CameraController controller;
  bool isDetecting = false;
  _CameraLiveScreenState(
      {this.imageHeight, this.imageWidth, this.recognitions});
  int imageHeight;
  int imageWidth;
  bool mawjoud = false;
  List<dynamic> recognitions;
  @override
  void initState() {
    super.initState();

    if (widget.cameras == null || widget.cameras.length < 1) {
      print('No camera is found');
    } else {
      controller = new CameraController(
        widget.cameras[0],
        ResolutionPreset.medium,
      );
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});

        controller.startImageStream((CameraImage img) {
          if (!isDetecting) {
            isDetecting = true;

            int startTime = new DateTime.now().millisecondsSinceEpoch;

            Tflite.runModelOnFrame(
              bytesList: img.planes.map((plane) {
                return plane.bytes;
              }).toList(),
              imageHeight: img.height,
              imageWidth: img.width,
              numResults: 2,
            ).then((recognitionss) {
              int endTime = new DateTime.now().millisecondsSinceEpoch;
              print("Detection took ${endTime - startTime}");

              setState(() {
                totaltime += (endTime - startTime);
                print(totaltime);
                recognitions = recognitionss;
              });
              if (totaltime > 2000) {
                if (recognitions.length == 2) {
                  mawjoud = true;
                  if (recognitions[1]["label"]
                      .toString()
                      .substring(2)
                      .startsWith("delice")) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }
                }
              }

              print(recognitionss);

              isDetecting = false;
            });
          }
        });
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }

    Size size = MediaQuery.of(context).size;
    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = controller.value.previewSize;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return Stack(
      children: [
        OverflowBox(
          maxHeight: screenRatio > previewRatio
              ? screenH
              : screenW / previewW * previewH,
          maxWidth: screenRatio > previewRatio
              ? screenH / previewH * previewW
              : screenW,
          child: CameraPreview(controller),
        ),
        EnclosedBox(
          recognitions,
          math.min(imageHeight, imageWidth),
          math.max(imageHeight, imageWidth),
          size.height,
          size.width,
        ),
      ],
    );
  }
}

class EnclosedBox extends StatelessWidget {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;

  EnclosedBox(
      this.results, this.previewH, this.previewW, this.screenH, this.screenW);

  List<Widget> _renderStrings() {
    double offset = -10;
    return results.map((re) {
      offset = offset + 14;
      return Positioned(
        left: 10,
        top: offset,
        width: screenW,
        height: screenH,
        child: Text(
          "${re["label"].toString().substring(2)} ${(re["confidence"] * 100).toStringAsFixed(0)}%",
          style: TextStyle(
            color: Colors.red,
            fontSize: 54.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _renderStrings(),
    );
  }
}
