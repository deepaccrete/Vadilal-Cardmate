import 'package:hive/hive.dart';
part 'imagemodel.g.dart';

@HiveType(typeId: 2)
class PendingImage extends HiveObject{

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String frontImage;

  @HiveField(2)
  final String? backPath;


  PendingImage({required this.id , required this.frontImage ,  this.backPath});

}