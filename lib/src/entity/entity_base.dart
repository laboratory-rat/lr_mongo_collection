import '../annotation/collection_options.dart';
import '../interface/i_entity_base.dart';
import 'dart:mirrors';

import 'package:bson/bson.dart';

@CollectionOptions('null')
class EntityBase implements IEntityBase{
    EntityBase();

    ObjectId id;
    String get clearId => id == null ? "" : id.id.toString();

    DateTime createdTime = new DateTime.now().toUtc();
    DateTime updatedTime;

    String _collectionName = '';
    String get collectionName {
        if(_collectionName.trim() != ''){
            return _collectionName;
        }

        ClassMirror mirror = reflectClass(this.runtimeType);
        List<InstanceMirror> metadata = mirror.metadata;

        var collectionAnnotation = metadata.first.reflectee;
        if(collectionAnnotation != null){
            _collectionName = (collectionAnnotation as CollectionOptions).collection;
        }

        return _collectionName;
    }

    @override
    Map toMap() {
        Map m = new Map();

        m['_id'] = id;
        m['createdTime'] = createdTime;
        m['updatedTime'] = updatedTime;

        return m;
    }
    
    @override
    void fromMap(Map m){
        id = m['_id'];
        createdTime = m['createdTime'];
        updatedTime = m['updatedTime'];
    }
}


