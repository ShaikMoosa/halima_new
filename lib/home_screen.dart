import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'week_provider.dart';
import 'week_data_model.dart';
import 'dart:math'; // For the random generator in animation
import 'settings.dart'; // Import the settings page

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int initialPageIndex = 0;
  String babyName = 'Baby Growth'; // Default title
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final weeksData = Provider.of<WeekProvider>(context, listen: false).weeksData;
      final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final int selectedWeek = args?['week'] ?? 1;
      babyName = args?['babyName'] ?? 'Baby Growth';

      // Check if weeksData is not empty before using it
      if (weeksData.isEmpty) {
        print("Error: weeksData is empty or not loaded.");
        return;
      }

      // Calculate the initial page index based on the selected week.
      initialPageIndex = weeksData.indexWhere((weekData) {
        final weekRange = weekData.weekRange.split('-');
        int startWeek = int.parse(weekRange.first);
        int endWeek = weekRange.length > 1 ? int.parse(weekRange.last) : startWeek;
        return selectedWeek >= startWeek && selectedWeek <= endWeek;
      });

      // Check if the initial page index is valid
      if (initialPageIndex < 0 || initialPageIndex >= weeksData.length) {
        print("Error: initialPageIndex is out of range: $initialPageIndex");
        initialPageIndex = 0; // Set to the first page if out of range
      }

      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            initialPageIndex,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;
    final weeksData = Provider.of<WeekProvider>(context).weeksData;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            babyName, // Display baby name or default title
            style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
        backgroundColor: Colors.pink.shade50, // Optional: Set background color for the AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: weeksData.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: weeksData.length,
              itemBuilder: (context, index) {
                final weekData = weeksData[index];
                // Determine if this is among the last seven weeks
                final isLastSeven = index >= weeksData.length - 7;
                return _buildWeekContainer(context, weekData, isLastSeven);
              },
            ),
    );
  }

  Widget _buildWeekContainer(BuildContext context, WeekData weekData, bool isLastSeven) {
    return Container(
      width: MediaQuery.of(context).size.width, // Full width of the screen
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: isLastSeven
            ? OverlayWeekContainer(weekData: weekData)
            : RegularWeekContainer(weekData: weekData),
      ),
    );
  }
}

// Widget for regular week containers (not among the last seven)
class RegularWeekContainer extends StatelessWidget {
  final WeekData weekData;

  const RegularWeekContainer({Key? key, required this.weekData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity, // Full width of the screen
      padding: const EdgeInsets.all(16.0),
      color: Colors.pink.shade50, // Background color
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: Image.asset(
              'assets/${weekData.fruit.toLowerCase()}.png',
              height: MediaQuery.of(context).size.height * 0.3, // Responsive height
              width: MediaQuery.of(context).size.width * 0.5, // Responsive width
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 150),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${weekData.fruit} 💖',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Week ${weekData.weekRange}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Provider.of<WeekProvider>(context, listen: false)
                  .selectWeek(weekData);

              // Navigate to ViewProgressScreen with the selected WeekData
              Navigator.pushNamed(
                context,
                '/viewProgress',
                arguments: weekData, // Pass the entire WeekData object as an argument
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink.shade300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: const Text(
              'View Progress',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget for week containers with overlay animation (last seven weeks)
class OverlayWeekContainer extends StatefulWidget {
  final WeekData weekData;

  const OverlayWeekContainer({Key? key, required this.weekData}) : super(key: key);

  @override
  _OverlayWeekContainerState createState() => _OverlayWeekContainerState();
}

class _OverlayWeekContainerState extends State<OverlayWeekContainer> with SingleTickerProviderStateMixin {
  bool _isRevealed = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The underlying content
        RegularWeekContainer(weekData: widget.weekData),
        // The overlay
        if (!_isRevealed)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isRevealed = true;
                });
              },
              child: Container(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    const Positioned.fill(
                      child: CanvasRevealEffect(),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isRevealed = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text(
                          'Preview',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// CanvasRevealEffect widget
class CanvasRevealEffect extends StatefulWidget {
  const CanvasRevealEffect({super.key});

  @override
  _CanvasRevealEffectState createState() => _CanvasRevealEffectState();
}

class _CanvasRevealEffectState extends State<CanvasRevealEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Square> squares;
  final int squareSize = 5;
  final double margin = 0.3;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..repeat();

    // Initialize squares
    squares = [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeSquares();
    });
  }

  void initializeSquares() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;

    final int columns = (size.width / (squareSize + margin)).floor();
    final int rows = (size.height / (squareSize + margin)).floor();

    setState(() {
      squares = List.generate(
        rows * columns,
        (index) {
          final int x = index % columns;
          final int y = index ~/ columns;
          return Square(
            offset: Offset(
              x * (squareSize + margin),
              y * (squareSize + margin),
            ),
            opacity: random.nextDouble(),
            animationDuration:
                Duration(milliseconds: 200 + random.nextInt(100)), // 0.2s to 0.3s
          );
        },
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Gradient colors
    const Gradient gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromARGB(255, 243, 33, 198),
        Color.fromARGB(255, 255, 159, 86),
      ],
    );

    return CustomPaint(
      painter: SquaresPainter(
        squares: squares,
        animation: _controller,
        gradient: gradient,
        squareSize: squareSize.toDouble(),
      ),
      size: Size.infinite,
    );
  }
}

class Square {
  final Offset offset;
  double opacity;
  final Duration animationDuration;

  Square({
    required this.offset,
    required this.opacity,
    required this.animationDuration,
  });
}

class SquaresPainter extends CustomPainter {
  final List<Square> squares;
  final Animation<double> animation;
  final Gradient gradient;
  final double squareSize;

  SquaresPainter({
    required this.squares,
    required this.animation,
    required this.gradient,
    required this.squareSize,
  }) : super(repaint: animation);

  final Random random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    // Apply the gradient
    final Rect rect = Offset.zero & size;
    final Paint backgroundPaint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, backgroundPaint);

    // Draw squares
    for (var square in squares) {
      // Randomly adjust opacity to create glitter effect
      if (random.nextDouble() < 0.1) {
        // 10% chance to change
        square.opacity = random.nextDouble();
      }

      final Paint paint = Paint()
        ..color = const Color.fromARGB(255, 252, 177, 218).withOpacity(square.opacity);

      canvas.drawRect(
        Rect.fromLTWH(
          square.offset.dx,
          square.offset.dy,
          squareSize,
          squareSize,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant SquaresPainter oldDelegate) => true;
}
