import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import 'package:camera/camera.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:model_viewer_plus/model_viewer_plus.dart';

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Kamera listesini al
  cameras = await availableCameras();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MatharApp());
}

class MatharApp extends StatelessWidget {
  const MatharApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mathar - AR Matematik Oyunu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
          secondary: Colors.orange,
        ),
        fontFamily: 'Quicksand',
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(fontSize: 18),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'MathAr',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black26,
                        offset: Offset(0, 5.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Artırılmış Gerçeklik ile Matematik Öğren!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Mobil cihazınız için hazırlanmış AR uygulaması',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CategoryScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    'Başla',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Geometri', 'icon': Icons.category, 'color': Colors.red},
      {'name': 'Sayılar', 'icon': Icons.confirmation_number, 'color': Colors.green},
      {'name': 'İşlemler', 'icon': Icons.calculate, 'color': Colors.blue},
      {'name': 'Ölçme', 'icon': Icons.straighten, 'color': Colors.orange},
      {'name': 'Şekiller', 'icon': Icons.shape_line, 'color': Colors.purple},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matematik Kategorileri'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ARScreen(categoryName: category['name'] as String),
                ),
              );
            },
            child: Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    category['icon'] as IconData,
                    size: 48,
                    color: category['color'] as Color,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    category['name'] as String,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ARScreen extends StatefulWidget {
  final String categoryName;
  
  const ARScreen({super.key, required this.categoryName});

  @override
  State<ARScreen> createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  bool _showQuestion = true;
  String _currentQuestion = "";
  bool _isObjectAdded = false;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  
  // 3D modelin özellikleri
  late String _modelPath;
  late Color _modelColor;
  late AnimationController _rotationController;
  
  // 3D nesnenin doğru cevabı
  late String _correctAnswer;
  
  // Görüntüleme modu
  bool _isARMode = false;
  
  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    
    // Animasyon kontrolcüsü
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    _initializeCamera();
    _setModelProperties();
    _setQuestionForCategory();
  }
  
  void _setModelProperties() {
    // Kategoriye göre 3D model özellikleri
    switch (widget.categoryName) {
      case 'Geometri':
        _modelPath = 'assets/models/cube.glb';
        _modelColor = Colors.red;
        _correctAnswer = 'Küp';
        break;
      case 'Sayılar':
        _modelPath = 'assets/models/pyramid.glb';
        _modelColor = Colors.green;
        _correctAnswer = '4';
        break;
      case 'İşlemler':
        _modelPath = 'assets/models/cylinder.glb';
        _modelColor = Colors.blue;
        _correctAnswer = 'πr²h';
        break;
      case 'Ölçme':
        _modelPath = 'assets/models/sphere.glb';
        _modelColor = Colors.orange;
        _correctAnswer = '4πr²';
        break;
      case 'Şekiller':
        _modelPath = 'assets/models/cone.glb';
        _modelColor = Colors.purple;
        _correctAnswer = 'Koni';
        break;
      default:
        _modelPath = 'assets/models/cube.glb';
        _modelColor = Colors.red;
        _correctAnswer = 'Küp';
    }
  }
  
  void _initializeCamera() async {
    if (cameras.isEmpty) return;

    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    
    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }
  
  void _setQuestionForCategory() {
    // Kategori bazında 3D nesnelerle ilgili sorular
    final questions = {
      'Geometri': 'Bu 3D şeklin adı nedir?',
      'Sayılar': 'Bu piramit şeklinin kaç yüzü vardır?',
      'İşlemler': 'Bu silindirin hacim formülü nedir?',
      'Ölçme': 'Bu kürenin yüzey alanı formülü nedir?',
      'Şekiller': 'Bu geometrik şeklin adı nedir?',
    };
    
    setState(() {
      _currentQuestion = questions[widget.categoryName] ?? 'Soru yükleniyor...';
    });
  }
  
  void _checkAnswer(String answer) {
    if (answer == _correctAnswer) {
      _confettiController.play();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Doğru cevap! Tebrikler!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Yanlış cevap. Doğru cevap: $_correctAnswer'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _show3DShape() {
    setState(() {
      _isObjectAdded = true;
      _showQuestion = true;
    });
  }
  
  void _toggleViewMode() {
    setState(() {
      _isARMode = !_isARMode;
      _isObjectAdded = false;
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _cameraController?.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryName} - ${_isARMode ? 'AR Modu' : '3D Modeller'}'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Arka plan - Kamera veya normal arka plan
          if (!_isARMode)
            _isCameraInitialized
                ? SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: CameraPreview(_cameraController!),
                  )
                : Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
          
          // Model gösterimi
          if (_isObjectAdded || _isARMode)
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.6,
              child: ModelViewer(
                backgroundColor: Colors.transparent,
                src: _modelPath,
                alt: 'Bir 3D model',
                ar: _isARMode, // AR modu etkinken AR özelliğini etkinleştir
                arModes: const ['scene-viewer', 'webxr', 'quick-look'],
                autoRotate: !_isARMode, // Sadece normal modda otomatik döndür
                cameraControls: !_isARMode, // Sadece normal modda kamera kontrolü
              ),
            ),
          
          // Soru kartı
          Align(
            alignment: Alignment.topCenter,
            child: _showQuestion && _isObjectAdded && !_isARMode
                ? Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentQuestion,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          children: [
                            _buildAnswerButton('Küp'),
                            _buildAnswerButton('4'),
                            _buildAnswerButton('πr²h'),
                            _buildAnswerButton('4πr²'),
                            _buildAnswerButton('Koni'),
                          ],
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          
          // Butonlar
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 3D Modeli Gösterme Butonu (sadece normal modda)
                  if (!_isARMode)
                  FloatingActionButton(
                    onPressed: _show3DShape,
                    backgroundColor: Colors.blue,
                    heroTag: 'show3DModel',
                    child: const Icon(Icons.view_in_ar),
                  ),
                  
                  // Modu Değiştirme Butonu
                  FloatingActionButton(
                    onPressed: _toggleViewMode,
                    backgroundColor: Colors.purple,
                    heroTag: 'toggleMode',
                    tooltip: _isARMode ? 'Normal Mod' : 'AR Modu',
                    child: Icon(_isARMode ? Icons.view_in_ar : Icons.view_in_ar),
                  ),
                  
                  // Yenileme Butonu (sadece normal modda)
                  if (!_isARMode)
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _showQuestion = true;
                        _setModelProperties();
                        _setQuestionForCategory();
                      });
                    },
                    backgroundColor: Colors.orange,
                    heroTag: 'refreshModel',
                    child: const Icon(Icons.refresh),
                  ),
                ],
              ),
            ),
          ),
          
          // Konfeti efekti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.2,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
          ),
          
          // AR modunda yardım metni
          if (_isARMode)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'AR simgesine dokunun ve modeli gerçek dünyada görüntüleyin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildAnswerButton(String answer) {
    return ElevatedButton(
      onPressed: () => _checkAnswer(answer),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      child: Text(answer),
    );
  }
}
