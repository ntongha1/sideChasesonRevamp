import 'package:file_picker/file_picker.dart';

Future<PlatformFile?> appFilePicker(List<String> exts) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: exts,
    allowMultiple: false,
  );
  if(result==null)return null;

  return result.files.single;
}
