import {
  AdminUserState,
  AdminUserGetters,
  AdminUserActions,
  AdminUserMutations,
} from './types'

export const state = (): AdminUserState => ({
  id: null,
})

export const getters: AdminUserGetters = {
  getUserID: (state) => state.id,
}

export const actions: AdminUserActions = {
  setUserID({ commit }, id: string) {
    commit('setUserID', id)
  },
}

export const mutations: AdminUserMutations = {
  setUserID(state, id: string) {
    state.id = id
  },
}
