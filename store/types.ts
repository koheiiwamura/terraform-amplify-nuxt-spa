import { ActionTree, ActionContext, MutationTree, GetterTree } from 'vuex'

export interface RootState {}

export interface AdminUserState {
  id: string | null
}

/**
 * Create a type to save some characters:
 */
export type AdminUserActionContext = ActionContext<AdminUserState, RootState>

/**
 * AdminUser getters
 */
export interface AdminUserGetters
  extends GetterTree<AdminUserState, RootState> {
  getUserID: (state: AdminUserState) => string | null
}

/**
 * AdminUser actions
 */
export interface AdminUserActions
  extends ActionTree<AdminUserState, RootState> {
  setUserID: (context: AdminUserActionContext, id: string) => void
}

/**
 * AdminUser mutations
 */
export interface AdminUserMutations extends MutationTree<AdminUserState> {
  setUserID: (state: AdminUserState, AdminUserToken: string) => void
}
