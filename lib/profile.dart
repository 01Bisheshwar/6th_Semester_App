import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Profile extends StatefulWidget {
  final String value;
  final PlatformFile? picValue;
  final String ip;
  Profile({required this.value, this.picValue, required this.ip});
  MyApp createState() => MyApp();
}

class MyApp extends State<Profile> {
  static bool isField = false;
  static bool isIP = false;
  static String name = ''; // Do read it from a server
  static PlatformFile? myDp;
  static String ip = '';
  void initState() {
    super.initState();
    name = widget.value;
    myDp = widget.picValue;
    ip = widget.ip;
  }

  //final theme colors
  static Color textColor = Colors.white;
  static List<Color> backColor = [
    Color.fromARGB(255, 0, 0, 0),
    Color.fromARGB(248, 4, 3, 94)
  ];
  static Color fieldColor = Color.fromARGB(130, 0, 0, 0);
  static Color buttonColor = Color.fromARGB(255, 183, 148, 148);
//default theme colors
  Color defaultTextColor = Colors.white;
  List<Color> defaulbackColor = [
    Color.fromARGB(255, 0, 0, 0),
    Color.fromARGB(248, 4, 3, 94)
  ];
  Color defaultFieldColor = Color.fromARGB(130, 0, 0, 0);
  Color defaultButtonColor = Color.fromARGB(255, 183, 148, 148);

  //theme1 colors
  Color theme1TextColor = Color.fromARGB(255, 159, 205, 225);
  List<Color> theme1backColor = [
    Color.fromARGB(255, 255, 10, 10),
    Color.fromARGB(255, 18, 16, 129)
  ];
  Color theme1FieldColor = Color.fromARGB(160, 127, 54, 15);
  Color theme1ButtonColor = Color.fromARGB(217, 120, 120, 74);

  //theme2 colors
  Color theme2TextColor = Color.fromARGB(255, 216, 231, 157);
  List<Color> theme2backColor = [
    Color.fromARGB(255, 56, 56, 255),
    Color.fromARGB(255, 213, 128, 0)
  ];
  Color theme2FieldColor = Color.fromARGB(159, 89, 167, 167);
  Color theme2ButtonColor = Color.fromARGB(217, 10, 86, 86);

  //theme3 colors
  Color theme3TextColor = Color.fromARGB(255, 255, 255, 255);
  List<Color> theme3backColor = [
    Color.fromARGB(255, 0, 0, 0),
    Color.fromARGB(255, 0, 0, 0)
  ];
  Color theme3FieldColor = Color.fromARGB(159, 255, 255, 255);
  Color theme3ButtonColor = Color.fromARGB(194, 49, 82, 82);

  //theme4 colors
  Color theme4TextColor = Colors.black;
  List<Color> theme4backColor = [
    Color.fromARGB(255, 137, 39, 176),
    Color.fromARGB(255, 67, 112, 15)
  ];
  Color theme4FieldColor = Color.fromARGB(181, 76, 175, 106);
  Color theme4ButtonColor = Colors.yellow;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    TextEditingController _controller1 = TextEditingController();
    _controller1.text = name;
    TextEditingController _controller2 = TextEditingController();
    _controller2.text = ip;
    // Calculate the desired width and height of the container
    //final double containerWidth = screenSize.width * 0.1; // 10% of screen width
    final double containerHeight =
        screenSize.height * 0.1; // 10% of screen height

    //double mysizeFont = screenSize.width > screenSize.height ? screenSize.width / 50 : screenSize.height / 50;

    void editName() {
      setState(() {
        isField = true;
      });
    }

    void saveName() {
      setState(() {
        name = _controller1.text;
        //print(name);
        isField = false;
      });
    }

    void editIP() {
      setState(() {
        isIP = true;
      });
    }

    void saveIP() {
      setState(() {
        ip = _controller2.text;
        //print(name);
        isIP = false;
      });
    }

    void defaultTheme() {
      textColor = defaultTextColor;
      backColor = defaulbackColor;
      fieldColor = defaultFieldColor;
      buttonColor = defaultButtonColor;
      setState(() {});
    }

    void theme1() {
      textColor = theme1TextColor;
      backColor = theme1backColor;
      fieldColor = theme1FieldColor;
      buttonColor = theme1ButtonColor;
      setState(() {});
    }

    void theme2() {
      textColor = theme2TextColor;
      backColor = theme2backColor;
      fieldColor = theme2FieldColor;
      buttonColor = theme2ButtonColor;
      setState(() {});
    }

    void theme3() {
      textColor = theme3TextColor;
      backColor = theme3backColor;
      fieldColor = theme3FieldColor;
      buttonColor = theme3ButtonColor;
      setState(() {});
    }

    void theme4() {
      textColor = theme4TextColor;
      backColor = theme4backColor;
      fieldColor = theme4FieldColor;
      buttonColor = theme4ButtonColor;
      setState(() {});
    }

    //Image picer
    Future<void> fetchData() async {
      // Pick image file
      final filePickerResult = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (filePickerResult != null && filePickerResult.files.isNotEmpty) {
        final platformFile = filePickerResult.files.single;
        if (platformFile.path != null) {
          try {
            ImageCropper _imageCropper = ImageCropper();
            CroppedFile? croppedFile = await _imageCropper.cropImage(
              sourcePath: platformFile.path!,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
              ],
            );

            if (croppedFile != null) {
              File croppedImageFile = File(croppedFile.path);
              String imageName = croppedImageFile.path
                  .split('/')
                  .last; // Extracting image name
              int imageSize = await croppedImageFile.length();
              // Assign the cropped image to myDp
              myDp = PlatformFile(
                path: croppedFile.path,
                name: imageName,
                size: imageSize,
              );
              setState(() {});
            } else {
              //print('Failed to retrieve video bytes');
            }
          } catch (e) {}
        } else {
          //print('No video file selected.');
        }
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: screenSize.width,
              height: containerHeight / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: IconButton(
                      onPressed: () {
                        Map<String, dynamic> dataToPassBack = {
                          'name': name,
                          'backColor': backColor,
                          'textColor': textColor,
                          'buttonColor': buttonColor,
                          'myDp': myDp,
                          'ip': ip,
                          // Add more key-value pairs as needed
                        };

                        Navigator.pop(context, dataToPassBack);
                      },
                      icon: Icon(Icons.arrow_back),
                      color: buttonColor,
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: screenSize.width,
              height: containerHeight * 5,
              decoration: BoxDecoration(
                color: Color.fromARGB(122, 65, 79, 90),
                borderRadius:
                    BorderRadius.circular(20), // Adjust the value as needed
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        'Change The Dp',
                        textStyle: TextStyle(
                          color: textColor,
                          fontSize: screenSize.width < screenSize.height
                              ? screenSize.width * 0.04
                              : screenSize.height * 0.04,
                          fontWeight: FontWeight.w700,
                        ),
                        speed: Duration(milliseconds: 100),
                      ),
                      TyperAnimatedText(
                        'Or Remove It',
                        textStyle: TextStyle(
                          color: textColor,
                          fontSize: screenSize.width < screenSize.height
                              ? screenSize.width * 0.04
                              : screenSize.height * 0.04,
                          fontWeight: FontWeight.w700,
                        ),
                        speed: Duration(milliseconds: 100),
                      ),
                    ],
                    totalRepeatCount: 20,
                    pause: Duration(milliseconds: 1000),
                  ),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: IconButton(
                            onPressed: fetchData,
                            icon: myDp != null &&
                                    myDp!.path != null &&
                                    File(myDp!.path!).existsSync()
                                ? Image.file(
                                    File(myDp!
                                        .path!), // Use the file path directly
                                  )
                                : Icon(Icons.person),
                            color: buttonColor,
                          ),
                        ),
                        Flexible(
                            child: IconButton(
                                onPressed: () {
                                  myDp = null;
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.refresh,
                                  color: buttonColor,
                                )))
                      ],
                    ),
                  ),
                  AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        'Edit Folder Name',
                        textStyle: TextStyle(
                          color: textColor,
                          fontSize: screenSize.width < screenSize.height
                              ? screenSize.width * 0.035
                              : screenSize.height * 0.035,
                          fontWeight: FontWeight.w700,
                        ),
                        speed: Duration(milliseconds: 100),
                      ),
                    ],
                    totalRepeatCount: 20,
                    pause: Duration(milliseconds: 1000),
                  ),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(100, 255, 255, 255),
                              borderRadius: BorderRadius.circular(
                                  20), // Adjust the value as needed
                            ),
                            child: TextField(
                              enabled: isField,
                              controller: _controller1,
                              maxLength: 10,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: fieldColor),
                              style: TextStyle(color: textColor),
                            ),
                          ),
                        ),
                        Flexible(
                          child: IconButton(
                            onPressed: editName,
                            icon: Icon(
                              Icons.edit,
                              color: buttonColor,
                            ),
                          ),
                        ),
                        Flexible(
                          child: IconButton(
                            onPressed: saveName,
                            icon: Icon(
                              Icons.save,
                              color: buttonColor,
                            ), // Example button to update the label text
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        'Edit IP Address',
                        textStyle: TextStyle(
                          color: textColor,
                          fontSize: screenSize.width < screenSize.height
                              ? screenSize.width * 0.035
                              : screenSize.height * 0.035,
                          fontWeight: FontWeight.w700,
                        ),
                        speed: Duration(milliseconds: 100),
                      ),
                    ],
                    totalRepeatCount: 20,
                    pause: Duration(milliseconds: 1000),
                  ),
                  Flexible(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(100, 255, 255, 255),
                            borderRadius: BorderRadius.circular(
                                20), // Adjust the value as needed
                          ),
                          child: TextField(
                            enabled: isIP,
                            controller: _controller2,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: fieldColor),
                            style: TextStyle(color: textColor),
                          ),
                        ),
                      ),
                      Flexible(
                        child: IconButton(
                          onPressed: editIP,
                          icon: Icon(
                            Icons.edit,
                            color: buttonColor,
                          ),
                        ),
                      ),
                      Flexible(
                        child: IconButton(
                          onPressed: saveIP,
                          icon: Icon(
                            Icons.save,
                            color: buttonColor,
                          ), // Example button to update the label text
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            ),
            Container(
              width: screenSize.width,
              height: containerHeight * 2.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromARGB(122, 65, 79, 90),
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        'Try Some Different Theme',
                        textStyle: TextStyle(
                          color: textColor,
                          fontSize: screenSize.width < screenSize.height
                              ? screenSize.width * 0.02
                              : screenSize.height * 0.02,
                          fontWeight: FontWeight.w700,
                        ),
                        speed: Duration(milliseconds: 100),
                      ),
                      TyperAnimatedText(
                        'Click On Any Theme',
                        textStyle: TextStyle(
                          color: textColor,
                          fontSize: screenSize.width < screenSize.height
                              ? screenSize.width * 0.02
                              : screenSize.height * 0.02,
                          fontWeight: FontWeight.w700,
                        ),
                        speed: Duration(milliseconds: 100),
                      ),
                    ],
                    totalRepeatCount: 20,
                    pause: Duration(milliseconds: 1000),
                  ),
                  Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                              child: GestureDetector(
                                  onTap: () {
                                    defaultTheme();
                                  },
                                  child: Container(
                                      width: containerHeight / 4,
                                      height: containerHeight / 4,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: defaulbackColor,
                                      ))))),
                          Flexible(
                              child: GestureDetector(
                                  onTap: () {
                                    theme1();
                                  },
                                  child: Container(
                                      width: containerHeight / 4,
                                      height: containerHeight / 4,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: theme1backColor,
                                      ))))),
                          Flexible(
                              child: GestureDetector(
                                  onTap: () {
                                    theme2();
                                  },
                                  child: Container(
                                      width: containerHeight / 4,
                                      height: containerHeight / 4,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: theme2backColor,
                                      ))))),
                          Flexible(
                              child: GestureDetector(
                                  onTap: () {
                                    theme3();
                                  },
                                  child: Container(
                                      width: containerHeight / 4,
                                      height: containerHeight / 4,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: theme3backColor,
                                      ))))),
                          Flexible(
                              child: GestureDetector(
                                  onTap: () {
                                    theme4();
                                  },
                                  child: Container(
                                      width: containerHeight / 4,
                                      height: containerHeight / 4,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: theme4backColor,
                                      )))))
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
