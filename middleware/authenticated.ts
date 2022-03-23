import { Context, Middleware } from '@nuxt/types'
import { getUserID, isAuthenticated } from '~/modules/authService'

const checkAuth: Middleware = async (context: Context) => {
  const { store, redirect, route } = context
  const _isAuthenticated = await isAuthenticated()
  // 未認証の場合はログインページへリダイレクト
  if (!_isAuthenticated && route.fullPath !== '/login')
    return redirect('/login')
  // 認証済みの場合はユーザー情報をStoreに保存
  if (_isAuthenticated && store.getters['adminUser/getUserID'] === null) {
    const userID = await getUserID()
    store.dispatch('adminUser/setUserID', userID)
  }
}

export default checkAuth
