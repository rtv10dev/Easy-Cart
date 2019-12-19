import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_cart/generated/custom_i18n.dart';
import 'package:easy_cart/src/providers/products_provider.dart';
import 'package:easy_cart/src/utils/utils.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:easy_cart/src/libs/constants.dart' as Constants;

class CreateProductDialog extends StatefulWidget {
  @override
  _CreateProductDialogState createState() => _CreateProductDialogState();
}

class _CreateProductDialogState extends State<CreateProductDialog> {
  SpeechRecognition _speechRecognition;
  final double _padding = 16.0;
  int _currentStep = 1;
  bool _isListening = false;
  String _productName = "";
  String _currentLocale = 'en-GB';
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Container(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _renderWizardStep()),
              )),
        ],
      ),
    );
  }

  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();

    _speechRecognition.activate();

    _speechRecognition.setCurrentLocaleHandler(
        (String locale) => setState(() => _currentLocale = locale));

    _speechRecognition.setRecognitionStartedHandler(
      () => setState(() => _isListening = true),
    );

    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState(() => _productName = speech),
    );

    _speechRecognition.setRecognitionCompleteHandler(
      () => setState(() => _isListening = false),
    );
  }

  _dialogContentStepOne(BuildContext context) {
    return <Widget>[
      Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: _padding,
                      bottom: _padding,
                      left: _padding,
                      right: _padding),
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: Colors.grey[200]),
                  child: Center(
                    child: Text(_productName,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22.0)),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FloatingActionButton(
                      child: Icon(Icons.mic),
                      onPressed: () {
                        if (!_isListening) {
                          setState(() {
                            _productName = S.of(context).talkNow;
                          });
                          _speechRecognition
                              .listen(locale: _currentLocale)
                              .then((result) => print('$result'));
                        }
                      },
                      backgroundColor: Theme.of(context).accentColor,
                    )
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      child: FlatButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        padding: EdgeInsets.all(0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Text(S.of(context).cancel.toUpperCase(),
                              style: TextStyle(color: Colors.blue)),
                        ),
                      ),
                    ),
                    SizedBox(
                      child: FlatButton(
                        onPressed: () {
                          if (_productName == "" ||
                              _isListening ||
                              _productName == S.of(context).talkNow) {
                            showErrorToast(S.of(context).invalidProduct);
                          } else {
                            setState(() {
                              _currentStep = 2;
                            });
                          }
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        padding: EdgeInsets.all(0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Text(S.of(context).next.toUpperCase(),
                              style: TextStyle(color: Colors.blue)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    ];
  }

  _dialogContentStepTwo(BuildContext context) {
    return <Widget>[
      Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 25,
                ),
                Text(S.of(context).quantity,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22.0)),
                _renderQuantityInput(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      child: FlatButton(
                        onPressed: () {
                          setState(() {
                            _currentStep = 1;
                          });
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        padding: EdgeInsets.all(0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Text(S.of(context).back.toUpperCase(),
                              style: TextStyle(color: Colors.blue)),
                        ),
                      ),
                    ),
                    SizedBox(
                      child: FlatButton(
                        onPressed: () {
                          _saveProduct();
                          Navigator.of(context).pop(false);
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        padding: EdgeInsets.all(0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Text(S.of(context).save.toUpperCase(),
                              style: TextStyle(color: Colors.blue)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    ];
  }

  _renderWizardStep() {
    switch (_currentStep) {
      case 1:
        return _dialogContentStepOne(context);
        break;
      case 2:
        return _dialogContentStepTwo(context);
        break;
      default:
        return _dialogContentStepOne(context);
    }
  }

  _renderQuantityInput() {
    return NumberPicker.horizontal(
        initialValue: _quantity,
        minValue: 1,
        maxValue: 100,
        onChanged: (newValue) => setState(() => _quantity = newValue));
  }

  _saveProduct() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String user = sharedPreferences.getString(Constants.USER_KEY);
    var productData = {
      'name': _productName,
      "user": user,
      'quantity': _quantity
    };
    try {
      var product = await ProductsProvider.createProduct(productData);
      return product;
    } catch (err) {
      showErrorToast(S.of(context).errorAddingProduct);
    }
  }
}
