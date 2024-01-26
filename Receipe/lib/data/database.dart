import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:receipe/main.dart';

import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

class Recipes extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 4, max: 55)();

  TextColumn get description => text().named('description')();

  IntColumn get tempsPrep => integer().named('tempsPrep')();

  IntColumn get category =>
      integer().nullable().references(Categories, #id)();

  IntColumn get season =>
      integer().references(Seasons, #id)();
}

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();
}

@DataClassName('IngredientAsso')
class IngredientsAssos extends Table {
  @override
  List<Set<Column>> get uniqueKeys => [
        {recipe, ingredient},
        {recipe, amount}
      ];

  IntColumn get recipe => integer().references(Recipes, #id)();

  IntColumn get ingredient => integer().references(Ingredients, #id)();

  IntColumn get amount => integer().named('amount')();
}

@DataClassName('Ingredient')
class Ingredients extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 4, max: 55)();
}

@DataClassName('Season')
class Seasons extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 4, max: 55)();
}

@DriftDatabase(
    tables: [Recipes, Ingredients, IngredientsAssos, Categories, Seasons])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Recipe>> get allRecipes => select(recipes).get();

  Future<List<Category>> get allCategories => select(categories).get();

  Future<List<Recipe>> getRecipesByCategory(Category c) async {
    final query = (await (database.select(recipes).join(
            [innerJoin(categories, categories.id.equalsExp(recipes.category))])
          ..where(recipes.category.equals(c.id)))
        .get());

    return query.map((e) {
      final recipe = e.readTable(recipes);

      return Recipe(
          id: recipe.id,
          title: recipe.title,
          description: recipe.description,
          category: recipe.category,
          season: recipe.season,
          tempsPrep: recipe.tempsPrep);
    }).toList();
  }

  Future<List<Recipe>> getRecipesBySeason(Season s) async {
    final query = (await (database
            .select(recipes)
            .join([innerJoin(seasons, seasons.id.equalsExp(recipes.season))])
          ..where(recipes.season.equals(s.id)))
        .get());

    return query.map((e) {
      final recipe = e.readTable(recipes);

      return Recipe(
          id: recipe.id,
          title: recipe.title,
          description: recipe.description,
          category: recipe.category,
          season: recipe.season,
          tempsPrep: recipe.tempsPrep);
    }).toList();
  }

  Future<Recipe> getRecipe(int id) {
    return (select(recipes)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<Category> getCategory(int id) {
    return (select(categories)..where((cat) => categories.id.equals(id)))
        .getSingle();
  }

  Future<Season> getSeason(int id) {
    return (select(seasons)..where((seasons) => seasons.id.equals(id)))
        .getSingle();
  }

  Future<int> addRecipe(RecipesCompanion recipe) {
    return into(recipes).insert(recipe);
  }

  Future<Ingredient> findIngredient(int id) {
    return (select(ingredients)
          ..where((ingredient) => ingredient.id.equals(id)))
        .getSingle();
  }

  Future<void> updateRecipe(Recipe recipe) {
    return update(recipes).replace(recipe);
  }

  Future<void> updateIngredientAsso(IngredientAsso ingredient) {
    return update(ingredientsAssos).replace(ingredient);
  }

  Future deleteRecipe(Recipe recipe) {
    return delete(recipes).delete(recipe);
  }

  Future<List<IngredientAsso>> findIngredientAssoByRecipeId(
      int recipeId) async {
    final query = await (database.select(ingredientsAssos).join([
      innerJoin(
          ingredients, ingredients.id.equalsExp(ingredientsAssos.ingredient))
    ])
          ..where(ingredientsAssos.recipe.equals(recipeId)))
        .get();
    return query.map((e) {
      final recipe = e.readTable(recipes);
      final ingredient = e.readTable(ingredients);
      final recipeIngredient = e.readTable(ingredientsAssos);

      return IngredientAsso(
          recipe: recipe.id,
          ingredient: ingredient.id,
          amount: recipeIngredient.amount);
    }).toList();
  }

  Future<Season> findSeasonByRecipe(int recipeId) async {
    final query = await (database
            .select(seasons)
            .join([innerJoin(recipes, seasons.id.equalsExp(recipes.season))])
          ..where(recipes.id.equals(recipeId)))
        .getSingle();

    final season = query.readTable(seasons);
    return Season(id: season.id, title: season.title);
  }

  Future<int> addIngredient(String name) async {
    final id = await into(ingredients)
        .insert(IngredientsCompanion.insert(title: name));
    return id;
  }

  Future<int> addIngredientAsso(IngredientAsso ingredientAsso) async {
    return into(ingredientsAssos).insert(ingredientAsso);
  }

  Future<void> deleteIngredientAsso(
      IngredientsAssosCompanion ingredient) async {
    delete(ingredientsAssos).delete(ingredient);
  }

  Future deleteCategory(Category category) {
    return delete(categories).delete(category);
  }

  Future<int> addCategory(Category category) {
    return into(categories).insert(category);
  }

  Future<List<Season>> initializeSeasons() async {
    var existingSeasons = await select(seasons).get();
    if (existingSeasons.isEmpty) {
      await into(seasons).insert(Season(id: 1, title: "Winter"));
      await into(seasons).insert(Season(id: 2, title: "Autumn"));
      await into(seasons).insert(Season(id: 3, title: "Summer"));
      await into(seasons).insert(Season(id: 4, title: "Spring"));
    }
    return existingSeasons = await select(seasons).get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    final cachebase = (await getTemporaryDirectory()).path;

    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
