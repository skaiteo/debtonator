import 'package:flutter/material.dart';
import 'package:raven/about_page.dart';
import 'package:raven/components/debt_card.dart';
import 'package:raven/models/debt_model.dart';
import 'package:raven/models/sp_helper.dart';
import 'package:raven/presets_page.dart';
import 'package:raven/components/settled_debt_tile.dart';
import 'package:raven/edit_debt_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(title: 'Debtonator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum MoreOptions { editPresets, about }

class _MyHomePageState extends State<MyHomePage> {
  bool _isSettledExpanded = false;
  List<Debt> _debts = [];
  // List<Map> _settledDebts = [];
  List<String> _presetNames = [];

  // constants for SharedPreferences keys
  final String kDebts = 'debts';
  // final String kSettledDebts = 'settledDebts';
  final String kPresets = 'presetNames';

  Future _debtFuture;

  @override
  void initState() {
    super.initState();
    _debtFuture = fetchInitialData();
  }

  Future fetchInitialData() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // List _sDebts = jsonDecode(prefs.getString(kDebts) ?? '[]');
    // List _sSettledDebts = jsonDecode(prefs.getString(kSettledDebts) ?? '[]');
    // List _sPresetNames = jsonDecode(prefs.getString(kPresets) ?? '[]');
    List<Debt> debts = await SpHelper.getDebts();
    List<String> presetNames = await SpHelper.getPresets();
    // List<String> sTestStringPresets = new List<String>.from(_sPresetNames);
    setState(() {
      _debts = debts;
      // _settledDebts = allData['settledDebts'];
      _presetNames = presetNames;
    });
    // await Future.delayed(Duration(milliseconds: 100));
  }

  void _updatePresetNames(List presetNames) async {
    setState(() {
      _presetNames = presetNames;
    });
    await SpHelper.savePresets(presetNames);
  }

  void _showNewDebtAlert(BuildContext context) async {
    // Debt _newDebt = await showDialog<Debt>(
    //   context: context,
    //   barrierDismissible: false, // user must tap button!
    //   builder: (BuildContext context) {
    //     return NewDebtDialog(presets: _presetNames);
    //   },
    // );
    Debt newDebt = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditDebtPage(presets: _presetNames),
      ),
    );

    if (newDebt != null) {
      setState(() {
        _debts.insert(0, newDebt);
      });
      await SpHelper.saveDebts(_debts);
    }
  }

  // // Callback for moving debt from _debts to _settledDebts
  // void _settleDebt(index) async {
  //   setState(() {
  //     // _settledDebts.insert(0, _debts.removeAt(index));
  //     _debts[index].isSettled = true;
  //   });
  //   await SpHelper.saveDebts(_debts);
  // }

  // // Callback for moving debt back from _settledDebts to _debts
  // void _restoreDebt(index) async {
  //   setState(() {
  //     // _debts.insert(0, _settledDebts.removeAt(index));
  //     _debts[index].isSettled = false;
  //   });
  //   await SpHelper.saveDebts(_debts);
  // }

  // // Callback for removing one debt from _settledDebts
  // void _removeDebt(index) async {
  //   setState(() {
  //     // _settledDebts.removeAt(index);
  //     _debts.removeAt(index);
  //   });
  //   await SpHelper.saveDebts(_debts);
  // }

  void _clearAllSettled() async {
    setState(() {
      _debts.removeWhere((Debt debt) {
        return debt.isSettled == true;
      });
    });
    await SpHelper.saveDebts(_debts);
  }

  void _handlePopupSelection(MoreOptions selection) async {
    List<String> newPresets = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          switch (selection) {
            case MoreOptions.editPresets:
              return PresetsPage(
                presetNames: _presetNames,
              );
              break;
            case MoreOptions.about:
              return AboutPage();
              break;
            default:
              return null;
          }
        },
      ),
    );

    if (selection == MoreOptions.editPresets && newPresets != null)
      _updatePresetNames(newPresets);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _debtFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              actions: <Widget>[
                PopupMenuButton<MoreOptions>(
                  onSelected: _handlePopupSelection,
                  itemBuilder: (context) => <PopupMenuEntry<MoreOptions>>[
                    PopupMenuItem<MoreOptions>(
                      child: ListTile(
                        title: Text('Preset names'),
                        leading: Icon(Icons.edit),
                      ),
                      value: MoreOptions.editPresets,
                    ),
                    PopupMenuItem<MoreOptions>(
                      child: ListTile(
                        title: Text('About'),
                        leading: Icon(Icons.info_outline),
                      ),
                      value: MoreOptions.about,
                    ),
                  ],
                ),
              ],
            ),
            body: ListView(
              padding: EdgeInsets.only(
                top: 5.0,
                bottom: 90.0,
              ),
              children: <Widget>[
                _buildDebts(),
                _buildSettledDebts(),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              // TODO: Maybe change this whole thing to show a page instead
              onPressed: () => _showNewDebtAlert(context),
              tooltip: 'Add New Debt',
              child: Icon(Icons.add),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('error'),
            ),
          );
        } else {
          // return Center(
          //   child: CircularProgressIndicator(),
          // );
          // Loaded too fast for indicator to be useful
          return Scaffold();
        }
      },
    );
  }

  Widget _buildDebts() {
    List<Widget> debts = <Widget>[];

    for (var i = 0; i < _debts.length; i++) {
      if (!_debts[i].isSettled) {
        debts.add(
          DebtCard(
            debt: _debts[i],
            settleDebtCallback: () async {
              setState(() {
                // _settledDebts.insert(0, _debts.removeAt(index));
                _debts[i].isSettled = true;
              });
              await SpHelper.saveDebts(_debts);
            },
          ),
        );
      }
    }

    if (debts.isEmpty) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: <Widget>[
            Icon(
              Icons.sentiment_very_satisfied,
              color: Colors.grey[600],
            ),
            Text(
              'No debts, we\'re cool!',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: debts,
      );
    }
  }

  Widget _buildSettledDebts() {
    List<Widget> settled = [];
    // List<Debt> settled = [];
    for (var i = 0; i < _debts.length; i++) {
      if (_debts[i].isSettled) {
        settled.add(
          SettledDebtTile(
            debt: _debts[i],
            restoreDebtCallback: () async {
              setState(() {
                _debts[i].isSettled = false;
              });
              await SpHelper.saveDebts(_debts);
            },
            removeDebtCallback: () async {
              setState(() {
                _debts.removeAt(i);
              });
              await SpHelper.saveDebts(_debts);
            },
          ),
        );
      }
    }
    settled.add(
      Visibility(
        visible: settled.isNotEmpty,
        child: RaisedButton(
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          child: Text('Clear all settled debts'),
          onPressed: _clearAllSettled,
        ),
      ),
    );

    return ExpansionTile(
      initiallyExpanded: _isSettledExpanded,
      onExpansionChanged: (newIsExpanded) {
        setState(() {
          _isSettledExpanded = newIsExpanded;
        });
      },
      title: Text('Settled debts'),
      children: settled,
    );
  }
}
