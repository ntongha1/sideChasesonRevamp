import 'package:sonalysis/core/navigation/keys.dart';
import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  pop() async {
    navigatorKey.currentState!.pop();
  }

  popWithData(Map data) async {
    navigatorKey.currentState!.pop(data);
  }

  Future clearAllTo(String routeName) async {
    navigatorKey.currentState!
        .pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  Future clearAllWithParameter(
      {required String routeName, required Map data}) async {
    navigatorKey.currentState!.pushNamedAndRemoveUntil(
        routeName, (route) => route.settings.name == RouteKeys.routeLoginScreen,
        arguments: data);
  }

  Future to(String routeName) async {
    var res = await navigatorKey.currentState!.pushNamed(routeName);
    return res;
  }

  Future toWithPameter({required String routeName, required Map data}) async {
    var res =
        await navigatorKey.currentState!.pushNamed(routeName, arguments: data);
    return res;
  }

  Future replaceWith(String routeName) async {
    navigatorKey.currentState!.pushReplacementNamed(routeName);
  }

  Future replaceWithPameter(
      {required String routeName, required Map data}) async {
    navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: data);
  }
}

class CustomRoutes {
  static Route fadeIn(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, page) {
        var begin = 0.0;
        var end = 1.0;
        var curve = Curves.easeInExpo;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return FadeTransition(
          opacity: animation.drive(tween),
          child: page,
        );
      },
    );
  }

  static Route slideIn(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, page) {
        var begin = const Offset(10, 0);
        var end = Offset.zero;
        var curve = Curves.easeInExpo;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: page,
        );
      },
    );
  }

  static Route slideUp(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, page) {
        var begin = const Offset(0, 1);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: page,
        );
      },
    );
  }
}
