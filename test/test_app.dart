import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_formatter/mask_formatter.dart';
import 'mask_formatter_test.dart';

class TestApp extends StatefulWidget {
  final TestEnv testEnv;
  TestApp(this.testEnv);

  @override
  TestAppState createState() => new TestAppState(testEnv);
}

class TestAppState extends State<TestApp> {
  TestEnv env;

  MaskTextInputFormatter maskFormatter;
  List<TextInputFormatter> formatters;
  TestAppState(this.env) {
    maskFormatter = new MaskTextInputFormatter(env.mask,
        escapeChar: env.escapeChar);
    formatters = env.inputFormatters;
    formatters.add(maskFormatter);
  }

  String inputValue = '';
  String unmaskedInputValue = '';
  _onTextChange(String s) {
    setState(() {
      inputValue = s;
      unmaskedInputValue = maskFormatter.getEscapedString(s);
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter masked input',
        home: Scaffold(
            body: Stack(children: <Widget>[
          TextField(
            key: widget.testEnv.textFieldKey,
            onChanged: _onTextChange,
            inputFormatters: formatters,
            decoration: InputDecoration(
              hintText: env.mask,
            ),
          ),
          Text(inputValue),
          Text(unmaskedInputValue)
        ])),
      );
}
