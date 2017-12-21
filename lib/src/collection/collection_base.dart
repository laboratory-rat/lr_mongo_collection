import '../helper/helper_entity_activator.dart';
import '../interface/i_collection_base.dart';
import '../interface/i_entity_base.dart';
import 'dart:async';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:uuid/uuid.dart';

class CollectionBase<E extends IEntityBase> implements ICollectionBase<E> {
  Uuid uuid = new Uuid();
  Db db;
  DbCollection collection;

  CollectionBase(String connection) {
    db = new Db(connection);
  }

  Future<DbCollection> openConnection() async {
    if(db.state == State.OPEN && collection != null) return collection;

    await db.open();

    if (collection == null) {
      var reflected = HelperEntityActivator.activate(E);
      collection = db.collection((reflected as E).collectionName);
    }

    return collection;
  }

  Future closeConnection() async {
    await db.close();
  }

  // insert

  Future<E> insert(E target) async {
    target.id = uuid.v4();

    await openConnection();
    await collection.insert(target.toMap());
    await closeConnection();

    return target;
  }

  Future<List<E>> insertAll(List<E> targets) async {
    var list = new List<Map>();
    targets.forEach((x) {
      x.id = uuid.v4();
      list.add(x.toMap());
    });

    await openConnection();
    await collection.insertAll(list);
    await closeConnection();

    return targets;
  }

  // find

  Future<E> findById(String id) async {
    await openConnection();
    var entity = await collection.findOne(where.eq('id', id));
    await closeConnection();
    return parse(entity);
  }

  Future<List<E>> findWhere(SelectorBuilder selector) async {
    await openConnection();
    var response = await collection.find(selector).toList();
    await closeConnection();

    return response.map((x) => parse(x)).toList();
  }

  Future<List<E>> findAll() async {
    await openConnection();
    var response = await collection.find().toList();
    await closeConnection();

    return response.map((x) => parse(x)).toList();
  }

  // count

  Future<int> count() async {
    await openConnection();
    var count = await collection.count();
    await closeConnection();

    return count;
  }

  Future<int> countWhere(SelectorBuilder selector) async {
    await openConnection();
    var count = await collection.count(selector);
    await closeConnection();

    return count;
  }

  // update
  Future update(E entity) async {
    await openConnection();
    await collection.save(entity.toMap());
    await closeConnection();
  }

  // delete
  Future deleteById(String id) async {
    await openConnection();
    await collection.remove(where.eq('id', id));
    await closeConnection();
  }

  Future deleteWhere(SelectorBuilder selector) async {
    await openConnection();
    await collection.remove(selector);
    await closeConnection();
  }

  E parse(Map map) {
    var entity = HelperEntityActivator.activate(E);
    entity.fromMap(map);
    return entity;
  }
}