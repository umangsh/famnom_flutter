import 'package:flutter/widgets.dart';
import 'package:famnom_flutter/app/app.dart';
import 'package:famnom_flutter/home/home.dart';
import 'package:famnom_flutter/login/login.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
