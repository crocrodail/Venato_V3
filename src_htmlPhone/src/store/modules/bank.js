import PhoneAPI from './../../PhoneAPI'

const state = {
  bankAmont: '0',
  bankAccount: 'SM61-VnT-50',
  bankFullname: 'Robert Pichon'
}

const getters = {
  bankAmont: ({ bankAmont }) => bankAmont,
  bankAccount: ({ bankAccount }) => bankAccount,
  bankFullname: ({ bankFullname }) => bankFullname
}

const actions = {
  sendpara ({ state }, { id, amount }) {
    PhoneAPI.callEvent('gcphone:bankTransfer', {id, amount})
  }
}

const mutations = {
  SET_BANK_AMONT (state, bankAmont) {
    state.bankAmont = bankAmont
  },
  SET_NUM_BANK_ACCOUNT (state, bankAccount) {
    state.bankAccount = bankAccount
  },
  SET_FULLNAME_ACCOUNT (state, fullname) {
    state.bankFullname = fullname
  }
}

export default {
  state,
  getters,
  actions,
  mutations
}

