import 'package:flutter/material.dart';

class QuizCategory {
  final String id;
  final String title;
  final IconData iconData;
  final String description;
  final Color color;
  final String modelPath;

  QuizCategory({
    required this.id,
    required this.title,
    required this.iconData,
    required this.description,
    required this.color,
    required this.modelPath,
  });
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });
}

// Sabit soru verileri
class QuestionData {
  static List<QuizQuestion> getQuestionsForCategory(String categoryId) {
    switch (categoryId) {
      case 'square':
        return [
          QuizQuestion(
            question: "Bir kenarı 4 cm olan karenin alanı kaç cm²'dir?",
            options: ["8", "12", "16", "20"],
            correctOptionIndex: 2,
            explanation: "Karenin alanı = kenar × kenar = 4 × 4 = 16 cm²",
          ),
          QuizQuestion(
            question: "Bir kenarı 6 cm olan karenin çevresi kaç cm'dir?",
            options: ["18", "24", "30", "36"],
            correctOptionIndex: 1,
            explanation: "Karenin çevresi = 4 × kenar = 4 × 6 = 24 cm",
          ),
          QuizQuestion(
            question: "Çevresi 20 cm olan bir karenin bir kenarı kaç cm'dir?",
            options: ["4", "5", "6", "10"],
            correctOptionIndex: 1,
            explanation: "Çevre = 4 × kenar, o halde kenar = çevre ÷ 4 = 20 ÷ 4 = 5 cm",
          ),
        ];

      case 'triangle':
        return [
          QuizQuestion(
            question: "Tabanı 6 cm, yüksekliği 4 cm olan üçgenin alanı kaç cm²'dir?",
            options: ["10", "12", "16", "24"],
            correctOptionIndex: 1,
            explanation: "Üçgenin alanı = (taban × yükseklik) ÷ 2 = (6 × 4) ÷ 2 = 12 cm²",
          ),
          QuizQuestion(
            question: "Kenarları 3, 4 ve 5 cm olan üçgenin çevresi kaç cm'dir?",
            options: ["8", "10", "12", "15"],
            correctOptionIndex: 2,
            explanation: "Üçgenin çevresi = 3 + 4 + 5 = 12 cm",
          ),
          QuizQuestion(
            question: "Eşkenar üçgenin her kenarı 5 cm ise çevresi kaç cm'dir?",
            options: ["10", "15", "20", "25"],
            correctOptionIndex: 1,
            explanation: "Eşkenar üçgenin çevresi = 3 × kenar = 3 × 5 = 15 cm",
          ),
        ];

      case 'circle':
        return [
          QuizQuestion(
            question: "Yarıçapı 3 cm olan dairenin alanı yaklaşık kaç cm²'dir? (π ≈ 3.14)",
            options: ["18.84", "28.26", "9.42", "12.56"],
            correctOptionIndex: 1,
            explanation: "Dairenin alanı = π × r² = 3.14 × 3² = 3.14 × 9 = 28.26 cm²",
          ),
          QuizQuestion(
            question: "Yarıçapı 4 cm olan dairenin çevresi (çemberin uzunluğu) yaklaşık kaç cm'dir? (π ≈ 3.14)",
            options: ["15.70", "25.12", "12.56", "28.26"],
            correctOptionIndex: 1,
            explanation: "Dairenin çevresi = 2 × π × r = 2 × 3.14 × 4 = 25.12 cm",
          ),
          QuizQuestion(
            question: "Çapı 6 cm olan dairenin alanı yaklaşık kaç cm²'dir? (π ≈ 3.14)",
            options: ["9.42", "18.84", "28.26", "56.52"],
            correctOptionIndex: 2,
            explanation: "Dairenin alanı = π × r² = π × (d/2)² = 3.14 × (6/2)² = 3.14 × 9 = 28.26 cm²",
          ),
        ];

      case 'sphere':
        return [
          QuizQuestion(
            question: "Yarıçapı 2 cm olan kürenin hacmi yaklaşık kaç cm³'tür? (π ≈ 3.14)",
            options: ["33.49", "16.75", "25.12", "8.37"],
            correctOptionIndex: 0,
            explanation: "Kürenin hacmi = (4/3) × π × r³ = (4/3) × 3.14 × 2³ = (4/3) × 3.14 × 8 = 33.49 cm³",
          ),
          QuizQuestion(
            question: "Yarıçapı 3 cm olan kürenin yüzey alanı yaklaşık kaç cm²'dir? (π ≈ 3.14)",
            options: ["56.52", "113.04", "28.26", "84.78"],
            correctOptionIndex: 1,
            explanation: "Kürenin yüzey alanı = 4 × π × r² = 4 × 3.14 × 3² = 4 × 3.14 × 9 = 113.04 cm²",
          ),
          QuizQuestion(
            question: "Hacmi yaklaşık 113.04 cm³ olan bir kürenin yarıçapı yaklaşık kaç cm'dir? (π ≈ 3.14)",
            options: ["2", "3", "4", "5"],
            correctOptionIndex: 2,
            explanation: "V = (4/3) × π × r³, 113.04 = (4/3) × 3.14 × r³, r = 3. küpkök(113.04 × 3 ÷ (4 × 3.14)) ≈ 3. küpkök(27) ≈ 3 cm",
          ),
        ];

      default:
        return [];
    }
  }
} 