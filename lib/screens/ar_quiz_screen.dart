import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'dart:math' show pi;
import 'package:confetti/confetti.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/quiz_category.dart';
import '../utils/camera_permission_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class ARQuizScreen extends StatefulWidget {
  final QuizCategory category;

  const ARQuizScreen({super.key, required this.category});

  @override
  State<ARQuizScreen> createState() => _ARQuizScreenState();
}

class _ARQuizScreenState extends State<ARQuizScreen> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  ARNode? objectNode;
  ARAnchorManager? arAnchorManager;
  
  late List<QuizQuestion> questions;
  int currentQuestionIndex = 0;
  bool isQuizVisible = false;
  bool isModelPlaced = false;
  bool isAnswerSelected = false;
  int? selectedAnswerIndex;
  bool isCorrectAnswer = false;
  bool modelError = false;
  
  late ConfettiController confettiController;
  late FlutterTts flutterTts;
  
  @override
  void initState() {
    super.initState();
    questions = QuestionData.getQuestionsForCategory(widget.category.id);
    confettiController = ConfettiController(duration: const Duration(seconds: 2));
    flutterTts = FlutterTts();
    _configureFlutterTts();
    
    // Kamera izni kontrolü
    _ensureCameraPermission();
    
    // Hemen quiz'i göster, modelleri beklemeden
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          isQuizVisible = true;
        });
      }
    });
  }
  
  Future<void> _configureFlutterTts() async {
    await flutterTts.setLanguage('tr-TR');
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  @override
  void dispose() {
    arSessionManager.dispose();
    confettiController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title),
        backgroundColor: widget.category.color,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: onARViewCreated,
          ),
          
          // İlerleme göstergesi
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              color: Colors.black54,
              child: Text(
                'Soru ${currentQuestionIndex + 1}/${questions.length}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          
          // Yönlendirme mesajı (modeller olmadan da devam edebilmek için)
          if (!isModelPlaced && !modelError)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Düz bir yüzeye dokunun',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isModelPlaced = true; // Modeli yerleştirmeden devam et
                          isQuizVisible = true;
                        });
                      },
                      child: const Text('Doğrudan Quiz\'e Geç'),
                    ),
                  ],
                ),
              ),
            ),

          // Model yüklenme hatası varsa
          if (modelError)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Model yüklenirken hata oluştu.\n3D modeller bulunmuyor.',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isModelPlaced = true; // Modeli yerleştirmeden devam et
                          isQuizVisible = true;
                        });
                      },
                      child: const Text('Quiz\'e Devam Et'),
                    ),
                  ],
                ),
              ),
            ),
          
          // Quiz arayüzü
          if (isQuizVisible)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Soru
                    Text(
                      questions[currentQuestionIndex].question,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Seçenekler
                    ...List.generate(
                      questions[currentQuestionIndex].options.length,
                      (index) => GestureDetector(
                        onTap: isAnswerSelected ? null : () => _checkAnswer(index),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _getOptionColor(index),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: selectedAnswerIndex == index
                                  ? _getBorderColor(index)
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text(
                                    ['A', 'B', 'C', 'D'][index],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: widget.category.color,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                questions[currentQuestionIndex].options[index],
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Açıklama
                    if (isAnswerSelected)
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isCorrectAnswer ? Colors.green.shade50 : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isCorrectAnswer ? Colors.green : Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          questions[currentQuestionIndex].explanation,
                          style: TextStyle(
                            fontSize: 14,
                            color: isCorrectAnswer ? Colors.green.shade900 : Colors.red.shade900,
                          ),
                        ),
                      ),
                    
                    // Sonraki buton
                    if (isAnswerSelected)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: ElevatedButton(
                          onPressed: _nextQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.category.color,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            currentQuestionIndex < questions.length - 1
                                ? 'Sonraki Soru'
                                : 'Quiz\'i Bitir',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          
          // Konfeti efekti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.1,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getOptionColor(int index) {
    if (!isAnswerSelected) {
      return Colors.white;
    }
    
    final correctIndex = questions[currentQuestionIndex].correctOptionIndex;
    
    if (index == correctIndex) {
      return Colors.green.shade100;
    }
    
    if (index == selectedAnswerIndex && selectedAnswerIndex != correctIndex) {
      return Colors.red.shade100;
    }
    
    return Colors.white;
  }
  
  Color _getBorderColor(int index) {
    if (!isAnswerSelected) {
      return widget.category.color;
    }
    
    final correctIndex = questions[currentQuestionIndex].correctOptionIndex;
    
    if (index == correctIndex) {
      return Colors.green;
    }
    
    if (index == selectedAnswerIndex && selectedAnswerIndex != correctIndex) {
      return Colors.red;
    }
    
    return Colors.grey.shade300;
  }
  
  void _checkAnswer(int index) {
    setState(() {
      selectedAnswerIndex = index;
      isAnswerSelected = true;
      isCorrectAnswer = index == questions[currentQuestionIndex].correctOptionIndex;
    });
    
    if (isCorrectAnswer) {
      confettiController.play();
      _speak('Doğru cevap!');
    } else {
      _speak('Yanlış cevap.');
    }
  }
  
  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        isAnswerSelected = false;
        selectedAnswerIndex = null;
      });
    } else {
      // Quiz bitti, sonuç ekranına yönlendir
      Navigator.pop(context);
    }
  }

  void onARViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager,
  ) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;
    arAnchorManager = anchorManager;
    
    arSessionManager.onInitialize();
    
    arObjectManager.onInitialize();
    
    arSessionManager.onPlaneOrPointTap = onPlaneOrPointTapped;
    
    // Model bulunamama durumunu yakala
    // arSessionManager.onError methodu kullanılmıyor
    setState(() {
      // Direkt olarak hata durumunu ele al
    });
  }
  
  Future<void> onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) async {
    if (isModelPlaced) return;
    
    try {
      var singleHitTestResult = hitTestResults.isNotEmpty ? hitTestResults.first : null;
      
      // Not: Gerçek modeller olmadan sadece AR oturumuna başlayarak quizi göstereceğiz
      setState(() {
        isModelPlaced = true;
        isQuizVisible = true;
      });
      
    } catch (e) {
      // Hata durumunda doğrudan quiz'i göster
      setState(() {
        modelError = true;
        isModelPlaced = true;
        isQuizVisible = true;
      });
    }
  }

  Future<void> _ensureCameraPermission() async {
    final hasPermission = await CameraPermissionManager.hasCameraPermission();
    if (!hasPermission) {
      await CameraPermissionManager.requestCameraPermission();
    }
  }
} 