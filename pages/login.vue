<template>
  <amplify-authenticator :auth-config="authConfig"> </amplify-authenticator>
</template>

<script>
import { I18n } from 'aws-amplify'

// amplify-ui-vueで用意している文言をカスタマイズ
const dict = {
  ja: {
    'Forgot your password? ': ' ', // オプションでは非表示にできないので、文言をスペースにして非表示としている
    'Reset password': ' ', // オプションでは非表示にできないので、文言をスペースにして非表示としている
    'Sign In': 'ログイン',
  },
}
I18n.putVocabularies(dict)
I18n.setLanguage('ja')

export default {
  data() {
    return {
      authConfig: {
        signInConfig: {
          header: 'ログイン',
          isSignUpDisplayed: false, // 新規登録画面へのリンクは非表示。管理者アカウントは自由に作成させないため。
        },
      },
    }
  },
}
</script>
