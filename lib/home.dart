import 'package:flutter/material.dart';
import 'package:food/profile.dart';
import 'package:food/videoPlayer.dart';
import 'package:http/http.dart' as http; //For backend
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  final String value;
  final PlatformFile? picValue;
  final String ip;
  Home({required this.value, this.picValue,required this.ip});
  @override
  MyApp createState() => MyApp();
}

class MyApp extends State<Home> with TickerProviderStateMixin {
  late AnimationController animationController;
  static bool showIndicator = false;
  static bool myPermissionstatus = false;
  static bool download = false;
  static bool process = false;
  //Profile picture
  static PlatformFile? myDp;

  //theme color
  static List<Color> backColor = [
    Color.fromARGB(255, 0, 0, 0),
    Color.fromARGB(248, 4, 3, 94)
  ];
  static Color textColor = Colors.white;
  static Color buttonColor = Color.fromARGB(255, 183, 148, 148);

  Future<void> requestPermission(
      Permission permission, BuildContext context) async {
    // Request permission
    final status = await permission.request();
    if (status.isGranted) {
      myPermissionstatus = true;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Permission is granted")));
    } else {
      myPermissionstatus = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Permission is not granted")));
    }
  }

  List<Widget> containers = [];

  static String vName = 'Click To Check The Video';
  static PlatformFile? backup;
  static String data = '';
  static Uint8List? responseData;
  static String ip = '';
  @override
  void initState() {
    animationController = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: const Duration(seconds: 150),
    )..addListener(() {
        setState(() {});
      });
    super.initState();
    data = widget.value;
    myDp = widget.picValue;
    ip = widget.ip;
    requestPermission(Permission.videos, context);
  }

  Widget build(BuildContext context) {
    // Get the screen size
    final Size screenSize = MediaQuery.of(context).size;

    // Calculate the desired width and height of the container
    final double containerWidth = screenSize.width * 0.1; // 10% of screen width
    final double containerHeight =
        screenSize.height * 0.1; // 10% of screen height

    Future<void> _saveVideo() async {
      // Get the directory for saving videos in the gallery
      final Directory directory = await getTemporaryDirectory();
      final String filePath = '${directory.path}/processed_video.mp4';
      // Write the processed video to a file
      final File processedVideo = File(filePath);
      await processedVideo.writeAsBytes(responseData!);

      // Save the processed video to the gallery
      final result = await ImageGallerySaver.saveFile(filePath);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Video saved {$result}")));

      // You can delete the temporary file if needed
      processedVideo.delete();
    }

    Future<void> _receiveProcess() async {
      try {
        var url =
            Uri.parse('http://$ip:8080/send-video?username=$data');
        var request = http.MultipartRequest('POST', url);
        var response = await request.send();

        // Check if the response is successful
        if (response.statusCode == 200) {
          responseData = await response.stream.toBytes();
          url = Uri.parse(
              'http://$ip:8080/delete-video?username=$data');
          request = http.MultipartRequest('POST', url);
          response = await request.send();
          if (response.statusCode == 200) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Downloading...")));
          }
          _saveVideo();
          setState(() {
            download = false;
            showIndicator = false;
          });
        } else {
          // Handle the case when the response is not successful
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "Failed to receive processed video. Error ${response.statusCode}")));
        }
      } catch (e) {
        // Handle any errors that occur during the process
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error receiving processed video: $e")));
      }
    }

    Future<void> _getProcess() async {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Video uploading....")));
      if (backup != null && backup!.path != null) {
        setState(() {
          showIndicator = true;
          animationController.value = 0.0;
          animationController.forward();
        });
        try {
          var url = Uri.parse(
              'http://$ip:8080/receive-video?username=$data');
          var request = http.MultipartRequest('POST', url);
          request.files
              .add(await http.MultipartFile.fromPath('video', backup!.path!));
          var response = await request.send();
          // Check response status code
          if (response.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Video uploaded successfully")));
            setState(() {
              animationController.value = 1.0;
              showIndicator = false;
              download = true;
            });
          } else {
            setState(() {
              animationController.stop();
              animationController.value = 0.0;
              showIndicator = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    "Failed to upload video. Error ${response.statusCode}")));
          }
        } catch (e) {
          setState(() {
            animationController.stop();
            animationController.value = 0.0;
            showIndicator = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error uploading video: $e")));
          // Error uploading video
        }
      }
    }

    Future<void> fetchData() async {
      // Pick video file
      final filePickerResult = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (filePickerResult != null && filePickerResult.files.isNotEmpty) {
        final platformFile = filePickerResult.files.single;
        if (platformFile.path != null) {
          backup = platformFile;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Video file picked")));
          setState(() {
            vName =
                platformFile.name; // Update button text with video file name
            process = true;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to retrieve video bytes")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No video file selected")));
      }
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: backColor,
            ),
            image: DecorationImage(
                image: AssetImage("lib/assets/LogoForObjectDetection.png"),
                opacity: 0.5,
                fit: BoxFit.contain)),
        width: double.infinity,
        height: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                //color: Color.fromARGB(122, 255, 255, 255),
                width: containerWidth,
                height: containerHeight / 2,

                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor),
                          onPressed: () async {
                            var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Profile(value: data, picValue: myDp, ip: ip)),
                            );

                            if (result != null &&
                                result is Map<String, dynamic>) {
                              data = result['name'];
                              backColor = result['backColor'];
                              textColor = result['textColor'];
                              buttonColor = result['buttonColor'];
                              myDp = result['myDp'];
                              ip = result['ip'];
                            }

                            setState(() {});
                            // Ensure newData is not null
                          },
                          icon: myDp != null &&
                                  myDp!.path != null &&
                                  File(myDp!.path!).existsSync()
                              ? ClipOval(
                                  child: Image.file(
                                    File(myDp!
                                        .path!), // Use the file path directly
                                  ),
                                )
                              : Icon(Icons.person),
                          label: Text(
                            data,
                            style: TextStyle(
                              color: textColor,
                              fontSize: screenSize.width < screenSize.height
                                  ? screenSize.width * 0.02
                                  : screenSize.height * 0.02,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SimpleDialog(
                                  title: Text('How To Use'),
                                  children: <Widget>[
                                    SimpleDialogOption(
                                      onPressed: null,
                                      child: Center(child: Text('Click On Add Video'),),
                                    ),
                                    SimpleDialogOption(
                                      onPressed: null,
                                      child: Center(child: Text('Check The Video'),),
                                    ),
                                    SimpleDialogOption(
                                      onPressed: null,
                                      child: Center(child: Text('Click On Process And Wait'),),
                                    ),
                                    SimpleDialogOption(
                                      onPressed: (){Navigator.pop(context);},
                                      child: Align(alignment: Alignment.bottomRight,child: Text('Exit', style: TextStyle(fontWeight: FontWeight.bold),),)
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            width: containerWidth * 5,
                            height: containerHeight * 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: buttonColor,
                            ),
                            child: Center(
                                child: AnimatedTextKit(
                              animatedTexts: [
                                TyperAnimatedText(
                                  'Click On Add Video',
                                  textStyle: TextStyle(
                                    color: textColor,
                                    fontSize:
                                        screenSize.width < screenSize.height
                                            ? screenSize.width * 0.025
                                            : screenSize.height * 0.025,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  speed: Duration(milliseconds: 100),
                                ),
                                TyperAnimatedText(
                                  'Check The Video',
                                  textStyle: TextStyle(
                                    color: textColor,
                                    fontSize:
                                        screenSize.width < screenSize.height
                                            ? screenSize.width * 0.025
                                            : screenSize.height * 0.025,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  speed: Duration(milliseconds: 100),
                                ),
                                TyperAnimatedText(
                                  'Click On Process And Wait',
                                  textStyle: TextStyle(
                                    color: textColor,
                                    fontSize:
                                        screenSize.width < screenSize.height
                                            ? screenSize.width * 0.025
                                            : screenSize.height * 0.025,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  speed: Duration(milliseconds: 100),
                                ),
                              ],
                              isRepeatingAnimation: true,
                              repeatForever: true,
                              pause: Duration(milliseconds: 1000),
                            )),
                          ),
                        ),
                      ),
                    ]),
              ),
              Container(
                width: containerWidth,
                height: containerHeight * 3,
                decoration: BoxDecoration(
                  color: Color.fromARGB(122, 65, 79, 90),
                  borderRadius:
                      BorderRadius.circular(20), // Adjust the value as needed
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerScreen(
                                videoPath: backup!.path,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          vName,
                          style: TextStyle(
                            color: textColor,
                            fontSize: screenSize.width < screenSize.height
                                ? screenSize.width * 0.025
                                : screenSize.height * 0.025,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor),
                        onPressed: () {
                          if (myPermissionstatus) {
                            fetchData();
                          } else {
                            requestPermission(Permission.videos, context);
                          }
                        }, // No action is performed when pressed
                        icon: Icon(Icons.add),
                        label: Text(
                          'Add Video',
                          style: TextStyle(
                            color: textColor,
                            fontSize: screenSize.width < screenSize.height
                                ? screenSize.width * 0.02
                                : screenSize.height * 0.02,
                          ),
                        ),
                      ),
                    ),
                    if (process)
                      Flexible(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor),
                          onPressed: () {
                            _getProcess();
                          },
                          child: Text(
                            "Process",
                            style: TextStyle(
                              color: textColor,
                              fontSize: screenSize.width < screenSize.height
                                  ? screenSize.width * 0.02
                                  : screenSize.height * 0.02,
                            ),
                          ),
                        ),
                      ),
                    if (showIndicator)
                      Flexible(
                        child: SizedBox(
                          height: 10,
                          child: LinearProgressIndicator(
                            value: animationController.value,
                          ),
                        ),
                      ),
                    if (download)
                      Flexible(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor),
                          onPressed: _receiveProcess,
                          child: Text(
                            "Download Video",
                            style: TextStyle(
                              color: textColor,
                              fontSize: screenSize.width < screenSize.height
                                  ? screenSize.width * 0.02
                                  : screenSize.height * 0.02,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
