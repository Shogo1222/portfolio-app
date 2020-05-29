<template>
  <v-app>
    <!-- ヘッダーbar -->
    <v-app-bar fixed app style="background-color:rgba(87,82,82,0.3);">
      <!-- ヘッダータイトル -->
      <v-btn
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
    <h1 v-show="isLoggedIn" class="white--text font-weight-thin mb-1 col-auto" text large>
      Hi ! {{ userName }}
    </h1>
    <SignupBtn />
    <v-btn
    v-if="isLoggedIn"
    dark
    @click.stop="rightDrawer = !rightDrawer"
    >
    <v-icon>
      mdi-menu
    </v-icon>
  </v-btn>
</v-app-bar>
<v-parallax
src="key_visual.jpg"
flat
style="height:100vh;"
>
<v-row
align="center"
justify="center"
>
<v-col class="text-center" cols="12">
  <h1 class="display-2 font-weight-thin mb-4">
    - Bischierge -
  </h1>
  <h4 class="display-1 font-weight-thin mb-4">
    What do you feel like eating?
  </h4>
  <v-btn
  color="#fff"
  dark
  rounded
  outlined
  large
  class="ma-2"
  @click="dialog = true"
  >
  Start Now
</v-btn>
</v-col>
</v-row>
</v-parallax>
<v-content>

  <v-container fill-height>
    <!-- 各ページの挿入 -->
    <nuxt />
  </v-container>
</v-content>
<!-- 右のナビゲーション内部 -->
<v-navigation-drawer v-model="rightDrawer" right temporary fixed>
  <v-list>
    <!-- 右リスト内ログアウトボタン（ログイン時のみ表示） -->
    <v-list-item
    v-if="isLoggedIn"
    @click="logout"
    >
    <v-list-item-action>
      <v-icon>fas fa-heart</v-icon>
    </v-list-item-action>
    <v-list-item-content>
      <v-list-item-title>Logout</v-list-item-title>
    </v-list-item-content>
  </v-list-item>
  <!-- 右リスト内 自分の投稿ボタン（ログイン時のみ表示） -->
  <v-list-item
  v-if="isLoggedIn"
  nuxt
  to="/my_topics"
  exact
  >
  <v-list-item-action>
    <v-icon>fas fa-camera</v-icon>
  </v-list-item-action>
  <v-list-item-content>
    <v-list-item-title>自分の投稿</v-list-item-title>
  </v-list-item-content>
</v-list-item>
<!-- 右リスト内 current_areaボタン -->
<v-list-item nuxt to="/current_area" exact>
  <v-list-item-action>
    <v-icon>fas fa-search-location</v-icon>
  </v-list-item-action>
  <v-list-item-content>
    <v-list-item-title>現在地周辺のお店を探す</v-list-item-title>
  </v-list-item-content>
</v-list-item>
<!-- 右リスト内 みんなの写真ボタン -->
<v-list-item nuxt to="/" exact>
  <v-list-item-action>
    <v-icon>fas fa-camera-retro</v-icon>
  </v-list-item-action>
  <v-list-item-content>
    <v-list-item-title>みんなの写真</v-list-item-title>
  </v-list-item-content>
</v-list-item>
</v-list>
</v-navigation-drawer>
<!-- フッター -->
<v-card height="150">
  <v-footer
  absolute
  class="font-weight-medium"
  >
  <v-col
  class="text-center"
  cols="12"
  >
  {{ new Date().getFullYear() }} — <strong>Bischierge</strong>
</v-col>
</v-footer>
</v-card>

<Success />
<Loading></Loading>　
</v-app>
</template>

<script>
import firebase from "@/plugins/firebase";
import LoginBtn from "../components/LoginBtn"
import SignupBtn from "../components/SignupBtn"
import Loading from "../components/Loading";
import Success from "../components/Success";

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
      title: "俺達のハンバーガー！"
    }
  },
  computed: {
    isLoggedIn() {
      console.log(this.$store.state.isLoggedIn);
      return this.$store.state.isLoggedIn;
    },
    userName(){
      return this.$store.state.name;
    }
  },
  methods: {
    logout() {
      firebase
      .auth()
      .signOut()
      .then(() => {
        this.$store.commit("setNotice", {
          status: true,
          message: "Success Logout"
        });
        setTimeout(() => {
          this.$store.commit("setNotice",{});
        }, 2000); //2秒後に隠す
        this.$store.commit("login", null);
        this.rightDrawer = false;
      })
      .catch(error => {
        console.log(error);
      });
    }
  }
}
</script>

<style scoped>
.v-parallax__image{
  filter: blur(3px) contrast(0.9);
}
</style>
