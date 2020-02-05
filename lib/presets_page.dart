import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

class PresetsPage extends StatefulWidget {
  PresetsPage({this.presetNames});

  final List<String> presetNames;

  @override
  _PresetsPageState createState() => _PresetsPageState();
}

class _PresetsPageState extends State<PresetsPage> {
  List<Map> _persons = [];

  TextEditingController _newPresetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.presetNames.length; i++) {
      _persons.add({
        'key': ValueKey(i),
        'name': widget.presetNames[i],
      });
    }
    // _presetNames = widget.presetNames;
  }

  int _indexOfKey(Key key) {
    return _persons.indexWhere((Map person) => person['key'] == key);
  }

  bool _reorderCallback(Key oldKey, Key newKey) {
    int draggingIndex = _indexOfKey(oldKey);
    int newPositionIndex = _indexOfKey(newKey);

    // Uncomment to allow only even target reorder possition
    // if (newPositionIndex % 2 == 1)
    //   return false;

    final draggedItem = _persons[draggingIndex];
    setState(() {
      debugPrint("Reordering $oldKey -> $newKey");
      _persons.removeAt(draggingIndex);
      _persons.insert(newPositionIndex, draggedItem);
    });

    return true;
  }

  void _addNewPreset() {
    if (_newPresetController.text != '')
      setState(() {
        _persons.add({
          'name': _newPresetController.text,
          'key': ValueKey(_persons.length),
        });
      });
    _newPresetController.clear();
  }

  void _removePreset(Map toBeRemoved) {
    setState(() {
      _persons.removeWhere((Map person) => person == toBeRemoved);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Preset Names'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              List<String> editedList = [];
              for (var person in _persons) {
                editedList.add(person['name']);
              }
              Navigator.of(context).pop(editedList);
            },
          ),
          // IconButton(
          //   icon: Icon(Icons.reorder),
          //   onPressed: () {
          //     Navigator.of(context).push(
          //         MaterialPageRoute(builder: (context) => MyReorderPage()));
          //   },
          // ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _newPresetController,
                    onChanged: (_) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      labelText: 'New Preset',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10.0),
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: Text('Add'),
                    onPressed: (_newPresetController.text.length == 0)
                        ? null
                        : _addNewPreset,
                    // TODO: Make button conditional
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ReorderableList(
              onReorder: _reorderCallback,
              child: ListView(
                // shrinkWrap: true,
                // itemCount: _persons.length,
                // itemBuilder: (context, index) {
                children: <Widget>[
                  for (var i = 0; i < _persons.length; i++)
                    OrderItem(
                      person: _persons[i],
                      isFirst: i == 0,
                      isLast: i == _persons.length - 1,
                      onRemoveCallback: _removePreset,
                    ),
                ],
                // },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  OrderItem({this.person, this.isFirst, this.isLast, this.onRemoveCallback});

  final Map person;
  final bool isFirst;
  final bool isLast;
  final onRemoveCallback;

  Widget _buildChild(context, state) {
    BoxDecoration deco;

    if (state == ReorderableItemState.dragProxy ||
        state == ReorderableItemState.dragProxyFinished) {
      // slightly transparent background white dragging (just like on iOS)
      deco = BoxDecoration(color: Color(0xD0FFFFFF));
    } else {
      bool placeholder = state == ReorderableItemState.placeholder;
      deco = BoxDecoration(
          border: Border(
              top: isFirst && !placeholder
                  ? Divider.createBorderSide(context) //
                  : BorderSide.none,
              bottom: isLast && placeholder
                  ? BorderSide.none //
                  : Divider.createBorderSide(context)),
          color: placeholder ? null : Colors.white);
    }

    return Container(
      decoration: deco,
      child: Opacity(
        // hide content for placeholder
        opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
                  child: Text('${person['name']}',
                      style: Theme.of(context).textTheme.subhead),
                ),
              ),
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  onRemoveCallback(person);
                },
              ),
              ReorderableListener(
                child: Container(
                  padding: EdgeInsets.only(right: 18.0, left: 18.0),
                  color: Colors.white,
                  child: Center(
                    child: Icon(Icons.drag_handle, color: Color(0xFF888888)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
      key: person['key'],
      childBuilder: _buildChild,
    );
  }
}
