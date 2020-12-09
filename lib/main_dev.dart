
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

// void main() async {

//   // await start();

//   var configuredApp = AppConfig(
//     apiBaseUrl: 'http://192.168.8.100:3000/api',
//     child: await start(),
//   );

//   runApp(configuredApp);
// }

