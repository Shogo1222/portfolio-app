<template>
  <!-- ボタン部分 -->
  <v-dialog v-model="dialog" max-width="800px">
    <template v-slot:activator="{ on }">
      <v-btn v-show="!isLoggedIn" class="white--text" text large v-on="on">
        SIGNUP
      </v-btn>
    </template>
    <!-- モーダル部分 -->
    <v-card>
      <validation-observer v-slot="{ invalid }">
        <v-toolbar dark>
          <v-toolbar-title>SignUp form</v-toolbar-title>
        </v-toolbar>
        <v-card-text>
          <v-form>
            <ValidationProvider
              v-slot="{ errors }"
              name="name"
              rules="required|max:8"
            >
              <v-text-field
                v-model="name"
                label="ユーザーネーム"
                name="name"
                prepend-icon=""
                :error-messages="errors[0]"
                type="text"
              />
            </ValidationProvider>
            <ValidationProvider
              v-slot="{ errors }"
              name="email"
              rules="required|email"
            >
              <v-text-field
                v-model="email"
                label="Email"
                name="email"
                prepend-icon=""
                :error-messages="errors[0]"
                type="text"
              />
            </ValidationProvider>
            <ValidationProvider
              v-slot="{ errors }"
              name="password"
              rules="required|min:6"
            >
              <v-text-field
                id="password"
                v-model="password"
                label="Password"
                name="password"
                prepend-icon=""
                :error-messages="errors[0]"
                type="password"
              />
            </ValidationProvider>
            <ValidationProvider
              v-slot="{ errors }"
              name="Password(確認用)"
              rules="required|min:6|confirmed:password"
            >
              <v-text-field
                id="password_confirmation"
                v-model="password_confirmation"
                label="Password(確認用)"
                name="password_confimation"
                prepend-icon=""
                :error-messages="errors[0]"
                type="password"
              />
            </ValidationProvider>
          </v-form>
          <p v-if="error" class="errors">
            {{ error }}
          </p>
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn
            color="black"
            class="white--text"
            :disabled="invalid"
            @click.prevent="register"
          >
            SIGNUP
          </v-btn>
        </v-card-actions>
      </validation-observer>
    </v-card>
  </v-dialog>
</template>

<script>
import firebase from "~/plugins/firebase"
import axios from "~/plugins/axios"

export default {
  data() {
    return {
      email: "",
      password: "",
      password_confirmation: "",
      name: "",
      dialog: false,
      error: ""
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.isLoggedIn
    }
  },
  methods: {
    register() {
      if (this.password !== this.password_confirmation) {
        this.error = "※パスワードとパスワード確認が一致していません"
      }

      this.$store.commit("setLoading", true)
      firebase
        .auth()
        .createUserWithEmailAndPassword(this.email, this.password)
        .then(res => {
          axios
            .post("/v1/users", {
              email: res.user.email,
              name: this.name,
              uid: res.user.uid
            })
            .then(() => {
              this.$store.commit("setLoading", false)
              this.$store.commit("login", {
                email: res.user.email,
                name: this.name,
                uid: res.user.uid
              })
              this.$store.commit("setNotice", {
                status: true,
                message: "Success Signup!"
              })
              setTimeout(() => {
                this.$store.commit("setNotice", {})
              }, 2000) //2秒後に隠す
              this.dialog = false
            })
        })
        .catch(error => {
          this.$store.commit("setLoading", false)
          this.error = (code => {
            switch (code) {
              case "auth/email-already-in-use":
                return "既にそのメールアドレスは使われています"
              case "auth/wrong-password":
                return "※パスワードが正しくありません"
              case "auth/weak-password":
                return "※パスワードは最低6文字以上にしてください"
              default:
                return "※メールアドレスとパスワードをご確認ください"
            }
          })(error.code)
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
