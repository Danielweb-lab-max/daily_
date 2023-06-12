import 'package:flutter/material.dart';

class LegalScreen extends StatefulWidget {
  const LegalScreen({Key? key}) : super(key: key);

  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen> {
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Legal Declaration"),
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
                        "1.Our application is not directed to online gambling. It is only application for entertainment and fun between friends. We do not support in any way gambling so understand that gambling involves risks. 2. Whilst we do are upmost to offer good analyze and information we cannot be held responsible for any choice you make outside our application that may incur as a result of gambling. 3. We do our best for all the info that we provide on this app, however from time to time, mistakes will be made and we will not be held liable. Please check any stats or info which you are unsure how accurate they are. 4. No guarantees are made with regards to results or financial gain. All forms of betting carry financial risks and it is down to individual decisions. 5. We cannot be held responsible for any losses that may incur as a result of following the betting tips provided on this application because we share our opinion (analyze tips) for fun with friends. 6. The material contained on this site is intended to inform and educate reader and in no way represents an inducement to gamble legally or illegally. 7. Past performance do not guarantee success in the future. 8. While we do our best to find the best for all our tips we cannot ensure they are always accurate as betting odds fluctuate from one minute to the next. 9. ALL TIPS are subject to change and were correct at the time of publishing. 10. We are not to be held liable to you(whether under the law of contract, the law of torts or otherwise) in relation to the contents of , or use of, or otherwise in connection with this application. ",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),



                    ],
                  ),
                ),
              ),

              Row(
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
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            ],

          ),
        ),
      );

  }
}
