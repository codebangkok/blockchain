import 'package:flutter/material.dart';
import 'helpers.dart';

// ignore: must_be_immutable
class ElectionScreen extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  ElectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        color: const Color(0xff15294a),
        shadowColor: Colors.grey,
        borderOnForeground: true,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 30, left: 10, right: 10),
          child: Column(
            children: [
              TextButton(
                onPressed: () {}, //TODO: open smart contract explorer
                child: const Text(
                  'Election',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Color(0xfffbbd5c),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  buildButton(
                    text: 'Vote 1',
                    onPressed: () {
                      //TODO: vote 1 action
                    },
                  ),
                  buildButton(
                    text: 'Vote 2',
                    onPressed: () {
                      //TODO: vote 2 action
                    },
                  ),
                  buildButton(
                    text: 'Vote 3',
                    onPressed: () {
                      //TODO: vote 3 action
                    },
                  ),
                  buildButton(
                    text: 'Vote 4',
                    onPressed: () {
                      //TODO: vote 4 action
                    },
                  ),
                  buildButton(
                    text: 'Vote 5',
                    onPressed: () {
                      //TODO: vote 5 action
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  buildButton(
                    text: 'Ballot',
                    onPressed: () {
                      //TODO: ballot action
                    },
                  ),
                  buildButton(
                    text: 'Score',
                    onPressed: () {
                      //TODO: score action
                    },
                  ),
                  buildButton(
                    text: 'Status',
                    onPressed: () {
                      //TODO: status action
                    },
                  ),
                  buildButton(
                    text: 'Open',
                    onPressed: () {
                      //TODO: open action
                    },
                  ),
                  buildButton(
                    text: 'Close',
                    onPressed: () {
                      //TODO: close action
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
