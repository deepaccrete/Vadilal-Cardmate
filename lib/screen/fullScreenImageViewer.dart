import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';

class FullScreenImageViewer extends StatefulWidget {
  // final bool isbase64;
  final List<dynamic> images;
  final int initialIndex;

  const FullScreenImageViewer({
    Key? key,
    // required this.isbase64,
    required this.images,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late int _currentIndex;
  late CarouselSliderController _carouselController;

  @override
  void initState() {
    super.initState();
    print("this si hte lneth of image 0---------------- ${widget.images.length}");
    _currentIndex = widget.initialIndex;
    _carouselController = CarouselSliderController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.white),
        ),
        title: Text(
          '${_currentIndex + 1} of ${widget.images.length}',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Add share functionality if needed
            },
            icon: const Icon(Icons.share, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main Image Carousel
          Center(
            child: widget.images.length == 1
                ? Hero(
              tag: 'image_${widget.initialIndex}',
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 5.0,
                child: Image.network(
                  widget.images[0],
                  fit: BoxFit.contain,
                ),
              ),
            )
                : CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height,
                viewportFraction: 1.0,
                enableInfiniteScroll: false,
                initialPage: widget.initialIndex,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: widget.images.asMap().entries.map((entry) {
                int index = entry.key;
                // Uint8List imageBytes = entry.value;
                String imageurl = entry.value;

                return Hero(
                  tag: 'image_$index',
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 5.0,
                    child:
                    // widget.isbase64?
                    // Image.memory(
                    //   imageBytes,
                    //   fit: BoxFit.contain,
                    //   width: MediaQuery.of(context).size.width,
                    // )
                    Image.network(imageurl,    fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width,)
                  ),
                );
              }).toList(),
            ),
          ),

          // Dots Indicator (only show if more than 1 image)
          if (widget.images.length > 1)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: DotsIndicator(
                  dotsCount: widget.images.length,
                  position: _currentIndex.toDouble(),
                  decorator: const DotsDecorator(
                    color: Colors.grey,
                    activeColor: Colors.white,
                    size: Size.square(8.0),
                    activeSize: Size(12.0, 8.0),
                    activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    spacing: EdgeInsets.all(4.0),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}