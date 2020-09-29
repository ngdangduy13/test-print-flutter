import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListItem extends StatefulWidget {

  ListItem({@required this.onPress, this.isFocus});

  final onPress;
  final isFocus;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ListItem();
  }
}

class _ListItem extends State<ListItem> with TickerProviderStateMixin {
  double _height = 20.0;
  double _width = 80.0;
  var _color = Colors.blue;
  bool _resized = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        setState(() {
          this.widget.onPress();
        });
      },
      child: Container(
//        color: _color,
        child: AnimatedSize(
          curve: Curves.linearToEaseOut,
          vsync: this,
          duration: Duration(milliseconds: 600),
          child: Container(
//            width: _width,
//            height: _height,
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                border: Border.all(color: this.widget.isFocus ? Colors.blueAccent : Colors.white, width: this.widget.isFocus ? 1 : 0)
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Product 1'),
                    Text('\$100')
                  ],
                ),
                this.widget.isFocus ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Product 1'),
                    Text('\$100')
                  ],
                ): Container(),
                this.widget.isFocus ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Product 1'),
                    Text('\$100')
                  ],
                ): Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}