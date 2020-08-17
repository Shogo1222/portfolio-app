import Vue from "vue"
import {
  ValidationProvider,
  ValidationObserver,
  localize,
  extend
} from "vee-validate"
import ja from "vee-validate/dist/locale/ja.json"
import { required, max, min, email, confirmed } from "vee-validate/dist/rules"

// バリデーションチェック項目
// vueサイドで項目を制御

// 必須項目
extend("required", required)
// emailの入力方式
extend("email", email)
// 最大文字数
extend("max", max)
// 最小文字数
extend("min", min)
// パスワード確認で同一チェック
extend("confirmed", confirmed)

Vue.component("ValidationProvider", ValidationProvider)
Vue.component("ValidationObserver", ValidationObserver)
localize("ja", ja)
