import 'package:firebase_storage/firebase_storage.dart';
import 'package:hoard/Services/firebase/auth.dart';

Future<String> getAndUploadProfileImage(var tempImage) async {
  final uid = AuthService().getCurrentUser().uid;
  try {
    final Reference firebaseStorageReference =
        FirebaseStorage.instance.ref().child('profilepics/$uid.jpg');
    UploadTask task = firebaseStorageReference.putFile(tempImage);
    TaskSnapshot snapshot = await task;
    String url = await snapshot.ref.getDownloadURL();
    return url;
  } catch (error) {
    print(error);
    throw error.toString();
  }
}
