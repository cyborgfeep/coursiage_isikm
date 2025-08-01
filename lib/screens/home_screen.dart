import 'package:coursiage_isikm/models/option.dart';
import 'package:coursiage_isikm/models/transaction.dart';
import 'package:coursiage_isikm/screens/scan_screen.dart';
import 'package:coursiage_isikm/screens/transaction_screen.dart';
import 'package:coursiage_isikm/utils/constants.dart';
import 'package:coursiage_isikm/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    initJiffy();
  }

  initJiffy() async {
    await Jiffy.setLocale('fr_fr');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 110,
            backgroundColor: primaryColor,
            leading: IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                print("Go to settings");
              },
            ),
            floating: true,
            elevation: 2,
            flexibleSpace: FlexibleSpaceBar(
              title: GestureDetector(
                onTap: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isVisible
                          ? RichText(
                              text: TextSpan(
                                text: "10.000",
                                style: GoogleFonts.aBeeZee(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: "F",
                                    style: GoogleFonts.aBeeZee(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Text(
                              "••••••••",
                              style: GoogleFonts.aBeeZee(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      SizedBox(width: 8),
                      Icon(
                        isVisible ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              centerTitle: true,
            ),
            pinned: true,
            actions: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                margin: EdgeInsets.only(right: 8),
                child: Row(
                  children: [
                    Icon(Icons.sim_card, size: 16, color: Colors.black),
                    SizedBox(width: 2),
                    Text(
                      "6789",
                      style: GoogleFonts.dmSans(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 750,
              child: Stack(
                children: [
                  Container(color: primaryColor),
                  Container(
                    margin: EdgeInsets.only(top: 110),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CardWidget(
                        height: 200,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ScanScreen();
                              },
                            ),
                          );
                        },
                      ),
                      GridView.builder(
                        physics: ClampingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                        ),
                        shrinkWrap: true,
                        itemCount: Option.optionList.length,
                        itemBuilder: (context, index) {
                          return optionWidget(o: Option.optionList[index]);
                        },
                      ),
                      Divider(thickness: 5, color: Colors.grey.shade300),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: Transaction.transactionList.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, i) {
                          Transaction t = Transaction.transactionList[i];
                          bool isDebit =
                              t.transactionType == TType.depot ||
                                  t.transactionType == TType.reception
                              ? true
                              : false;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${t.transactionType == TType.envoi
                                          ? "À "
                                          : t.transactionType == TType.reception
                                          ? "De "
                                          : ""}${t.titre}",
                                      style: GoogleFonts.dmSans(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${isDebit ? "" : "-"}${t.montant}F",
                                      style: GoogleFonts.dmSans(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  Jiffy.parse(
                                    t.dateTime.toString(),
                                  ).format(pattern: "dd MMMM yyyy à HH:mm"),
                                  style: GoogleFonts.dmSans(
                                    color: Colors.grey,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: .3),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.search, color: primaryColor),
                                Text(
                                  "Rechercher",
                                  style: GoogleFonts.dmSans(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget optionWidget({required Option o}) {
    return GestureDetector(
      onTap: () {
        switch (o.title) {
          case "Transfert":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return TransactionScreen(isCreditScreen: false);
                },
              ),
            );
            break;
          case "Crédit":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return TransactionScreen(isCreditScreen: true);
                },
              ),
            );
            break;
          default:
            break;
        }
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: o.color.withValues(alpha: .3),
              borderRadius: BorderRadius.circular(45),
            ),
            padding: EdgeInsets.all(8),
            child: Icon(o.icon, size: 45, color: o.color),
          ),
          SizedBox(height: 5),
          Text(o.title, style: GoogleFonts.dmSans(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
