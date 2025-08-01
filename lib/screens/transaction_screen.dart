import 'package:coursiage_isikm/widgets/camera_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionScreen extends StatefulWidget {
  final bool isCreditScreen;

  const TransactionScreen({super.key, required this.isCreditScreen});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  TextEditingController searchController = TextEditingController();
  List<Contact> contacts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getContacts();
  }

  Future<void> getContacts() async {
    setState(() {
      isLoading = true;
    });
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(withProperties: true);
      contacts.removeWhere(
        (element) =>
            element.phones.isEmpty ||
            !element.phones.first.normalizedNumber.startsWith("+221") ||
            !element.phones.first.normalizedNumber
                .replaceAll("+221", "")
                .startsWith("7"),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          !widget.isCreditScreen ? "Envoyer de l'argent" : "Achat Crédit",
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [headerWidget(), SizedBox(height: 20), contactSection()],
          ),
        ),
      ),
    );
  }

  Widget headerWidget() {
    return Column(
      children: [
        TextField(
          controller: searchController,
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          decoration: InputDecoration(label: Text("À")),
          onChanged: (value) {
            print(value);
          },
        ),
        SizedBox(height: 20),

        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(45),
              ),
              padding: EdgeInsets.all(4),
              child: Icon(Icons.add_outlined, color: Colors.white, size: 35),
            ),
            SizedBox(width: 10),
            Flexible(
              child: Text(
                widget.isCreditScreen
                    ? "Acheter du credit pour un nouveau numéro"
                    : "Saisir un nouveau numéro",

                style: GoogleFonts.dmSans(fontSize: 14),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        !widget.isCreditScreen
            ? GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CameraWidget()),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.qr_code_scanner_rounded,
                      color: Colors.blue,
                      size: 40,
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        "Scanner pour envoyer",

                        style: GoogleFonts.dmSans(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }

  contactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Contacts",
          style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 10),
        isLoading
            ? CircularProgressIndicator()
            : ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: contacts.length > 50 ? 50 : contacts.length,
                itemBuilder: (context, index) {
                  Contact c = contacts[index];
                  String number = c.phones.first.normalizedNumber.replaceAll(
                    "+221",
                    "",
                  );
                  Color color = number.startsWith("76")
                      ? Colors.blue.shade900
                      : number.startsWith("70")
                      ? Colors.yellow
                      : Colors.orange;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        widget.isCreditScreen
                            ? Container(
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(45),
                                ),
                                padding: EdgeInsets.all(8),
                                child: SizedBox(width: 30, height: 30),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: .2),
                                  borderRadius: BorderRadius.circular(45),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.person_2,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                              ),
                        SizedBox(width: 10),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.displayName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                number,
                                style: GoogleFonts.dmSans(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ],
    );
  }
}
