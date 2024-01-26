import 'package:receipe/data/database.dart';
import 'package:flutter/material.dart';
import 'package:receipe/ui/pages/add_recipe.page.dart';
import 'package:receipe/ui/pages/update_recipe.page.dart';

class RecipeHeaderWidget extends StatelessWidget {
  const RecipeHeaderWidget({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) => SliverAppBar(
        toolbarHeight: 45,
        leadingWidth: 80,
        leading: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: Colors.black.withOpacity(0.25),
          ),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => UpdateRecipe(recipe: recipe),
                ),
              );
            },
            icon: const Icon(
              Icons.edit,
            ),
            iconSize: 33,
            color: Colors.white,
          ),
          const SizedBox(width: 20),
        ],
        expandedHeight: 250,
        backgroundColor: Colors.greenAccent,
        flexibleSpace: FlexibleSpaceBar(
          background: Padding(
            padding: const EdgeInsets.all(50),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(50),
              ),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
