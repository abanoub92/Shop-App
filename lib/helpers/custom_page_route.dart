import 'package:flutter/material.dart';

/*
 * Create a custom transition animation between two 
 * screens
 */
class CustomPageRoute<T> extends MaterialPageRoute<T> {

  CustomPageRoute({WidgetBuilder builder, RouteSettings settings}) 
  //pass the child class data to parent constructor
  : super (builder: builder, settings: settings);


  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondAnimation, Widget child){
    
    // if (settings.){
    //   return child;
    // }

    return FadeTransition(opacity: animation, child: child);
  }

}