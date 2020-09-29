import 'package:flutter/material.dart';
import 'package:flutter_app/list-item.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Update AnimatedList data')),
        body: BodyWidget(),
      ),
    );
  }
}

class BodyWidget extends StatefulWidget {
  @override
  BodyWidgetState createState() {
    return new BodyWidgetState();
  }
}

class BodyWidgetState extends State<BodyWidget> {
  // the GlobalKey is needed to animate the list
  final GlobalKey<AnimatedListState> _listKey = GlobalKey(); // backing data
  List<String> _data = ['Horse', 'Cow', 'Camel', 'Sheep', 'Goat'];
  var selectedItemIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 500,
          child: AnimatedList(
            key: _listKey,
            initialItemCount: _data.length,
            itemBuilder: (context, index, animation) {
              return _buildItem(_data[index], animation, index);
            },
          ),
        ),
        RaisedButton(
          child: Text(
            'Insert single item',
            style: TextStyle(fontSize: 20),
          ),
          onPressed: () {
            _onButtonPress();
          },
        )
      ],
    );
  }

  Widget _buildItem(String item, Animation animation, int index) {
//    return ListItem();
    _onPress() {
      setState(() {
        if (this.selectedItemIndex == index) {
          selectedItemIndex = -1;
        } else {
          selectedItemIndex = index;
        }
      });
    }

    return SizeTransition(
      sizeFactor: animation,
      child: ListItem(
        onPress: _onPress,
        isFocus: this.selectedItemIndex == index,
      ),
    );
  }

  Future<void> _onButtonPress() async {
    // replace this with method choice below
//    _insertSingleItem();
//    _insertSingleItem();
    final PrinterNetworkManager printerManager = PrinterNetworkManager();

    printerManager.selectPrinter('192.168.0.240', port: 9100);

    final PosPrintResult res =
        await printerManager.printTicket(await testTicket());
    print('Print result: ${res.msg}');
  }

  Future<Ticket> testTicket() async {
    final profile = await CapabilityProfile.load();
    final Ticket ticket = Ticket(PaperSize.mm80, profile);

    ticket.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    ticket.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
        styles: PosStyles(codeTable: 'CP1252'));
    ticket.text('Special 2: blåbærgrød', styles: PosStyles(codeTable: 'CP1252'));

    ticket.text('Bold text', styles: PosStyles(bold: true));
    ticket.text('Reverse text', styles: PosStyles(reverse: true));
    ticket.text('Underlined text',
        styles: PosStyles(underline: true), linesAfter: 1);
    ticket.text('Align left', styles: PosStyles(align: PosAlign.left));
    ticket.text('Align center', styles: PosStyles(align: PosAlign.center));
    ticket.text('Align right',
        styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    ticket.row([
      PosColumn(
        text: 'col3',
        width: 3,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col6',
        width: 6,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col3',
        width: 3,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);

    ticket.text('Text size 200%',
        styles: PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    // Print image
    // final ByteData data = await rootBundle.load('assets/logo.png');
    // final Uint8List bytes = data.buffer.asUint8List();
    // final Image image = decodeImage(bytes);
    // ticket.image(image);
    // Print image using alternative commands
    // ticket.imageRaster(image);
    // ticket.imageRaster(image, imageFn: PosImageFn.graphics);

    // Print barcode
    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    ticket.barcode(Barcode.upcA(barData));

    // Print mixed (chinese + latin) text. Only for printers supporting Kanji mode
    // ticket.text(
    //   'hello ! 中文字 # world @ éphémère &',
    //   styles: PosStyles(codeTable: PosCodeTable.westEur),
    //   containsChinese: true,
    // );

    ticket.feed(2);

    ticket.cut();
    return ticket;
  }

  void _insertSingleItem() {
    String item = "Pig";
    int insertIndex = 2;
    _data.insert(insertIndex, item);
    _listKey.currentState.insertItem(insertIndex);
  }

  void _insertMultipleItems() {
    final items = ['Pig', 'Chichen', 'Dog'];
    int insertIndex = 2;
    _data.insertAll(insertIndex, items);
    // This is a bit of a hack because currentState doesn't have
    // an insertAll() method.
    for (int offset = 0; offset < items.length; offset++) {
      _listKey.currentState.insertItem(insertIndex + offset);
    }
  }

  void _removeSingleItems() {
    int removeIndex = 2;
    String removedItem = _data.removeAt(removeIndex);
    // This builder is just so that the animation has something
    // to work with before it disappears from view since the
    // original has already been deleted.
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      // A method to build the Card widget.
      return _buildItem(removedItem, animation, removeIndex);
    };
    _listKey.currentState.removeItem(removeIndex, builder);
  }

  void _removeMultipleItems() {
    int removeIndex = 2;
    int count = 2;
    for (int i = 0; i < count; i++) {
      String removedItem = _data.removeAt(removeIndex);
      AnimatedListRemovedItemBuilder builder = (context, animation) {
        return _buildItem(removedItem, animation, removeIndex);
      };
      _listKey.currentState.removeItem(removeIndex, builder);
    }
  }

  void _removeAllItems() {
    final length = _data.length;
    for (int i = length - 1; i >= 0; i--) {
      String removedItem = _data.removeAt(i);
      AnimatedListRemovedItemBuilder builder = (context, animation) {
        return _buildItem(removedItem, animation, i);
      };
      _listKey.currentState.removeItem(i, builder);
    }
  }

  void _updateSingleItem() {
    final newValue = 'I like sheep';
    final index = 3;
    setState(() {
      _data[index] = newValue;
    });
  }
}