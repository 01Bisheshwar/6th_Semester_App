import 'package:flutter/material.dart';
import 'package:food/home.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Picture extends StatefulWidget {
  final String value;
  final String ip;
  Picture({required this.value, required this.ip});
  @override
  _PictureState createState() => _PictureState();
}

class _PictureState extends State<Picture> {
  static PlatformFile? myDp;

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
            String imageName =
                croppedImageFile.path.split('/').last; // Extracting image name
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

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 0, 0, 0),
                Color.fromARGB(248, 4, 3, 94)
              ],
            ),
            image: DecorationImage(
                image: AssetImage("lib/assets/LogoForObjectDetection.png"),
                opacity: 0.5,
                fit: BoxFit.contain)),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Container(
            color: Color.fromARGB(158, 255, 255, 255),
            width: screenSize.width,
            height: screenSize.height / 2,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        'How About A Cool DP?',
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: screenSize.width<screenSize.height? screenSize.width*0.03 : screenSize.height*0.03,
                          fontWeight: FontWeight.w700,
                        ),
                        speed: Duration(milliseconds: 100),
                      ),
                      TyperAnimatedText(
                        'Upload A Pic',
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: screenSize.width<screenSize.height? screenSize.width*0.03 : screenSize.height*0.03,
                          fontWeight: FontWeight.w700,
                        ),
                        speed: Duration(milliseconds: 100),
                      ),
                    ],
                    totalRepeatCount: 20,
                    pause: Duration(milliseconds: 1000),
                  ),
                ),
                Flexible(
                  child: IconButton(
                    onPressed: fetchData,
                    icon: myDp != null &&
                            myDp!.path != null &&
                            File(myDp!.path!).existsSync()
                        ? Image.file(
                            File(myDp!.path!), // Use the file path directly
                          )
                        : Icon(Icons.person),
                  ),
                ),
                Flexible(
                    child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Home(value: widget.value, picValue: myDp, ip: widget.ip),
                      ),
                    );
                  },
                  child: Text("Submit"),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
