import 'package:drift/drift.dart';
import 'package:receipe/data/database.dart';

import '../../main.dart';

class IngredientAssoService {
  Future<List<IngredientAsso>> getAllIngredientsByRecipe(int recipeId) {
    return database.findIngredientAssoByRecipeId(recipeId);
  }

  Future<int> addIngredient(String name) {
    return database.addIngredient(name);
  }

  Future<List<IngredientReciping>> findAllIngredientReciping(
      int recipeId) async {
    final query = await (database.select(database.ingredientsAssos).join([
      innerJoin(
          database.ingredients,
          database.ingredients.id
              .equalsExp(database.ingredientsAssos.ingredient))
    ])
          ..where(database.ingredientsAssos.recipe.equals(recipeId)))
        .get();

    return query.map((mapper) {
      final ingredientAsso = mapper.readTable(database.ingredientsAssos);
      final ingredient = mapper.readTable(database.ingredients);
      return IngredientReciping(ingredient, ingredientAsso.amount);
    }).toList();
  }

  Future<Ingredient> findIngredient(int id) {
    return database.findIngredient(id);
  }

  Future<int> addIngredientsAsso(int recipeId, int ingredientId, int amount) {
    IngredientAsso ingredientAsso = IngredientAsso(
        recipe: recipeId, ingredient: ingredientId, amount: amount);
    return database.addIngredientAsso(ingredientAsso);
  }

  Future<void> updateIngredientAsso(
      int recipeId, int ingredientId, int amount) async {
    IngredientAsso ingredientAsso = await IngredientAsso(
        recipe: recipeId, ingredient: ingredientId, amount: amount);
    database.updateIngredientAsso(ingredientAsso);
  }
}

class IngredientReciping {
  late Ingredient ingredient;
  late int quantity;

  IngredientReciping(Ingredient ingredient, int quantity) {
    this.ingredient = ingredient;
    this.quantity = quantity;
  }
}
