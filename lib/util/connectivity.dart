// // @action
// checkInternetConnection(navigatorKey) {
//
//   final Connectivity _connectivity = Connectivity();
//   late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
//   Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
//     connectionStatus = result;
//     // ignore: avoid_print
//     if (connectionStatus[0] != ConnectivityResult.wifi ) {
//       navigatorKey.currentState?.pushNamed('/errorScreen');
//       isDisconnected=true;
//       // Navigator.push(context, MaterialPageRoute(builder: (context) => NotConnectedErrorScreen(),));
//     } else if (connectionStatus[0] == ConnectivityResult.wifi && isDisconnected == true) {
//       final isActive = await isHttpServerActive();
//       Logger.log("this is the isAcitve --- ${isActive}");
//       if(isActive){
//         if(loginCredentials != null){
//           navigatorKey.currentState?.pop();
//           //navigatorKey.currentState?.pushNamedAndRemoveUntil('/homeScreen',(Route<dynamic> route) => false,);
//         }
//         else{
//           navigatorKey.currentState?.pushNamedAndRemoveUntil('/loginScreen',(Route<dynamic> route) => false,);
//         }
//       }
//       isDisconnected=false;
//     }
//
//     Logger.log('Connectivity changed: $connectionStatus');
//   }
//
//   _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
//   Future<void> initConnectivity() async {
//     late List<ConnectivityResult> result;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       result = await _connectivity.checkConnectivity();
//     } on PlatformException catch (e) {
//       developer.log('Couldn\'t check connectivity status', error: e);
//       return;
//     }
//     // if (!mounted) {
//     //   return Future.value(null);
//     // }
//
//     return _updateConnectionStatus(result);
//   }
//   initConnectivity();
// }
//