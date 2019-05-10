import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_weather_app/generic_widgets/radial_position.dart';

class SlidingRadialList extends StatelessWidget {

  RadialListViewModel radialList;
  SlidingRadialListController controller;

  SlidingRadialList({
    this.radialList,
    this.controller,
  });

  List<Widget> _radialListItems() {
    final double firstItemAngle = -pi / 3;
    final double lastItemAngle = pi / 3;
    final double angleDiffPerItem = (lastItemAngle - firstItemAngle) /
        (radialList.items.length - 1);

    double currAngle = firstItemAngle;

    return radialList.items.map((RadialListItemViewModel viewModel) {
      final listItem = _radialListItem(viewModel, currAngle);
      currAngle += angleDiffPerItem;
      return listItem;
    }).toList();
  }

  Widget _radialListItem(RadialListItemViewModel viewModel, double angle) {
    // Move Icons to middle of screen
    return new Transform(
      transform: new Matrix4.translationValues(40.0, 334.0, 0.0),
      child: new RadialPosition(
        radius: 140.0 + 75.0,
        angle: angle,
        child: new RadialListItem(
          listItem: viewModel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: _radialListItems(),
    );
  }
}


class SlidingRadialListController extends ChangeNotifier {

  final double firstItemAngle = -pi / 3;
  final double lastItemAngle = pi / 3;
  final double startSlidingAngle = 3 * pi / 4;

  final int itemCount;

  final AnimationController _slideController;
  final AnimationController _fadeController;
  List<Animation<double>> _slidePositions;

  RadialListState _state;

  SlidingRadialListController({
    this.itemCount,
    vsync,

  }) : _slideController = new AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: vsync,
      ),
      _fadeController = new AnimationController(
        duration: const Duration(milliseconds: 150),
        vsync: vsync,
      ) {
    _slideController
      ..addListener(() => notifyListeners())
      ..addStatusListener((AnimationStatus status) {
        switch(status) {
          case AnimationStatus.forward:
            _state = RadialListState.slidingOpen;
            notifyListeners();
            break;
          case AnimationStatus.completed:
            _state = RadialListState.open;
            notifyListeners();
            break;
          case AnimationStatus.reverse:
          case AnimationStatus.dismissed:
            break;
        }
      });

    _fadeController
      ..addListener(() => notifyListeners())
      ..addStatusListener((AnimationStatus status) {
        switch(status) {
          case AnimationStatus.forward:
            _state = RadialListState.fadingOut;
            notifyListeners();
            break;
          case AnimationStatus.completed:
            _state = RadialListState.closed;

            // Reset Animation Controllers
            _slideController.value = 0.0;
            _fadeController.value = 0.0;
            notifyListeners();
            break;
          case AnimationStatus.reverse:
          case AnimationStatus.dismissed:
            break;
        }
      });

    // Starts 10% behind next item.  Total of 50%.
    /*
     * Interval Table
     *
     * 1st Icon: No Delay. Takes 50% to complete.
     * 2nd Icon: Starts at 10%. Ends at 60%.
     * 3rd Icon: Starts at 20%. Ends at 70%.
     * 4th Icon: Starts at 40%. Ends at 90%.
     * 5th Icon: Starst at 50%. Ends at 100%.
     *
     */
    final delayInterval = 0.1;
    final slideInterval = 0.5;
    final angleDeltaPerItem = (lastItemAngle - firstItemAngle) / (itemCount - 1);

    for(var i = 0; i < itemCount; ++i) {
      final start = delayInterval * i;
      final end = start + slideInterval;

      final endSlidingAngle = firstItemAngle + (angleDeltaPerItem * i);

      _slidePositions.add(
        new Tween(
          begin: startSlidingAngle,
          end: endSlidingAngle,
        ).animate(
          new CurvedAnimation(
            parent: _slideController,
            curve: new Interval(start, end, curve: Curves.easeInOut),
          )
        ),
      );
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  double getItemAngle(int index) {
    return _slidePositions[index].value;
  }

  double getItemOpacity(int index) {
    switch(_state) {
      case RadialListState.closed:
        return 0.0;
      case RadialListState.slidingOpen:
      case RadialListState.open:
        return 1.0;
      case RadialListState.fadingOut:
        return (1.0 - _fadeController.value);
      default:
        return 1.0;
    }
  }

  Future<Null> open() {
    if(_state == RadialListState.closed) {
      _slideController.forward();
      // TODO Return a future
    }
    return null;
  }

  Future<Null> close() {
    if(_state == RadialListState.open) {
      _slideController.forward();
      // TODO Return a future
    }
    return null;
  }

}

enum RadialListState {
  closed,
  slidingOpen,
  open,
  fadingOut,
}

class RadialListItem extends StatelessWidget {
  final RadialListItemViewModel listItem;

  RadialListItem({
    this.listItem,
  });

  @override
  Widget build(BuildContext context) {
    final circleDecoration = listItem.isSelected
      ? new BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        )
      : new BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: new Border.all(
            color: Colors.white,
            width: 2.0,
          ),
        );

    return new Transform(
      transform: new Matrix4.translationValues(-30.0, -30.0, 0.0),
      child: new Row(
        children: <Widget>[
          new Container(
            width: 60.0,
            height: 60.0,
            decoration: circleDecoration,
            child: new Padding(
              padding: const EdgeInsets.all(7.0),
              child: new Image(
                image: listItem.icon,
                color: listItem.isSelected ? const Color(0xFF6688CC) : Colors.white,
              ),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  listItem.title,
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                new Text(
                  listItem.subtitle,
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RadialListViewModel {
  final List<RadialListItemViewModel> items;

  RadialListViewModel({
    this.items = const [],
  });
}

class RadialListItemViewModel {
  final ImageProvider icon;
  final String title;
  final String subtitle;
  final bool isSelected;

  RadialListItemViewModel({
    this.icon,
    this.title = '',
    this.subtitle = '',
    this.isSelected = false,
  });


}