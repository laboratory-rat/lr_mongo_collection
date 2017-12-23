import 'i_entity_serializable.dart';

abstract class IEntityBase implements IEntitySerializable{
    String id;
    String get collectionName;
}