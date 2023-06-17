import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:users/Assistants/request_assistant.dart';
import 'package:users/global/global.dart';
import 'package:users/global/map_key.dart';
import 'package:users/infoHandler/app_info.dart';
import 'package:users/models/directions.dart';
import 'package:users/models/user_model.dart';

class AssistantMethods{
  static void readCurrentOnlineUserInfo() async {
    currentUser= firebaseAuth.currentUser;
    DatabaseReference userRef= FirebaseDatabase.instance
    .ref()
    .child("users")
    .child(currentUser!.uid);

    userRef.once().then((snap){
      if(snap.snapshot.value!=null){
        userModelCurrentInfo= UserModel.fromSnapshot(snap.snapshot);
      }
    });
  }

  static Future<String> searchAddressForGeographicCoOrdinates(Position position, context) async {

    double latitude = -17.7864704;
    double longitude =-63.193088;

    String apiUrl= "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$mapKey";
    String humanReadableAddress="";

    var requestReponse= await RequestAssistant.receiveRequest(apiUrl);

    if(requestReponse!="Error Ocurrido. Fallo! No responde"){
      humanReadableAddress=requestReponse["results"][0]["formatted_address"];

      Directions userPickUpAddress= Directions();
      userPickUpAddress.locationLatitude=latitude;
      userPickUpAddress.locationLongitude=longitude;
      userPickUpAddress.locationName=humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }

    return humanReadableAddress;
  }
}