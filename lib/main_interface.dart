import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gasolinahan_simulator/database/database.dart';
import 'package:gasolinahan_simulator/my-utilities/color_palette.dart';
import 'package:gasolinahan_simulator/my-utilities/dimension_adapter.dart';

class MainInterface extends StatefulWidget {
  const MainInterface({super.key});

  @override
  State<MainInterface> createState() => _MainInterfaceState();
}

class _MainInterfaceState extends State<MainInterface> {
  //// this will contain the current color palette in use
  late List<Color> inUseColor;
  TextEditingController _pesos = TextEditingController();
  FocusNode _pesosFocus = FocusNode();
  TextEditingController _liters = TextEditingController();
  FocusNode _litersFocus = FocusNode();
  TextEditingController _pesosPerLiters = TextEditingController();
  FocusNode _pesosPerLitersFocus = FocusNode();

  AudioPlayer audioPlayer = AudioPlayer();

  late TextEditingController _currentInput;
  bool theProcessIsStillRunning = false;

  //// database related
  // List<Map<String, dynamic>>? records = [];

  // void fetch() async {
  //   try {
  //     final data = await DatabaseHelper().viewData();
  //     setState(() {
  //       records = data;
  //       print("Fetched data: $records");
  //     });
  //   } catch (exceptions) {
  //     //// maybe add a pop up dialog in here later
  //     print("The problem is: $exceptions");
  //   }
  // }

  //// this logic is for concatinating a single digit to already inputted value
  void addValue(String value) {
    if (value == "C") {
      _currentInput.clear();
      //// to make sure it is not null
      _currentInput.text = "0.0";
    } else if (value == "GO") {
    } else if (value == "F1" ||
        value == "F2" ||
        value == "F3" ||
        value == "F4") {
    }
    //// this will add the value to the current textfield in focus
    else {
      //// this logic will check if the value of the textfield is 0.0 or 0, so
      ///// that the new input values will be concatinated correctly
      if (_currentInput.text == "0.0" || _currentInput.text == "0") {
        _currentInput.text = ""; // clear the initial value
      }
      _currentInput.text += value;
      setState(() {
        print("${_currentInput.text} is the current value input");
        if (_pesosFocus.hasFocus) {
          _pesos.text = _currentInput.text;
        } else if (_litersFocus.hasFocus) {
          _liters.text = _currentInput.text;
        } else if (_pesosPerLitersFocus.hasFocus) {
          _pesosPerLiters.text = _currentInput.text;
        }
      });
    }
  }

  //// this logic will calculate the PESOS or LITERS value
  //// NOTE: some of this function's logic is not optimized, but it works.
  /////      Computers store numbers in binary format, thats why there are
  /////      some rounding errors when dealing with floating point numbers.
  /////      That is why I used +.1 or -.1 in some conditional statements to
  /////      anticipate these rounding errors when it comes to conditional statements.
  void calculator(int determiner) {
    //// this flag is for determining if the process is completed or canceled

    //// 1 == looking for PESOS, 2 == looking for LITERS
    if (determiner == 1) {
      ////FORMULA: PESOS = LITERS * PESOS/LITERS

      //// this aync function will be used to delay the execution of the loop
      () async {
        for (
          double i = 0.0;
          i - .1 <=
              (double.tryParse(_liters.text)! *
                  double.tryParse(_pesosPerLiters.text)!);
          i += .1
        ) {
          //// this logic is for determining if the process is done
          ///// if the current value of PESOS being displayed is greater than or
          ///// qual to the FORMULA then the process is done
          if (i + 0.1 >=
              (double.tryParse(_liters.text)! *
                  double.tryParse(_pesosPerLiters.text)!)) {
            // print("PROCESS COMPLETEDDDDDDDDDDD!");
            audioPlayer.stop();
          }

          //// for the Emergency Stop
          if (!theProcessIsStillRunning) {
            break;
          }
          //// this will delay the execution of the could allowing visibility for the
          ///// user to see the current value
          await Future.delayed(Duration(milliseconds: 50));
          setState(() {
            _pesos.text = i.toStringAsFixed(1);
            // print("the value of i is $i");
            // print(
            //   (double.tryParse(_liters.text)! *
            //       double.tryParse(_pesosPerLiters.text)!),
            // );
          });
        }
      }(); //// this () at the end is how to call an annonymous function
    } else if (determiner == 2) {
      ////FORMULA: LITERS = PESOS / PESOS/LITERS

      //// this aync function will be used to delay the execution of the loop
      () async {
        for (
          double i = 0.0;
          i - .1 <=
              (double.tryParse(_pesos.text)! /
                  double.tryParse(_pesosPerLiters.text)!);
          i += .1
        ) {
          //// for the Emergency Stop
          if (!theProcessIsStillRunning) {
            break;
          }
          //// this will delay the execution of the could allowing visibility for the
          ///// user to see the current value
          await Future.delayed(Duration(milliseconds: 650));
          setState(() {
            // print("the value of i is $i");
            // print(
            //   (double.tryParse(_pesos.text)! /
            //       double.tryParse(_pesosPerLiters.text)!),
            // );
            _liters.text = i.toStringAsFixed(1);
          });

          //// this logic is for determining if the process is done
          ///// if the current value of LITERS being displayed is greater than or
          ///// qual to the FORMULA then the process is done
          if (i >=
              (double.tryParse(_pesos.text)! /
                  double.tryParse(_pesosPerLiters.text)!)) {
            // print("PROCESS COMPLETEDDDDDDDDDDD!");
            audioPlayer.stop();
          }
        }
      }(); //// this () at the end is how to call an annonymous function
    }
  }

  // void fetchData() async {}

  @override
  void initState() {
    super.initState();
    //// to prevent landscape mode (as of for now, this can be changed later)
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    //// initializes the current color palette
    inUseColor = MyColorPalette.inUse;
    _pesos.text = "0.0";
    _liters.text = "0.0";
    _pesosPerLiters.text = "51.0";
  }

  //// to dispose the controllers and focus nodes
  @override
  void dispose() {
    _pesos.dispose();
    _liters.dispose();
    _pesosPerLiters.dispose();
    _pesosFocus.dispose();
    _litersFocus.dispose();
    _pesosPerLitersFocus.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MyDimensionAdapter.getWidth(context),
        height: MyDimensionAdapter.getHeight(context),
        // color: MyColorPalette.premiumColor[2],
        color: inUseColor[0],
        child: Stack(
          children: [
            Align(alignment: Alignment.center),
            //// header text
            headerText(context),
            //// this is where everything will be placed
            cardboardInterface(context),
          ],
        ),
      ),
    );
  }

  ////--------------------------------------------------------------------------

  Positioned headerText(BuildContext context) {
    return Positioned(
      top: 0,
      child: SafeArea(
        child: SizedBox(
          // color: Colors.amber,
          width: MyDimensionAdapter.getWidth(context),
          height:
              MyDimensionAdapter.getHeight(context) *
              (.13 / 1.5), //para ma sakto sa height
          child: Center(
            child: Text(
              "PREMIUM",
              style: TextStyle(
                color: MyColorPalette.txtColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Positioned cardboardInterface(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: MyDimensionAdapter.getWidth(context),
        height: MyDimensionAdapter.getHeight(context) * .87,
        decoration: BoxDecoration(
          color: MyColorPalette.bgGrey,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            //// navigation buttons
            navButtons(),
            //// text field card
            textFieldCard(),
            //// emergency stop button
            emergencyStop(),
            //// input buton cotainer
            inputButtonsContainer(),
          ],
        ),
      ),
    );
  }

  Container navButtons() {
    return Container(
      // color: Colors.amber,
      width: MyDimensionAdapter.getWidth(context) * .30,
      height: MyDimensionAdapter.getHeight(context) * .05,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.circle_outlined, color: MyColorPalette.premiumColor[2]),
          Icon(Icons.circle_outlined, color: MyColorPalette.regularColor[3]),
          Icon(Icons.circle_outlined, color: MyColorPalette.dieselColor[3]),
        ],
      ),
    );
  }

  Container textFieldCard() {
    return Container(
      width: MyDimensionAdapter.getWidth(context) * .87,
      height: MyDimensionAdapter.getHeight(context) * .25,
      decoration: BoxDecoration(
        color: inUseColor[0],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // color: Colors.amber,
            width: MyDimensionAdapter.getWidth(context) * .32,
            height: MyDimensionAdapter.getHeight(context) * .22,
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1),
                Text(
                  "PESOS",
                  style: TextStyle(
                    color: MyColorPalette.txtColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "LITERS",
                  style: TextStyle(
                    color: MyColorPalette.txtColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  "PESOS/LITERS",
                  style: TextStyle(
                    color: MyColorPalette.txtColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
              ],
            ),
          ),
          Container(
            // color: Colors.green,
            width: MyDimensionAdapter.getWidth(context) * .48,
            height: MyDimensionAdapter.getHeight(context) * .22,
            padding: const EdgeInsets.only(right: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MyDimensionAdapter.getHeight(context) * .05,
                  //// PESOS text field
                  child: TextField(
                    focusNode: _pesosFocus,
                    controller: _pesos,
                    readOnly: true,
                    style: TextStyle(
                      color: MyColorPalette.txtColor,
                      fontSize: 28,
                    ),
                    textAlign: TextAlign.end,

                    //// maximum length of characters in a text field
                    maxLength: 10,

                    decoration: InputDecoration(
                      //// this Offstage will remove the counter
                      counter: Offstage(),
                      contentPadding: const EdgeInsets.all(0),
                      fillColor: MyColorPalette.txtFieldGrey,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.0,
                          color: MyColorPalette.goButton,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: MyColorPalette.txtColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MyDimensionAdapter.getHeight(context) * .05,
                  //// LITERS text field
                  child: TextField(
                    focusNode: _litersFocus,
                    controller: _liters,
                    readOnly: true,
                    style: TextStyle(
                      color: MyColorPalette.txtColor,
                      fontSize: 28,
                    ),
                    textAlign: TextAlign.end,

                    //// maximum length of characters in a text field
                    maxLength: 10,

                    decoration: InputDecoration(
                      //// this Offstage will remove the counter
                      counter: Offstage(),
                      contentPadding: const EdgeInsets.all(0),
                      fillColor: MyColorPalette.txtFieldGrey,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.0,
                          color: MyColorPalette.goButton,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: MyColorPalette.txtFieldGrey,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MyDimensionAdapter.getHeight(context) * .04,
                  //// PESOS/LITERS text field
                  child: TextField(
                    focusNode: _pesosPerLitersFocus,
                    controller: _pesosPerLiters,
                    readOnly: true,
                    style: TextStyle(
                      color: MyColorPalette.txtColor,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.end,

                    //// maximum length of characters in a text field
                    maxLength: 10,

                    decoration: InputDecoration(
                      //// this Offstage will remove the counter
                      counter: Offstage(),
                      contentPadding: const EdgeInsets.all(0),
                      fillColor: MyColorPalette.txtFieldGrey,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.0,
                          color: MyColorPalette.goButton,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: MyColorPalette.txtFieldGrey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox emergencyStop() {
    return SizedBox(
      // color: const Color.fromARGB(255, 197, 197, 197),
      height: MyDimensionAdapter.getHeight(context) * .15,
      child: Center(
        child: GestureDetector(
          onTap: () async {
            await audioPlayer.stop();
            theProcessIsStillRunning = false; // stop the process
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: MyDimensionAdapter.getHeight(context) * .02,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.circle_outlined,
                      size: MyDimensionAdapter.getWidth(context) * .20,
                      color: MyColorPalette.emergencyStopOutLine,
                    ),

                    Icon(
                      Icons.circle,
                      size: MyDimensionAdapter.getWidth(context) * .165,
                      color: MyColorPalette.emergencyStopFill,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: MyDimensionAdapter.getHeight(context) * .02,
                child: Text(
                  "EMERGENCY STOP",
                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //// this is the input buttons, do not modify the list
  final List buttonText = [
    "7",
    "8",
    "9",
    "F1",
    "4",
    "5",
    "6",
    "F2",
    "1",
    "2",
    "3",
    "F3",
    "0",
    "GO",
    "C",
    "F4",
  ];

  SizedBox inputButtonsContainer() {
    return SizedBox(
      // color: Colors.amber,
      width: MyDimensionAdapter.getWidth(context) * .80,
      height: MyDimensionAdapter.getHeight(context) * .42,
      child: GridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        padding: const EdgeInsets.only(bottom: 10),
        children: List.generate(16, (index) {
          return InkWell(
            onTap: () async {
              print("Button ${buttonText[index]} pressed");

              //// this logic is only for the GO button
              if (buttonText[index] == "GO") {
                try {
                  //// this logic is for detecting if the text fields are not empty and should be above 0 value
                  if (double.tryParse(_pesos.text)! > 0.0 ||
                      double.tryParse(_liters.text)! > 0.0) {
                    //// this will set to loop the audio
                    await audioPlayer.setReleaseMode(ReleaseMode.loop);
                    //// this will start the audio
                    await audioPlayer.play(AssetSource("audio/diesel_sfx.aac"));
                    theProcessIsStillRunning = true; // start the process

                    // //// database logic
                    // DatabaseHelper dbHelper = DatabaseHelper();
                    // dbHelper.updatePrice(id, row);

                    if (_pesosFocus.hasFocus) {
                      print("PESOS HAS FOCUSSSS ${_pesosFocus.hasFocus}");
                      calculator(2); // calculate LITERS
                    } else if (_litersFocus.hasFocus) {
                      print("LITER HAS FOCUSSSS ${_litersFocus.hasFocus}");
                      calculator(1); // calculate PESOS
                    }
                  }
                }
                //// for determining the problem
                catch (e) {
                  // print(
                  //   "HHHHHHHHHHHHHHHHHHHHHHH ${double.tryParse(_pesos.text)}",
                  // );
                  // _pesos.text = "";
                }
              }

              //// to determine who has the focus
              if (_pesosFocus.hasFocus) {
                _currentInput = _pesos;
                addValue(buttonText[index]);
              } else if (_litersFocus.hasFocus) {
                _currentInput = _liters;
                addValue(buttonText[index]);
              } else if (_pesosPerLitersFocus.hasFocus) {
                _currentInput = _pesosPerLiters;
                addValue(buttonText[index]);
              } else {
                return; // No text field is focused
              }
            },
            child: Container(
              decoration: BoxDecoration(
                //// this logic will determine the color of the button
                color: (index == 3 || index == 7 || index == 11 || index > 12)
                    ? (index == 13)
                          ? MyColorPalette.goButton
                          : inUseColor[1]
                    : inUseColor[0],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  buttonText[index],
                  style: TextStyle(
                    color: (buttonText[index] == "GO")
                        ? const Color.fromARGB(255, 244, 228, 203)
                        : MyColorPalette.txtColor,
                    fontSize: MyDimensionAdapter.getWidth(context) * .1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
