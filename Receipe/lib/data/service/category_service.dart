import 'package:flutter/foundation.dart';
import 'package:receipe/data/database.dart';

class CategoryService {
  Categories? getCategory(Stream<Categories> category){
    Categories? resultat;

  category.listen((donnees) {
  resultat = donnees;
  });
  return resultat;
}
}