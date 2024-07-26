import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:food/dpset.dart';

class Screen1 extends StatefulWidget {
  @override
  _IntroScreenState1 createState() => _IntroScreenState1();
}

class _IntroScreenState1 extends State<Screen1> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromARGB(255, 0, 0, 0), Color.fromARGB(248, 4, 3, 94)],
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
                AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      'Welcome',
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: screenSize.width<screenSize.height? screenSize.width*0.03 : screenSize.height*0.03,
                        fontWeight: FontWeight.w700,
                      ),
                      speed: Duration(milliseconds: 100),
                    ),
                    TyperAnimatedText(
                      'Set Folder Name',
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: screenSize.width<screenSize.height? screenSize.width*0.03 : screenSize.height*0.03,
                        fontWeight: FontWeight.w700,
                      ),
                      speed: Duration(milliseconds: 100),
                    ),
                    TyperAnimatedText(
                      'Set IP Address',
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
                TextField(
                  controller: controller1,
                  maxLength: 15,
                  decoration: InputDecoration(
                    hintText: 'Enter Folder Name',
                    hintStyle:
                        TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
                TextField(
                  controller: controller2,
                  decoration: InputDecoration(
                    hintText: 'Enter IP Of the Server',
                    hintStyle:
                        TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Picture(value: controller1.text, ip: controller2.text),
                      ),
                    );
                  },
                  child: Text("Submit"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
