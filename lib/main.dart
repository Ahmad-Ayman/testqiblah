import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smooth_compass_plus/utils/src/compass_ui.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:location/location.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

          child: SmoothCompassWidget(
            loadingAnimation: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/fullbackground.png'),
                    fit: BoxFit.cover),
              ),
              child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(),
                  )),
            ),
            errorLocationServiceWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'خدمة تحديد المواقع غير مفعلة',

                ),
                SizedBox(height: 16,),

                ElevatedButton(
                    onPressed: () async {
                      Location loc = Location();
                      await loc.requestService().then((bool value) {
                        if (value) {
                          setState(() {});
                        }
                      });
                    },
                    child: Text('تفعيل الخدمة'))
              ],
            ),
            errorLocationPermissionWidget: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    Platform.isAndroid
                        ? 'من فضلك قم بقبول طلب الوصول لموقعك الحالي لتستطيع '
                        'الوصول لاتجاه القبلة'
                        : 'من فضلك اسمح '
                        'للتطبيق بالوصول لخدمة تحديد الموقع من '
                        'الاعدادات الخاصة بجهازك',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16,),
                  ElevatedButton(
                      onPressed: () async {
                        Location loc = Location();
                        if (Platform.isIOS) {
                          await perm.openAppSettings().then((bool value) {
                            if (value) {
                              setState(() {});
                            }
                          });
                        } else {
                          await loc.requestPermission().then((
                              PermissionStatus value) {
                            if (value == PermissionStatus.granted ||
                                value == PermissionStatus.grantedLimited) {
                              setState(() {});
                            }
                          });
                        }
                      },
                      child: Text('تفعيل الخدمة'))
                ],
              ),
            ),
            rotationSpeed: 400,
            height: 500,
            isQiblahCompass: true,
            width: 500,
            compassBuilder: (BuildContext context,
                AsyncSnapshot<CompassModel>? compassData, Widget compassAsset) {
              if (compassData?.data == null) {
                return Center(
                  child: Text('Error: Unable to get compass data'),
                );
              }
              return SizedBox(
                height:450,
                width: 450,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: compassData!.data!.qiblahOffset.toInt() ==
                                compassData.data!.angle.toInt()
                                ? Image.asset('assets/images/kaabafixed.png')
                                : Image.asset('assets/images/qiblahright.png'),
                          ),
                          //put your qiblah needle here
                          Positioned(
                            top: 20,
                            left: 0,
                            right: 0,
                            bottom: 20,
                            child: AnimatedRotation(
                              turns: compassData.data?.turns ?? 0 / 360,
                              duration: const Duration(milliseconds: 400),
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    top: 20,
                                    bottom: 20,
                                    left: 0,
                                    right: 0,
                                    child: AnimatedRotation(
                                        turns: (compassData.data!
                                            .qiblahOffset ?? 0) /
                                            360,
                                        duration: const Duration(
                                            milliseconds: 400),
                                        child: Image.asset(
                                            'assets/images/neeedle.png')),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    SizedBox(height: 16,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 80),
                      child: Text(
                        compassData.data!.qiblahOffset.toInt() ==
                            compassData.data!.angle.toInt()
                            ? '''أنت الآن في إتجاه القِبلة..
ليتقبل الله منك'''
                            : ''' قم بتدوير الهاتف حتى تصبح الكعبة في المنتصف''',

                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

      ),

    );
  }
}
