import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:html';

/// Will open a file selector to upload an image
///
/// [onSelected] is the function to execute when a file is selected
void uploadImage({required Function(File file) onSelected}) {
  // a file selector that only accepts images
  final uploadInput = FileUploadInputElement()..accept = 'image/*';
  uploadInput.click();

  uploadInput.onChange.listen((event) {
    final file = uploadInput.files?.first; // file selected
    final reader = FileReader();
    reader.readAsDataUrl(file!);
    reader.onLoadEnd.listen((event) {
      onSelected(file);
    });
  });
}

/// Uploads an image on Firestore Storage
///
/// returns the name of the image
String uploadToStorage() {
  String filename = "";
  uploadImage(onSelected: (file) {
    // What to do when a file is selected
    filename = basename(file.name);
    FirebaseStorage.instance
        .refFromURL('gs://hongym-4cb68.appspot.com') // Storage URL
        .child("img/exercises/$filename") // Where the image will be stored
        .putBlob(file); // Puts the image on the storage
  });
  return filename;
}
