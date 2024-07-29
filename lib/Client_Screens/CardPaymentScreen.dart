import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardPaymentScreen extends StatefulWidget {
  const CardPaymentScreen({super.key});

  @override
  _CardPaymentScreenState createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expireDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderNameController = TextEditingController();

  bool _isProcessing = false;
  bool _paymentSuccess = false;
  String _paymentMessage = '';
  String? _selectedPaymentMethod;

  String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your card number';
    } else if (value.length != 16) {
      return 'Card number must be 16 digits';
    }
    return null;
  }

  String? validateExpireDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the expiration date';
    } else if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
      return 'Enter expiration date in MM/YY format';
    } else {
      final parts = value.split('/');
      final month = int.tryParse(parts[0]);
      final year = int.tryParse(parts[1]);

      if (month == null || month < 1 || month > 12) {
        return 'Enter a valid month (01-12)';
      }
      if (year == null || year < 0) {
        return 'Enter a valid year';
      }
    }
    return null;
  }

  String? validateCvv(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the CVV';
    } else if (value.length != 3) {
      return 'CVV must be 3 digits';
    }
    return null;
  }

  String? validateCardHolderName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the cardholder name';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedPaymentMethod != null) {
      setState(() {
        _isProcessing = true;
        _paymentSuccess = false;
        _paymentMessage = '';
      });

      // Simulate a payment processing delay
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isProcessing = false;
          _paymentSuccess = true;
          _paymentMessage = 'Payment successful!';
        });

        // Show a success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Payment Status'),
            content: Text(_paymentMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (_paymentSuccess) {
                    Navigator.pushNamed(context, '/pay.slipcard');
                  }
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      });
    } else if (_selectedPaymentMethod == null) {
      setState(() {
        _paymentMessage = 'Please select a payment method';
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Payment Status'),
          content: Text(_paymentMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //title: Text(''),
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Card Payment',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Radio<String>(
                                value: 'Mastercard',
                                groupValue: _selectedPaymentMethod,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedPaymentMethod = value;
                                  });
                                },
                              ),
                            ),
                            Flexible(
                              child: Image.network(
                                'https://w7.pngwing.com/pngs/397/885/png-transparent-logo-mastercard-product-font-mastercard-text-orange-logo-thumbnail.png',
                                width: 50,
                              ),
                            ),
                            Flexible(
                              child: Radio<String>(
                                value: 'Visa',
                                groupValue: _selectedPaymentMethod,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedPaymentMethod = value;
                                  });
                                },
                              ),
                            ),
                            Flexible(
                              child: Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/4/41/Visa_Logo.png',
                                width: 50,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _cardNumberController,
                          decoration: InputDecoration(
                            labelText: 'Card Number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: validateCardNumber,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _expireDateController,
                          decoration: InputDecoration(
                            labelText: 'Expire Date (MM/YY)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(5),
                          ],
                          validator: validateExpireDate,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _cvvController,
                          decoration: InputDecoration(
                            labelText: 'CVV',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: validateCvv,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _cardHolderNameController,
                          decoration: InputDecoration(
                            labelText: 'Card Holder Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: validateCardHolderName,
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: (_formKey.currentState?.validate() ?? false) &&
                                    _selectedPaymentMethod != null
                                ? () {
                                    _submitForm();
                                  }
                                : null,
                            child: Text('Submit'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
