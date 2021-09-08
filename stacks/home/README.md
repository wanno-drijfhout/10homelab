# Home automation

![Home Assistant](https://www.home-assistant.io/images/home-assistant-logo.svg ':size=96px') *[Home Assistant] is an open source home automation that puts local control and privacy first. Powered by a worldwide community of tinkerers and DIY enthusiasts. Perfect to run on a Raspberry Pi or a local server.*

![ESPHome](https://esphome.io/_static/logo-text.svg ':size=96px') *[ESPHome] is a system to control your ESP8266/ESP32 by simple yet powerful configuration files and control them remotely through Home Automation systems.*

![Mosquitto](https://mosquitto.org/images/mosquitto-text-side-28.png ':size=96px') *Eclipse [Mosquitto] is an open source (EPL/EDL licensed) message broker that implements the MQTT protocol versions 5.0, 3.1.1 and 3.1. Mosquitto is lightweight and is suitable for use on all devices from low power single board computers to full servers.*

## Features

- [X] Home automation
- [X] Home device control
- [X] Energy consumption and production insights
- [X] IKEA Trådfri lights control
- [ ] IKEA Trådfri event observation (sensors, remotes, shortcut buttons)
- [ ] Secure MQTT connections
- [ ] OpenTherm Gateway control
- [ ] Room presence detection

## Resources

- [Home Assistant]
- [homeassistant-powercalc]
  - [Awesome HA Blueprints]
  - [ikea-tradfri-coap-docs]
- [Mosquitto]
  - [MQTT Room Presence]
- [WallPanel]
- [ESPHome]
  - [ESPHome-OpenTherm]
  - [OpenTherm Gateway]

[Home Assistant]: https://www.home-assistant.io/
[homeassistant-powercalc]: https://github.com/bramstroker/homeassistant-powercalc
[Awesome HA Blueprints]: https://epmatt.github.io/awesome-ha-blueprints/docs/blueprints/
[ikea-tradfri-coap-docs]: https://github.com/glenndehaan/ikea-tradfri-coap-docs#sensor
[Mosquitto]: https://mosquitto.org/
[MQTT Room Presence]: https://www.home-assistant.io/integrations/mqtt_room
[WallPanel]: https://thanksmister.com/wallpanel-android/
[ESPHome]: https://esphome.io/
[ESPHome-OpenTherm]: https://github.com/rsciriano/ESPHome-OpenTherm
[OpenTherm Gateway]: https://otgw.tclcode.com/


## mosquitto.conf

![mosquitto.conf](./mosquitto.conf ':include')

## docker-stack.yaml

![docker-stack.yaml](./docker-stack.yaml ':include')
