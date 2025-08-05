import 'package:coursiage_isikm/models/favorite_contacts.dart';
import 'package:coursiage_isikm/services/contact_provider.dart';
import 'package:coursiage_isikm/widgets/camera_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';

class TransactionScreen extends StatefulWidget {
  final bool isCreditScreen;

  const TransactionScreen({super.key, required this.isCreditScreen});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  TextEditingController searchController = TextEditingController();
  List<Contact> contacts = [];
  List<FavoriteContact> favorites = [];
  bool isLoading = false;
  bool isLoadingFav = false;
  ContactProvider provider = ContactProvider();

  @override
  void initState() {
    super.initState();

    getContacts();
    initDatabase();
  }

  Future<void> initDatabase() async {
    String path = await getDatabasesPath();
    String dbPath = "$path/contact.db";

    provider.open(dbPath).then((value) {
      getFavContacts();
    });
  }

  getFavContacts() async {
    setState(() {
      isLoadingFav = true;
    });
    favorites = await provider.getFavoriteList();
    setState(() {
      isLoadingFav = false;
    });
  }

  addFavContacts(String name, String phone) async {
    FavoriteContact fc = FavoriteContact(name: name, phone: phone);

    provider.insert(fc).then((value) {
      if (value.id != null) {
        setState(() {
          favorites.add(value);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.fixed,
              content: Text("Contact ajouté aux favoris"),
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.fixed,
            content: Text("Ce contact est deja dans les favoris"),
          ),
        );

        //print("Ce contact est deja dans les favoris");
      }
    });
  }

  deleteFavContacts(FavoriteContact c) {
    provider.delete(c.id!).then((value) {
      setState(() {
        favorites.removeWhere((element) => element.id == c.id);
      });
    });
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
            children: [
              headerWidget(),
              SizedBox(height: favorites.isNotEmpty ? 20 : 0),
              favorites.isNotEmpty ? favoriteSection() : SizedBox.shrink(),
              SizedBox(height: 20),
              contactSection(),
            ],
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
          onChanged: (value) {},
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

  favoriteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Favoris",
          style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 10),
        isLoadingFav
            ? CircularProgressIndicator()
            : ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: favorites.length > 50 ? 5 : favorites.length,
                itemBuilder: (context, index) {
                  FavoriteContact c = favorites[index];
                  String number = c.phone!;
                  Color color = number.startsWith("76")
                      ? Colors.blue.shade900
                      : number.startsWith("70")
                      ? Colors.yellow
                      : Colors.orange;
                  return GestureDetector(
                    onDoubleTap: () {
                      deleteFavContacts(c);
                    },
                    child: Padding(
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
                                  c.name!,
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
                    ),
                  );
                },
              ),
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
        if (isLoading)
          CircularProgressIndicator()
        else
          ListView.builder(
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
              return GestureDetector(
                onDoubleTap: () {
                  addFavContacts(c.displayName, number);
                },
                child: Padding(
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
                ),
              );
            },
          ),
      ],
    );
  }
}
