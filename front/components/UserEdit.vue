<template>
  <!-- エディットボタン部分 -->
  <v-dialog v-model="dialog" max-width="800px">
    <!-- エディットモーダルボタン部分 -->
    <template v-slot:activator="{ on }">
      <v-btn
        v-show="isLoggedIn"
        outlined
        class="white--text font-weight-medium mt-3"
        v-on="on"
      >
        EDIT
        <v-icon class="ml-1" color="white">
          edit
        </v-icon>
      </v-btn>
    </template>
    <!-- エディットモーダル部分 -->
    <v-card>
      <validation-observer v-slot="{ invalid }">
        <v-toolbar dark>
          <v-toolbar-title>Edit form</v-toolbar-title>
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
                v-model="inputedName"
                label="Username"
                name="inputedName"
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
                v-model="inputedEmail"
                label="Email"
                name="inputedEmail"
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
            <v-text-field
              v-model="imageName"
              label="Click ME! Let's upload your image"
              prepend-icon="attach_file"
              @click="pickFile"
            />
            <input
              ref="image"
              type="file"
              style="display: none"
              accept="image/*"
              @change="onFilePicked"
            />
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
            @click.prevent="update"
          >
            UPDATE
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
  props: {
    name: {
      type: String,
      required: true
    },
    email: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      dialog: false,
      error: "",
      inputedName: "",
      inputedEmail: "",
      password: "",
      imageName: "",
      imageUrl: "",
      imageFile: ""
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.isLoggedIn
    }
  },
  watch: {
    name: function() {
      this.inputedName = this.name
    },
    email: function() {
      this.inputedEmail = this.email
    }
  },
  methods: {
    // 選択された画像ファイルの処理
    pickFile() {
      this.$refs.image.click()
    },
    onFilePicked(e) {
      const files = e.target.files
      if (files[0] !== undefined) {
        this.imageName = files[0].name
        if (this.imageName.lastIndexOf(".") <= 0) {
          return
        }
        const fr = new FileReader()
        fr.readAsDataURL(files[0])
        fr.addEventListener("load", () => {
          this.imageUrl = fr.result
          this.imageFile = files[0]
        })
      } else {
        this.imageName = ""
        this.imageFile = ""
        this.imageUrl = ""
      }
    },
    update() {
      this.$store.commit("setLoading", true)
      var user = firebase.auth().currentUser
      user
        .updateEmail(this.inputedEmail)
        .then(this.updateRailsUser(user))
        .catch(error => {
          this.$store.commit("setLoading", false)
          this.error = "We can not update record. please retry," + error
        })
    },
    updateRailsUser(user) {
      // 再認証成功後、vuexとDBに値を挿入
      let formData = new FormData()
      formData.append("email", this.inputedEmail)
      formData.append("name", this.inputedName)
      formData.append("uid", user.uid)
      if (this.imageFile) {
        formData.append("image", this.imageFile)
      }
      axios
        .patch("/v1/users", formData, {
          headers: {
            "Content-Type": "multipart/form-data"
          }
        })
        .then(responseUser => {
          this.$store.commit("login", {
            id: responseUser.data.id,
            email: responseUser.data.email,
            name: responseUser.data.name,
            uid: responseUser.data.uid
          })
          this.$store.commit("setNotice", {
            status: true,
            message: "Success Edit!"
          })
          this.$store.commit("setLoading", false)
          setTimeout(() => {
            this.reauthenticateWithCredential()
            this.$store.commit("setNotice", {})
          }, 2000) //2秒後に隠す
          this.$emit("success-update")
          this.dialog = false
        })
    },
    reauthenticateWithCredential() {
      var user = firebase.auth().currentUser
      var credential = firebase.auth.EmailAuthProvider.credential(
        this.inputedEmail,
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

<style scoped>
.errors {
  color: red;
  margin-top: 20px;
}
</style>
