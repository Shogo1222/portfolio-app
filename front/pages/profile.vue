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
                  <UserDelete
                  :email="email"
                  @success-update="getUser"
                  />
                </div>
              </v-col>
            </v-img>
          </v-sheet>
          <v-card class="mt-5">
            <h2 class="font-weight-thin pl-5 pt-5">
              Your Tags:
            </h2>
            <v-col cols="12" class="text-center">
              <UserTag :user-id="id" />
            </v-col>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
    <ShopsOverView
    :user-id="this.id"
    :action="visited"
    />
    <ShopsOverView
    :user-id="this.id"
    :action="favorite"
    />
    <ShopsOverView
    :user-id="this.id"
    :action="comment"
    />

  </v-app>
</template>
<script>
import axios from "~/plugins/axios"
import UserEdit from "~/components/UserEdit"
import UserDelete from "~/components/UserDelete"
import UserTag from "~/components/UserTag"
import ShopsOverView from "~/components/ShopsOverView"

export default {
  components: {
    UserEdit,
    UserDelete,
    UserTag,
    ShopsOverView
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
      comment: "comment"
    }
  },
  created() {
    this.getUser()
  },
  methods: {
    getUser() {
      if (!this.$store.state.uid) {
        setTimeout(() => {
          this.getUser()
        }, 1000) // uidがvuexから取得できなければ再起的にリトライ
      } else {
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
      }
    }
  }
}
</script>
