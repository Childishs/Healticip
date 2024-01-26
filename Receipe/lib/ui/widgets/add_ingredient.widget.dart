import 'package:flutter/material.dart';
import 'package:receipe/data/service/ingredientAsso_service.dart';

import '../../data/database.dart';

class AddIngredientsWidget extends StatefulWidget {
  final Function(List<IngredientReciping>)? onIngredientsChanged;

  final List<IngredientReciping>? ingredients;

  final Recipe? recipe;

  const AddIngredientsWidget({
    Key? key,
    required this.onIngredientsChanged,
    this.ingredients,
    this.recipe,
  }) : super(key: key);

  @override
  _AddIngredientsWidgetState createState() => _AddIngredientsWidgetState();
}

class _AddIngredientsWidgetState extends State<AddIngredientsWidget> {
  List<IngredientReciping> ingredientsReciping = [];
  IngredientAssoService ingredientAssoService = IngredientAssoService();
  String ingredientName = "";
  int quantity = 0;

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      ingredientAssoService.findAllIngredientReciping(widget.recipe!.id).then((value) => ingredientsReciping = value);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        if (ingredientsReciping.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            itemCount: ingredientsReciping.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  ingredientsReciping[index].ingredient.title,
                  style: TextStyle(color: Colors.black), // Adjust text color
                ),
                subtitle: Text(
                  'Quantity: ${ingredientsReciping[index].quantity}',
                  style: TextStyle(color: Colors.grey), // Adjust text color
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      ingredientsReciping.removeAt(index);
                      if (widget.onIngredientsChanged != null) {
                        widget.onIngredientsChanged!(ingredientsReciping);
                      }
                    });
                  },
                ),
              );
            },
          ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Add an ingredient',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: TextStyle(color: Colors.black),
                onChanged: (value) => ingredientName = value,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Quantity',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                onChanged: (value) => quantity = int.tryParse(value) ?? 0,
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                Ingredient ingredient = Ingredient(title: 'Default Ingredient', id: 0);

                ingredientAssoService.addIngredient(ingredientName).then(
                      (value) =>
                          ingredientAssoService.findIngredient(value).then(
                        (value) {
                          ingredient = value;

                          IngredientReciping ingredientRecip =
                              IngredientReciping(ingredient, quantity);
                          ingredientsReciping.add(ingredientRecip);

                          if (widget.onIngredientsChanged != null) {
                            widget.onIngredientsChanged!(ingredientsReciping);
                          }
                        },
                      ),
                    );
              },
            ),
          ],
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
