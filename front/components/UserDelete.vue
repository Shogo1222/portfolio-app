<template>
  <!-- デリートボタン部分 -->
  <v-dialog v-model="dialog" max-width="800px">
    <!-- デリートモーダルボタン部分 -->
    <template v-slot:activator="{ on }">
      <v-btn
        v-show="isLoggedIn"
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

      <v-card-actions>
        <v-spacer />
        <v-btn color="black" text @click="dialog = false">
          Disagree
        </v-btn>
        <v-btn color="red" text @click="deleteUser" :disabled="invalid">
          Agree
        </v-btn>
      </v-card-actions>
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
  watch: {
    email: function() {
      this.authenticatedEmail = this.email
    }
  },
  methods: {
    deleteUser() {
      this.$store.commit("setLoading", true)
      var user = firebase.auth().currentUser
      this.reauthenticateWithCredential(user)
      user
        .delete()
        .then(
          function() {
            axios
              .delete("/v1/users", { parmas: { uid: this.$store.state.uid } })
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
          }.bind(this)
        )
        .catch(error => {
          console.log(error)
          this.$store.commit("setLoading", false)
        })
    },
    reauthenticateWithCredential(user) {
      var credential = firebase.auth.EmailAuthProvider.credential(
        this.authenticatedEmail,
        this.password
      )
      // firebase上で再認証させる
      user.reauthenticateWithCredential(credential).catch(function(error) {
        this.$store.commit("setLoading", false)
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
