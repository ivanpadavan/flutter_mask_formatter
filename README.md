# mask_formatter

Another pure dart package for masked text. 
Implemented as [TextInputFormtter](https://docs.flutter.io/flutter/services/TextInputFormatter-class.html)
Seems to be composable and universal.
## Getting Started

There are two properties to pass into constuructor:
1. `mask` (not named);
2. `escapeChar` - if you need to change the default one ('_')

And useful method `getEscapedString`. TextController will return masked value So it's hand converter.


With this piece of code:
```dart
import 'package:mask_formatter/mask_formatter.dart';

class App extends StatefulWidget {
  AppState createState() => new AppState();
}

class AppState extends State<App> {
  final maskFormatter = MaskTextInputFormatter('+1 (___) ___-__-__');

  String inputValue = '';
  String unmaskedInputValue = '';
  _onTextChange(String s) {
    setState(() {
      inputValue = s;
      unmaskedInputValue = maskFormatter.getEscapedString(s);
    });
  }

  @override
  Widget build(BuildContext context) => 
    MaterialApp(
      title: 'Flutter masked input',
      home: Scaffold(
        body: TextField(
          key: widget.testEnv.textFieldKey,
          onChanged: _onTextChange,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
            maskFormatter
          ],
            decoration: InputDecoration(
              hintText: '+1 (___) ___-__-__'
            ),
          )
    );
}
```
You'll get quite good looking, functional and composable way to solve the issue (at least nicer than [here](https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/material/text_form_field_demo.dart#L293)).

Happy coding!