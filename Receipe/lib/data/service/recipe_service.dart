import 'package:drift/drift.dart';
import 'package:receipe/main.dart';

import '../database.dart';
import 'ingredientAsso_service.dart';

class RecipeService {

  IngredientAssoService ingredientAssoService = IngredientAssoService();
  Future<List<Recipe>> getAllRecipes() {
    return database.allRecipes;
  }

  Future<List<Recipe>> getRecipesByCategory(int idCat) {
    Future<Category> category = database.getCategory(idCat);
    Category? cat;
    category.then((value) => cat = value);
    return database.getRecipesByCategory(cat!);
  }

  Future<List<Recipe>> getRecipesBySeason(int idSeason) {
    Future<Season> season = database.getSeason(idSeason);
    Season? returnSeason;
    season.then((value) => returnSeason = value);
    return database.getRecipesBySeason(returnSeason!);
  }

  Future<int> addRecipeWithIngredients(String title, String description, int tempsPrep, List<IngredientReciping> ingredients,  int seasonId) async {
    RecipesCompanion recipe = RecipesCompanion.insert(title: title, description: description, tempsPrep: tempsPrep, season: seasonId);
    int recipeId = await database.addRecipe(recipe);

    for(IngredientReciping ing in ingredients){
      ingredientAssoService.addIngredientsAsso(recipeId, ing.ingredient.id, ing.quantity);
    }
    return recipeId;
  }

  Future<int> updateRecipeWithIngredients(Recipe recipe, List<IngredientReciping> ingredientsAsso) async {
    database.updateRecipe(recipe);
    for(IngredientReciping ing in ingredientsAsso){
      ingredientAssoService.updateIngredientAsso(recipe.id, ing.ingredient.id, ing.quantity);
    }
    return recipe.id;
  }
  Future<void> deleteRecipe(Recipe recipe) async {
    List<IngredientAsso>? ingredientsAssocies;
    database.findIngredientAssoByRecipeId(recipe.id).then((
        value) => ingredientsAssocies!);
    for (IngredientAsso ing in ingredientsAssocies!) {
      database.deleteIngredientAsso(ing.toCompanion(true));
    }
    database.deleteRecipe(recipe);
  }
}
