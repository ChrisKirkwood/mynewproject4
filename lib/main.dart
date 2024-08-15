import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
//import 'logger.dart';  // Importing the logger
import 'api_service.dart';  // Importing the ApiService

// Initializing the Logger
final Logger logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");  // Load environment variables

  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  logger.i('Application started and camera initialized.');

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(camera: camera),
    );
  }
}

class Home extends StatefulWidget {
  final CameraDescription camera;

  const Home({Key? key, required this.camera}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  late CameraController _cameraController;
  bool _isCameraVisible = false;

  final List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();  // Initialize ApiService

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _cameraController.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
      logger.i('Camera initialized successfully.');
    }).catchError((error) {
      logger.e('Camera initialization error: $error');
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add({'user': _controller.text});
      });

      try {
        // Get AI response
        final aiResponse = await _apiService.getAiResponse(_controller.text);
        setState(() {
          messages.add({'ai': aiResponse});
        });
        logger.i('AI response received successfully.');
      } catch (e) {
        logger.e('Failed to get AI response: $e');
      }

      _controller.clear();
    }
  }

  void _toggleCameraView() {
    setState(() {
      _isCameraVisible = !_isCameraVisible;
      logger.i('Camera view toggled: $_isCameraVisible');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Athena'),
        centerTitle: true,
        backgroundColor: Colors.lightGreen[700],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/4 BG.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isUserMessage = message.containsKey('user');
                  return Align(
                    alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: isUserMessage ? Colors.green.withOpacity(0.8) : Colors.blue.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        isUserMessage ? message['user']! : message['ai']!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Enter Names of Cards Below',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: Colors.white,
                      fontFamily: 'IndieFlower',  // Ensure that this font is added in pubspec.yaml
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            hintText: 'Enter text',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FloatingActionButton(
                        onPressed: _sendMessage,
                        backgroundColor: Colors.lightGreen[700],
                        child: const Text('Send'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isCameraVisible)
            Positioned.fill(
              child: CameraPreview(_cameraController),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleCameraView,
        backgroundColor: Colors.purple[500],
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
