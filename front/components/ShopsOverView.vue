<template>
  <v-app v-if="shops.length">
    <v-container>
      <v-flex xs12 sm12 md12>
        <h2 v-if="!isOtherUser" class="display-1 font-weight-thin my-5">
          Recent {{ description }}
        </h2>
        <h2 v-if="isOtherUser" class="display-1 font-weight-thin my-5">
          Others {{ description }}
        </h2>
        <v-row justify="center">
          <VisitedMap
            v-if="action === 'visited' && !isOtherUser"
            :shops="shops"
          />
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
                    <Favorite v-if="action === 'favorite'" :shop="shop" />
                    <Visited v-if="action === 'visited'" :shop="shop" />
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
          </v-col>
        </v-row>
      </v-flex>
    </v-container>
  </v-app>
</template>

<script>
import axios from "~/plugins/axios"
import ShopDetailsDialog from "./ShopDetailsDialog.vue"
import Favorite from "./Favorite.vue"
import Visited from "./Visited.vue"
import VisitedMap from "./VisitedMap.vue"

export default {
  components: {
    ShopDetailsDialog,
    Favorite,
    Visited,
    VisitedMap
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
  props: {
    userId: {
      type: Number,
      required: false,
      default: 0
    },
    userIds: {
      type: Array,
      required: false,
      default: () => {}
    },
    action: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      shops: [],
      description: ""
    }
  },
  computed: {
    isOtherUser() {
      return this.$store.state.id !== this.userId
    }
  },
  watch: {
    userId: function() {
      this.getShops()
    },
    userIds: function() {
      this.getShops()
    }
  },
  created: function() {
    this.getShops()
  },
  mounted: function() {
    switch (this.action) {
      case "favorite":
        this.description = "Favorite Bistros"
        break
      case "visited":
        this.description = "Visited Bistros"
        break
      case "comment":
        this.description = "Commented Bistros"
        break
      default:
    }
  },
  methods: {
    getShops() {
      axios
        .get("/v1/logged_shop/recent_shop/", {
          params: {
            user_id: this.userId ? this.userId : this.userIds,
            action_from: this.action
          }
        })
        .then(res => {
          // プロフィール画面ではそのまま返す
          if (this.$store.state.id === this.userId) {
            this.shops = res.data
            return
          } else {
            // お気に入り・訪問したお店ページでは同shop_idと
            // お気に入り・訪問したお店を除外する。
            var shopIds = []
            var excludeDuplicateShops = []

            // shop_idの重複を除去
            res.data.filter(shop => {
              if (shopIds.indexOf(shop.shop_id) === -1) {
                excludeDuplicateShops.push(shop)
                shopIds.push(shop.shop_id)
              }
            })
            switch (this.action) {
              case "favorite":
                this.excludeFavorite(shopIds, excludeDuplicateShops)
                break
              case "visited":
                this.excludeVisited(shopIds, excludeDuplicateShops)
                break
              default:
                break
            }
          }
        })
    },
    excludeFavorite(shopIds, excludeDuplicateShops) {
      axios
        .get("/v1/favorite", {
          params: {
            user_id: this.$store.state.id,
            shop_id: shopIds
          }
        })
        .then(res => {
          // ユーザーがお気に入りしているショップの除去
          var favoriteShopIds = []
          res.data.filter(favorite => favoriteShopIds.push(favorite.shop_id))
          var excludeFavoriteShops = excludeDuplicateShops.filter(
            shop => favoriteShopIds.indexOf(shop.shop_id) == -1
          )
          this.shops = excludeFavoriteShops
        })
    },
    excludeVisited(shopIds, excludeDuplicateShops) {
      axios
        .get("/v1/visited_shop", {
          params: {
            user_id: this.$store.state.id,
            shop_id: shopIds
          }
        })
        .then(res => {
          // ユーザーが訪問したことがあるショップの除去
          var visitedShopIds = []
          res.data.filter(visitedShop =>
            visitedShopIds.push(visitedShop.shop_id)
          )
          var excludeVisitedShops = excludeDuplicateShops.filter(
            shop => visitedShopIds.indexOf(shop.shop_id) == -1
          )
          this.shops = excludeVisitedShops
        })
    }
  }
}
</script>
