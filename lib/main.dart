import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guitou/app.dart';
import 'package:guitou/bloc/blocs.dart';


void main() {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(BlocProvider(
    create: (BuildContext context) => DataCollectedBloc()..add(DataCollectedLoad()),
    // lazy: false,
    child: GuitouApp(),
  ));
}

// Future<bool> requestWritePermission() async {
//   final List<PermissionGroup> permissions = <PermissionGroup>[PermissionGroup.storage];

//   final PermissionStatus statusFuture = await PermissionHandler()
//       .checkPermissionStatus(PermissionGroup.storage); 
  
//   if (statusFuture == PermissionStatus.granted) {
//     return true;
//   } else {
//     final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
//       await PermissionHandler().requestPermissions(permissions);

//     return permissionRequestResult[PermissionGroup.storage] == PermissionStatus.granted;
//   }

// }

// Future<String> _loadProjectAsset() async {
//   return await rootBundle.loadString('assets/project.json');
// }

// Future<Project> loadProject() async {
//   String jsonString = await _loadProjectAsset();
//   final jsonResponse = json.decode(jsonString);
//   return new Project.fromJson(jsonResponse);
// }  

// Future<Widget> start() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   bool permissionGranted = await requestWritePermission();
//   if (!permissionGranted) {
//     return null;
//   }

//   await loadProject();
//   debugPrint("\nLOAD PROJECT...\n");
//   debugPrint(json.encode(Project.instance.xormsDetails));
//   debugPrint("\nCHECK IT");

//   final directory = await getApplicationDocumentsDirectory();
//   final file = File("${directory.path}/${Project.instance.id}.json");

//   if (await file.exists()) {
//     final contents = await file.readAsString();
//     final parsedJson = json.decode(contents);

//     Project.object = Project.fromJson(parsedJson);
//   } else {
//     await file.writeAsString(json.encode(Project.instance.toJson()));
//   }

//   return Future<Widget>.delayed(
//     new Duration(
//       seconds: 2
//     ), () => GuitouApp()
//   );
// }
