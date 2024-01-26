import 'package:flutter/material.dart';
import 'package:receipe/data/database.dart';
import 'package:receipe/data/service/ingredientAsso_service.dart';
import 'package:receipe/ui/widgets/recipe_header.widget.dart';
import 'package:receipe/ui/widgets/season_bubble.widget.dart';
import '../../data/service/recipe_service.dart';
import '../../data/service/season_service.dart';

class RecipeDetailsPage extends StatefulWidget {
  final Recipe recipe;
  RecipeDetailsPage({Key? key, required this.recipe}) : super(key: key);

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  IngredientAssoService ingredientAssoService = IngredientAssoService();
  RecipeService recipeService = RecipeService();
  SeasonService seasonService = SeasonService();
  late List<IngredientReciping> listIngredientAsso =[];
  late Season season;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      seasonService.getById(widget.recipe.id).then((value) {
        setState(() {
          season = value;
        });
      });
      ingredientAssoService.findAllIngredientReciping(widget.recipe.id)
          .then((value) {
        setState(() {
          listIngredientAsso = value;
        });
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          RecipeHeaderWidget(
            recipe: widget.recipe,
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          widget.recipe.title,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          widget.recipe.description,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                 const SizedBox(height : 10),
                 Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: SeasonBubble(
                      season: season,
                      isSelected: true,
                      scale: 1.3,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Text(
                        'Duration:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${widget.recipe.tempsPrep} minutes',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: listIngredientAsso.length,
                          itemBuilder: (context, index) {
                            IngredientReciping ingredientReciping = listIngredientAsso[index];
                            return ListTile(
                              title: Text(ingredientReciping.ingredient.title),
                              subtitle: Text('Quantity: ${ingredientReciping.quantity}'),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

    );
  }
}
