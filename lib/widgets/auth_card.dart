import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';
import '../providers/auth_provider.dart';
import '../screens/auth_screen.dart';
import '../screens/product_overview_screen.dart';

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin{
  
  final GlobalKey<FormState> _formKey = GlobalKey();
  
  AuthMode _authMode = AuthMode.Login;
  
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  
  var _isLoading = false;
  
  final _passwordController = TextEditingController();

  //Helps us to control animations
  AnimationController _controller;

  //Generic animation add a type to it (in out case will animate the hieght)
  Animation<Size> _heightAnimation;

  //opacity animation for fade transition
  Animation<double> _opacityAnimation;

  //slide animation for slide transition
  Animation<Offset> _sliderAnimation;

  @override
  void initState(){
    super.initState();

    //vsync: is a pointer check with the mixin class 
    //the animated widget is visible or not to preform the animation
    //duration: the delay and duration of executing the animation
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300,),
    );
    //tween is a generic class
    //it's knows how to animate between two values
    //animate: the animation type with parent that is the controller
    //curve the animation movemation type
    _heightAnimation = Tween<Size>(
      begin: Size(double.infinity, 260), 
      end: Size(double.infinity, 320)
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    //redraw the screen when the animation is started and reversed
    //if we use Animation buider, there is no use for setState and listener
    //_hieghtAnimation.addListener(() => setState(() {}));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _sliderAnimation = Tween<Offset>(begin: Offset(0, -1.5), end: Offset(0, 0)).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose(){
    super.dispose();

    //remove the animation listener when screen disposed
    _controller.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<AuthProvider>(context, listen: false).login(
          _authData['email'], 
          _authData['password']
        );
      } else {
        // Sign user up
        await Provider.of<AuthProvider>(context, listen: false).signUp(
          _authData['email'], 
          _authData['password']
        );
      }

      Navigator.of(context).pushNamed(ProductOverviewScreen.route_name);

    } on HttpException catch (error) {
      var errorMessage = 'Authentication Failed.';
      if (error.toString().contains('EMAIL_EXISTS')){
        errorMessage = 'The email address is already in use.';
      }else if (error.toString().contains('INVALID_EMAIL')){
        errorMessage = 'This is not a valid email address.';
      }else if (error.toString().contains('WEAK_PASSWORD')){
        errorMessage = 'This password is too weak.';
      }else if (error.toString().contains('EMAIL_NOT_FOUND')){
        errorMessage = 'Could not find a user with that email.';
      }else if (error.toString().contains('INVALID_PASSWORD')){
        errorMessage = 'Invalid password.';
      }

      _showAlertDialog(errorMessage);
    } catch (error){
      const errorMessage = 'Could not authenticate you, please try again later.';
      _showAlertDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      //start the animation (when switch button clicked)
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      //end the animation (when it back to first screen)
      _controller.reverse();
    }
  }

  void _showAlertDialog(String message){
    showDialog(
      context: context, 
      builder: (ctx){
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(ctx).pop(), 
              child: Text('Ok')
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      
      //control and animated widgets without controller
      //or globel animation variable
      //it's more efficent and do more and manu things for us
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300,),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),  //_authMode == AuthMode.Signup ? 320 : 260
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                _authMode == AuthMode.Signup ?
                SlideTransition(
                  position: _sliderAnimation,
                  child: TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }

                            return null;
                          }
                        : null,
                  ),
                )
                :
                Container(),
                SizedBox(
                  height: 20,
                ),
                _isLoading ?
                  CircularProgressIndicator()
                :
                  RaisedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ), 
    );
  }
}

// Fade animation with widget
// FadeTransition(
//   opacity: _opacityAnimation,
//   child: TextFormField(
//     enabled: _authMode == AuthMode.Signup,
//     decoration: InputDecoration(labelText: 'Confirm Password'),
//     obscureText: true,
//     validator: _authMode == AuthMode.Signup
//         ? (value) {
//             if (value != _passwordController.text) {
//               return 'Passwords do not match!';
//             }

//             return null;
//           }
//         : null,
//   ),
// )


//Build animation from scratch
// AnimatedBuilder(
//         animation: _hieghtAnimation, 
//         //this container will rerendered when the animation is fired
//         builder: (ctx, ch) => Container(
//           //height: _authMode == AuthMode.Signup ? 320 : 260,
//           //add the animation to the place you want to animated
//           height: _hieghtAnimation.value.height,
//           constraints:
//               BoxConstraints(minHeight: _hieghtAnimation.value.height),  //_authMode == AuthMode.Signup ? 320 : 260
//           width: deviceSize.width * 0.75,
//           padding: EdgeInsets.all(16.0),
//           child: ch,
//         ),
//         //that will static widget will never change or rebuild
//         // when the animation executed
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'E-Mail'),
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value.isEmpty || !value.contains('@')) {
//                       return 'Invalid email!';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) {
//                     _authData['email'] = value;
//                   },
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'Password'),
//                   obscureText: true,
//                   controller: _passwordController,
//                   validator: (value) {
//                     if (value.isEmpty || value.length < 5) {
//                       return 'Password is too short!';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) {
//                     _authData['password'] = value;
//                   },
//                 ),
//                 _authMode == AuthMode.Signup ?
//                   TextFormField(
//                     enabled: _authMode == AuthMode.Signup,
//                     decoration: InputDecoration(labelText: 'Confirm Password'),
//                     obscureText: true,
//                     validator: _authMode == AuthMode.Signup
//                         ? (value) {
//                             if (value != _passwordController.text) {
//                               return 'Passwords do not match!';
//                             }

//                             return null;
//                           }
//                         : null,
//                   )
//                 :
//                 Container(),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 _isLoading ?
//                   CircularProgressIndicator()
//                 :
//                   RaisedButton(
//                     child:
//                         Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
//                     onPressed: _submit,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
//                     color: Theme.of(context).primaryColor,
//                     textColor: Theme.of(context).primaryTextTheme.button.color,
//                   ),
//                 FlatButton(
//                   child: Text(
//                       '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
//                   onPressed: _switchAuthMode,
//                   padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
//                   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                   textColor: Theme.of(context).primaryColor,
//                 ),
//               ],
//             ),
//           ),
//         ),
//         )