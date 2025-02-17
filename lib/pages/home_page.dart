import 'dart:async';

import 'package:abbon_mobile_test/utils/codegen_loader.g.dart';
import 'package:copy_with/copy_with.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

part 'home_page.g.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeContoller controller;
  @override
  void initState() {
    super.initState();
    controller = HomeContoller();
    controller.initialize(
      phoneNumber: '0945083304',
      email: 'wenatchay850@gmail.com',
      lineAddress: 'weenatchai',
    );
  }

  void openSnackBar({required String message}) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> onTapLocation() async {
    final message = await controller.getLocationDeniedMessage();
    if (message != null) {
      openSnackBar(message: message);
      return;
    }
    controller.openCurrentPositionMap();
  }

  Future<void> onTapCamera() async {
    final message = await controller.getCameraDenideMessage();
    if (message != null) {
      openSnackBar(message: message);
      return;
    }
    controller.openCamera();
  }

  Future<void> onTapGallery() async {
    final message = await controller.getGalleryDenideMessage();
    if (message != null) {
      openSnackBar(message: message);
      return;
    }
    controller.openGallery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.homePage.tr(context: context)),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Center(
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.photo_library),
                            title: Text(LocaleKeys.gallery.tr()),
                            onTap: () async {
                              await onTapGallery();
                              if (mounted) {
                                context.pop();
                              }
                            },
                          ),
                          ListTile(
                            enabled: controller.isSupportCamera,
                            leading: Icon(Icons.camera_outlined),
                            title: Text(LocaleKeys.camera.tr()),
                            onTap: () async {
                              await onTapCamera();
                              if (mounted) {
                                context.pop();
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, value, _) {
                    return CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          controller.hasImage ? FileImage(value.image!) : null,
                      child: Visibility(
                        visible: !controller.hasImage,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person, size: 50),
                            Text(
                              LocaleKeys.edit.tr(),
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
          SizedBox(height: 20),
          Text(
            LocaleKeys.myName.tr(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text(LocaleKeys.currentLocation.tr()),
            onTap: onTapLocation,
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text(LocaleKeys.call.tr()),
            onTap: controller.openPhoneCall,
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text(LocaleKeys.mail.tr()),
            onTap: controller.openMail,
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text(LocaleKeys.line.tr()),
            onTap: controller.openLine,
          ),
        ],
      ),
    );
  }
}

@CopyWith()
class HomeValue {
  File? image;
  HomeValue({this.image});
}

class HomeContoller extends ValueNotifier<HomeValue> {
  late ImagePicker picker;
  late String _phoneNumber;
  late String _email;
  late String _lineAddress;

  HomeContoller() : super(HomeValue());

  Future<void> initialize({
    required String phoneNumber,
    required String email,
    required String lineAddress,
  }) async {
    picker = ImagePicker();
    _phoneNumber = phoneNumber;
    _email = email;
    _lineAddress = lineAddress;
  }

  Future<void> openGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      value = value.copyWith(
        image: () => File(pickedFile.path),
      );
    }
  }

  Future<void> openCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      value = value.copyWith(
        image: () => File(pickedFile.path),
      );
    }
  }

  Future<void> openPhoneCall() async {
    final url = Uri.parse('tel:$_phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> openMail() async {
    final url = Uri.parse('mailto:$_email');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> openLine() async {
    final url = Uri.parse('https://line.me/ti/p/~$_lineAddress');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> openCurrentPositionMap() async {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<String?> getLocationDeniedMessage() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocaleKeys.locationServicesAreDisabled.tr();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocaleKeys.locationPermissionsAreDenied.tr();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocaleKeys.locationPermissionsArePermanently.tr();
    }
    return null;
  }

  Future<String?> getCameraDenideMessage() async {
    final permission = await Permission.camera.request();
    if (permission.isDenied || permission.isPermanentlyDenied) {
      return LocaleKeys.cameraPermissionsAreDenied.tr();
    }
    return null;
  }
  // TODO android version test, maybe use storage
  Future<String?> getGalleryDenideMessage() async {
    final permission = await Permission.photos.request();
    if (permission.isDenied || permission.isPermanentlyDenied) {
      return LocaleKeys.galleryPermissionsAreDenied.tr();
    }
    return null;
  }

  get isSupportCamera => picker.supportsImageSource(ImageSource.camera);
  get hasImage => value.image != null;
}
