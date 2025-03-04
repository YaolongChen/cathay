import 'package:image_picker/image_picker.dart';

class ImageFileDataSource {
  ImageFileDataSource({required ImagePicker imagePicker})
    : _imagePicker = imagePicker;

  final ImagePicker _imagePicker;

  Future<Uri?> getSingleImageFromGallery() async {
    final xFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      return Uri.file(xFile.path);
    }
    return null;
  }
}
