import firebase from "@/plugins/firebase"
import axios from "@/plugins/axios"

// firebaseから取得したユーザーのDB存在確認
// 存在すればvuexへcommit
const authCheck = ({ store }) => {
  firebase.auth().onAuthStateChanged(async user => {
    if (user) {
      const { data } = await axios.get(`/v1/users?uid=${user.uid}`)
      if (data) {
        data.isLoggedIn = true
        data.uid = user.uid
      }
      store.commit("login", data)
    } else {
      store.commit("login", null)
    }
  })
}

export default authCheck
