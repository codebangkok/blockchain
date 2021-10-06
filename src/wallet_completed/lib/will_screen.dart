import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:wallet/helpers.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

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

  Contract? _willContract;
  final _willAddress = '0xbC8124E25E03b0439AeB5336C252B4f08d43E7AB';
  final _willAbi =
      '[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"heir","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"Create","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"heir","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"Deceased","type":"event"},{"inputs":[{"internalType":"address","name":"owner","type":"address"}],"name":"contracts","outputs":[{"internalType":"address","name":"heir","type":"address"},{"internalType":"uint256","name":"balance","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"heir","type":"address"}],"name":"create","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"}],"name":"deceased","outputs":[],"stateMutability":"nonpayable","type":"function"}]';

  void connect() {
    _willContract = Contract(
      _willAddress,
      Interface(_willAbi),
      provider!.getSigner(),
    );

    _willContract!.on('Create', (owner, heir, amount, event) {
      // ignore: avoid_print
      print('Create: owner($owner) heir($heir) = $amount');
    });

    _willContract!.on('Deceased', (owner, heir, amount, event) {
      // ignore: avoid_print
      print('Deceased: owner($owner) heir($heir) = $amount');
    });
  }

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
                onPressed: () => html.window.open('$explorerAddressUrl/$_willAddress', '_blank'), //TODO: open smart contract explorer
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
                                final heir = heirInputController.text;
                                final amount = double.parse(amountInputController.text) * pow(10, 18);

                                heirInputController.text = '';
                                amountInputController.text = '1';
                                Navigator.of(context).pop();

                                try {
                                  final tx = await _willContract!.send('create', [heir], TransactionOverride(value: BigInt.from(amount)));
                                  html.window.open('$explorerTxUrl/${tx.hash}', '_blank');
                                } catch (ex) {
                                  await showDialogError(context: context, message: ethereumException(ex));
                                }
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
                                final owner = deceasedInputController.text;
                                deceasedInputController.text = '';
                                Navigator.of(context).pop();

                                try {
                                  final tx = await _willContract!.send('deceased', [owner]);
                                  html.window.open('$explorerTxUrl/${tx.hash}', '_blank');
                                } catch (ex) {
                                  await showDialogError(context: context, message: ethereumException(ex));
                                }
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
                                final owner = contractInputController.text;
                                contractInputController.text = '';
                                Navigator.of(context).pop();

                                var heir = '';
                                var balance = BigInt.zero;
                                try {
                                  final result = await _willContract!.call<dynamic>('contracts', [owner]);

                                  heir = result[0];
                                  balance = BigInt.parse((result[1].toString()));
                                } catch (ex) {
                                  await showDialogError(context: context, message: ethereumException(ex));
                                  return;
                                }

                                if (balance == BigInt.zero) {
                                  await showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text("No testament"),
                                      content: const Text("You can create a new one."),
                                      actions: [
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                      ],
                                    ),
                                  );
                                  return;
                                }

                                final willBalanceEth = weiToEth(balance);
                                final willBalanceUsd = weiToUsd(balance);
                                await showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text(
                                      'Heir: $heir',
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    content: Text(
                                      'Amount: $willBalanceEth ETH (\$$willBalanceUsd)',
                                      textAlign: TextAlign.start,
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () => Navigator.of(context).pop(),
                                      ),
                                    ],
                                  ),
                                );
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
