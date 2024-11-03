import 'package:flutter/material.dart';

class Sub extends StatefulWidget {
  const Sub(this.builder, {super.key});
  final Widget Function(BuildContext context) builder;

  @override
  State<Sub> createState() => _SubState();
}

class _SubState extends State<Sub> {
  static _SubState? _currentState;
  final List<Pub> _publishers = [];

  void addPublisher(Pub publisher) {
    if (!_publishers.contains(publisher)) {
      _publishers.add(publisher);
      publisher.addListener(_update);
    }
  }

  void _update() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    for (var publisher in _publishers) {
      publisher.removeListener(_update);
    }
    _publishers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final previousState = _currentState;
    _currentState = this;
    final result = widget.builder(context);
    _currentState = previousState;
    return result;
  }
}

abstract class Pub extends ChangeNotifier {
  T get<T>(T value) {
    final currentState = _SubState._currentState;
    if (currentState != null) {
      currentState.addPublisher(this);
    }
    return value;
  }
}
