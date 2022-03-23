import Vue from 'vue'
import Amplify, * as AmplifyModules from 'aws-amplify'
import { Context } from '@nuxt/types'
// @ts-ignore
import { AmplifyPlugin } from 'aws-amplify-vue'
export default (context: Context) => {
  Amplify.configure({
    Auth: {
      region: context.$config.AWS_REGION,
      userPoolId: context.$config.COGNITO_USER_POOL_ID,
      userPoolWebClientId: context.$config.COGNITO_USER_POOL_WEB_CLIENT_ID,
    },
  })

  Vue.use(AmplifyPlugin, AmplifyModules)
}
