import 'package:flutter/material.dart';
import 'package:raven/models/debt_model.dart';

class SettledDebtTile extends StatelessWidget {
  SettledDebtTile({Debt debt, restoreDebtCallback, removeDebtCallback})
      :
        // : this._index = index,
        this._debt = debt,
        this._restoreDebt = restoreDebtCallback,
        this._removeDebt = removeDebtCallback;

  // final int _index;
  final Debt _debt;
  final _restoreDebt;
  final _removeDebt;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.vertical_align_top),
        onPressed: () => _restoreDebt,
      ),
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
                _debt.owesMe ? '${_debt.name} paid me' : 'Paid ${_debt.name}'),
          ),
          Text('RM${_debt.amount}')
        ],
      ),
      subtitle: Text('${_debt.reason}'),
      trailing: IconButton(
        icon: Icon(Icons.clear),
        onPressed: _removeDebt,
      ),
    );
  }
}
