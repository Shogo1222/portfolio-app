<!-- 検索ページ -->
<template>
  <v-app>
    <v-container>
      <v-flex xs12 sm12 md12>
        <v-row justify="start">
          <v-col cols="11">
            <v-text-field
              ref="searchTxt"
              v-model="searchTxt"
              clear-icon="close"
              clearable
              light
              data-vv-name="address"
              label="Name, ShopTag, UserTag"
              single-line
            />
          </v-col>
          <v-col cols="1">
            <v-btn
              class="mt-2 float-right"
              color="#000"
              icon
              rounded
              @click="search"
            >
              <v-icon>search</v-icon>
            </v-btn>
          </v-col>
        </v-row>

        <!-- タブタイトル -->
        <v-row justify="center">
          <v-col cols="12" md="12" xl="10">
            <v-card flat>
              <v-tabs v-model="tab" centered icons-and-text>
                <v-tabs-slider />

                <v-tab href="#tab-1">
                  Users
                  <v-icon>person</v-icon>
                </v-tab>

                <v-tab href="#tab-2">
                  User Tag
                  <v-icon>local_offer</v-icon>
                </v-tab>

                <v-tab href="#tab-3">
                  Shop Tag
                  <v-icon>local_offer</v-icon>
                </v-tab>
              </v-tabs>

              <!-- タブアイテム -->
              <v-tabs-items v-model="tab">
                <!-- ユーザー検索タブ -->
                <v-tab-item value="tab-1">
                  <v-container>
                    <v-list>
                      <v-list-item
                        v-for="user in users"
                        :key="user.id"
                        @click=""
                      >
                        <UserDetailsDialogList :user-id="user.id" />
                      </v-list-item>
                    </v-list>
                    <v-row v-if="!users.length">
                      <v-card else class="mx-auto" width="350">
                        <v-list-item three-line>
                          <v-list-item-content>
                            <v-list-item-title class="headline mb-1">
                              Sorry! Not found
                            </v-list-item-title>
                            <v-list-item-subtitle>
                              Change your search text
                            </v-list-item-subtitle>
                          </v-list-item-content>
                        </v-list-item>
                      </v-card>
                    </v-row>
                  </v-container>
                </v-tab-item>

                <!-- ユーザータグタブ -->
                <v-tab-item value="tab-2">
                  <v-card flat>
                    <v-container>
                      <v-list>
                        <v-list-item
                          v-for="user in tagsUsers"
                          :key="user.id"
                          @click=""
                        >
                          <UserDetailsDialogList :user-id="user.id" />
                        </v-list-item>
                      </v-list>
                      <v-row v-if="!tagsUsers.length">
                        <v-card else class="mx-auto" width="350">
                          <v-list-item three-line>
                            <v-list-item-content>
                              <v-list-item-title class="headline mb-1">
                                Sorry! Not found
                              </v-list-item-title>
                              <v-list-item-subtitle>
                                Change your search text
                              </v-list-item-subtitle>
                            </v-list-item-content>
                          </v-list-item>
                        </v-card>
                      </v-row>
                    </v-container>
                  </v-card>
                </v-tab-item>

                <!-- ショップタグタブ -->
                <v-tab-item value="tab-3">
                  <v-card flat>
                    <v-card flat>
                      <v-row justify="center">
                        <v-col cols="12" md="12" xl="10">
                          <v-row v-if="tagsShops.length" justify="center">
                            <v-card
                              v-for="shop in tagsShops"
                              :key="shop.shop_id"
                              class="mx-3 my-4"
                              width="350"
                            >
                              <v-img height="250" :src="shop.photo">
                                <v-card-actions class="float-right">
                                  <Favorite :shop="shop" />
                                  <Visited :shop="shop" />
                                </v-card-actions>
                              </v-img>
                              <v-card-title>
                                {{ shop.name | truncate(15, "...") }}
                              </v-card-title>
                              <v-card-text style="height: 250px;">
                                <div class="my-4 subtitle-1">
                                  {{ shop.catch | truncate(30, "...") }}
                                </div>

                                <span class="grey--text">Budget: </span><br />
                                <span>
                                  {{ shop.budget | truncate(20, "...") }}</span>
                                <br />
                                <span class="grey--text">Access: </span>
                                <br />
                                <span>{{
                                  shop.mobile_access | truncate(23, "...")
                                }}</span>
                                <br />
                                <span class="grey--text">Open hours: </span>
                                <br />
                                <span>{{
                                  shop.open | truncate(30, "...")
                                }}</span>
                              </v-card-text>
                              <v-card-actions class="mt-4">
                                <ShopDetailsDialog :shop="shop" />
                              </v-card-actions>
                            </v-card>
                          </v-row>

                          <v-row v-if="!tagsShops.length">
                            <v-card else class="mx-auto" width="350">
                              <v-list-item three-line>
                                <v-list-item-content>
                                  <v-list-item-title class="headline mb-1">
                                    Sorry! Not found
                                  </v-list-item-title>
                                  <v-list-item-subtitle>
                                    Change your search text
                                  </v-list-item-subtitle>
                                </v-list-item-content>
                              </v-list-item>
                            </v-card>
                          </v-row>
                        </v-col>
                      </v-row>
                    </v-card>
                  </v-card>
                </v-tab-item>
              </v-tabs-items>
            </v-card>
          </v-col>
        </v-row>
      </v-flex>
    </v-container>
  </v-app>
</template>

<script>
import axios from "~/plugins/axios"
import ShopDetailsDialog from "../components/ShopDetailsDialog.vue"
import Favorite from "../components/Favorite.vue"
import Visited from "../components/Visited.vue"
import UserDetailsDialogList from "../components/UserDetailsDialogList"

export default {
  middleware: "authenticated",
  components: {
    ShopDetailsDialog,
    Favorite,
    Visited,
    UserDetailsDialogList
  },
  filters: {
    truncate: function(value, length) {
      if (!value) {
        return ""
      }
      var ommision = "..."
      if (value.length <= length) {
        return value
      }
      return value.substring(0, length) + ommision
    }
  },
  data() {
    return {
      tab: null,
      searchTxt: "",
      shops: [],
      tagsUsers: [],
      tagsShops: [],
      users: []
    }
  },
  watch: {
    "$route.query.search_txt": {
      handler: function(search) {
        this.searchTxt = search
        this.search()
      },
      deep: true,
      immediate: true
    },
    "$route.query.tab": {
      handler: function(tab) {
        this.tab = tab
        this.search()
      },
      deep: true,
      immediate: true
    }
  },
  created: function() {
    if (this.$route.query.search_txt) {
      this.searchTxt = this.$route.query.search_txt
    }

    if (this.$route.query.tab) {
      this.tab = this.$route.query.tab
    }
    this.search()
  },
  methods: {
    search() {
      this.tagsShops = []
      this.tagsUsers = []
      this.users = []
      this.getTagsUsers()
      this.getTagsShops()
      this.getUser()
    },
    getTagsUsers() {
      axios
        .get("/v1/user_tags", {
          params: {
            tag: this.searchTxt
          }
        })
        .then(res => {
          this.tags = res.data
          if (!this.tags.length) {
            this.tagsUsers = []
          } else {
            var userIds = []
            this.tags.filter(tag => {
              userIds.push(tag.user_id)
            })
            axios
              .get("/v1/users", {
                params: {
                  ids: userIds
                }
              })
              .then(res => {
                this.tagsUsers = res.data
              })
          }
        })
    },
    getTagsShops() {
      if (!this.searchTxt) {
        return
      }
      axios
        .get("/v1/shop_tags", {
          params: {
            tag: this.searchTxt
          }
        })
        .then(res => {
          this.tags = res.data
          if (!this.tags.length) {
            this.tagsShops = []
          } else {
            var shopIds = []
            this.tags.filter(tag => {
              shopIds.push(tag.shop_id)
            })
            axios
              .get("/v1/logged_shop", {
                params: {
                  shop_ids: shopIds,
                  action_from: "tag"
                }
              })
              .then(res => {
                this.tagsShops = res.data
              })
          }
        })
    },
    getUser() {
      axios
        .get("/v1/users", {
          params: {
            name: this.searchTxt
          }
        })
        .then(res => {
          this.users = res.data
        })
    }
  }
}
</script>
