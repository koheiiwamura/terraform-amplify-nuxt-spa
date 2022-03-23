import { Auth } from 'aws-amplify'

export const getUserID = async (): Promise<string> => {
  const user = await Auth.currentAuthenticatedUser()
  return user.attributes.sub
}

export const isAuthenticated = async (): Promise<boolean> => {
  return await new Promise((resolve, _) => {
    /* eslint promise/param-names: 1 */
    return Auth.currentAuthenticatedUser()
      .then(() => resolve(true))
      .catch(() => resolve(false))
  })
}
