<!-- ユーザーダッシュボー -->
<template>
  <v-app>
    <v-container>
      <v-row align="center" justify="center">
        <v-col cols="12">
          <v-sheet class="mt-5" height="400" width="100%">
            <v-img height="400" width="100%" src="profile_card_back.jpg">
              <v-col>
                <v-list-item>
                  <v-list-item-content>
                    <v-list-item-title class="title">
                      <h2 class="white--text font-weight-thin">
                        <v-icon class="mr-2" color="white">
                          person
                        </v-icon>
                        {{ name }}
                      </h2>
                    </v-list-item-title>
                    <v-list-item-subtitle>
                      <h2 class="white--text font-weight-thin">
                        <v-icon class="mr-2" color="white">
                          email
                        </v-icon>
                        {{ email }}
                      </h2>
                    </v-list-item-subtitle>
                  </v-list-item-content>
                </v-list-item>
              </v-col>
              <v-col cols="12" class="text-center">
                <v-avatar class="profile" color="grey" size="180">
                  <v-img :src="imageUrl" />
                </v-avatar>
                <div>
                  <UserEdit
                    :name="name"
                    :email="email"
                    @success-update="getUser"
                  />
                  <UserDelete :email="email" @success-update="getUser" />
                </div>
              </v-col>
            </v-img>
          </v-sheet>
          <v-card flat class="mt-5">
            <h2 class="font-weight-thin pl-5 pt-5">
              Your Tags:
            </h2>
            <v-col cols="12" class="text-center">
              <UserTag :user-id="id" />
            </v-col>
          </v-card>
          <v-divider />

          <v-card flat class="mt-5">
            <v-tabs v-model="tab" centered icons-and-text>
              <v-tabs-slider />

              <!-- フォローしているタブ -->
              <v-tab href="#tab-1">
                Following ({{ followingNum }})
                <v-icon>person</v-icon>
              </v-tab>

              <!-- フォローされているタブ-->
              <v-tab href="#tab-2">
                Follower ({{ followerNum }})
                <v-icon>local_offer</v-icon>
              </v-tab>
            </v-tabs>

            <!-- フォローしているタブ -->
            <v-tabs-items v-model="tab">
              <v-tab-item value="tab-1">
                <v-container>
                  <v-list max-height="300px" style="overflow: auto">
                    <v-list-item
                      v-for="user in following"
                      :key="user.id"
                      @click=""
                    >
                      <UserDetailsDialogList :user-id="user.id" />
                    </v-list-item>
                  </v-list>
                  <v-row v-if="!following.length">
                    <v-card else class="mx-auto" width="350">
                      <v-list-item three-line>
                        <v-list-item-content>
                          <v-list-item-title class="headline mb-1">
                            Sorry! Not found
                          </v-list-item-title>
                          <v-list-item-subtitle>
                            Please follow someone
                          </v-list-item-subtitle>
                        </v-list-item-content>
                      </v-list-item>
                    </v-card>
                  </v-row>
                </v-container>
              </v-tab-item>

              <!-- フォローされているタブ-->
              <v-tab-item value="tab-2">
                <v-card flat>
                  <v-container>
                    <v-list max-height="300px" style="overflow: auto">
                      <v-list-item
                        v-for="user in follower"
                        :key="user.id"
                        @click=""
                      >
                        <UserDetailsDialogList :user-id="user.id" />
                      </v-list-item>
                    </v-list>
                    <v-row v-if="!follower.length">
                      <v-card else class="mx-auto" width="350">
                        <v-list-item three-line>
                          <v-list-item-content>
                            <v-list-item-title class="headline mb-1">
                              Sorry! Not found
                            </v-list-item-title>
                            <v-list-item-subtitle>
                              You don't have any followers
                            </v-list-item-subtitle>
                          </v-list-item-content>
                        </v-list-item>
                      </v-card>
                    </v-row>
                  </v-container>
                </v-card>
              </v-tab-item>
            </v-tabs-items>
          </v-card>
        </v-col>
      </v-row>
      <v-divider />
    </v-container>

    <ShopsOverView :user-id="this.id" :action="visited" />
    <ShopsOverView :user-id="this.id" :action="favorite" />
    <ShopsOverView :user-id="this.id" :action="comment" />
  </v-app>
</template>
<script>
import axios from "~/plugins/axios"
import UserEdit from "~/components/UserEdit"
import UserDelete from "~/components/UserDelete"
import UserTag from "~/components/UserTag"
import ShopsOverView from "~/components/ShopsOverView"
import UserDetailsDialogList from "../components/UserDetailsDialogList"

export default {
  components: {
    UserEdit,
    UserDelete,
    UserTag,
    ShopsOverView,
    UserDetailsDialogList
  },
  filters: {
    truncate: function(value, length) {
      var ommision = "..."
      if (value.length <= length) {
        return value
      }
      return value.substring(0, length) + ommision
    }
  },
  data() {
    return {
      id: 0,
      name: "",
      email: "",
      imageUrl: "",
      favorite: "favorite",
      visited: "visited",
      comment: "comment",
      tab: null,
      follower: [],
      following: [],
      followerNum: 0,
      followingNum: 0
    }
  },
  created() {
    if (!this.$store.state.uid) {
      setTimeout(() => {
        this.getUser()
        this.getFollower()
        this.getFollowing()
      }, 1000)
    } else {
      this.getUser()
      this.getFollower()
      this.getFollowing()
    }
  },
  methods: {
    getUser() {
      axios
        .get("/v1/users", {
          params: {
            uid: this.$store.state.uid
          }
        })
        .then(res => {
          this.id = res.data.id
          this.name = res.data.name
          this.email = res.data.email
          this.imageUrl = res.data.image.url ? res.data.image.url : ""
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
                this.followingNum = this.following.length
              })
          }
        })
    },
    getFollower() {
      axios
        .get("/v1/follow_relationship", {
          params: {
            following_user_id: this.$store.state.id
          }
        })
        .then(res => {
          var follower_user = res.data
          var follower_user_ids = []
          if (!follower_user.length) {
            this.follower = []
          } else {
            follower_user.filter(follower => {
              follower_user_ids.push(follower.user_id)
            })
            axios
              .get("/v1/users", {
                params: {
                  ids: follower_user_ids
                }
              })
              .then(res => {
                this.follower = res.data
                this.followerNum = this.follower.length
              })
          }
        })
    }
  }
}
</script>
