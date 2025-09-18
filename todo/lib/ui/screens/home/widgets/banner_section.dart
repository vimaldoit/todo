import 'dart:async';

import 'package:flutter/material.dart';

class BannerSec extends StatefulWidget {
  const BannerSec({super.key});

  @override
  State<BannerSec> createState() => _BannerSecState();
}

class _BannerSecState extends State<BannerSec> {
  late final Timer _timer;
  late final CarouselController _carouselController;
  final _itemExtent = 330.0;
  final _autoPlayDuration = const Duration(seconds: 4);
  int _currentIndex = 0;
  List<String> offersList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carouselController = CarouselController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer.periodic(_autoPlayDuration, (_) => _animateToNextItem());
    });
  }

  void _animateToNextItem() {
    final position = _carouselController.position;

    final nextOffset = _carouselController.offset + _itemExtent;
    final maxScroll = position.maxScrollExtent;

    if (nextOffset > maxScroll) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _carouselController.jumpTo(0);
        setState(() => _currentIndex = 0);
      });
    } else {
      _carouselController.animateTo(
        nextOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceIn,
      );
      setState(() => _currentIndex = (_currentIndex + 1) % 2);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: CarouselView(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemSnapping: true,
            controller: _carouselController,
            scrollDirection: Axis.horizontal,
            itemExtent: double.infinity,
            children: List<Widget>.generate(offersList.length, (int index) {
              return Image.network('${offersList[index]}', fit: BoxFit.cover);
            }),
          ),
        ),
      ],
    );
  }
}
