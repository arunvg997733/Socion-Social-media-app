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
    final pickimage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickimage != null) {
      image.value = pickimage.path;
    }
  }
}
