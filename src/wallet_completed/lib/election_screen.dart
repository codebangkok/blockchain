import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'helpers.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

// ignore: must_be_immutable
class ElectionScreen extends StatelessWidget {
  ElectionScreen({Key? key}) : super(key: key);

  Contract? _electionContract;
  final _electionAddress = '0x0b5E65a05a94DAb3604D91b1b9d1cd487b10F152';
  final _electionAbi =
      '[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"issueId","type":"uint256"},{"indexed":false,"internalType":"bool","name":"open","type":"bool"}],"name":"StatusChange","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"issueId","type":"uint256"},{"indexed":true,"internalType":"uint256","name":"option","type":"uint256"},{"indexed":false,"internalType":"address","name":"voter","type":"address"}],"name":"Vote","type":"event"},{"inputs":[],"name":"ballot","outputs":[{"internalType":"uint256","name":"option","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"close","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"open","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"scores","outputs":[{"internalType":"uint256[]","name":"","type":"uint256[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"status","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"option","type":"uint256"}],"name":"vote","outputs":[],"stateMutability":"nonpayable","type":"function"}]';

  void connect() {
    _electionContract = Contract(
      _electionAddress,
      Interface(_electionAbi),
      provider!.getSigner(),
    );

    _electionContract!.on('Vote', (issudId, voter, option, event) {
      // ignore: avoid_print
      print('Vote: issudId($issudId) voter($voter) option($option)');
    });

    _electionContract!.on('StatusChange', (issueId, open, event) {
      // ignore: avoid_print
      print('StatusChange: open = $open');
    });
  }

  Future vote({required BuildContext context, required int option}) async {
    try {
      final tx = await _electionContract!.send('vote', [option.toString()]);
      html.window.open('$explorerTxUrl/${tx.hash}', '_blank');
    } catch (ex) {
      await showDialogError(context: context, message: ethereumException(ex));
    }
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
                onPressed: () => html.window.open('$explorerAddressUrl/$_electionAddress', '_blank'), //TODO: open smart contract explorer
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
                    onPressed: () async {
                      //TODO: vote 1 action
                      await vote(context: context, option: 1);
                    },
                  ),
                  buildButton(
                    text: 'Vote 2',
                    onPressed: () async {
                      //TODO: vote 2 action
                      await vote(context: context, option: 2);
                    },
                  ),
                  buildButton(
                    text: 'Vote 3',
                    onPressed: () async {
                      //TODO: vote 3 action
                      await vote(context: context, option: 3);
                    },
                  ),
                  buildButton(
                    text: 'Vote 4',
                    onPressed: () async {
                      //TODO: vote 4 action
                      await vote(context: context, option: 4);
                    },
                  ),
                  buildButton(
                    text: 'Vote 5',
                    onPressed: () async {
                      //TODO: vote 5 action
                      await vote(context: context, option: 5);
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
                    onPressed: () async {
                      //TODO: ballot action
                      var option = BigInt.zero;
                      try {
                        option = await _electionContract!.call<BigInt>('ballot');
                      } catch (ex) {
                        await showDialogError(context: context, message: ethereumException(ex));
                        return;
                      }
                      await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(
                            "You vote option $option",
                            textAlign: TextAlign.start,
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
                  buildButton(
                    text: 'Score',
                    onPressed: () async {
                      //TODO: score action
                      var scores = List<dynamic>.empty();
                      try {
                        scores = await _electionContract!.call<List<dynamic>>('scores');
                      } catch (ex) {
                        await showDialogError(context: context, message: ethereumException(ex));
                        return;
                      }

                      await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text(
                            'Score',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            'Option 1 = ${scores[1]}\nOption 2 = ${scores[2]}\nOption 3 = ${scores[3]}\nOption 4 = ${scores[4]}\nOption 5 = ${scores[5]}',
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
                  buildButton(
                    text: 'Status',
                    onPressed: () async {
                      //TODO: status action
                      var status = '';
                      try {
                        status = await _electionContract!.call<String>('status');
                      } catch (ex) {
                        await showDialogError(context: context, message: ethereumException(ex));
                        return;
                      }
                      await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(
                            status == 'open' ? 'Election Opening' : 'Election Closed',
                            textAlign: TextAlign.start,
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
                  buildButton(
                    text: 'Open',
                    onPressed: () async {
                      //TODO: open action
                      try {
                        final tx = await _electionContract!.send('open');
                        html.window.open('$explorerTxUrl/${tx.hash}', '_blank');
                      } catch (ex) {
                        await showDialogError(context: context, message: ethereumException(ex));
                      }
                    },
                  ),
                  buildButton(
                    text: 'Close',
                    onPressed: () async {
                      //TODO: close action
                      try {
                        final tx = await _electionContract!.send('close');
                        html.window.open('$explorerTxUrl/${tx.hash}', '_blank');
                      } catch (ex) {
                        await showDialogError(context: context, message: ethereumException(ex));
                      }
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
