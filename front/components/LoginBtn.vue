<template>
  <!-- ボタン部分 -->
  <v-dialog v-model="dialog" max-width="600px">
    <template v-slot:activator="{ on }">
      <v-btn v-show="!isLoggedIn" class="white--text" text large v-on="on">
        LOGIN
      </v-btn>
    </template>
    <!-- モーダル部分 -->
    <v-card style="background-color:rgba(255,255,255,0.8);">
      <v-row justify="center">
        <v-col cols="10" align="center">
          <h2>Login</h2>
          <form>
            <v-text-field v-model="email" :counter="50" label="email" data-vv-name="email" required></v-text-field>
            <v-text-field
            v-model="password"
            label="password"
            data-vv-name="password"
            required
            :type="show1 ? 'text' : 'password'"
            :append-icon="show1 ? 'mdi-eye' : 'mdi-eye-off'"
            @click:append="show1 = !show1"
            >
          </v-text-field>
          <v-btn dark class="mr-4" @click="login">submit</v-btn>
          <v-btn dark class="mr-4" @click="testLogin">testLogin</v-btn>
          <p v-if="error" class="errors">{{error}}</p>
        </form>
      </v-col>
    </v-row>
  </v-card>
</v-dialog>
</template>

<script>
import firebase from "@/plugins/firebase";

export default {
  data() {
    return {
      email: "",
      password: "",
      show1: false,
      error: "",
      dialog: false
    };
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.isLoggedIn
    }
  },
  methods: {
    login() {
      firebase
      .auth()
      .signInWithEmailAndPassword(this.email, this.password)
      .then(() => {
        this.dialog = false
      })
      .catch(error => {
        console.log(error);
        this.error = (code => {
          switch (code) {
            case "auth/user-not-found":
            return "メールアドレスが間違っています";
            case "auth/wrong-password":
            return "※パスワードが正しくありません";
            default:
            return "※メールアドレスとパスワードをご確認ください";
          }
        })(error.code);
      });
    },
    // テストユーザー用ログイン
    testLogin() {
      firebase
      .auth()
      .signInWithEmailAndPassword('test@gmail.com', 'testPassword')
      .then(() => {
        this.$store.commit("setNotice", {
          status: true,
          message: "Success Login!"
        });
        setTimeout(() => {
          this.$store.commit("setNotice",{});
        }, 2000); //2秒後に隠す
        this.dialog = false;
      })
    }
  }
}
</script>

<style scoped>
.errors {
  color: red;
  margin-top: 20px;
}
</style>
