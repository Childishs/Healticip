import 'dart:ui';

import 'package:flutter/material.dart';

import '../../main.dart';
import '../database.dart';

class SeasonService{

  Future<List<Season>> getAllSeasons(){
    return database.initializeSeasons();
  }

  Future<Season> getById(int id){
    return database.getSeason(id);
  }

  Future<Season> getByRecipe(int recipeId){
    return database.findSeasonByRecipe(recipeId);
  }
  Color getColor(Season season) {
    switch (season.title) {
      case 'Winter' :
        return const Color(0x460091D4);
      case 'Autumn':
        return const Color(0x8CFF8F00);
      case 'Spring':
        return const Color(0xBBF48FB1);
      case 'Summer':
        return const Color(0xA3B2FF59);
      default:
        return Colors.grey;
    }
  }

}