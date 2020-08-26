<style scoped>
.v-parallax__image {
  filter: blur(3px) contrast(0.9);
}
</style>

<template>
  <v-app>
    <!-- ヘッダバー -->
    <v-app-bar
      style="background:linear-gradient(100deg, rgba(130,182,12,0.6) 0%, rgba(214,221,36,0.4) 40%, rgba(68,208,240,0.6) 100%);"
      fixed
      flat
      app
    >
      <!-- ロゴ -->
      <v-btn
        v-if="!$vuetify.breakpoint.xs"
        color="#fff"
        dark
        rounded
        outlined
        large
        class="ma-2"
        text
        nuxt
        to="/"
      >
        Bischierge
      </v-btn>
      <v-spacer />
      <LoginBtn v-show="!isLoggedIn" />
      <div v-if="isLoggedIn">
        <v-btn large icon color="white" nuxt to="/search">
          <v-icon>
            search
          </v-icon>
        </v-btn>
        <v-btn large icon color="white" nuxt to="/favorites">
          <v-icon>
            favorite
          </v-icon>
        </v-btn>
        <v-badge dot color="red" overlap offset-y="13" :value="inviteNotice">
          <v-btn large icon color="white" nuxt to="/invitation">
            <v-icon>
              mail
            </v-icon>
          </v-btn>
        </v-badge>
      </div>
      <SignupBtn />
      <v-btn
        v-if="isLoggedIn"
        large
        icon
        color="white"
        @click.stop="rightDrawer = !rightDrawer"
      >
        <v-icon>
          menu
        </v-icon>
      </v-btn>
    </v-app-bar>
    <v-content>
      <!-- 各ページの挿入 -->
      <nuxt />
    </v-content>
    <!-- 右のナビゲーション内部 -->
    <v-navigation-drawer v-model="rightDrawer" right temporary fixed>
      <v-list>
        <!-- 右リスト内Homeボタン（ログイン時のみ表示） -->
        <v-list-item v-if="isLoggedIn" nuxt to="/">
          <v-list-item-action>
            <v-icon>home</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>Home</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <!-- 右リスト内プロフィール（ログイン時のみ表示） -->
        <v-list-item v-if="isLoggedIn" nuxt to="/profile">
          <v-list-item-action>
            <v-badge dot color="red" overlap offset-x="1" :value="followNotice">
              <v-icon>person</v-icon>
            </v-badge>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>Profile</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <!-- 右リスト内お気に入りリスト（ログイン時のみ表示） -->
        <v-list-item v-if="isLoggedIn" nuxt to="/favorites">
          <v-list-item-action>
            <v-icon>favorite</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>Favorite Bistros</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <!-- 右リスト内訪問したお店リスト（ログイン時のみ表示） -->
        <v-list-item v-if="isLoggedIn" nuxt to="/visited">
          <v-list-item-action>
            <v-icon>check_circle_outline</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>Visited Bistros</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <!-- 右リスト内インビテーションリスト（ログイン時のみ表示） -->
        <v-list-item v-if="isLoggedIn" nuxt to="/invitation">
          <v-list-item-action>
            <v-icon>mail</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>Invitation</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-divider />
        <!-- 右リスト内ログアウトボタン（ログイン時のみ表示） -->
        <v-list-item v-if="isLoggedIn" @click="logout">
          <v-list-item-action>
            <v-icon>arrow_back</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>Logout</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
    <!-- フッター -->
    <v-card height="150">
      <v-footer absolute class="font-weight-medium">
        <v-col class="text-center" cols="12">
          {{ new Date().getFullYear() }} — <strong>Bischierge</strong>
        </v-col>
      </v-footer>
    </v-card>

    <Success />
    <Loading />
  </v-app>
</template>

<script>
import axios from "~/plugins/axios"

import firebase from "@/plugins/firebase"
import LoginBtn from "../components/LoginBtn"
import SignupBtn from "../components/SignupBtn"
import Loading from "../components/Loading"
import Success from "../components/Success"

export default {
  components: {
    LoginBtn,
    SignupBtn,
    Loading,
    Success
  },
  data() {
    return {
      fixed: false,
      rightDrawer: false,
      followNotice: false,
      inviteNotice: false
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.isLoggedIn
    },
    userName() {
      return this.$store.state.name
    },
    getFollowNotification() {
      return this.$store.state.followNotification
    },
    getInviteNotification() {
      return this.$store.state.inviteNotification
    }
  },
  watch: {
    getFollowNotification() {
      this.getNotice()
    },
    getInviteNotification() {
      this.getNotice()
    },
    isLoggedIn() {
      this.getNotice()
    }
  },
  mounted() {
    this.getNotice()
  },
  methods: {
    getNotice() {
      axios
        .get("/v1/notification", {
          params: {
            user_id: this.$store.state.id
          }
        })
        .then(res => {
          if (!res.data.length) {
            this.followNotice = false
            this.inviteNotice = false
          } else {
            this.followNotice = false
            this.inviteNotice = false
            res.data.filter(notice => {
              switch (notice.action_from) {
                case "follow":
                  this.followNotice = true
                  this.$store.commit("setfollowNotice", true)
                  break
                case "invite":
                  this.inviteNotice = true
                  this.$store.commit("setinviteNotice", true)
                  break
                default:
              }
            })
          }
        })
    },
    logout() {
      firebase
        .auth()
        .signOut()
        .then(() => {
          this.$store.commit("setNotice", {
            status: true,
            message: "Success Logout"
          })
          setTimeout(() => {
            this.$store.commit("setNotice", {})
          }, 2000) //2秒後に隠す
          this.$store.commit("login", null)
          this.rightDrawer = false
          this.$router.push("/")
        })
        .catch(error => {
          console.log(error)
        })
    }
  }
}
</script>
