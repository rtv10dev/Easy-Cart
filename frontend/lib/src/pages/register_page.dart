import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_cart/generated/custom_i18n.dart';
import 'package:easy_cart/src/utils/utils.dart' as utils;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_cart/src/libs/constants.dart' as Constants;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String userName = '';
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _renderContent(),
                ))));
  }

  List<Widget> _renderContent() {
    return [
      _renderTitle(),
      _renderUsernameInput(),
      SizedBox(height: 15.0),
      _renderButton()
    ];
  }

  Widget _renderTitle() {
    final String titleText = S.of(context).nameQuestion;
    return Text(titleText, style: TextStyle(fontSize: 25));
  }

  Widget _renderButton() {
    final String buttonText = S.of(context).confirm;
    return RaisedButton(
      padding: const EdgeInsets.all(8.0),
      textColor: Colors.white,
      color: Colors.blue,
      child: Text(
        buttonText,
      ),
      onPressed: _submit,
    );
  }

  Widget _renderUsernameInput() {
    final String errorText = S.of(context).invalidName;
    return Container(
      width: 300.0,
      child: TextFormField(
        textAlign: TextAlign.center,
        onChanged: (String value) {
          userName = value;
        },
        validator: (value) {
          if (!utils.isEmpty(value)) {
            return null;
          } else {
            return errorText;
          }
        },
      ),
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(Constants.USER_KEY, userName);
    Navigator.pushNamedAndRemoveUntil(context, 'products', (_) => false);
  }
}
