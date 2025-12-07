import 'package:firebase_core/firebase_core.dart';


class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'API_KEY_HERE',
      appId: 'APP_ID_HERE',
      messagingSenderId: 'SENDER_ID_HERE',
      projectId: 'PROJECT_ID_HERE',
    );
  }
}
