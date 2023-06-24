import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
// import 'package:likk_picker/likk_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:expense_app/blocs/app_blocs.dart';
import 'package:expense_app/extensions/extensions.dart';
import 'package:expense_app/models/models.dart';

enum NewTransactionState {
  edit,
  add,
}

class NewTransaction extends StatefulWidget {
  final NewTransactionState state;
  final Budget budget;
  final Transaction? transaction;

  NewTransaction.add({
    Key? key, required this.budget,
  })  : this.state = NewTransactionState.add,
        this.transaction = null,
        super(key: key);

  NewTransaction.edit({
    Key? key, required this.budget,
    required this.transaction,
  })  : this.state = NewTransactionState.edit,
        super(key: key);

  @override
  _NewTransactionState createState() => _NewTransactionState(budget);
}

class _NewTransactionState extends State<NewTransaction> {
  final Budget budget;
  _NewTransactionState(this.budget);

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _pickedDate;
  File? _imageFile;
  Directory? _appLibraryDirectory;
  // GalleryController? _controller;

  @override
  void initState() {
    super.initState();
    _updateDirectory();
    // _controller = GalleryController(
    //   gallerySetting: GallerySetting(
    //     enableCamera: true,
    //     maximum: 1,
    //     requestType: RequestType.image,
    //     onItemClick: (entity, list) async {
    //       if (list.isNotEmpty) {
    //         final file = await list[0].entity.file;
    //         _updateImage(file!);
    //         Navigator.pop(context);
    //       }
    //     },
    //   ),
    // );

    if (widget.state == NewTransactionState.edit) {
      _titleController.text = widget.transaction!.title;
      _amountController.text = widget.transaction!.amount.toString();
      _pickedDate = widget.transaction!.date;
      _dateController.text = DateFormat.yMMMd().format(_pickedDate!);
      widget.transaction!.imagePath.isNotEmpty
          ? _imageFile = File(widget.transaction!.imagePath)
          : _imageFile = null;
    }
  }

  Future<void> _updateDirectory() async {
    _appLibraryDirectory = await getApplicationDocumentsDirectory();
    _appLibraryDirectory = await _appLibraryDirectory!.create();
  }

  void _updateImage(File image) {
    final fileExtension = image.path.split('.').last;
    if (fileExtension == 'jpg' ||
        fileExtension == 'jpeg' ||
        fileExtension == 'png') {
      setState(() {
        _imageFile = image;
      });
    }
  }

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    late File writtenFile;
    if (_imageFile != null) {
      final imageFilePath = '${_appLibraryDirectory!.path}/${const Uuid().v4()}.png';
      final emptyFile = await File(imageFilePath).create();
      writtenFile = await emptyFile.writeAsBytes(_imageFile!.readAsBytesSync());
    }
    final tBloc = context.read<TransactionsBloc>();
    final transaction = Transaction(
      id: widget.state == NewTransactionState.add
          ? const Uuid().v4()
          : widget.transaction!.id,
      title: _titleController.text,
      amount: double.parse(_amountController.text),
      date: _pickedDate!,
      category: budget.id,
      imagePath: _imageFile == null ? '' : writtenFile.path,
      createdOn: DateTime.now(),
    );
    if (widget.state == NewTransactionState.add) {
      tBloc.add(
        AddTransaction(transaction: transaction, budget: budget),
      );
    } else {
      tBloc.add(
        UpdateTransaction(transaction: transaction, budget: budget),
      );
    }
    Navigator.of(context).pop(transaction);
  }

  void _startDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.parse("2020-01-01 00:00:01Z"),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }
      _pickedDate = value;
      _dateController.text = DateFormat.yMMMd().format(_pickedDate!);
    });
  }

  @override
  void dispose() {
    // _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            18,
          ),
        ),
        elevation: 8,
        child: Container(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  controller: _titleController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Title cannot be empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Price',
                    prefixText: getCurrencySymbol(),
                  ),
                  keyboardType: TextInputType.number,
                  controller: _amountController,
                  onFieldSubmitted: (_) => _startDatePicker(),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Amount cannot be empty';
                    }
                    final price = double.tryParse(value);
                    if (price == null) {
                      return 'Please enter numbers only';
                    }
                    if (price <= 0) {
                      return 'Price must be greater than 0';
                    }
                    if (price >= 1000000) {
                      return 'Price must be less than 100,00,00';
                    }
                    return null;
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                    bottom: 30,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          controller: _dateController,
                          decoration: const InputDecoration(labelText: 'Date'),
                          enableInteractiveSelection: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please pick a date';
                            }
                            return null;
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: _startDatePicker,
                        child: Text(
                          'Choose Date',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(fontSize: 20),)),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: _onSubmit,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 10))
                      ),
                      child: Text(
                        widget.state == NewTransactionState.add
                            ? 'Add Transaction'
                            : 'Update',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
