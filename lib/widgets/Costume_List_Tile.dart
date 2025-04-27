import 'package:flutter/material.dart';
import '../data/Constants.dart';

class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    super.key,
    required this.listTileIcon,
    required this.title,

  });
  final String title;
  final IconData listTileIcon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        listTileIcon,
        size: 30,
      ), // Image.asset('assets/images/npPerson.jpg'),
      title: Text(title, style: KStyle.titleTextStyle),
      // subtitle: Text('subtitle',style: KStyle.normalTextStyle,),

      //enableFeedback: true,
      // shape: RoundedRectangleBorder(
      //
      //   borderRadius: BorderRadius.circular(15),
      //   side: BorderSide(
      //       width: 3,
      //       color: Colors.grey.shade300),
      //
      // ),
    );
  }
}

class ProfileListTile extends StatelessWidget {
  const ProfileListTile({
    super.key,
    required this.profileImageAsset,
    required this.profileImageNetwork,
    required this.title,
    required this.destination,
  });
  final String profileImageAsset;
  final String profileImageNetwork;
  final String title;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    double borderRadius = 15;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Material(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          },
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.grey),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Row(
              children: [
                ClipOval(

                  child:
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: profileImageNetwork.isNotEmpty?
                         Image.network(
                      profileImageNetwork,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/no-connection.jpg', // Your offline fallback image
                          fit: BoxFit.cover,
                        );
                      },
                    )  : Image.asset(profileImageAsset),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(title, style: KStyle.titleTextStyle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
