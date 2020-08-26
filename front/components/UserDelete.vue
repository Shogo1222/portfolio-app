<template>
  <!-- デリートボタン部分 -->
  <v-dialog v-model="dialog" max-width="800px">
    <!-- デリートモーダルボタン部分 -->
    <template v-slot:activator="{ on }">
      <v-btn
        v-if="isLoggedIn"
        outlined
        class="red--text font-weight-medium mt-3"
        v-on="on"
      >
        <v-icon color="red">
          delete
        </v-icon>
      </v-btn>
    </template>
    <!-- デリートモーダル部分 -->
    <v-card>
      <v-card-title class="headline">
        Delete your account?
      </v-card-title>
      <v-container>
        <v-row align="center" justify="center">
          <v-col cols="11">
            <v-card-text class="red--text">
              ※We can not restore deleted account<br />
              ※We can not remove Testuser
            </v-card-text>
            <validation-observer v-slot="{ invalid }">
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

              <v-card-actions v-if="email !== 'test@gmail.com'">
                <v-spacer />
                <v-btn color="black" text @click="dialog = false">
                  Disagree
                </v-btn>
                <v-btn color="red" text :disabled="invalid" @click="deleteUser">
                  Agree
                </v-btn>
              </v-card-actions>
              <p v-if="error" class="errors">
                {{ error }}
              </p>
            </validation-observer>
          </v-col>
        </v-row>
      </v-container>
    </v-card>
  </v-dialog>
</template>

<script>
import firebase from "~/plugins/firebase"
import axios from "~/plugins/axios"

export default {
  props: {
    email: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      authenticatedEmail: "",
      password: "",
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
    deleteUser() {
      var user = firebase.auth().currentUser
      var credential = firebase.auth.EmailAuthProvider.credential(
        this.email,
        this.password
      )
      // firebase上で再認証させる
      user
        .reauthenticateWithCredential(credential)
        .then(() => {
          var uid = this.$store.state.uid
          user.delete().then(() => {
            axios
              .delete("/v1/users", { params: { uid: uid } })
              .then(() => {
                this.$store.commit("setNotice", {
                  status: true,
                  message: "Success Delete"
                })
                setTimeout(() => {
                  this.$store.commit("setNotice", {})
                }, 2000) //2秒後に隠す
                this.$store.commit("login", null)
                this.$store.commit("setLoading", false)
                this.$router.push("/")
              })
              .catch(error => {
                console.log(error)
                this.$store.commit("setLoading", false)
              })
          })
        })
        .catch(error => {
          this.error = (code => {
            switch (code) {
              case "auth/email-already-in-use":
                return "Email address is already in use"
              case "auth/wrong-password":
                return "The password is in correct"
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
