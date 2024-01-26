import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:receipe/data/service/ingredientAsso_service.dart';
import 'package:receipe/data/service/recipe_service.dart';
import 'package:receipe/ui/pages/home.page.dart';

import '../../data/database.dart';
import '../../data/service/season_service.dart';
import '../widgets/add_ingredient.widget.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({Key? key}) : super(key: key);

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  late final RecipeService recipeService;
  late final IngredientAssoService ingredientService;
  late final SeasonService seasonService;
  final _formKey = GlobalKey<FormState>();
  String? title;
  String? description;
  int? tempsPrep;
  Season? season;
  List<IngredientReciping> ingredients = [];
  late List<Season> seasonList;

  @override
  void initState() {
    super.initState();
    recipeService = RecipeService();
    ingredientService = IngredientAssoService();
    seasonService = SeasonService();
    seasonList = []; // Initialize an empty list
    _loadSeasons(); // Load seasons asynchronously
  }

  // Asynchronous function to load seasons
  Future<void> _loadSeasons() async {
    final seasons = await seasonService.getAllSeasons();
    setState(() {
      seasonList = seasons;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une recette'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                                season = isSelected ? null : e;
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
                TextField(
                  decoration: InputDecoration(
                    icon: const Icon(Icons.abc),
                    hintText: 'Title',
                  ),
                  onChanged: (value) => title = value,
                ),
                TextField(
                  decoration: InputDecoration(
                    icon: const Icon(Icons.abc),
                    hintText: 'Description',
                  ),
                  onChanged: (value) => description = value,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    icon: Icon(Icons.timelapse),
                    hintText: 'Temps préparation',
                  ),
                  onChanged: (value) => tempsPrep = int.tryParse(value),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 3),
                  child: AddIngredientsWidget(
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
                            content: Text('Please add at least one ingredient'),
                          ),
                        );
                      } else if (season == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please choose a season'),
                          ),
                        );
                      } else {
                        recipeService.addRecipeWithIngredients(
                          title!,
                          description!,
                          tempsPrep ?? 0,
                          ingredients,
                          season!.id,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Recette ajoutée')),
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Ajouter'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
