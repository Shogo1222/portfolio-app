<!-- お気に入りリストページ -->
<template>
  <v-app>
    <v-container>
      <v-flex xs12 sm12 md12>
        <h2 class="display-1 font-weight-thin my-5">
          Your Visited Bistros
        </h2>
        <v-row justify="center">
          <v-col cols="12" md="12" xl="10">
            <v-row v-if="shops.length" justify="center">
              <v-card
                v-for="shop in shops"
                :key="shop.id"
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
                  <span> {{ shop.budget | truncate(20, "...") }}</span>
                  <br />
                  <span class="grey--text">Access: </span>
                  <br />
                  <span>{{ shop.mobile_access | truncate(23, "...") }}</span>
                  <br />
                  <span class="grey--text">Open hours: </span>
                  <br />
                  <span>{{ shop.open | truncate(30, "...") }}</span>
                </v-card-text>
                <v-card-actions class="mt-4">
                  <ShopDetailsDialog :shop="shop" />
                </v-card-actions>
              </v-card>
            </v-row>
            <!--　項目が取得出来ない場合  -->
            <v-row v-if="!shops.length">
              <v-card else class="mx-auto" width="400">
                <v-list-item three-line>
                  <v-list-item-content>
                    <v-list-item-title class="headline mb-1">
                      Sorry! We can't find any bistros
                    </v-list-item-title>
                    <v-list-item-subtitle>
                      please go back home and check visited bistros
                    </v-list-item-subtitle>
                  </v-list-item-content>
                </v-list-item>
              </v-card>
            </v-row>
            <!-- フォロワーレコメンド -->
            <v-row justify="center">
              <ShopsOverView
                v-if="followerIds"
                :user-ids="followerIds"
                :action="action"
              />
            </v-row>
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
import ShopsOverView from "~/components/ShopsOverView"

export default {
  middleware: "authenticated",
  components: {
    ShopDetailsDialog,
    Favorite,
    Visited,
    ShopsOverView
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
      shops: [],
      action: "visited",
      followerIds: []
    }
  },
  mounted() {
    this.getShops()
    this.getFollower()
  },
  methods: {
    getShops() {
      axios
        .get("/v1/logged_shop", {
          params: {
            user_id: this.$store.state.id,
            action_from: this.action
          }
        })
        .then(res => {
          this.shops = res.data
        })
    },
    // フォロワーを一件選んでレコメンドを表示する
    getFollower() {
      axios
        .get("/v1/follow_relationship", {
          params: {
            user_id: this.$store.state.id
          }
        })
        .then(res => {
          if (res.data) {
            res.data.forEach(follow => {
              this.followerIds.push(follow.following_user_id)
            })
          }
        })
    }
  }
}
</script>
