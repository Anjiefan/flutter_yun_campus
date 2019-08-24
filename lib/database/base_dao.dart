import 'dart:async';
import 'dart:core';
abstract class BaseDAO<B, T>{
  insert(T model);
  insertAll(List<T> modelList);
  deleteById(int id);
  update(T model);
  updateAll(List<T> modelList);
  Future<T> getById(int id);
  Future<List<T>> getAll(Map map);
  T convertBeanToModel(B bean);
  List<T> convertBeanToModelAll(List<B> beanList);
  B convertModelToBean(T model);
  List<B> convertModelToBeanAll(List<T> modelList);
}