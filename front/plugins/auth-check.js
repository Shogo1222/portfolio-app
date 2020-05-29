import firebase from "@/plugins/firebase"
import axios from "@/plugins/axios"

const authCheck = ({ store, redirect }) => {
  firebase.auth().onAuthStateChanged(async user => {
    if (user) {
      const { data } = await axios.get(`/v1/users?uid=${user.uid}`);
      if(data){
        data.isLoggedIn = true;
      }
      store.commit("login", data);
    } else {
      store.commit("login", null);
    }
  });
}

export default authCheck
