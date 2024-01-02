import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:remote_camera/pages/camera.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () async {
        await availableCameras().then(
          (value) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CameraPage(cameras: value),
            ),
          ),
        );
      },
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.red.shade300,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.red.shade200.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 10,
                // offset: Offset(0, 3),
              )
            ]),
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              child: SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset('assets/icons/camera.png')),
            ),
            Text(
              'Remote camera.',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    ));
  }
}
