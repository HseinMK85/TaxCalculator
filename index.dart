import 'package:flutter/material.dart';

void main() {
  runApp(PayrollTaxCalculatorApp());
}

class PayrollTaxCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PayrollCalculatorScreen(),
    );
  }
}

class PayrollCalculatorScreen extends StatefulWidget {
  @override
  _PayrollCalculatorScreenState createState() =>
      _PayrollCalculatorScreenState();
}

class _PayrollCalculatorScreenState extends State<PayrollCalculatorScreen> {
  // Controllers for input fields
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _allowancesController = TextEditingController();
  final TextEditingController _deductionsController = TextEditingController();

  String _selectedCurrency = 'USD';
  String _result = '';

  // Tax slabs (generalized system)
  double calculateTax(double income) {
    if (income <= 10000) {
      return 0;
    } else if (income <= 50000) {
      return (income - 10000) * 0.10;
    } else {
      return (40000 * 0.10) + ((income - 50000) * 0.20);
    }
  }

  // Updated currency conversion rate
  double convertToLBP(double amount) => amount * 89700; 

  void calculatePayroll() {
    final salary = double.tryParse(_salaryController.text) ?? 0.0;
    final allowances = double.tryParse(_allowancesController.text) ?? 0.0;
    final deductions = double.tryParse(_deductionsController.text) ?? 0.0;

    final grossIncome = salary + allowances;
    final tax = calculateTax(grossIncome);
    final netIncome = grossIncome - tax - deductions;

    double finalNetIncome =
        _selectedCurrency == 'LBP' ? convertToLBP(netIncome) : netIncome;

    setState(() {
      _result =
          "Gross Income: ${_selectedCurrency == 'LBP' ? convertToLBP(grossIncome).toStringAsFixed(2) : grossIncome.toStringAsFixed(2)} $_selectedCurrency\n"
          "Tax: ${_selectedCurrency == 'LBP' ? convertToLBP(tax).toStringAsFixed(2) : tax.toStringAsFixed(2)} $_selectedCurrency\n"
          "Net Income: ${finalNetIncome.toStringAsFixed(2)} $_selectedCurrency";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payroll and Tax Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _salaryController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Basic Salary'),
            ),
            TextField(
              controller: _allowancesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Allowances',
                hintText: 'E.g., Transportation, medical, meals',
              ),
            ),
            TextField(
              controller: _deductionsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Deductions',
                hintText: 'E.g., Loan, absence penalty',
              ),
            ),
            DropdownButton<String>(
              value: _selectedCurrency,
              items: ['USD', 'LBP'].map((String currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCurrency = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: calculatePayroll,
                child: Text('Calculate'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _result,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
