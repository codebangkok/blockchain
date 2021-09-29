import 'package:flutter/material.dart';
import 'package:wallet/helpers.dart';

// ignore: must_be_immutable
class WillScreen extends StatelessWidget {
  WillScreen({Key? key}) : super(key: key);

  final createKey = GlobalKey<FormState>();
  final deceasedKey = GlobalKey<FormState>();
  final contractKey = GlobalKey<FormState>();

  final heirInputController = TextEditingController();
  final deceasedInputController = TextEditingController();
  final amountInputController = TextEditingController(text: '1');
  final contractInputController = TextEditingController();

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
                  'Testament',
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
                    text: 'Create',
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Create Testament'),
                          content: SizedBox(
                            height: 150,
                            child: SingleChildScrollView(
                              child: Form(
                                key: createKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: heirInputController,
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                        labelText: 'Heir Address',
                                        hintText: '0x00...',
                                      ),
                                      validator: (value) => value == null || value.isEmpty ? "required" : null,
                                    ),
                                    TextFormField(
                                      controller: amountInputController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'Amount (ETH)',
                                        hintText: '1',
                                      ),
                                      validator: (value) => value == null || value.isEmpty ? "required" : null,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () async {
                                if (!(createKey.currentState?.validate() ?? false)) return;

                                //TODO: create testament action
                              },
                            ),
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  buildButton(
                    text: 'Deceased',
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Deceased'),
                          content: Form(
                            key: deceasedKey,
                            child: TextFormField(
                              controller: deceasedInputController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                labelText: 'Owner Address',
                                hintText: '0x00...',
                              ),
                              validator: (value) => value == null || value.isEmpty ? "required" : null,
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () async {
                                if (!(deceasedKey.currentState?.validate() ?? false)) return;

                                //TODO: deceased action
                              },
                            ),
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                deceasedInputController.text = '';
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  buildButton(
                    text: 'Contract',
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Contract'),
                          content: Form(
                            key: contractKey,
                            child: TextFormField(
                              controller: contractInputController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                labelText: 'Owner Address',
                                hintText: '0x00...',
                              ),
                              validator: (value) => value == null || value.isEmpty ? "required" : null,
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () async {
                                if (!(contractKey.currentState?.validate() ?? false)) return;

                                //TODO: show contract action
                              },
                            ),
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                contractInputController.text = '';
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
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
