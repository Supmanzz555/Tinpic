import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinpic/models/pics.dart';
import 'package:tinpic/API/services.dart';
import 'package:tinpic/pages/swipe.dart';
import 'dart:math';

class SwipeMenu extends StatefulWidget {
  const SwipeMenu({super.key});

  @override
  State<SwipeMenu> createState() => _SwipeMenuState();
}

class _SwipeMenuState extends State<SwipeMenu> {
  late Future<List<Pics>> _futureImages;

  @override
  void initState() {
    super.initState();
    _futureImages = ApiServices().fetchImages();
  }

  Map<String, List<Pics>> groupImagesByMonth(List<Pics> images) {
    final Map<String, List<Pics>> groupedImages = {};
    final DateFormat formatter = DateFormat('MM-yyyy');

    for (final image in images) {
      final String monthyear = formatter.format(DateTime.parse(image.uploadDate));
      if (!groupedImages.containsKey(monthyear)) {
        groupedImages[monthyear] = [];
      }
      groupedImages[monthyear]!.add(image);
    }
    return groupedImages;
  }

  Color generateRandomColor() { // gen random colors value on the select menu
    final random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Date or just random?', style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.amber[200],
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 84, 86, 86),
      body: FutureBuilder<List<Pics>>(
        future: _futureImages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load Pics'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Pics available:(', style: TextStyle(color: Colors.white),));
          }

          final allImages = snapshot.data!;
          final grouped = groupImagesByMonth(allImages);
          final months = grouped.keys.toList()
            ..sort((a, b) => DateFormat('MM yyyy')
                .parse(b)
                .compareTo(DateFormat('MM yyyy').parse(a)));

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              // Random picking (all pics)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: ElevatedButton(
                  onPressed: () {
                      final randompic = List<Pics>.from(allImages); // randompic list and shuffle it 
                      randompic.shuffle();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Swipepage(images: randompic)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    backgroundColor: generateRandomColor(),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                    elevation: 0, 
                  ),
                  child: const Text(
                    'Random',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 0),
              //picking (group by month not random)
              ...months.map((month) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Swipepage(images: grouped[month]!),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: generateRandomColor(),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                        elevation: 0, 
                      ),
                      child: Text(
                        month,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}