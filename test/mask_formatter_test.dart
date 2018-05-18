import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';

import 'test_app.dart';

class TestEnv {
  Key textFieldKey = new Key('tfk');
  String mask;
  String escapeChar;

  List<TextInputFormatter> inputFormatters;

  String typedText;
  String expectedMaskedValue;
  String expectedUnmaskedValue;

  TestEnv(
      {this.mask,
      this.escapeChar,
      this.typedText,
      this.expectedMaskedValue,
      this.expectedUnmaskedValue,
      this.inputFormatters});

  TestEnv copyWith(
          {String mask,
          String escapeChar,
          String typedText,
          String expectedMaskedValue,
          String expectedUnmaskedValue,
          List<TextInputFormatter> inputFormatters}) =>
      TestEnv(
          mask: mask ?? this.mask,
          escapeChar: escapeChar ?? this.escapeChar,
          typedText: typedText ?? this.typedText,
          expectedMaskedValue: expectedMaskedValue ?? this.expectedMaskedValue,
          expectedUnmaskedValue:
              expectedUnmaskedValue ?? this.expectedUnmaskedValue,
          inputFormatters: inputFormatters ?? this.inputFormatters);
}

testerConstructor(TestEnv env) {
  return (WidgetTester tester) async {
    final app = new TestApp(env);
    await tester.pumpWidget(app);
    await tester.enterText(find.byKey(env.textFieldKey), env.typedText);
    final TestAppState state = tester.state(find.byType(TestApp));
    expect(state.unmaskedInputValue, env.expectedUnmaskedValue);
    expect(state.inputValue, env.expectedMaskedValue);
  };
}

void main() {
  var env = TestEnv(
      mask: '+1 (___) ___-__-__',
      escapeChar: '_',
      typedText: '8001234567',
      expectedMaskedValue: '+1 (800) 123-45-67',
      expectedUnmaskedValue: '8001234567',
      inputFormatters: [],
  );

  testWidgets('Masks works', testerConstructor(env));
  testWidgets('with different escape charesters', testerConstructor(env.copyWith(
    mask: '+1 (***) ***-**-**',
    escapeChar: '*'
  )));
  testWidgets('Text can overflow', testerConstructor(env.copyWith(
    typedText: 'abc8001234567',
    expectedMaskedValue: '+1 (abc) 800-12-34567',
    expectedUnmaskedValue: 'abc8001234567'
  )));
  testWidgets('And formatter is composable (order matters)', testerConstructor(env.copyWith(
    expectedMaskedValue: '+1 (800) 123-45-67',
    expectedUnmaskedValue: '8001234567',
    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly]
  )));
}
