import 'dart:async';

import 'i_entity_base.dart';
import 'package:mongo_dart/mongo_dart.dart';

abstract class ICollectionBase<E extends IEntityBase> {
  ICollectionBase(String connection);

  Future<DbCollection> openConnection();
  Future closeConnection();

  Future<E> insert(E target);

  Future<List<E>> insertAll(List<E> targets);

  // find

  Future<E> findById(String id);

  Future<List<E>> findWhere(SelectorBuilder selector);

  Future<List<E>> findAll();

  // count

  Future<int> count();

  Future<int> countWhere(SelectorBuilder selector);

  // update
  Future update(E entity);

  // delete
  Future deleteById(String id);

  Future deleteWhere(SelectorBuilder selector);

  E parse(Map map);
}