import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:receipe/data/service/ingredientAsso_service.dart';
import 'package:receipe/data/service/recipe_service.dart';
import 'package:receipe/ui/pages/home.page.dart';

import '../../data/database.dart';
import '../../data/service/season_service.dart';
import '../widgets/add_ingredient.widget.dart';

class UpdateRecipe extends StatefulWidget {
  const UpdateRecipe({Key? key, required this.recipe}) : super(key: key);

  final Recipe recipe;

  @override
  State<UpdateRecipe> createState() => _UpdateRecipePageState();
}

class _UpdateRecipePageState extends State<UpdateRecipe> {
  @override
  void initState() {
    super.initState();
    initializeForm();
  }

  final _formKey = GlobalKey<FormState>();
  late Season season;
  SeasonService seasonService = SeasonService();
  final RecipeService recipeService = RecipeService();
  final IngredientAssoService ingredientService = IngredientAssoService();
  List<IngredientReciping> ingredients = [];
  List<Season> seasonList = [];

  final TextEditingController titleInputController = TextEditingController();
  final TextEditingController durationInputController = TextEditingController();
  final TextEditingController descriptionInputController =
      TextEditingController();

  void initializeForm() {
    ingredientService
        .findAllIngredientReciping(widget.recipe.id)
        .then((value) => ingredients = value);
    seasonService.getByRecipe(widget.recipe.id).then((value) => season = value);
    seasonService.getAllSeasons().then((seasons) {
      setState(() {
        seasonList = seasons;
      });
    });

    titleInputController.text = widget.recipe.title;
    durationInputController.text = widget.recipe.tempsPrep.toString();
    descriptionInputController.text = widget.recipe.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier ${widget.recipe.title}'),
      ),
      body: FutureBuilder(
        future:
        seasonService.getByRecipe(widget.recipe.id).then((value) => season = value),
          builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: titleInputController,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                        prefixIcon: Icon(Icons.abc),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'The name is obligatory';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: descriptionInputController,
                      decoration: const InputDecoration(
                        hintText: 'Description',
                        prefixIcon: Icon(Icons.description),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'The description is obligatory';
                        }
                        return null;
                      },
                    ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: seasonList.map((e) {
                              bool isSelected = e == season;
                              return Padding(
                                padding: const EdgeInsets.only(right: 3),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      season = (isSelected ? null : e)!;
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
                    TextFormField(
                      controller: durationInputController,
                      decoration: const InputDecoration(
                        hintText: 'Time to prepare',
                        prefixIcon: Icon(Icons.timer_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: AddIngredientsWidget(
                        ingredients: ingredients,
                        recipe: widget.recipe,
                        onIngredientsChanged: (updatedIngredients) {
                          setState(() {
                            ingredients = updatedIngredients;
                          });
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (ingredients.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Please add at least one ingredient')),
                            );
                          } else {
                            Recipe recipeToUpdate = Recipe(
                                id: widget.recipe.id,
                                title: titleInputController.text,
                                description: descriptionInputController.text,
                                tempsPrep:
                                    int.tryParse(durationInputController.text) ?? 0,
                                season: season.id);
                            recipeService.updateRecipeWithIngredients(
                                recipeToUpdate, ingredients);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Recette modifiée')),
                            );
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => HomePage(),
                            ));
                          }
                        }
                      },
                      child: Text('Modifier'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  void onChangeSeason(Season a) {
    setState(() {
      season = a;
    });
  }
}
