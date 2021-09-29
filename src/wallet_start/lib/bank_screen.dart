import 'package:flutter/material.dart';
import 'helpers.dart';

// ignore: must_be_immutable
class BankScreen extends StatelessWidget {
  BankScreen({Key? key}) : super(key: key);

  final depositKey = GlobalKey<FormState>();
  final withdrawKey = GlobalKey<FormState>();

  final depositInputController = TextEditingController(text: '1');
  final withdrawInputController = TextEditingController(text: '1');

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
                  'Bank',
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
                    text: 'Deposit',
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Deposit (ETH)'),
                          content: Form(
                            key: depositKey,
                            child: TextFormField(
                              controller: depositInputController,
                              keyboardType: TextInputType.number,
                              validator: (value) => value == null || value.isEmpty ? "required" : null,
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () async {
                                if (!(depositKey.currentState?.validate() ?? false)) return;

                                //TODO: deposit action
                              },
                            ),
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                depositInputController.text = '1';
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  buildButton(
                    text: 'Withdraw',
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Withdraw (ETH)'),
                          content: Form(
                            key: withdrawKey,
                            child: TextFormField(
                              controller: withdrawInputController,
                              keyboardType: TextInputType.number,
                              validator: (value) => value == null || value.isEmpty ? "required" : null,
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () async {
                                if (!(withdrawKey.currentState?.validate() ?? false)) return;

                                //TODO: withdraw action
                              },
                            ),
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                withdrawInputController.text = '1';
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  buildButton(
                    text: 'Balance',
                    onPressed: () async {
                      //TODO: check balance action
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
