import Vue from "vue"
import Vuex from "vuex"

Vue.use(Vuex)

const store = () => {
  return new Vuex.Store({
    state: {
      id: "",
      name: "",
      isLoggedIn: false,
      loading: false,
      notification: {
        status: false,
        message: ""
      }
    },
    mutations: {
      login(state, user) {
        if (!user) {
          state.id = ""
          state.name = ""
          state.isLoggedIn = false
        } else {
          state.id = user.id
          state.name = user.name
          state.isLoggedIn = true
          console.log(state)
        }
      },
      setLoading(state, payload) {
        state.loading = payload
      },
      setNotice(state, payload) {
        //追加
        state.notification = payload
      }
    }
  })
}

export default store
