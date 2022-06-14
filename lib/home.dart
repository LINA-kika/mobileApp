import 'package:flutter/material.dart';
import 'package:rubcon/constrants.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        /*decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/primaryBg.png'),
              fit: BoxFit.cover,
            )),*/
        color: rubconColor,
        child: Stack(
          children: <Widget>[
            Positioned(top: 110, right: 0, bottom: 30, child: LayerOne()),
            Positioned(top: 120, right: 0, bottom: 40, child: LayerTwo()),
            Positioned(top: 120, right: 0, bottom: 48, child: LayerThree()),
          ],
        ),
      ),
    );
  }
}
class LayerOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 654,
      decoration: BoxDecoration(
        color: layerOneBg,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60.0),
            bottomRight: Radius.circular(60.0)
        ),
      ),
    );
  }
}
class LayerTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 399,
      height: 584,
      decoration: BoxDecoration(
        color: layerTwoBg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60.0),
          bottomRight: Radius.circular(60.0),
          bottomLeft: Radius.circular(60.0),
        ),
      ),
    );
  }
}

class LayerThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height:  MediaQuery.of(context).viewInsets.bottom,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 59,
            top: 99,
            child: Text(
              'Email',
              style: TextStyle(
                  fontFamily: 'Poppins-Medium',
                  fontSize: 24,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Positioned(
              left: 59,
              top: 129,
              child: Container(
                width: 310,
                child: TextField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Введите Email',
                    hintStyle: TextStyle(color: hintText),
                  ),
                ),
              )),
          Positioned(
            left: 59,
            top: 199,
            child: Text(
              'Пароль',
              style: TextStyle(
                  fontFamily: 'Poppins-Medium',
                  fontSize: 24,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Positioned(
              left: 59,
              top: 229,
              child: Container(
                width: 310,
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Введите пароль',
                    hintStyle: TextStyle(color: hintText),
                  ),
                ),
              )),
          /*Positioned(
              left: 46,
              top: 361,
              child: Checkbox(
                checkColor: Colors.black,
                activeColor: checkbox,
                value: isChecked,
                onChanged: (bool? value) {
                  isChecked = value!;
                },
              )),
          Positioned(
              left: 87,
              top: 375,
              child: Text(
                'Запомнить меня',
                style: TextStyle(
                    color: forgotPasswordText,
                    fontSize: 16,
                    fontFamily: 'Poppins-Medium',
                    fontWeight: FontWeight.w500),
              )),*/
          Positioned(
              top: 365,
              right: 60,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  primary: Colors.white,
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/projects");
                },
                child: const Text('Войти',textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Poppins-Medium',
                      fontWeight: FontWeight.w400),),
              ),/*Container(
                width: 99,
                height: 35,
                decoration: BoxDecoration(
                  color: signInButton,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    'Войти',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Poppins-Medium',
                        fontWeight: FontWeight.w400),
                  ),
                ),
              )*/),

        ],
      ),
    );
  }
}
