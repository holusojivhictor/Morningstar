# Morningstar
<p align="center">
  <img height="120px" src="assets/items/logos/app_icon_alt.png">
</p>

> A database/guide kinda app for Call of Duty Mobile game.

### Features

* Soldiers
* Weapons
* Vehicles
* Comics
* Tier list builder
* Blueprints and camos

[<img height="100" width="250" src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" />](https://play.google.com/store/apps/details?id=com.morpheus.morningstar)

### Contributing

You can build and run the project by following these steps:

* Clone this repository
* Checkout the **develop** branch
* Run ``flutter pub get``
* Run ``flutter pub run build_runner build --delete-conflicting-outputs``
* Create a ``Secrets`` class in the infrastructure/telemetry folder and add a static property called ``appCenterKey`` (You could also comment out the related code)
