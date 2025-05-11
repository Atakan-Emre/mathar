import 'package:flutter/material.dart';
import 'ar_quiz_screen.dart';
import '../models/quiz_category.dart';

class QuizCategoryScreen extends StatelessWidget {
  const QuizCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<QuizCategory> categories = [
      QuizCategory(
        id: 'square',
        title: 'Kare',
        iconData: Icons.crop_square_outlined,
        description: 'Kare ile ilgili soruları çöz',
        color: Colors.blue,
        modelPath: 'assets/models/kare.glb',
      ),
      QuizCategory(
        id: 'triangle',
        title: 'Üçgen',
        iconData: Icons.change_history_outlined,
        description: 'Üçgen ile ilgili soruları çöz',
        color: Colors.orange,
        modelPath: 'assets/models/ucgen.glb',
      ),
      QuizCategory(
        id: 'circle',
        title: 'Daire',
        iconData: Icons.circle_outlined,
        description: 'Daire ile ilgili soruları çöz',
        color: Colors.green,
        modelPath: 'assets/models/daire.glb',
      ),
      QuizCategory(
        id: 'sphere',
        title: 'Küre',
        iconData: Icons.panorama_fish_eye,
        description: 'Küre ile ilgili soruları çöz',
        color: Colors.purple,
        modelPath: 'assets/models/kure.glb',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori Seç'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.9,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryCard(
              category: category,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ARQuizScreen(category: category),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final QuizCategory category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4.0,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                category.color,
                category.color.withOpacity(0.7),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                category.iconData,
                size: 60.0,
                color: Colors.white,
              ),
              const SizedBox(height: 16.0),
              Text(
                category.title,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                category.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 