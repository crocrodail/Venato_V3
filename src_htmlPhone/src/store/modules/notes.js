import PhoneAPI from './../../PhoneAPI'
const LOCAL_NAME = 'gc_notes_channels'

let NotesAudio = null

const state = {
  channels: [{"channel":"Idées de développements","lastMessage":1590076564000,"id":1},{"channel":"Bugs Venato","lastMessage":1590076601000,"id":2},{"channel":"Idées pour changer le monde","lastMessage":0,"id":3}],
  currentChannel: null,
  messagesChannel: []
}

const getters = {
  notesChannels: ({ channels }) => channels,
  notesCurrentChannel: ({ currentChannel }) => currentChannel,
  notesMessages: ({ messagesChannel }) => messagesChannel
}

const actions = {
  notesReset ({commit}) {
    commit('NOTES_SET_MESSAGES', { messages: [] })
    commit('NOTES_SET_CHANNEL', { channel: null })
    commit('NOTES_REMOVES_ALL_CHANNELS')
  },
  notesSetChannel ({ state, commit, dispatch }, channel) {
    console.log(channel)
  },
  notesAddChannel ({ commit }, { channel }) {
    commit('NOTES_ADD_CHANNELS', { channel })
  },
  notesRemoveChannel ({ commit }, { channel }) {
    commit('NOTES_REMOVES_CHANNELS', { channel })
  },
  notesGetChannels (data, userId) {
    PhoneAPI.notesGetChannel(userId)
  },
  notesGetMessagesChannel ({ commit }, { channel }) {
    PhoneAPI.notesGetMessagesChannel(channel)
  },
  notesSendMessage (state, { channel, message }) {
    PhoneAPI.notesSendMessage(channel, message)
  }
}

const mutations = {
  NOTES_SET_CHANNEL (state, { channel }) {
    state.currentChannel = channel
  },
  SET_NOTE_CHANNELS (state, channels) {
    state.channels = channels
  },
  NOTES_ADD_CHANNELS (state, { channel }) {
    state.channels.push({
      channel
    })
  },
  NOTES_REMOVES_CHANNELS (state, { channel }) {
    state.channels = state.channels.filter(c => {
      return c.channel !== channel
    })
    localStorage[LOCAL_NAME] = JSON.stringify(state.channels)
  },
  NOTES_REMOVES_ALL_CHANNELS (state) {
    state.channels = []
    localStorage[LOCAL_NAME] = JSON.stringify(state.channels)
  },
  NOTES_ADD_MESSAGES (state, { message }) {
    if (message.channel === state.currentChannel) {
      state.messagesChannel.push(message)
    }
  },
  NOTES_SET_MESSAGES (state, { messages }) {
    state.messagesChannel = messages
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}

if (process.env.NODE_ENV !== 'production') {
  state.currentChannel = 'debug'
  state.messagesChannel = JSON.parse('[{"channel":"teste","message":"teste","id":6,"time":1528671680000},{"channel":"teste","message":"Hop","id":5,"time":1528671153000}]')
  for (let i = 0; i < 200; i++) {
    state.messagesChannel.push(Object.assign({}, state.messagesChannel[0], { id: 100 + i, message: 'mess ' + i }))
  }
  state.messagesChannel.push({
    message: 'Message sur plusieur ligne car il faut bien !!! Ok !',
    id: 5000,
    time: new Date().getTime()
  })
  state.messagesChannel.push({
    message: 'Message sur plusieur ligne car il faut bien !!! Ok !',
    id: 5000,
    time: new Date().getTime()
  })
  state.messagesChannel.push({
    message: 'Message sur plusieur ligne car il faut bien !!! Ok !',
    id: 5000,
    time: new Date(4567845).getTime()
  })
}
