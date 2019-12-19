*********
Easy Cart
*********

.. sectnum::

.. contents::

Description
-----------
Application built aiming to the maximum simplicity possible

The main purpose was to have an app where you can save your shopping list quickly and simply and then use it while doing the shopping

Backend
-------

API REST built with NestJS

Requirements
~~~~~~~~~~~~
- MongoDB (tested with v4.2)
- Node (tested v8.9.4)
- Firebase

Installation
~~~~~~~~~~~~
- Set your mongo url in the config/index.ts file
- Configure Firebase(https://firebase.google.com/docs/admin/setup), add the json file in the config directory with the name serviceAccountKey.json and the databaseURL in the index.ts file
- Go to the backend directory
- Install the dependencies with the command "npm install"
- Start the service with the command "npm run start"

Frontend
--------

Mobile App built with flutter  

Requirements
~~~~~~~~~~~~
- Flutter (tested with v1.12.13+hotfix.5)
- Dart (tested with v2.7.0)
- Easy Cart backend running

Installation
~~~~~~~~~~~~
- Set your backend url in frontend/lib/src/constants.dart
- Add the google-services.json file from Firebase to android/app directory
- Generate the apk


*This app has been tested only on android*
