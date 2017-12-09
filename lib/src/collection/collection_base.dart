import '../helper/helper_entity_activator.dart';
import '../interface/i_collection_base.dart';
import '../interface/i_entity_base.dart';
import 'dart:async';

import 'package:mongo_dart/mongo_dart.dart';


class CollectionBase<E extends IEntityBase> implements ICollectionBase<E> {
  Db db;
  DbCollection collection;

  CollectionBase(String connection) {
    db = new Db(connection);
  }

  @override
  Future<DbCollection> openConnection() async {
    if(db.state == State.OPEN && collection != null) return collection;

    await db.open();

    if (collection == null) {
      var reflected = HelperEntityActivator.activate(E);
      collection = db.collection((reflected as E).collectionName);
    }

    return collection;
  }

  @override
  Future closeConnection() async {
    await db.close();
  }

  // insert

  @override
  Future<E> insert(E target) async {
    target.id = new ObjectId();

    await openConnection();
    await collection.insert(target.toMap());
    await closeConnection();

    return target;
  }

  @override
  Future<List<E>> insertAll(List<E> targets) async {
    var list = new List<Map>();
    targets.forEach((x) {
      x.id = new ObjectId();
      list.add(x.toMap());
    });

    await openConnection();
    await collection.insertAll(list);
    await closeConnection();

    return targets;
  }

  // find

  @override
  Future<E> findById(String id) async {
    await openConnection();
    var entity = await collection.findOne(where.id(ObjectId.parse(id)));
    await closeConnection();
    return parse(entity);
  }

  @override
  Future<List<E>> findWhere(SelectorBuilder selector) async {
    await openConnection();
    var response = await collection.find(selector).toList();
    await closeConnection();

    return response.map((x) => parse(x)).toList();
  }

  @override
  Future<List<E>> findAll() async {
    await openConnection();
    var response = await collection.find().toList();
    await closeConnection();

    return response.map((x) => parse(x)).toList();
  }

  // count

  @override
  Future<int> count() async {
    await openConnection();
    var count = await collection.count();
    await closeConnection();

    return count;
  }

  @override
  Future<int> countWhere(SelectorBuilder selector) async {
    await openConnection();
    var count = await collection.count(selector);
    await closeConnection();

    return count;
  }

  // update
  @override
  Future update(E entity) async {
    await openConnection();
    await collection.save(entity.toMap());
    await closeConnection();
  }

  // delete
  @override
  Future deleteById(String id) async {
    await openConnection();
    await collection.remove(where.id(ObjectId.parse(id)));
    await closeConnection();
  }

  @override
  Future deleteWhere(SelectorBuilder selector) async {
    await openConnection();
    await collection.remove(selector);
    await closeConnection();
  }

  @override
  E parse(Map map) {
    var entity = HelperEntityActivator.activate(E);
    entity.fromMap(map);
    return entity;
  }
}