<template>
  <v-app>
    <v-container>
      <v-flex xs12 sm12 md12>
        <h2 class="display-1 font-weight-thin my-5">
          Your Favorite Bistros
        </h2>
        <v-row justify="center">
          <v-col cols="12" md="12" xl="10">
            <v-row justify="center">
              <v-card
                v-for="shop in shops"
                :key="shop.id"
                class="mx-3 my-4"
                width="350"
              >
                <v-img height="250" :src="shop.photo.pc.l">
                  <v-card-actions class="float-right">
                    <Favorite :shop-id="shop.id" />
                  </v-card-actions>
                </v-img>
                <v-card-title>
                  {{ shop.name | truncate(19, "...") }}
                </v-card-title>
                <v-card-text style="height: 250px;">
                  <div class="my-4 subtitle-1">
                    {{ shop.catch | truncate(30, "...") }}
                  </div>

                  <span class="grey--text">・平均予算：</span><br />
                  <span> {{ shop.budget.average | truncate(15, "...") }}</span>
                  <br />
                  <span class="grey--text">・アクセス：</span>
                  <br />
                  <span>{{ shop.mobile_access | truncate(23, "...") }}</span>
                  <br />
                  <span class="grey--text">・営業時間：</span>
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
import ShopDetailsDialog from "../components/ShopDetailsDialog.vue"
import Favorite from "../components/Favorite.vue"

export default {
  components: {
    ShopDetailsDialog,
    Favorite
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
      alert: false,
      shops: []
    }
  },
  created: function() {
    this.getFavorites()
  },
  methods: {
    // 現在地の緯度、経度の取得
    getFavorites() {
      axios.get("/v1/favorite?user_id=1").then(res => {
        if (res.data) {
          var shopIds = []
          res.data.forEach(data => {
            shopIds.push(data.shop_id)
          })
          this.getShops(shopIds)
          console.log(res.data)
        } else {
          console.log("yay")
        }
      })
    },
    getShops(shopIds) {
      console.log(shopIds)
      this.$axios
        .$get("/api/", {
          params: {
            key: process.env.VUE_APP_HOTPEPPER_API_KEY,
            count: 100,
            id: shopIds.join(","),
            format: "json"
          },
          headers: {
            "Access-Control-Allow-Origin": "*"
          }
        })
        .then(res => {
          this.shops = res.results.shop
          this.length = res.results.shop.length
          if (res.results.shop.length === 0) {
            this.alert = true
          }
        })
    }
  }
}
</script>
