<template>
  <!-- サインアップボタン部分 -->
  <v-dialog v-model="dialog" max-width="800px">
    <template v-slot:activator="{ on }">
      <v-btn v-show="!isLoggedIn" class="white--text" text large v-on="on">
        SIGNUP
      </v-btn>
    </template>
    <!-- サインアップモーダル部分 -->
    <v-card>
      <validation-observer v-slot="{ invalid }">
        <v-toolbar dark>
          <v-toolbar-title>SignUp form</v-toolbar-title>
        </v-toolbar>
        <v-card-text>
          <v-form>
            <!-- Username: 最大文字数8 -->
            <ValidationProvider
              v-slot="{ errors }"
              name="name"
              rules="required|max:8"
            >
              <v-text-field
                v-model="name"
                label="Username"
                name="name"
                prepend-icon=""
                :error-messages="errors[0]"
                type="text"
              />
            </ValidationProvider>
            <!-- メールアドレス: 入力方式チェック -->
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
            <!-- パスワード: 最小文字数6 -->
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
            <!-- パスワード: 最小文字数6 -->
            <ValidationProvider
              v-slot="{ errors }"
              name="Password(Confirm)"
              rules="required|min:6|confirmed:password"
            >
              <v-text-field
                id="password_confirmation"
                v-model="password_confirmation"
                label="Password(Confirm)"
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
        this.error = "Passwords do not match each other"
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
            .then(responseUser => {
              this.$store.commit("setLoading", false)
              this.$store.commit("login", {
                id: responseUser.data.id,
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
                return "Email address is already in use"
              case "auth/wrong-password":
                return "The password is in correct"
              case "auth/weak-password":
                return "Confirm password, please input above 6 letters"
              default:
                return "Confirm email address and password"
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
