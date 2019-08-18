Config = {}

Config.RestrictedChannels = 10 -- channels that are encrypted (EMS, Fire and police can be included there) if we give eg 10, channels from 1 - 10 will be encrypted
Config.enableCmd = false --  /radio command should be active or not (if not you have to carry the item "radio") true / false

Config.messages = {

  ['not_on_radio'] = "Vous n'êtes actuellement sur aucune fréquence",
  ['on_radio'] = 'Vous êtes actuellement sur la fréquence: <b>',
  ['joined_to_radio'] = 'Vous avez rejoint la fréquence: <b>',
  ['restricted_channel_error'] = 'Vous ne pouvez pas rejoindre une fréquence cryptées!',
  ['you_on_radio'] = 'Vous êtes déjà sur la fréquence: <b>',
  ['you_leave'] = 'Vous avez quitté la fréquence: <b>'

}
