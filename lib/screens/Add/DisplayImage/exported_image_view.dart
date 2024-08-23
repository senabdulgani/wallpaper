import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:wallpaper_manager/product/theme/app_colors.dart';

class DisplayImageScreen extends StatefulWidget {
  final Uint8List imageBytes;

  const DisplayImageScreen({
    super.key,
    required this.imageBytes,
  });

  @override
  State<DisplayImageScreen> createState() => _DisplayImageScreenState();
}

class _DisplayImageScreenState extends State<DisplayImageScreen> {
  String home = "Home Screen";
  String lock = "Lock Screen";
  String both = "Both Screen";
  String system = "System";

  late Stream<String> progressString;

  late String res;

  bool downloading = false;

  var result = "Waiting to set wallpaper";

  bool _isDisable = true;

  int nextImageID = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Wallpaper'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            downloading
                ? imageDownloadDialog()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: ClipRRect(
                      borderRadius: AppColors.borderRadiusAll * 2,
                      child: Image.memory(widget.imageBytes),
                    ),
                  ),
            const Gap(5),
            ElevatedButton(
              onPressed: () async {
                await downloadImage(context);
              },
              style: ElevatedButton.styleFrom(
                iconColor: AppColors.main,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: const Text('Set'),
            ),
            const Gap(25),
            Column(
              children: <Widget>[
                ElevatedButton(
                  onPressed: _isDisable
                      ? null
                      : () async {
                          await downloadImage(context);

                          var width = MediaQuery.of(context).size.width;
                          var height = MediaQuery.of(context).size.height;

                          home = await Wallpaper.homeScreen(
                            options: RequestSizeOptions.resizeFit,
                            width: width,
                            location: DownloadLocation.applicationDirectory,
                            height: height,
                          );
                          setState(() {
                            downloading = false;
                            home = home;
                          });
                          print("Task Done");
                        },
                  child: Text(home),
                ),
                ElevatedButton(
                  onPressed: _isDisable
                      ? null
                      : () async {
                          await downloadImage(context);

                          lock = await Wallpaper.lockScreen(
                            location: DownloadLocation.applicationDirectory,
                          );
                          setState(() {
                            downloading = false;
                            lock = lock;
                          });
                          print("Task Done");
                        },
                  child: Text(lock),
                ),
                ElevatedButton(
                  onPressed: _isDisable
                      ? null
                      : () async {
                          await downloadImage(context);

                          both = await Wallpaper.bothScreen(
                            location: DownloadLocation.applicationDirectory,
                          );
                          setState(() {
                            downloading = false;
                            both = both;
                          });
                          print("Task Done");
                        },
                  child: Text(both),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> downloadImage(BuildContext context) async {
    progressString = Wallpaper.imageDownloadProgress(
      '',
      location: DownloadLocation.applicationDirectory,
    );
    progressString.listen((data) {
      setState(() {
        res = data;
        downloading = true;
      });
      print("DataReceived: $data");
    }, onDone: () async {
      setState(() {
        downloading = false;
        _isDisable = false;
      });
      print("Task Done");
    }, onError: (error) {
      setState(() {
        downloading = false;
        _isDisable = true;
      });
      print("Some Error");
    });
  }

  Widget imageDownloadDialog() {
    return SizedBox(
      height: 120.0,
      width: 200.0,
      child: Card(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircularProgressIndicator(),
            const SizedBox(height: 20.0),
            Text(
              "Downloading File : $res",
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
