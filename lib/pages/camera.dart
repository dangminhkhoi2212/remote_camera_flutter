import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remote_camera/pages/preview_picture.dart';
import 'package:tflite/tflite.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;

  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraPageSate();
}

class _CameraPageSate extends State<CameraPage> {
  late CameraController _cameraController;
  bool _isRearCemeraSelected = false;
  CameraImage? cameraImage;
  String output = '';

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    initCamera(widget.cameras![0]);
  }

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _cameraController.initialize().then((value) {
        if (!mounted) return;

        setState(() {
          _cameraController.startImageStream((image) => cameraImage = image);
          runModel();
        });
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  Future takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }

    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      XFile picture = await _cameraController.takePicture();

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreviewPicture(picture: picture)),
        );
      }
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model/model.tflite', labels: 'assets/model/labels.txt');
  }

  Future<void> runModel() async {
    if (cameraImage != null) {
      var predictions = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes.map((plane) => plane.bytes).toList(),
          imageHeight: cameraImage!.height,
          imageWidth: cameraImage!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 3,
          threshold: 0.1,
          asynch: true);
      for (var element in predictions!) {
        setState(() {
          output = element['label'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          _cameraController.value.isInitialized
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * .85,
                  child: CameraPreview(_cameraController),
                )
              : Container(
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
          Center(
            child: Text(
              output,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * .15,
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Expanded(
                      child: IconButton(
                    onPressed: takePicture,
                    iconSize: 50,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.circle, color: Colors.white),
                  )),
                  Expanded(
                    child: IconButton(
                      padding: EdgeInsets.all(20),
                      icon: Icon(
                          _isRearCemeraSelected
                              ? CupertinoIcons.switch_camera
                              : CupertinoIcons.switch_camera_solid,
                          color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _isRearCemeraSelected = !_isRearCemeraSelected;
                        });
                        initCamera(
                            widget.cameras![_isRearCemeraSelected ? 0 : 1]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
