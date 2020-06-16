import PhoneAPI from './../../PhoneAPI'

const state = {
  appelsHistorique: [],
  appelsInfo: null
}

const getters = {
  appelsHistorique: ({ appelsHistorique }) => appelsHistorique,
  appelsInfo: ({ appelsInfo }) => appelsInfo,
  appelsDisplayName (state, getters) {
    if (state.appelsInfo === null) {
      return 'ERROR'
    }
    if (state.appelsInfo.hidden === true) {
      return getters.IntlString('APP_PHONE_NUMBER_HIDDEN')
    }
    const num = getters.appelsDisplayNumber
    const contact = getters.contacts.find(e => e.number === num) || {}
    return contact.display || getters.IntlString('APP_PHONE_NUMBER_UNKNOWN')
  },
  appelsDisplayNumber (state, getters) {
    if (state.appelsInfo === null) {
      return 'ERROR'
    }
    if (getters.isInitiatorCall === true) {
      return state.appelsInfo.receiver_num
    }
    if (state.appelsInfo.hidden === true) {
      return '###-####'
    }
    return state.appelsInfo.transmitter_num
  },
  isInitiatorCall (state, getters) {
    if (state.appelsInfo === null) {
      return false
    }
    return state.appelsInfo.initiator === true
  }
}

const actions = {
  startCall ({ commit }, { numero }) {
    PhoneAPI.startCall(numero)
  },
  acceptCall ({ state }) {
    PhoneAPI.acceptCall(state.appelsInfo)
  },
  rejectCall ({ state }) {
    PhoneAPI.rejectCall(state.appelsInfo)
  },
  ignoreCall ({ commit }) {
    commit('SET_APPELS_INFO', null)
    // PhoneAPI.ignoreCall(state.appelsInfo)
  },
  appelsDeleteHistorique ({ commit, state }, { numero }) {
    PhoneAPI.appelsDeleteHistorique(numero)
    commit('SET_APPELS_HISTORIQUE', state.appelsHistorique.filter(h => {
      return h.num !== numero
    }))
  },
  appelsDeleteAllHistorique ({ commit }) {
    PhoneAPI.appelsDeleteAllHistorique()
    commit('SET_APPELS_HISTORIQUE', [])
  },
  resetAppels ({ commit }) {
    commit('SET_APPELS_HISTORIQUE', [])
    commit('SET_APPELS_INFO', null)
  }
}

const mutations = {
  SET_APPELS_HISTORIQUE (state, appelsHistorique) {
    state.appelsHistorique = appelsHistorique
  },
  SET_APPELS_INFO_IF_EMPTY (state, appelsInfo) {
    if (state.appelsInfo === null) {
      state.appelsInfo = appelsInfo
    }
  },
  SET_APPELS_INFO (state, appelsInfo) {
    state.appelsInfo = appelsInfo
  },
  SET_APPELS_INFO_IS_ACCEPTS (state, isAccepts) {
    if (state.appelsInfo !== null) {
      state.appelsInfo = Object.assign({}, state.appelsInfo, {
        is_accepts: isAccepts
      })
    }
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}


