import 'package:exim_lab/core/services/analytics_service.dart';
import 'package:flutter/material.dart';

class CustomAnalyticsObserver extends RouteObserver<PageRoute<dynamic>> {
  final AnalyticsService analyticsService;

  CustomAnalyticsObserver({required this.analyticsService});

  void _sendScreenView(PageRoute<dynamic> route) {
    var screenName = route.settings.name;
    if (screenName != null) {
      analyticsService.logScreenView(screenName);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(previousRoute);
    }
  }
}
