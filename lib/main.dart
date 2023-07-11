import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(myApp());
}

class myApp extends StatelessWidget {
  // const myApp({super.key});

  final String mailAddress = "writis_@is-sus.com";
  final String mailTitle = "件名";
  final String mailContents = "本文";
  final String webSite = "https://nomindev.net";

  ScreenshotController screenshotController = ScreenshotController();

  Future<void> launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw "${url}が立ち上がりません";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () async {
                  await screenshotController
                      .capture(delay: const Duration(milliseconds: 10))
                      .then((image) async {
                    if (image != null) {
                      final directory =
                          (await getApplicationDocumentsDirectory()).path;
                      final imagePath =
                          await File('${directory}/image.png').create();
                      await imagePath.writeAsBytes(image);
                      await Share.shareXFiles([XFile(imagePath.path)],
                          text: '私のプロフィールです');
                    }
                  });
                },
                child: Icon(
                  Icons.share,
                  color: Colors.white,
                ))
          ],
          title: Text("My Profile"),
          backgroundColor: Colors.pinkAccent,
        ),
        body: Center(
          child: Column(
            children: [
              Screenshot(
                controller: screenshotController,
                child: Column(
                  children: [
                    Image.asset(
                      "assets/icon.jpg",
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "nomindev",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("HP: "),
                          Text("https://nomindev.net"),
                          TextButton(
                              onPressed: () async {
                                launchURL(webSite);
                              },
                              child: Icon(Icons.public))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("メール: "),
                    Text("writis_@is-sus.com"),
                    TextButton(
                        onPressed: () async {
                          launchURL(
                              'mailto:${mailAddress}?subject=${mailTitle}&body=${mailContents}');
                        },
                        child: Icon(Icons.mail)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
