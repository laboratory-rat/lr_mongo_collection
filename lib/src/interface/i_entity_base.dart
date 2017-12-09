import 'i_entity_serializable.dart';
import 'package:mongo_dart/mongo_dart.dart';

abstract class IEntityBase implements IEntitySerializable{
    ObjectId id;
    String get clearId;

    String get collectionName;
}