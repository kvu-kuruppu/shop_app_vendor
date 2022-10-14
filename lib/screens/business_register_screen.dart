import 'dart:io';
import 'dart:async';

import 'package:csc_picker/csc_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app_vendor/constants/routes.dart';
import 'package:shop_app_vendor/services/firebase_services.dart';

class BusinessRegisterScreen extends StatefulWidget {
  const BusinessRegisterScreen({Key? key}) : super(key: key);

  @override
  State<BusinessRegisterScreen> createState() => _BusinessRegisterScreenState();
}

class _BusinessRegisterScreenState extends State<BusinessRegisterScreen> {
  final FirebaseService _services = FirebaseService();
  final _formkey = GlobalKey<FormState>();
  final _businessNameInput = TextEditingController();
  final _contactNoInput = TextEditingController();
  final _emailInput = TextEditingController();
  final _gstNoInput = TextEditingController();
  final _pinCodeInput = TextEditingController();
  final _landmarkInput = TextEditingController();
  String? _businessName;
  String? _taxStatus;
  XFile? _shopImg;
  final ImagePicker _picker = ImagePicker();
  XFile? _logo;
  String? countryValue;
  String? stateValue;
  String? cityValue;
  String? _shopImgURL;
  String? _logoURL;

  Widget _formField({
    TextEditingController? controller,
    String? label,
    TextInputType? type,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
      ),
      validator: validator,
      onChanged: (value) {
        if (controller == _businessNameInput) {
          setState(() {
            _businessName = value;
          });
        }
      },
    );
  }

  Future<XFile?> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  _scaffold({msg}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).clearSnackBars();
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: Stack(
                children: [
                  _shopImg == null
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: TextButton(
                            onPressed: () {
                              pickImage().then((value) {
                                setState(() {
                                  _shopImg = value;
                                });
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.upload,
                                  size: 80,
                                  color: Colors.black,
                                ),
                                Text(
                                  'Click here to upload an image',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            pickImage().then((value) {
                              setState(() {
                                _shopImg = value;
                              });
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              image: DecorationImage(
                                image: FileImage(
                                  File(_shopImg!.path),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                  Positioned(
                    top: 30,
                    right: 10,
                    child: Card(
                      shape: const CircleBorder(),
                      color: Colors.white.withOpacity(0.7),
                      child: IconButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                        icon: const Icon(Icons.logout),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              pickImage().then((value) {
                                setState(() {
                                  _logo = value;
                                });
                              });
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Card(
                                color: Colors.white.withOpacity(0.7),
                                child: _logo == null
                                    ? const SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: Center(child: Icon(Icons.add)),
                                      )
                                    : SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: Image.file(
                                          File(_logo!.path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Card(
                            color: Colors.white.withOpacity(0.7),
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  _businessName != null
                                      ? _businessName!
                                      : 'Business Name',
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    // Business Name Input
                    _formField(
                      controller: _businessNameInput,
                      label: 'Business Name',
                      type: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Business Name is required';
                        }
                      },
                    ),
                    // Contact No Input
                    _formField(
                      controller: _contactNoInput,
                      label: 'Contact No',
                      type: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Contact No is required';
                        }
                      },
                    ),
                    // Email Input
                    _formField(
                      controller: _emailInput,
                      label: 'Email',
                      type: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email is required';
                        }
                        if (!EmailValidator.validate(value)) {
                          return 'Enter Valid Email';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tax Registered: ',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: 100,
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButtonFormField(
                              value: _taxStatus,
                              items: <String>[
                                'Yes',
                                'No'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _taxStatus = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Select Tax Status';
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_taxStatus == 'Yes')
                      // GST No Input
                      _formField(
                        controller: _gstNoInput,
                        label: 'GST No',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'GST No is required';
                          }
                        },
                      ),
                    // PIN Code Input
                    _formField(
                      controller: _pinCodeInput,
                      label: 'PIN Code',
                      type: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'PIN Code is required';
                        }
                      },
                    ),
                    // Landmark Input
                    _formField(
                      controller: _landmarkInput,
                      label: 'Landmark',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Landmark is required';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    cscMethod(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_shopImg == null) {
                      _scaffold(msg: 'Shop Image not selected');
                      return;
                    }
                    if (_logo == null) {
                      _scaffold(msg: 'Logo not selected');
                      return;
                    }
                    if (_formkey.currentState!.validate()) {
                      if (countryValue == null ||
                          stateValue == null ||
                          cityValue == null) {
                        _scaffold(
                            msg: 'Country, State and City are not selected');
                        return;
                      }
                      EasyLoading.show(status: 'Please Wait');
                      _services
                          .uploadImg(
                              file: _shopImg,
                              reference:
                                  'vendors/${_services.user!.uid}/shop_image')
                          .then((url) {
                        if (url.isNotEmpty) {
                          setState(() {
                            _shopImgURL = url;
                          });
                        }
                      }).then((value) {
                        _services
                            .uploadImg(
                                file: _logo,
                                reference:
                                    'vendors/${_services.user!.uid}/logo')
                            .then((url) {
                          if (url.isNotEmpty) {
                            setState(() {
                              _logoURL = url;
                            });
                          }
                        }).then((value) {
                          _services.addVendor(
                            data: {
                              'shopImage': _shopImgURL,
                              'logo': _logoURL,
                              'businessName': _businessNameInput.text,
                              'contactNo': _contactNoInput.text,
                              'email': _emailInput.text,
                              'taxStatus': _taxStatus,
                              'gstNo': _gstNoInput.text.isEmpty
                                  ? null
                                  : _gstNoInput.text,
                              'pinCode': _pinCodeInput.text,
                              'landmark': _landmarkInput.text,
                              'countryValue': countryValue,
                              'stateValue': stateValue,
                              'cityValue': cityValue,
                              'uid': _services.user!.uid,
                              'time': DateTime.now(),
                              'approved': false,
                            },
                          ).then((value) {
                            EasyLoading.dismiss();
                            return Navigator.of(context)
                                .pushNamedAndRemoveUntil(
                                    landingScreenRoute, (route) => false);
                          });
                        });
                      });
                    }
                  },
                  child: const Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  CSCPicker cscMethod() {
    return CSCPicker(
      ///Enable disable state dropdown [OPTIONAL PARAMETER]
      showStates: true,

      /// Enable disable city drop down [OPTIONAL PARAMETER]
      showCities: true,

      ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
      flagState: CountryFlag.ENABLE,

      ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
      dropdownDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 1)),

      ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
      disabledDropdownDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          // color: Colors.grey.shade300,
          border: Border.all(color: Colors.grey.shade300, width: 1)),

      ///placeholders for dropdown search field
      countrySearchPlaceholder: "Country",
      stateSearchPlaceholder: "State",
      citySearchPlaceholder: "City",

      ///labels for dropdown
      countryDropdownLabel: "*Country",
      stateDropdownLabel: "*State",
      cityDropdownLabel: "*City",

      ///Default Country
      // defaultCountry: DefaultCountry.United_States,

      ///Disable country dropdown (Note: use it with default country)
      //disableCountry: true,

      ///selected item style [OPTIONAL PARAMETER]
      selectedItemStyle: const TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),

      ///DropdownDialog Heading style [OPTIONAL PARAMETER]
      dropdownHeadingStyle: const TextStyle(
          color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),

      ///DropdownDialog Item style [OPTIONAL PARAMETER]
      dropdownItemStyle: const TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),

      ///Dialog box radius [OPTIONAL PARAMETER]
      dropdownDialogRadius: 10.0,

      ///Search bar radius [OPTIONAL PARAMETER]
      searchBarRadius: 10.0,

      ///triggers once country selected in dropdown
      onCountryChanged: (value) {
        setState(() {
          ///store value in country variable
          countryValue = value;
        });
      },

      ///triggers once state selected in dropdown
      onStateChanged: (value) {
        setState(() {
          ///store value in state variable
          stateValue = value;
        });
      },

      ///triggers once city selected in dropdown
      onCityChanged: (value) {
        setState(() {
          ///store value in city variable
          cityValue = value;
        });
      },
    );
  }
}
