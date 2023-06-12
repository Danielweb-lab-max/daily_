import 'package:flutter/material.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Terms of service"),
        ),
      ),
      body: Container(
        decoration:BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
              stops: [0.5,1.1],
              colors: [Colors.lightBlueAccent,Colors.deepPurpleAccent]

          ),
        ) ,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Container(

                child: Column(

                  children: [

                    Text(
                      "These terms and conditions outline the rules and regulations for the use of the application,created by TwoPlus Community. This application is only informative tool and must be used just for fun. We post various sports prediction that represent our opinion regarding the eventual outcome of those games. We do not encourage or support betting and gambling. By continuing to use app, you fully understand that this is only informative service and you accept that we will not be any in what responsible for your personal actions. Everyone who uses the app is 100% responsible for his actions and for obeying the applicable laws in his country.  Act responsible! 18+ only. Not designed for children! If you want to review the Terms and Conditions later you can do that at any time in the app menu. If you have any questions or concerns regarding these Terms and Terms or Agreement please contact Support@Twoplus.africa",
                      style: TextStyle(
                        fontSize: 18,
                        color:Colors.black,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Material(

                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/');
                              },
                              height: 10,
                              minWidth: 40,
                              child: Text(
                                "Back",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),



                  ],
                ),
              ),
            ),



          ],

        ),
      ),
    );
  }
}
