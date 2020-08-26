import Vue from "vue"
import Vuex from "vuex"

Vue.use(Vuex)

const store = () => {
  return new Vuex.Store({
    state: {
      id: "",
      name: "",
      uid: "",
      isLoggedIn: false,
      loading: false,
      notification: {
        status: false,
        message: ""
      },
      followNotification: false,
      inviteNotification: false
    },
    mutations: {
      // ログイン状態
      login(state, user) {
        if (!user) {
          state.id = ""
          state.name = ""
          state.uid = ""
          state.isLoggedIn = false
        } else {
          state.id = user.id
          state.name = user.name
          state.uid = user.uid
          state.isLoggedIn = true
        }
      },
      // 画面ぐるぐる
      setLoading(state, payload) {
        state.loading = payload
      },
      // Success表示
      setNotice(state, payload) {
        state.notification = payload
      },
      // follow通知
      setfollowNotice(state, status) {
        state.followNotification = status
      },
      // invitation通知
      setinviteNotice(state, status) {
        state.inviteNotification = status
      }
    }
  })
}

export default store
