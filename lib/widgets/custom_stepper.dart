import 'package:flutter/material.dart';

class CustomStepper extends StatefulWidget {
  const CustomStepper({
    super.key,
    required this.steps,
    this.type = StepperType.vertical,
    this.currentStep = 0,
    required this.circleView,
    required this.lineColor,
  }) : assert(0 <= currentStep && currentStep < steps.length);

  final List<Step> steps;

  final StepperType type;

  final int currentStep;

  final List<Widget> circleView;

  final Color lineColor;

  @override
  State<CustomStepper> createState() => _StepperState();
}

class _StepperState extends State<CustomStepper> with TickerProviderStateMixin {
  late List<GlobalKey> _keys;
  final Map<int, StepState> _oldStates = <int, StepState>{};

  @override
  void initState() {
    super.initState();
    _keys = List<GlobalKey>.generate(
      widget.steps.length,
      (int i) => GlobalKey(),
    );

    for (int i = 0; i < widget.steps.length; i += 1) {
      _oldStates[i] = widget.steps[i].state;
    }
  }

  @override
  void didUpdateWidget(CustomStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(widget.steps.length == oldWidget.steps.length);

    for (int i = 0; i < oldWidget.steps.length; i += 1) {
      _oldStates[i] = oldWidget.steps[i].state;
    }
  }

  bool _isFirst(int index) {
    return index == 0;
  }

  bool _isLast(int index) {
    return widget.steps.length - 1 == index;
  }

  Widget _buildLine(bool visible) {
    return Container(
      width: visible ? 1.0 : 0.0,
      height: 16.0,
      color: widget.lineColor,
    );
  }

  Widget _buildHeaderText(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        widget.steps[index].title,
        if (widget.steps[index].subtitle != null)
          Container(
            margin: const EdgeInsets.only(top: 2.0),
            child: widget.steps[index].subtitle!,
          ),
      ],
    );
  }

  Widget _buildVerticalHeader(int index) {
    return Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            _buildLine(!_isFirst(index)),
            widget.circleView[index],
            _buildLine(!_isLast(index)),
          ],
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsetsDirectional.only(start: 12.0),
            child: _buildHeaderText(index),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalBody(int index) {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      padding: const EdgeInsets.only(left: 20, bottom: 12),
      decoration: BoxDecoration(
        border: !_isLast(index)
            ? Border(left: BorderSide(color: widget.lineColor))
            : null,
      ),
      child: widget.steps[index].content,
    );
  }

  Widget _buildVertical() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        for (int i = 0; i < widget.steps.length; i += 1)
          Column(
            key: _keys[i],
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildVerticalHeader(i),
              _buildVerticalBody(i),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case StepperType.vertical:
        return _buildVertical();
      case StepperType.horizontal:
        return _buildHorizontal();
    }
  }

  Widget _buildHorizontal() {
    return Container();
  }
}
