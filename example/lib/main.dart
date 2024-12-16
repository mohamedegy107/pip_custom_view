import 'package:example/routes_map.dart';
import 'package:flutter/material.dart';
import 'package:pip_view/pip_view.dart';

import 'routes.dart';

void main() => runApp(ExampleApp());

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // navigatorObservers: [AppNavigatorObserver(context)],
      // home: HomeScreen(),
      onGenerateRoute: AppRoutes.generateRoutes,
      routes: RoutesName.appRoutes,
      initialRoute: HomeScreen.id,
    );
  }
}

class HomeScreen extends StatelessWidget {
  static const String id = '/HomeScreen';

  @override
  Widget build(BuildContext context) {
    return PIPView(
      routes: AppRoutes.generateRoutes,
      pipViewWidget: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: Colors.amber,
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage("https://tinypng.com/static/images/boat.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
      floatingHeight: 70,
      floatingWidth: 70,
      builder: (context, isFloating) {
        return Scaffold(
          resizeToAvoidBottomInset: !isFloating,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('This page will float!'),
                  MaterialButton(
                    color: Theme.of(context).primaryColor,
                    child: Text('Start floating!'),
                    onPressed: () {
                      PIPView.of(context)!.presentBelow(BackgroundScreen());
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class BackgroundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('This is the background page!'),
              Text('If you tap on the floating screen, it stops floating.'),
              Text('Navigation works as expected.'),
              MaterialButton(
                color: Theme.of(context).primaryColor,
                child: Text('Push to navigation'),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    NavigatedScreen.id,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigatedScreen extends StatelessWidget {
  static const String id = '/NavigatedScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navigated Screen'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('This is the page you navigated to.'),
              Text('See how it stays below the floating page?'),
              Text('Just amazing!'),
              Spacer(),
              Text('It also avoids keyboard!'),
              TextField(),
            ],
          ),
        ),
      ),
    );
  }
}

// class AppNavigatorObserver extends NavigatorObserver {
//   final BuildContext context;

//   AppNavigatorObserver(this.context);
//   @override
//   void didPop(Route route, Route? previousRoute) {
//     super.didPop(route, previousRoute);
//     Navigator.removeRoute(
//       context,
//       route,
//     );
//     debugPrint('رجوع من الشاشة: ${route.settings.name}');
//   }

//   @override
//   void didPush(Route route, Route? previousRoute) {
//     super.didPush(route, previousRoute);
//     // يتم استدعاء الحدث عند الانتقال إلى شاشة جديدة
//     debugPrint('تم التنقل إلى الشاشة: ${route.settings.name}');
//   }
// }
