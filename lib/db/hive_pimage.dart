import 'package:camera_app/model/dbModel/imagemodel.dart';
import 'package:hive/hive.dart';

class HivePimage {
  static const String boxName = 'pending_images';

  static Future<Box<PendingImage>> _getBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<PendingImage>(boxName);
    } else {
      return await Hive.openBox<PendingImage>(boxName);
    }
  }

  static Future<void> savePendingImage(PendingImage image) async {
    final box = await _getBox();
    await box.put(image.id, image);
  }

  static Future<void> deletePendingImage(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }

  static Future<List<PendingImage>> getAllPendingImages() async {
    final box = await _getBox();
    return box.values.toList();
  }
}
