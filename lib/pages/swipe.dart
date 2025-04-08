// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:tinpic/models/pics.dart';
import 'package:tinpic/API/services.dart';
import 'package:intl/intl.dart';

class Swipepage extends StatefulWidget {
  final List<Pics> images;

  const Swipepage({super.key, required this.images});
  @override
  State<Swipepage> createState() => _SwipepageState();
}

class _SwipepageState extends State<Swipepage> with SingleTickerProviderStateMixin {
  late List<Pics> images;
  final ApiServices api = ApiServices();

  Offset cardOffset = Offset.zero;
  double swipeThreshold = 100;

  @override
  void initState() {
    super.initState();
    images = List.from(widget.images);
  }

  void _handleSwipe(DragEndDetails details) {
    if (cardOffset.dx < -swipeThreshold) {
      _onSwipeLeft();
    } else if (cardOffset.dx > swipeThreshold) {
      _onSwipeRight();
    }

    setState(() {
      cardOffset = Offset.zero;
    });
  }

  void _onSwipeLeft() {
    final current = images.first;

    setState(() {
      images.removeAt(0);
    });

    api.deleteImage(current.id).catchError((e) { // remove from db and list
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to delete: $e")));
    });

    _checkEnd();
  }

  void _onSwipeRight() { //only remove from list the from db
    setState(() {
      images.removeAt(0);
    });

    _checkEnd();
  }

  void _checkEnd() { //if all card empty return to home and show snack
    if (images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You swiped all the pics such a swiper!"),
        duration: Duration(seconds: 2),
      ));

      Navigator.popUntil(context, ModalRoute.withName('/'));
    }
  }

  String formatDate(String date) {
    try {
      return DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentImage = images.isNotEmpty ? images.first : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Swipe it Away!" , style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.amber[200],
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          currentImage == null
              ? const Center(
                  child: Text("No more Pics to swipe:)", style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold )),
                )
              : GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      cardOffset += details.delta;
                    });
                  },
                  onPanEnd: _handleSwipe,
                  child: Center(
                    child: AnimatedContainer( //card animation
                      duration: const Duration(milliseconds: 200),
                      transform: Matrix4.identity()
                        ..translate(cardOffset.dx, cardOffset.dy)
                        ..rotateZ(cardOffset.dx * 0.0015),
                      curve: Curves.easeOut,
                      child: Card(
                        elevation: 16,
                        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        child: Column(
                          children: [
                            Expanded(
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    'http://10.0.2.2:8000/${currentImage.path}',
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(child: CircularProgressIndicator());
                                    },
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Center(child: Icon(Icons.broken_image, size: 48, color: Colors.white)),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.transparent, Colors.black87],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // showing pics info
                            Container(
                              color: Colors.black87,
                              padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentImage.name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text("ID: ${currentImage.id}", style: const TextStyle(color: Colors.white70)),
                                  Text("Uploaded: ${formatDate(currentImage.uploadDate)}",
                                      style: const TextStyle(color: Colors.white54)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

          // Swipe Buttons
          if (currentImage != null)
            Positioned(
              bottom: 45,
              left: 50,
              right: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    heroTag: "swipe_left",
                    onPressed: () {
                      setState(() => cardOffset = const Offset(-101, 0));
                      _handleSwipe(DragEndDetails());
                    },
                    backgroundColor: Colors.redAccent,
                    child: const Icon(Icons.delete, size: 28),
                  ),
                  FloatingActionButton(
                    heroTag: "swipe_right",
                    onPressed: () {
                      setState(() => cardOffset = const Offset(101, 0));
                      _handleSwipe(DragEndDetails());
                    },
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.favorite, size: 28),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
