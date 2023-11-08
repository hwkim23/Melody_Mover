import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

class Walking extends StatefulWidget {
  const Walking({super.key});

  @override
  State<Walking> createState() => _WalkingState();
}

class _WalkingState extends State<Walking> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?';
  int stepCount = 0;
  bool isOne = true;
  String strStep = "0";
  bool isPressed = false;
  Timer? timer;
  int timePassed = 0;
  int wpm = 0;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void walkingRate() {
    setState(() {
      if (stepCount != 0) {
        timePassed += 1;
        wpm = ((stepCount / timePassed) * 60).round();
      }
    });
  }

  void onStepCount(StepCount event) {
    if (kDebugMode) {
      print(event);
    }
    setState(() {
      if (isOne == true) {
        stepCount = 0;
        isOne = false;
      } else {
        stepCount += 1;
      }
      strStep = "$stepCount";
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    if (kDebugMode) {
      print(event);
    }
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    if (kDebugMode) {
      print('onPedestrianStatusError: $error');
    }
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    if (kDebugMode) {
      print(_status);
    }
  }

  void onStepCountError(error) {
    if (kDebugMode) {
      print('onStepCountError: $error');
    }
    setState(() {
      strStep = 'Step Count not available';
    });
  }

  void initPlatformState() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => walkingRate());

    setState(() {
      isPressed = true;
      isOne = true;
    });

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  void reset() {
    setState(() {
      isPressed = false;
      stepCount = 0;
      timePassed = 0;
      wpm = 0;
      strStep = "$stepCount";
    });

    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05, top: 30),
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text("Ready to move?", style: TextStyle(fontSize:35, fontWeight: FontWeight.bold))
            ),
          ),
          Container(
            height: 320,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0)
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 7),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text("Cue", style: TextStyle(fontSize:18, fontWeight: FontWeight.bold))
                    ),
                  ),
                  Center(
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xffF8F8F8),
                        borderRadius: BorderRadius.circular(12)),
                      child: CustomDropDown(
                        items: const [
                          CustomDropdownMenuItem(
                            value: 0,
                            child: Text("Metronome", style: TextStyle(fontSize:24, fontWeight: FontWeight.bold)),
                          ),
                          CustomDropdownMenuItem(
                            value: 1,
                            child: Text("Footfall", style: TextStyle(fontSize:24, fontWeight: FontWeight.bold)),
                          ),
                          CustomDropdownMenuItem(
                            value: 2,
                            child: Text("Verbal Cue", style: TextStyle(fontSize:24, fontWeight: FontWeight.bold)),
                          ),
                          CustomDropdownMenuItem(
                            value: 3,
                            child: Text("Video", style: TextStyle(fontSize:24, fontWeight: FontWeight.bold)),
                          ),
                        ],
                        hintText: "Choose Cue Type",
                        borderRadius: 5,
                        onChanged: (val) {

                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text("Rate", style: TextStyle(fontSize:18, fontWeight: FontWeight.bold))
                    ),
                  ),
                  Center(
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                          color: const Color(0xffF8F8F8),
                          borderRadius: BorderRadius.circular(12)),
                      child: CustomDropDown(
                        items: const [
                          CustomDropdownMenuItem(
                            value: 0,
                            child: Text("10 steps/min", style: TextStyle(fontSize:24, fontWeight: FontWeight.bold)),
                          ),
                          CustomDropdownMenuItem(
                            value: 1,
                            child: Text("20 steps/min", style: TextStyle(fontSize:24, fontWeight: FontWeight.bold)),
                          ),
                          CustomDropdownMenuItem(
                            value: 2,
                            child: Text("30 steps/min", style: TextStyle(fontSize:24, fontWeight: FontWeight.bold)),
                          ),
                          CustomDropdownMenuItem(
                            value: 3,
                            child: Text("40 steps/min", style: TextStyle(fontSize:24, fontWeight: FontWeight.bold)),
                          ),
                          CustomDropdownMenuItem(
                            value: 4,
                            child: Text("50 steps/min", style: TextStyle(fontSize:24, fontWeight: FontWeight.bold)),
                          ),
                          CustomDropdownMenuItem(
                            value: 5,
                            child: Text("60 steps/min", style: TextStyle(fontSize:24, fontWeight: FontWeight.bold)),
                          ),
                        ],
                        hintText: "Choose Rate",
                        borderRadius: 5,
                        onChanged: (val) {

                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text("Music", style: TextStyle(fontSize:18, fontWeight: FontWeight.bold))
                    ),
                  ),
                  Center(
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                          color: const Color(0xffF8F8F8),
                          borderRadius: BorderRadius.circular(12)),
                      child: CustomDropDown(
                        items: const [
                          CustomDropdownMenuItem(
                            value: 0,
                            child: Text("Metronome", style: TextStyle(fontSize:24, fontWeight: FontWeight.bold)),
                          ),
                          CustomDropdownMenuItem(
                            value: 1,
                            child: Text("Footfall", style: TextStyle(fontSize:24, fontWeight: FontWeight.bold)),
                          ),
                          CustomDropdownMenuItem(
                            value: 2,
                            child: Text("Verbal Cue", style: TextStyle(fontSize:24, fontWeight: FontWeight.bold)),
                          ),
                          CustomDropdownMenuItem(
                            value: 3,
                            child: Text("Video", style: TextStyle(fontSize:24, fontWeight: FontWeight.bold)),
                          ),
                        ],
                        hintText: "Choose Music",
                        borderRadius: 5,
                        onChanged: (val) {

                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
              width: double.infinity,
              height: 45,
              child: TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          )
                      )
                  ),
                  onPressed: () {
                    //TODO: Content function
                  },
                  child: const Text("Start Session", style: TextStyle(color: Colors.black)))),
        ],
      ),
    );
  }
}

class CustomDropDown<T> extends StatefulWidget {
  final List<CustomDropdownMenuItem> items;
  final Function onChanged;
  final String hintText;
  final double borderRadius;
  final double maxListHeight;
  final double borderWidth;
  final int defaultSelectedIndex;
  final bool enabled;

  const CustomDropDown(
      {required this.items,
        required this.onChanged,
        this.hintText = "",
        this.borderRadius = 0,
        this.borderWidth = 1,
        this.maxListHeight = 100,
        this.defaultSelectedIndex = -1,
        Key? key,
        this.enabled = true})
      : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown>
    with WidgetsBindingObserver {
  bool _isOpen = false, _isAnyItemSelected = false, _isReverse = false;
  late OverlayEntry _overlayEntry;
  late RenderBox? _renderBox;
  Widget? _itemSelected;
  late Offset dropDownOffset;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          dropDownOffset = getOffset();
        });
      }
      if (widget.defaultSelectedIndex > -1) {
        if (widget.defaultSelectedIndex < widget.items.length) {
          if (mounted) {
            setState(() {
              _isAnyItemSelected = true;
              _itemSelected = widget.items[widget.defaultSelectedIndex];
              widget.onChanged(widget.items[widget.defaultSelectedIndex].value);
            });
          }
        }
      }
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  void _addOverlay() {
    if (mounted) {
      setState(() {
        _isOpen = true;
      });
    }

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry);
  }

  void _removeOverlay() {
    if (mounted) {
      setState(() {
        _isOpen = false;
      });
      _overlayEntry.remove();
    }
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  OverlayEntry _createOverlayEntry() {
    _renderBox = context.findRenderObject() as RenderBox?;

    var size = _renderBox!.size;

    dropDownOffset = getOffset();

    return OverlayEntry(
        maintainState: false,
        builder: (context) => Align(
          alignment: Alignment.center,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: dropDownOffset,
            child: SizedBox(
              height: widget.maxListHeight + 60,
              width: size.width,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: _isReverse
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                      constraints: BoxConstraints(
                          maxHeight: widget.maxListHeight + 55,
                          maxWidth: size.width),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(widget.borderRadius),
                        ),
                        child: Material(
                          elevation: 0,
                          shadowColor: Colors.black,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            children: widget.items
                                .map((item) => GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
                                child: item.child,
                              ),
                              onTap: () {
                                if (mounted) {
                                  setState(() {
                                    _isAnyItemSelected = true;
                                    _itemSelected = item.child;
                                    _removeOverlay();
                                    widget.onChanged(item.value);
                                  });
                                }
                              },
                            ))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Offset getOffset() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    double y = renderBox!.localToGlobal(Offset.zero).dy;
    double spaceAvailable = _getAvailableSpace(y + renderBox.size.height);
    if (spaceAvailable > widget.maxListHeight) {
      _isReverse = false;
      return Offset(0, renderBox.size.height);
    } else {
      _isReverse = true;
      return Offset(
          0,
          renderBox.size.height -
              (widget.maxListHeight + renderBox.size.height));
    }
  }

  double _getAvailableSpace(double offsetY) {
    double safePaddingTop = MediaQuery.of(context).padding.top;
    double safePaddingBottom = MediaQuery.of(context).padding.bottom;

    double screenHeight =
        MediaQuery.of(context).size.height - safePaddingBottom - safePaddingTop;

    return screenHeight - offsetY;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: widget.enabled
            ? () {
          _isOpen ? _removeOverlay() : _addOverlay();
        }
            : null,
        child: Container(
          decoration: _getDecoration(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  flex: 3,
                  child: _isAnyItemSelected
                    ? _itemSelected!
                    : Text(
                      widget.hintText,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(fontSize:24, fontWeight: FontWeight.bold)
                    ),
                ),
                Flexible(
                  flex: 1,
                  child: !(_isOpen && !_isReverse) ? const Icon(Icons.arrow_drop_down) : const Icon(Icons.arrow_drop_up),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Decoration? _getDecoration() {
    if (_isOpen && !_isReverse) {
      return BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.borderRadius),
              topRight: Radius.circular(
                widget.borderRadius,
              )));
    } else if (_isOpen && _isReverse) {
      return BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(widget.borderRadius),
              bottomRight: Radius.circular(
                widget.borderRadius,
              )));
    } else if (!_isOpen) {
      return BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)));
    }
    return null;
  }
}

class CustomDropdownMenuItem<T> extends StatelessWidget {
  final T value;
  final Widget child;

  const CustomDropdownMenuItem({super.key, required this.value, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}