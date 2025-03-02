import 'package:image_picker/image_picker.dart';

Future<XFile?> pickImageFromGallery() async {
  final ImagePicker imagePicker = ImagePicker();
  final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
  return image;
}
