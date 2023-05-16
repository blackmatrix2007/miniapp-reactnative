import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mp_flutter_runtime/mp_flutter_runtime.dart';
import 'package:mpflutter_flutter_template/ext/template_method_channel.dart';
import 'package:mpflutter_flutter_template/mp_config.dart';
import 'package:mpflutter_flutter_template/splash.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  extMain();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MPFlutter Template',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => MyFirstdPage(),
        'home': (context) => const MPFlutterContainerPage(),
        'radio': (context) => MyStatefulWidget(),
        'flutterdemo': (context) => FlutterDemo(storage: CounterStorage()),
      },
    );
  }
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    final d = await getExternalStorageDirectory();
    print(d);
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}

class FlutterDemo extends StatefulWidget {
  const FlutterDemo({Key? key, required this.storage}) : super(key: key);

  final CounterStorage storage;

  @override
  State<FlutterDemo> createState() => _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((value) {
      setState(() {
        _counter = value;
      });
    });
  }

  Future<File> _incrementCounter() {
    setState(() {
      _counter++;
    });

    // Write the variable as a string to the file.
    return widget.storage.writeCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Reading and Writing Files'),
      ),
      body: Stack(
        children: <Widget>[
          FractionallySizedBox(
            //heightFactor: 0.,
            //color: Colors.red,
            child: Container(
              color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    height: 200,
                    width: 300,
                    color: Colors.black,
                  ),
                  const Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(
                    height: 40,
                    child: TextField(
                        controller: TextEditingController(),
                        focusNode: FocusNode(),
                        style: TextStyle()),
                  ),
                  ElevatedButton(
                    onPressed: _incrementCounter,
                    child: const Text('Increment Counter'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedFile = await ImagePicker().getImage(
                        source: ImageSource.gallery,
                      );
                      if (pickedFile != null) {
                        final image = File(pickedFile.path);
                        // final result = await ImageEditor.editImage(
                        //   image: image,
                        // );
                        // print(result);
                      }
                    },
                    child: const Text('Edit Image'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MPFlutterContainerPage extends StatefulWidget {
  const MPFlutterContainerPage({Key? key}) : super(key: key);

  @override
  State<MPFlutterContainerPage> createState() => _MPFlutterContainerPageState();
}

class _MPFlutterContainerPageState extends State<MPFlutterContainerPage> {
  MPEngine? engine;

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initEngine();
  }

  void initEngine() async {
    if (engine == null) {
      final engine = MPEngine(
          flutterContext: context,
          packageId: "com.example.mpflutter_flutter_template");
      // showModalBottomSheet(context: context, builder: builder)
      if (MPConfig.dev) {
        engine.initWithDebuggerServerAddr('${MPConfig.devServer}:9898');
      } else {
        engine.initWithMpkData(
          // (await rootBundle.load('assets/app.mpk')).buffer.asUint8List(),
          (await rootBundle.load('assets/app.mpk')).buffer.asUint8List(),
        );
      }
      setState(() {
        this.engine = engine;
      });
      await Future.delayed(const Duration(milliseconds: 100));
      await engine.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (engine == null) return const Splash();
    return MPPage(
      engine: engine!,
      splash: const Splash(),
      mymessage: const {},
      viewId: 0,
    );
  }
}

class MyFirstdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: GestureDetector(
              onTap: () async {
                var s = await getTemporaryDirectory();

                print(s);
              },
              child: Container(
                width: 200,
                height: 50,
                color: Colors.pink,
                child: Opacity(
                  opacity: 0.3,
                  child: Center(
                    child: Text(
                      'copy image here image editor',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);
                var s = await getTemporaryDirectory();
                String dirPath = s.path + '/Albums/fff_001';
                Directory dir = Directory(dirPath);
                var exists = await dir.exists();
                print(exists);
                if (exists == false) {
                  await dir.create(recursive: true);
                }

                String img = dirPath + '/1680668300702.jpeg';
                // String imagePath = s.path +'/Albums/fff_001/'+'${DateTime.now().millisecondsSinceEpoch}.jpeg';
                // print(image!.path + " -> "+ imagePath);
                // var ss = await image!.saveTo(imagePath);
                var ss = await File(image!.path).copy(img);
                print(ss.path);

                //  /var/mobile/Containers/Data/Application/AFC14467-7328-4E2E-BFC2-D2A2CE8F5C45/Library/Caches/Albums/fff_001/1680625668257.jpeg

                //var result = await image?.readAsBytes();

                // final editedImage = await Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ImageEditor(
                //       image: result,
                //       allowCamera: true,
                //       allowGallery: false,
                //       allowMultiple: false,
                //     ),
                //   ),
                // );
              },
              child: Container(
                width: 200,
                height: 50,
                color: Colors.pink,
                child: Center(
                  child: Text(
                    'copy image here image editor',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);

                var result = await image?.readAsBytes();
                Stopwatch stopwatch = Stopwatch()..start();

                // final editedImage = await Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ImageEditor(
                //       image: result,
                //       allowCamera: true,
                //       allowGallery: false,
                //       allowMultiple: false,
                //     ),
                //   ),
                // );

                stopwatch.stop();
                print('time elapsed ${stopwatch.elapsed}');
              },
              child: Container(
                width: 200,
                height: 50,
                color: Colors.pink,
                child: Center(
                  child: Text(
                    'Tap here image editor',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                Navigator.of(context).pushNamed('home');
// final data = (await rootBundle.load(
//                         'assets/appITconer.mpk'))
//                     .buffer
//                     .asUint8List();
//                 Navigator.push(
//                   context,
//                     MaterialPageRoute<void>(
//                       builder: (context) => MPMiniPageDebug(
//                         initParams: {
//                           "refreshToken":"eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICI3M2Y2NzAwNC0yMzZlLTQ2OGMtOTcyYi1kNWFiMTg0OWViMTQifQ.eyJleHAiOjE2ODE5ODU0NDUsImlhdCI6MTY4MTk3ODI0NSwianRpIjoiMjFlNWIxYWYtYTlmMS00ZmQ0LTg2NTAtMjcwNTE4MjYxMDAwIiwiaXNzIjoiaHR0cHM6Ly9rZXljbG9hay1pbnRlcm5hbC11YXQubWJiYW5rLmNvbS52bi9hdXRoL3JlYWxtcy9pbnRlcm5hbCIsImF1ZCI6Imh0dHBzOi8va2V5Y2xvYWstaW50ZXJuYWwtdWF0Lm1iYmFuay5jb20udm4vYXV0aC9yZWFsbXMvaW50ZXJuYWwiLCJzdWIiOiIwNjA3MTA3OC02MDdlLTQ5YTgtYmM5Yy1jMDYzYjllMDY5NDciLCJ0eXAiOiJSZWZyZXNoIiwiYXpwIjoiaGNtLWZyb250ZW5kIiwic2Vzc2lvbl9zdGF0ZSI6ImYyZWJmMDlmLWQ2YWEtNDBiOC04MmM1LTA1ODkwODYxOWJjYSIsInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsInNpZCI6ImYyZWJmMDlmLWQ2YWEtNDBiOC04MmM1LTA1ODkwODYxOWJjYSJ9.tFeONOUMnFb9_mQalOmXFhUiia04BTKFCjicxBWajWs",
//                           "accessToken":"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJGaWVQekJZY1BhVkl5Q19nZWs5Zzdqc1ZWV2JYZExROUVQTHUxMm02RGx3In0.eyJleHAiOjE2ODE5ODAwNDUsImlhdCI6MTY4MTk3ODI0NSwianRpIjoiZDI3ZjQxZjgtZWE0Yy00ZjUzLTkzNzctYmU3ZDY5NmI3OGUzIiwiaXNzIjoiaHR0cHM6Ly9rZXljbG9hay1pbnRlcm5hbC11YXQubWJiYW5rLmNvbS52bi9hdXRoL3JlYWxtcy9pbnRlcm5hbCIsImF1ZCI6WyJoY20tc2VydmljZV9iayIsImhjbS1zZXJ2aWNlIiwicmVhbG0tbWFuYWdlbWVudCIsImhjbS1zZXJ2aWNlLXVhdC0xIiwiY3JtLWZyb250ZW5kIiwic2FsZS1zZXJ2aWNlIiwicG1oLXNlcnZpY2UiLCJwYW1zLXNlcnZpY2UtdjEiLCJoY20tc2VydmljZS11YXQiLCJhY2NvdW50IiwibXltYi1zZXJ2aWNlLXYxIl0sInN1YiI6IjA2MDcxMDc4LTYwN2UtNDlhOC1iYzljLWMwNjNiOWUwNjk0NyIsInR5cCI6IkJlYXJlciIsImF6cCI6ImhjbS1mcm9udGVuZCIsInNlc3Npb25fc3RhdGUiOiJmMmViZjA5Zi1kNmFhLTQwYjgtODJjNS0wNTg5MDg2MTliY2EiLCJhY3IiOiIxIiwiYWxsb3dlZC1vcmlnaW5zIjpbIioiXSwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbIm9mZmxpbmVfYWNjZXNzIiwiZGVmYXVsdC1yb2xlcy1jcm0iLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImhjbS1zZXJ2aWNlX2JrIjp7InJvbGVzIjpbIkhDTS1NQkVSIiwiSENNLUVORF9VU0VSX1JFUE9SVCJdfSwiaGNtLXNlcnZpY2UiOnsicm9sZXMiOlsiSENNLU5HSElfQ0hBTUNPTkdfUkVQT1JUIiwiSENNLU1CRVIiLCJIQ00tQURNX05PVElGWV9URU1QTEFURSIsIkhDTS0wMF9CSUVVTUFVIiwiSENNLUVORF9VU0VSX1JFUE9SVCIsIkhDTS1BRE1JTiJdfSwicmVhbG0tbWFuYWdlbWVudCI6eyJyb2xlcyI6WyJ2aWV3LWlkZW50aXR5LXByb3ZpZGVycyIsInZpZXctcmVhbG0iLCJtYW5hZ2UtaWRlbnRpdHktcHJvdmlkZXJzIiwiaW1wZXJzb25hdGlvbiIsInJlYWxtLWFkbWluIiwiY3JlYXRlLWNsaWVudCIsIm1hbmFnZS11c2VycyIsInF1ZXJ5LXJlYWxtcyIsInZpZXctYXV0aG9yaXphdGlvbiIsInF1ZXJ5LWNsaWVudHMiLCJxdWVyeS11c2VycyIsIm1hbmFnZS1ldmVudHMiLCJtYW5hZ2UtcmVhbG0iLCJ2aWV3LWV2ZW50cyIsInZpZXctdXNlcnMiLCJ2aWV3LWNsaWVudHMiLCJtYW5hZ2UtYXV0aG9yaXphdGlvbiIsIm1hbmFnZS1jbGllbnRzIiwicXVlcnktZ3JvdXBzIl19LCJoY20tc2VydmljZS11YXQtMSI6eyJyb2xlcyI6WyJIQ00tTkdISV9DSEFNQ09OR19SRVBPUlQiLCJIQ00tTUJFUiIsIkhDTS1BRE1fTk9USUZZX1RFTVBMQVRFIiwiSENNLTAwX0JJRVVNQVUiLCJIQ00tRU5EX1VTRVJfUkVQT1JUIiwiSENNLUFETUlOIl19LCJjcm0tZnJvbnRlbmQiOnsicm9sZXMiOlsidW1hX3Byb3RlY3Rpb24iLCJtYW5hZ2UtYXV0aG9yaXphdGlvbiIsInZpZXctYXV0aG9yaXphdGlvbiJdfSwic2FsZS1zZXJ2aWNlIjp7InJvbGVzIjpbInVtYV9wcm90ZWN0aW9uIl19LCJwbWgtc2VydmljZSI6eyJyb2xlcyI6WyJQTUhfTUJFUiJdfSwicGFtcy1zZXJ2aWNlLXYxIjp7InJvbGVzIjpbIlBBTVMtTUJFUiJdfSwiaGNtLXNlcnZpY2UtdWF0Ijp7InJvbGVzIjpbIkhDTS1OR0hJX0NIQU1DT05HX1JFUE9SVCIsIkhDTS0wMDEiLCJIQ00tTUJFUiIsIkhDTS1BRE1fTk9USUZZX1RFTVBMQVRFIiwiSENNLUVORF9VU0VSX1JFUE9SVCIsIkhDTS0wMF9CSUVVTUFVIiwiSENNLUFETUlOIl19LCJhY2NvdW50Ijp7InJvbGVzIjpbIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19LCJteW1iLXNlcnZpY2UtdjEiOnsicm9sZXMiOlsiTVktTUItTUJFUiIsIk1ZLU1CLUFETS1DTVMiXX19LCJzY29wZSI6InByb2ZpbGUgZW1haWwiLCJzaWQiOiJmMmViZjA5Zi1kNmFhLTQwYjgtODJjNS0wNTg5MDg2MTliY2EiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsIm5hbWUiOiJxdXllbm10Lm9zIiwicHJlZmVycmVkX3VzZXJuYW1lIjoicXV5ZW5tdF90ZXN0IiwiZ2l2ZW5fbmFtZSI6InF1eWVubXQub3MiLCJlbWFpbCI6InF1eWVubXQub3NAbWJiYW5rLmNvbS52biJ9.jrduZPpOHiiRi5d5xzJ1jZrBwejyitcfTL22nun12iSU-rNHd6ULUchF6TZXOERWmxCVduTl_g2jcajEXr9vOeT0Zh1H9dP4I-Olqmy91BYo60SHuWHwKSGH_QB18Gto0Duljl3ALXT19EfDwQNzmcrhacBqzFGzCiNTJ1rGMFygbswmGdEZNOx060s5KgNMpmAWps1y1GnklbgO4se_OGKlvhQ68iwsjvJDVCvGyHysduMAiiVSlgUEHo2gktiEcjnNeV-0r6_oqXPBS61b-mzkn9ds9iLQbdSaUEWiW4KuqW-u0d7wRRzAsC8zxW9koK0lVNO6qFSmozN-my6wTA"
//                         },
//                         mpk: data,
//                               dev: false,
//                               ip: MPConfig.devServer,
//                       ),
//                     ),
//
//                 );
              },
              child: Container(
                width: 200,
                height: 200,
                color: Colors.pink,
                child: Center(
                  child: Text(
                    'Tap here',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                Navigator.of(context).pushNamed('radio');
              },
              child: Container(
                width: 200,
                height: 200,
                color: Colors.pink,
                child: Center(
                  child: Text(
                    'Tap here radio ',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('flutterdemo');
              },
              child: Container(
                width: 200,
                height: 200,
                color: Colors.pink,
                child: Center(
                  child: Text(
                    'flutterdemo Tap here storage',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum BestTutorSite { cafedev, w3schools, tutorialandexample, javatpoint }

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key? key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  BestTutorSite? _site = BestTutorSite.javatpoint;

  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: <Widget>[
          ListTile(
            title: const Text('www.cafedev.vn'),
            leading: Radio(
              value: BestTutorSite.javatpoint,
              groupValue: _site,
              onChanged: (BestTutorSite? value) {
                setState(() {
                  _site = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('www.w3school.com'),
            leading: Radio(
              value: BestTutorSite.w3schools,
              groupValue: _site,
              onChanged: (BestTutorSite? value) {
                setState(() {
                  _site = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('www.tutorialandexample.com'),
            leading: Transform.scale(
              scale: 2.0,
              child: Radio(
                value: BestTutorSite.tutorialandexample,
                groupValue: _site,
                onChanged: (BestTutorSite? value) {
                  setState(() {
                    _site = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
