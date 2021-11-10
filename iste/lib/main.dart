import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:iste/board/board_home_screen.dart';
import 'package:iste/board/broadcasts/new_broadcast_screen.dart';
import 'package:iste/board/broadcasts/success_broadcast_screen.dart';
import 'package:iste/board/requests/approved_requests_details_screen.dart';
import 'package:iste/board/requests/approved_requests_screen.dart';
import 'package:iste/board/requests/request_added_screen.dart';
import 'package:iste/board/requests/request_added_successfully_screen.dart';
import 'package:iste/board/requests/request_deleted_screen.dart';
import 'package:iste/board/requests/view_requests_screen.dart';
import 'package:iste/board/tasks/edit_task_success_screen.dart';
import 'package:iste/board/tasks/new_task_screen.dart';
import 'package:iste/board/tasks/success_task_screen.dart';
import 'package:iste/core/core_broadcasts/core_broadcast_screen.dart';
import 'package:iste/core/core_broadcasts/new_core_broadcast_screen.dart';
import 'package:iste/core/core_broadcasts/success_core_broadcast_screen.dart';
import 'package:iste/core/home_screen.dart';
import 'package:iste/core/storage/file_deleted_screen.dart';
import 'package:iste/core/storage/file_upload_successful.dart';
import 'package:iste/core/storage/upload_new_file_screen.dart';
import 'package:iste/core/tasks/task_deleted_screen.dart';
import 'package:iste/core/tasks/task_details_screen.dart';
import 'package:iste/login_screen.dart';
import 'package:iste/sign_up_screen.dart';
import 'package:iste/update_app.dart';
import 'package:page_transition/page_transition.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // await Firebase.initializeApp();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: LoginScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/task_details_screen':
            return PageTransition(
              child: TaskDetailsScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          case '/new_task_screen':
            return PageTransition(
              child: NewTaskScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          case '/new_broadcast_screen':
            return PageTransition(
              child: NewBroadcastScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          case '/approved_requests_screen':
            return PageTransition(
              child: ApprovedRequestsScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          case '/view_requests_screen':
            return PageTransition(
              child: ViewRequestsScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          case '/approved_requests_details_screen':
            return PageTransition(
              child: ApprovedRequestDetailsScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          case '/core_broadcast_screen':
            return PageTransition(
              child: CoreBroadcastScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          case '/new_core_broadcast_screen':
            return PageTransition(
              child: NewCoreBroadcastScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          case '/upload_new_file_screen':
            return PageTransition(
              child: UploadNewFileScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;
          default:
            return null;
        }
      },
      routes: {
        LoginScreen.routeName: (ctx) => LoginScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
        SignUpScreen.routeName: (ctx) => SignUpScreen(),
        BoardHomeScreen.routeName: (ctx) => BoardHomeScreen(),
        NewTaskScreen.routeName: (ctx) => NewTaskScreen(),
        NewBroadcastScreen.routeName: (ctx) => NewBroadcastScreen(),
        SuccessTaskScreen.routeName: (ctx) => SuccessTaskScreen(),
        EditTaskSuccessScreen.routeName: (ctx) => EditTaskSuccessScreen(),
        SuccessBroadcastScreen.routeName: (ctx) => SuccessBroadcastScreen(),
        TaskDeletedScreen.routeName: (ctx) => TaskDeletedScreen(),
        RequestDeletedScreen.routeName: (ctx) => RequestDeletedScreen(),
        RequestAddedScreen.routeName: (ctx) => RequestAddedScreen(),
        RequestAddedSuccessfully.routeName: (ctx) => RequestAddedSuccessfully(),
        UpdateApp.routeName: (ctx) => UpdateApp(),
        SuccessCoreBroadcastScreen.routeName: (ctx) => SuccessCoreBroadcastScreen(),
        FileUploadSuccessful.routeName: (ctx) => FileUploadSuccessful(),
        FileDeletedScreen.routeName: (ctx) => FileDeletedScreen(),
      },
    );
  }
}
