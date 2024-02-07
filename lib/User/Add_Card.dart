// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class Credit_Card extends StatefulWidget {
  const Credit_Card({super.key});

  @override
  State<Credit_Card> createState() => _Credit_CardState();
}

class _Credit_CardState extends State<Credit_Card> {
    bool isLightTheme = false;
    String cardNumber = '';
    String expiryDate = '';
    String cardHolderName = '';
    String cvvCode = '';
    bool isCvvFocused = false;
    bool useGlassMorphism = false;
    bool useBackgroundImage = false;
    bool useFloatingAnimation = true;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    @override
    Widget build(BuildContext context) {
      var mdheight = MediaQuery.sizeOf(context).height;
      var mdwidth = MediaQuery.sizeOf(context).width;
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: Text("Card Details",style: TextStyle(color: Colors.black,fontSize: mdheight*0.030),),
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0,
        ),
          body: Builder(
              builder: (BuildContext context) {
                return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage(
                          isLightTheme ? 'assets/bg-light.png' : 'assets/bg-dark.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: SafeArea(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CreditCardWidget(
                                enableFloatingCard: useFloatingAnimation,
                                glassmorphismConfig: _getGlassmorphismConfig(),
                                cardNumber: cardNumber,
                                expiryDate: expiryDate,
                                cardHolderName: cardHolderName,
                                cvvCode: cvvCode,
                                showBackView: isCvvFocused,
                                obscureCardNumber: true,
                                obscureCardCvv: true,
                                isHolderNameVisible: true,
                                backgroundImage: useBackgroundImage ? 'assets/card_bg.png' : null,
                                isSwipeGestureEnabled: true,
                                onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
                                customCardTypeIcons: [
                                  CustomCardTypeIcon(
                                    cardType: CardType.mastercard,
                                    cardImage: Image.asset('assets/mastercard.png',
                                      height: mdheight * 0.05,
                                      width: mdwidth * 0.05),
                                  ),
                                ],
                              ),
                              Expanded(
                                  child: SingleChildScrollView(
                                      child: Column(
                                          children: [
                                            CreditCardForm(
                                              formKey: formKey,
                                              obscureCvv: true,
                                              obscureNumber: true,
                                              cardNumber: cardNumber,
                                              cvvCode: cvvCode,
                                              isHolderNameVisible: true,
                                              isCardNumberVisible: true,
                                              isExpiryDateVisible: true,
                                              cardHolderName: cardHolderName,
                                              expiryDate: expiryDate,
                                              inputConfiguration: InputConfiguration(
                                                cardNumberDecoration: InputDecoration(
                                                  fillColor: Colors.grey.shade100,
                                                  filled: true,
                                                  hintText:  'XXXX XXXX XXXX XXXX',
                                                  labelText: "Number",
                                                  border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(mdheight * 0.02)),
                                                ),
                                                expiryDateDecoration: InputDecoration(
                                                    fillColor: Colors.grey.shade100,
                                                    filled: true,
                                                    labelText: 'Expired Date',
                                                    hintText: 'XX/XX',
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(mdheight * 0.02))
                                                ),
                                                cvvCodeDecoration: InputDecoration(
                                                    fillColor: Colors.grey.shade100,
                                                    filled: true,
                                                    labelText: 'CVV',
                                                    hintText: 'XXX',
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(mdheight * 0.02))
                                                ),
                                                cardHolderDecoration: InputDecoration(
                                                    fillColor: Colors.grey.shade100,
                                                    filled: true,
                                                    labelText: 'Card Holder',
                                                    hintText: 'Card Holder',
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(mdheight * 0.02))
                                                ),
                                              ),
                                              onCreditCardModelChange: onCreditCardModelChange,
                                            ),
                                            SizedBox(height: mdheight * 0.020),
                                            GestureDetector(
                                                onTap: _onValidate,
                                                child: Container(
                                                    margin:  EdgeInsets.symmetric(
                                                      horizontal: mdheight * 0.02,
                                                      vertical: mdwidth * 0.01,
                                                    ),
                                                    decoration:  BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(mdheight * 0.01),
                                                      ),
                                                    ),
                                                    padding: EdgeInsets.only(left: mdheight * 0.02, top: mdheight * 0.01, bottom: mdheight * 0.01, right: mdheight * 0.01),
                                                    child: SizedBox(
                                                      height: mdheight*0.07,
                                                      width: mdwidth,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.deepPurple.shade800,
                                                           ),
                                                        onPressed: (){},
                                                        child: const Text("Confirm", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),),
                                                    )
                                                )
                                            ),
                                          ]
                                      )
                                  )
                              ),
                            ]
                        )
                    )
                );
              }
              )
      );
    }

    void _onValidate() {
      if (formKey.currentState?.validate() ?? false) {
      } else {
      }
    }

    Glassmorphism? _getGlassmorphismConfig() {
      if (!useGlassMorphism) {
        return null;
    }

    final LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Colors.grey.withAlpha(50), Colors.grey.withAlpha(50)],
      stops: const <double>[0.3, 0],
    );

    return isLightTheme
    ? Glassmorphism(blurX: 8.0, blurY: 16.0, gradient: gradient)
        : Glassmorphism.defaultConfig();
    }

    void onCreditCardModelChange(CreditCardModel creditCardModel) {
      setState(() {
        cardNumber = creditCardModel.cardNumber;
        expiryDate = creditCardModel.expiryDate;
        cardHolderName = creditCardModel.cardHolderName;
        cvvCode = creditCardModel.cvvCode;
        isCvvFocused = creditCardModel.isCvvFocused;
      });
    }
  }
