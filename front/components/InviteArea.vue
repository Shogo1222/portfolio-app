<template>
  <!-- 招待部分 -->
  <v-container v-if="isLoggedIn">
    <v-row align="center" justify="center">
      <v-dialog v-model="dialog" width="500" scrollable>
        <!-- 招待ダイアログボタン部分 -->
        <template v-slot:activator="{ on }">
          <v-btn
            class="ma-2 mt-5"
            color="primary"
            outlined
            dark
            width="100%"
            style="text-transform: none"
            v-on="on"
          >
            Send Invitation
          </v-btn>
        </template>

        <!-- タ招待ダイアログ部分 -->
        <v-card>
          <v-list v-if="following.length">
            <v-subheader>Select Invite User</v-subheader>
            <v-list-item-group v-model="model" color="primary">
              <v-list-item
                v-for="user in following"
                :key="user.id"
                :value="user.id"
                @click=""
              >
                <v-list-item-avatar color="grey">
                  <v-img :src="user.image.url ? user.image.url : ''" />
                </v-list-item-avatar>
                <v-list-item-content>
                  <v-list-item-title v-text="user.name" />
                </v-list-item-content>
              </v-list-item>
            </v-list-item-group>
            </v-list-item>
          </v-list>
          <v-card-actions>
            <v-spacer />
            <v-btn color="primary" dark outlined rounded @click="invite">
              Invite
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-row>
  </v-container>
</template>

<script>
import axios from "~/plugins/axios"

export default {
  props: {
    shop: {
      type: Object,
      required: true
    },
    isShow: {
      type: Boolean,
      required: true
    }
  },
  data() {
    return {
      dialog: false,
      model: 0,
      following: [],
      action: "invite"
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.isLoggedIn
    }
  },
  watch: {},
  mounted() {
      this.getFollowing()
  },
  methods: {
    invite(){
      this.$store.commit("setLoading", true)
      axios
        .post("/v1/logged_shop", {
          user_id: this.$store.state.id,
          shop_id: this.shop.shop_id,
          action_from: this.action,
          lat: this.shop.lat,
          lng: this.shop.lng,
          name: this.shop.name,
          catch: this.shop.catch,
          capacity: this.shop.capacity,
          photo: this.shop.photo,
          budget: this.shop.budget,
          budget_memo: this.shop.budget_memo,
          mobile_access: this.shop.mobile_access,
          open: this.shop.open,
          non_smoking: this.shop.non_smoking,
          address: this.shop.address
        })
        .then(res => {
          axios
            .post("/v1/invitation", {
              user_id: this.$store.state.id,
              to_user_id: this.model,
              logged_shop_id: res.data.id
            })
            .then(res => {
              axios
                .post("/v1/notification", {
                  user_id: res.data.to_user_id,
                  action_from: "invite",
                  invitation_id: res.data.id
                })
                .then(() => {
                  this.dialog = false
                  setTimeout(() => {
                    this.$store.commit("setLoading", false)
                  }, 500) //1秒後に隠す
                })
            })
        })
    },
    getFollowing() {
      axios
        .get("/v1/follow_relationship", {
          params: {
            user_id: this.$store.state.id
          }
        })
        .then(res => {
          var following_user = res.data
          var following_user_ids = []
          if (!following_user.length) {
            this.following = []
          } else {
            following_user.filter(following => {
              following_user_ids.push(following.following_user_id)
            })
            axios
              .get("/v1/users", {
                params: {
                  ids: following_user_ids
                }
              })
              .then(res => {
                this.following = res.data
              })
          }
        })
    }
  }
}
</script>
