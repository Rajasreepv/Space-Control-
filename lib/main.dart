// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_counter_app/bloc.dart';
import 'package:space_counter_app/event.dart';
import 'package:space_counter_app/state.dart';
// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_counter_app/bloc.dart';
import 'package:space_counter_app/event.dart';
import 'package:space_counter_app/state.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Space Mission Control',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.indigo[400],
        scaffoldBackgroundColor: const Color(0xFF121212),
        fontFamily: 'Montserrat',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Exo',
            fontWeight: FontWeight.w700,
          ),
          displayMedium: TextStyle(
            fontFamily: 'Exo',
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
          ),
        ),
        colorScheme: ColorScheme.dark(
          primary: Colors.indigo[400]!,
          secondary: Colors.tealAccent,
          surface: const Color(0xFF1E1E1E),
          background: const Color(0xFF121212),
        ),
      ),
      home: BlocProvider(
        create: (context) => CounterBloc(),
        child: const ModernRocketCounterPage(),
      ),
    );
  }
}

class ModernRocketCounterPage extends StatefulWidget {
  const ModernRocketCounterPage({super.key});

  @override
  State<ModernRocketCounterPage> createState() => _ModernRocketCounterPageState();
}

class _ModernRocketCounterPageState extends State<ModernRocketCounterPage> with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _launchButtonController;
  late AnimationController _landButtonController;
  late AnimationController _resetButtonController;
  late AnimationController _countController;
  
  final List<AnimationController> _rocketControllers = [];
  int _previousCount = 0;

  @override
  void initState() {
    super.initState();
    
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    _launchButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _landButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _resetButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _countController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _launchButtonController.dispose();
    _landButtonController.dispose();
    _resetButtonController.dispose();
    _countController.dispose();
    
    for (var controller in _rocketControllers) {
      controller.dispose();
    }
    
    super.dispose();
  }

  void _startLaunchAnimation() {
    _launchButtonController.forward().then((_) => _launchButtonController.reverse());
    HapticFeedback.mediumImpact();
  }

  void _startLandAnimation() {
    _landButtonController.forward().then((_) => _landButtonController.reverse());
    HapticFeedback.mediumImpact();
  }

  void _startResetAnimation() {
    _resetButtonController.forward().then((_) => _resetButtonController.reverse());
    HapticFeedback.mediumImpact();
  }

  void _updateRocketAnimations(int count) {
    // Handle count changes for rocket animations
    if (count > _previousCount) {
      _countController.forward(from: 0.0);
      
      // Add a new rocket animation controller
      final rocketController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      );
      _rocketControllers.add(rocketController);
      rocketController.forward(from: 0.0);
    } else if (count < _previousCount) {
      _countController.forward(from: 0.0);
      
      // Remove a rocket controller if needed
      if (_rocketControllers.isNotEmpty) {
        final controller = _rocketControllers.removeLast();
        controller.dispose();
      }
    }
    
    _previousCount = count;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'MISSION CONTROL',
          style: TextStyle(
            fontFamily: 'Exo',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _backgroundController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1A237E),
                  const Color(0xFF0D47A1),
                  const Color(0xFF01579B),
                  const Color(0xFF006064),
                ],
                stops: [
                  0.0,
                  0.3 + 0.1 * math.sin(_backgroundController.value * math.pi * 2),
                  0.6 + 0.1 * math.cos(_backgroundController.value * math.pi * 2),
                  1.0,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Animated stars in the background
                ...List.generate(50, (index) {
                      final sizeS = MediaQuery.of(context).size;
                  final random = math.Random(index);
                  final top = random.nextDouble() * sizeS.height;
                  final left = random.nextDouble() * sizeS.width;
                  final size = random.nextDouble() * 3 + 1;
                  final opacity = 0.3 + 
                      0.7 * (math.sin((_backgroundController.value * math.pi * 2) + index));

                  return Positioned(
                    top: top,
                    left: left,
                    child: Opacity(
                      opacity: opacity.clamp(0.3, 1.0),
                      child: Container(
                        width: size,
                        height: size,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }),
                
                // Main content
                SafeArea(
                  child: child!,
                ),
              ],
            ),
          );
        },
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Mission Status Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white12,
                    width: 0.5,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.greenAccent.withOpacity(0.6),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'MISSIONS ACTIVE',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const Spacer(),
                        BlocBuilder<CounterBloc, CounterState>(
                          builder: (context, state) {
                            // Update animations on count change
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _updateRocketAnimations(state.rocketCount);
                            });
                            
                            return AnimatedBuilder(
                              animation: _countController,
                              builder: (context, _) {
                                return Transform.scale(
                                  scale: 1.0 + _countController.value * 0.2,
                                  child: Text(
                                    '${state.rocketCount}',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.greenAccent,
                                      shadows: [
                                        Shadow(
                                          color: Colors.greenAccent.withOpacity(0.8),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Rocket Visualization
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: BlocBuilder<CounterBloc, CounterState>(
                        builder: (context, state) {
                          if (state.rocketCount == 0) {
                            return const Center(
                              child: Text(
                                'No Active Missions',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            );
                          }
                          
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  state.rocketCount,
                                  (index) {
                                    // Use the rocket controller if available
                                    final controller = index < _rocketControllers.length
                                        ? _rocketControllers[index]
                                        : null;
                                    
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      child: controller != null
                                          ? AnimatedBuilder(
                                              animation: controller,
                                              builder: (context, child) {
                                                return Transform.translate(
                                                  offset: Offset(
                                                    0,
                                                    10 * math.sin(controller.value * math.pi * 2),
                                                  ),
                                                  child: const Text(
                                                    '🚀',
                                                    style: TextStyle(fontSize: 32),
                                                  ),
                                                );
                                              },
                                            )
                                          : const Text(
                                              '🚀',
                                              style: TextStyle(fontSize: 32),
                                            ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const Spacer(),
            
            // Mission Control Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white12,
                    width: 0.5,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'MISSION CONTROL',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Launch & Land Buttons
                    Row(
                      children: [
                        Expanded(
                          child: AnimatedBuilder(
                            animation: _launchButtonController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: 1.0 - _launchButtonController.value * 0.1,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _startLaunchAnimation();
                                    context.read<CounterBloc>().add(LaunchRocket());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green[600],
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 5,
                                    shadowColor: Colors.greenAccent.withOpacity(0.5),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.rocket_launch,
                                        size: 28,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'LAUNCH',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AnimatedBuilder(
                            animation: _landButtonController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: 1.0 - _landButtonController.value * 0.1,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _startLandAnimation();
                                    context.read<CounterBloc>().add(LandRocket());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 5,
                                    shadowColor: Colors.redAccent.withOpacity(0.5),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.flight_land,
                                        size: 28,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'LAND',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Reset Button
                    AnimatedBuilder(
                      animation: _resetButtonController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 - _resetButtonController.value * 0.1,
                          child: TextButton.icon(
                            onPressed: () {
                              _startResetAnimation();
                              context.read<CounterBloc>().add(ResetRockets());
                            },
                            icon: const Icon(Icons.restart_alt),
                            label: const Text('ABORT ALL MISSIONS'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white70,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}