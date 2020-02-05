import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:raven/models/debt_model.dart';

class EditDebtPage extends StatefulWidget {
  @override
  _EditDebtPageState createState() => _EditDebtPageState();

  final List<String> presets;

  EditDebtPage({@required this.presets});
}

class _EditDebtPageState extends State<EditDebtPage> {
  List<bool> _whoOwesWho = [true, false];

  FocusScopeNode _focusScopeNode = FocusScopeNode();
  TextEditingController _nameController = TextEditingController();
  MoneyMaskedTextController _amountController = MoneyMaskedTextController(
    thousandSeparator: ',',
    decimalSeparator: '.',
  );
  TextEditingController _reasonController = TextEditingController();

  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _moveToNextField() {
    _focusScopeNode.nextFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Debt'),
        // actions: <Widget>[
        //   FlatButton(
        //     onPressed: () {},
        //     child: Text('ADD'),
        //     textColor: Colors.white,
        //   )
        // ],
      ),
      body: FocusScope(
        node: _focusScopeNode,
        child: ListView(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            bottom: 80.0,
          ),
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                controller: _nameController,
                onEditingComplete: _moveToNextField,
                // TODO: See if this impact performance
                // onChanged: (_) {
                //   setState(() {});
                // },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  // hintText: 'E.g.: John Dough',
                  suffixIcon: (_nameController.text.length == 0)
                      ? null
                      : IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _nameController.clear();
                            });
                          },
                        ),
                ),
              ),
            ),
            _buildChips(),
            _buildToggleButtons(),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              onEditingComplete: _moveToNextField,
              showCursor: false,
              enableInteractiveSelection: false,
              decoration: InputDecoration(
                icon: Text('RM'),
                border: OutlineInputBorder(),
                labelText: 'Amount',
              ),
            ),
            SizedBox(
              height: 50.0,
              child: Center(
                child: Text('for'),
              ),
            ),
            TextField(
              controller: _reasonController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Reason',
                suffixIcon:
                    (_reasonController.text == '') ? null : Icon(Icons.clear),
              ),
            ),
          ],
        ),
      ),
      // bottomSheet: BottomSheet(
      //   onClosing: () {},
      //   builder: (BuildContext context) {
      //     return Container(height: 50.0, color: Colors.red);
      //   },
      // ),
      // bottomNavigationBar: BottomAppBar(
      //   // color: Colors.red,
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
      //     child: ,
      //   ),
      // ),
      floatingActionButton: FloatingActionButton.extended(
        label: Row(
          children: <Widget>[
            Text('ADD'),
            // Icon(Icons.check),
          ],
        ),
        shape: StadiumBorder(),
        onPressed: () {},
      ),
    );
    // actions: <Widget>[
    //   FlatButton(
    //     child: Text('Cancel'),
    //     onPressed: () {
    //       Navigator.of(context).pop();
    //     },
    //   ),
    //   FlatButton(
    //     child: Text('OK'),
    //     onPressed: () {
    //       Navigator.of(context).pop(
    //         Debt(
    //           name: _nameController.text,
    //           reason: _reasonController.text,
    //           amount: _amountController.numberValue,
    //           owesMe: _whoOwesWho[0],
    //         ),
    //       );
    //       // Navigator.of(context).pop({
    //       //   'name': _nameController.text,
    //       //   'amount': _amountController.numberValue,
    //       //   'reason': _reasonController.text,
    //       //   'owesMe': _whoOwesWho[0],
    //       // });
    //     },
    //   ),
    // ],
  }

  Widget _buildChips() {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      spacing: 5.0,
      children: widget.presets.map((String friendName) {
        return InputChip(
          label: Text('$friendName'),
          onPressed: () {
            // setState(() {
            _nameController.text = '$friendName';
            // });
            //TODO: set cursor to the end of text
          },
        );
      }).toList(),
    );
  }

  Widget _buildToggleButtons() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: ToggleButtons(
        isSelected: _whoOwesWho,
        children: <Widget>[
          Container(
            width: 100.0,
            alignment: Alignment.center,
            child: Text('borrowed my'),
          ),
          Container(
            width: 100.0,
            alignment: Alignment.center,
            child: Text('lent me'),
          ),
        ],
        onPressed: (int index) {
          setState(() {
            for (int i = 0; i < _whoOwesWho.length; i++) {
              _whoOwesWho[i] = (i == index);
            }
          });
        },
      ),
    );
  }
}
