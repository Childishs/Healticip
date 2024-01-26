import 'package:flutter/material.dart';
import 'package:receipe/ui/pages/add_recipe.page.dart';
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image.asset(
            'assets/images/recette_icone.png',
            height: 40, // Adjust the size as needed
          ),
          SizedBox(width: 10),
          Text(
            'Healthy Recipes',
            style: TextStyle(
              color: Colors.greenAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => AddRecipePage()),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue, // Set your desired background color
        ),
      ],
    );
  }
}
