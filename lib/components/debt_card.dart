import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:raven/models/debt_model.dart';

// To keep only one Slidable open
final SlidableController slidableController = SlidableController();

class DebtCard extends StatelessWidget {
  DebtCard({Debt debt, settleDebtCallback})
      :
        // : this._index = index,
        this._debt = debt,
        this._settleDebt = settleDebtCallback;

  // final int _index;
  final Debt _debt;
  final _settleDebt;
  final _moneyFormat = NumberFormat.compactCurrency(
    symbol: 'RM',
    decimalDigits: 2,
  );
  final _dateFormat = DateFormat.yMMMEd();
  final _timeFormat = DateFormat.Hm();

  @override
  Widget build(BuildContext context) {
    return Card(
      // TODO: Find out if Slidable can even be put in a card
      // TODO: Maybe change to an expansion tile
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Slidable(
          controller: slidableController,
          actionPane: SlidableBehindActionPane(),
          actionExtentRatio: 0.20,
          child: Container(
            color: _debt.owesMe ? Colors.green[50] : Colors.red[50],
            child: ListTile(
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(_debt.owesMe
                        ? '${_debt.name} owes me'
                        : 'I owe ${_debt.name}'),
                  ),
                  Text('${_moneyFormat.format(_debt.amount)}'),
                ],
              ),
              subtitle: Text('${_debt.reason}'),
              // trailing: IconButton(
              //   icon: Icon(Icons.edit),
              //   onPressed: () {},
              //   // padding: EdgeInsets.all(0.0),
              // ),
              trailing: InkWell(
                onTap: () {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('pressed'),
                    ),
                  );
                },
                child: Icon(Icons.edit),
              ),
            ),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Settled',
              icon: Icons.check,
              color: Theme.of(context).primaryColorDark,
              onTap: _settleDebt,
            )
          ],
        ),
      ),
    );
  }
}
