import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonalysis/core/utils/colors.dart';
import 'package:sonalysis/helpers/helpers.dart';
import 'package:sonalysis/lang/strings.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:sonalysis/widgets/custom_dropdown.dart';

class SelectPlanModalWidget extends StatefulWidget {
  const SelectPlanModalWidget({Key? key, this.email}) : super(key: key);

  final String? email;

  @override
  _SelectPlanModalWidgetState createState() => _SelectPlanModalWidgetState();
}

class _SelectPlanModalWidgetState extends State<SelectPlanModalWidget> {
  String? _selectedRecurrency;
  var selectedPlan, selectedPaymentPartner;
  bool canProceed = false, canProceed2 = false, isSelectPaymentPartner = false;
  var publicKey = "pk_test_abcf7cddf20eaf9fd8173413991e4762888afe11";
  final plugin = PaystackPlugin();

  @override
  void initState() {
    plugin.initialize(publicKey: publicKey);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: CupertinoPageScaffold(
      backgroundColor: Colors.transparent.withOpacity(0.9),
      child: Container(
        decoration: BoxDecoration(
            color: isSelectPaymentPartner ? sonaBlack : sonaLightBlack,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            )),
        //height: 640.h,
        height: MediaQuery.of(context).size.height * 0.9,
        child: SingleChildScrollView(
          child: isSelectPaymentPartner
              ? Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Payment method",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Stack(
                        children: [
                          Image.asset(
                            imagesDir + '/mastercard.png',
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fitWidth,
                          ),
                          Positioned(
                              left: MediaQuery.of(context).size.width * 0.8,
                              top: 17,
                              child: Radio(
                                value: "mastercard",
                                fillColor:
                                    MaterialStateColor.resolveWith((states) {
                                  return Colors.white;
                                }),
                                groupValue: selectedPaymentPartner,
                                onChanged: (value) {
                                  setState(() {
                                    canProceed2 = true;
                                    selectedPaymentPartner = value;
                                    print(selectedPaymentPartner);
                                  });
                                },
                                activeColor: sonaPurple2,
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Stack(
                        children: [
                          Image.asset(
                            imagesDir + '/paypal.png',
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fitWidth,
                          ),
                          Positioned(
                              left: MediaQuery.of(context).size.width * 0.8,
                              top: 10,
                              child: Radio(
                                value: "paypal",
                                fillColor:
                                    MaterialStateColor.resolveWith((states) {
                                  return Colors.white;
                                }),
                                groupValue: selectedPaymentPartner,
                                onChanged: (value) {
                                  setState(() {
                                    canProceed2 = true;
                                    selectedPaymentPartner = value;
                                    print(selectedPaymentPartner);
                                  });
                                },
                                activeColor: sonaPurple2,
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Stack(
                        children: [
                          Image.asset(
                            imagesDir + '/visa.png',
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fitWidth,
                          ),
                          Positioned(
                              left: MediaQuery.of(context).size.width * 0.8,
                              top: 10,
                              child: Radio(
                                value: "visa",
                                fillColor:
                                    MaterialStateColor.resolveWith((states) {
                                  return Colors.white;
                                }),
                                groupValue: selectedPaymentPartner,
                                onChanged: (value) {
                                  setState(() {
                                    canProceed2 = true;
                                    selectedPaymentPartner = value;
                                    print(selectedPaymentPartner);
                                  });
                                },
                                activeColor: sonaPurple2,
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shadowColor: AppColors.sonaPurple2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            child: Text('Make Payment'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13.sp)),
                            onPressed: () async {
                              if (canProceed2) {
                                var random = Random();
                                //do payment
                                Charge charge = Charge()
                                  ..amount = selectedPlan == "basic"
                                      ? 900 * 100
                                      : 2000 * 100
                                  ..reference = "sonalysisd:" +
                                      random.nextInt(999999).toString()
                                  // or ..accessCode = _getAccessCodeFrmInitialization()
                                  ..email = widget.email;
                                CheckoutResponse response =
                                    await plugin.checkout(
                                  context,
                                  method: CheckoutMethod
                                      .card, // Defaults to CheckoutMethod.selectable
                                  charge: charge,
                                  fullscreen: false,
                                  logo: Image.asset(
                                    imagesDir + '/logo.png',
                                    width: 60,
                                    fit: BoxFit.fitWidth,
                                  ),
                                );
                                if (response.status != false &&
                                    response.method != null) {
                                  Navigator.of(context).pop(true);
                                } else {
                                  _onPaymentCancelled(context);
                                }
                                //print('paystack Response = $response');
                                //_updateStatus(response.reference, '$response');
                              }
                            },
                          )),
                    )
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                        decoration: BoxDecoration(
                            color: sonaLightBlack,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50))),
                        width: 50,
                        child: Divider(
                            thickness: 5, color: getColorHexFromStr("818181"))),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          width: 140,
                          margin: const EdgeInsets.only(top: 10, bottom: 0),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: CustomDropdown(
                            locked: false,
                            items: const ["Monthly", "Yearly"],
                            labelText: "Choose Your Plan",
                            error: '',
                            hint: 'Monthly',
                            selected: _selectedRecurrency,
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                            onChange: (selected) {
                              setState(() {
                                _selectedRecurrency = selected;
                              });
                            },
                          )),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: sonaLightBlack,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.grey, width: 1.5.w),
                        ),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        padding: const EdgeInsets.all(20),
                        child: Stack(
                          children: [
                            Image.asset(imagesDir + '/basic.png',
                                fit: BoxFit.contain,
                                repeat: ImageRepeat.noRepeat,
                                width: 130),
                            Positioned(
                                left: MediaQuery.of(context).size.width * 0.7,
                                top: -10,
                                child: Radio(
                                  value: "basic",
                                  groupValue: selectedPlan,
                                  fillColor:
                                      MaterialStateColor.resolveWith((states) {
                                    return Colors.white;
                                  }),
                                  onChanged: (value) {
                                    setState(() {
                                      canProceed = true;
                                      selectedPlan = value;
                                      print(selectedPlan);
                                    });
                                  },
                                  activeColor: sonaPurple2,
                                ))
                          ],
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: sonaLightBlack,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.grey, width: 1.5.w),
                        ),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        padding: const EdgeInsets.all(20),
                        child: Stack(
                          children: [
                            Image.asset(imagesDir + '/premium.png',
                                fit: BoxFit.contain,
                                repeat: ImageRepeat.noRepeat,
                                width: 130),
                            Positioned(
                                left: MediaQuery.of(context).size.width * 0.7,
                                top: -10,
                                child: Radio(
                                  value: "premium",
                                  fillColor:
                                      MaterialStateColor.resolveWith((states) {
                                    return Colors.white;
                                  }),
                                  groupValue: selectedPlan,
                                  onChanged: (value) {
                                    setState(() {
                                      canProceed = true;
                                      selectedPlan = value;
                                      print(selectedPlan);
                                    });
                                  },
                                  activeColor: sonaPurple2,
                                ))
                          ],
                        )),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shadowColor: canProceed2
                                  ? sonaPurple1
                                  : sonaPurpleDisabled,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            child: Text('Choose Plan'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13.sp)),
                            onPressed: () {
                              if (canProceed) {
                                setState(() {
                                  isSelectPaymentPartner = true;
                                });
                              }
                            },
                          )),
                    )
                  ],
                ),
        ),
      ),
    ));
  }

  void _onPaymentCancelled(BuildContext context) {
    print("++Cancelled");
    // Scaffold.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('Payment Cancelled'),
    //   ),
    // );
  }

  void _onPaymentPending() {
    print("++Pending");
    // Scaffold.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('Payment Pending'),
    //   ),
    // );
  }

  void _onPaymentFailed() {
    print("++Failed");
    // Scaffold.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Payment Failed'),
    //   ),
    // );
  }
}
