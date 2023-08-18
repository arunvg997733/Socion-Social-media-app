import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePickController extends GetxController {
  var image = ''.obs;

  pickGalleryImage() async {
    final pickimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickimage != null) {
      image.value = pickimage.path;
    }
  }

  pickCameraImage() async {
    final pickimage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickimage != null) {
      image.value = pickimage.path;
    }
  }

  Future<String> uploadimage() async {
    String imagelink = '';
    String uniquno = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = referenceRoot.child('userdata');
    Reference referenceImageToUpload = referenceDirImage.child(uniquno);
    try {
      UploadTask uploadTask = referenceImageToUpload.putFile(File(image.value));
      TaskSnapshot snapshot = await uploadTask;
      imagelink = await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('print error = $e');
    }

    return imagelink;
  }
}
