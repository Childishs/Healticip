import 'package:flutter/material.dart';
import 'package:receipe/data/service/recipe_service.dart';
import 'package:receipe/data/service/season_service.dart';
import 'package:receipe/ui/pages/recipeDetails.page.dart';
import 'package:receipe/ui/widgets/header.widget.dart';
import 'package:receipe/ui/widgets/receipe_resume.widget.dart';

import '../../data/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Recipe> filteredRecipeList = [];
  late List<Season> seasonList = [];

  RecipeService recipeService = RecipeService();
  SeasonService seasonService = SeasonService();

  Season? selectedSeason;

  @override
  void initState() {
    super.initState();
    loadSeasonsAndRecipes();
  }

  void loadSeasonsAndRecipes() async {
    final seasons = await seasonService.getAllSeasons();
    setState(() {
      seasonList = seasons;
    });
    Future.delayed(Duration.zero,() => recipeService.getAllRecipes().then((value) => filteredRecipeList= value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: HeaderWidget(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: seasonList.map((e) {
                    bool isSelected = e == selectedSeason;
                    return Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedSeason = isSelected ? null : e;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: isSelected
                              ? MaterialStateProperty.all<Color>(
                              seasonService.getColor(e))
                              : null,
                        ),
                        child: Text(e.title),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ) +
                    EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom,
                    ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.6,
                ),
                itemCount: filteredRecipeList.length,
                itemBuilder: (BuildContext context, int oneRecipe) {
                  final Recipe recipe = filteredRecipeList[oneRecipe];
                  return ReceipeResume(
                    recipe: recipe,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RecipeDetailsPage(recipe: recipe),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
