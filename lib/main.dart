import 'package:flutter/material.dart';
import 'QuizBrain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() {
  runApp(const Quizzler());
}

class Quizzler extends StatelessWidget {
  const Quizzler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: const SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: QuizPage()),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> iconArr = [];

  Icon correctIcon() => const Icon(Icons.check, color: Colors.green);
  Icon incorrectIcon() => const Icon(Icons.close, color: Colors.red);

  final questionBrain = QuizBrain();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                questionBrain.getQuestion(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ansBtn('True', true, () {
              setState(() {
                ansBtnPressed(true);
              });
            }),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ansBtn('False', false, () {
              setState(() {
                ansBtnPressed(false);
              });
            }),
          ),
        ),
        Row(children: iconArr)
      ],
    );
  }

  ansBtnPressed(bool userAns) {
    if (questionBrain.continueGame()) {
      questionBrain.nextQuestion();
      questionBrain.getAns() == userAns
          ? iconArr.add(correctIcon())
          : iconArr.add(incorrectIcon());
    } else {
      Alert(context: context, title: "End", desc: "Game Ended", buttons: [
        DialogButton(
          onPressed: () {
            setState(() {
              questionBrain.restartGame();
              iconArr.clear();
              Navigator.pop(context);
            });
          },
          color: const Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(0.0),
          child: const Text(
            "Restart",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ]).show();
    }
  }

  Widget ansBtn(String title, bool isTrue, onPress) {
    return ElevatedButton(
      onPressed: onPress,
      style: ButtonStyle(backgroundColor: getColor(isTrue)),
      child: Text(title),
    );
  }

  MaterialStateProperty<Color?> getColor(bool isTrue) => isTrue
      ? const MaterialStatePropertyAll<Color>(Colors.green)
      : const MaterialStatePropertyAll<Color>(Colors.red);
}
