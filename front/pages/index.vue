<template>
  <v-app>
    <v-parallax src="key_visual.jpg" flat style="height:95vh;">
      <v-row align="center" justify="center">
        <v-col class="text-center" cols="12">
          <h1 class="display-2 font-weight-thin mb-4">
            - Bischierge -
          </h1>
          <h4 class="display-1 font-weight-thin mb-4">
            What do you feel like eating?
          </h4>
          <StartBtn @get-location-shops="getLocation" />
        </v-col>
      </v-row>
    </v-parallax>
    <v-container>
      <v-flex xs12 sm12 md12>
        <h2 class="display-1 font-weight-thin my-5">
          Recommended Bistros
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

            <v-row v-if="!shops.length">
              <v-card else class="mx-auto" width="400">
                <v-list-item three-line>
                  <v-list-item-content>
                    <v-list-item-title class="headline mb-1">
                      Sorry! We can't find any bistros
                    </v-list-item-title>
                    <v-list-item-subtitle>
                      please go back home and add favorite your
                    </v-list-item-subtitle>
                  </v-list-item-content>
                </v-list-item>
              </v-card>
            </v-row>
          </v-col>
        </v-row>
        <v-row align="center" justify="space-around">
          <v-btn
            class="ma-2"
            color="#000"
            rounded
            outlined
            :loading="loading"
            :disabled="loading"
            @click="loader = 'loading'"
          >
            Reload
            <v-icon dark right>
              refresh
            </v-icon>
          </v-btn>
        </v-row>
      </v-flex>
    </v-container>
  </v-app>
</template>

<script>
import StartBtn from "../components/StartBtn.vue"
import ShopDetailsDialog from "../components/ShopDetailsDialog.vue"
import Favorite from "../components/Favorite.vue"

export default {
  components: {
    StartBtn,
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
      loader: null,
      loading: false,
      latitude: 0,
      longitude: 0,
      alert: false,
      shops: [],
      genre: [],
      range: null
    }
  },
  watch: {
    loader() {
      const l = this.loader
      this[l] = !this[l]
      setTimeout(() => (this[l] = false), 1000)
      this.loader = null
      this.getLocation()
      window.scroll({
        top: 750,
        behavior: "smooth"
      })
    }
  },
  created: function() {
    this.getLocation()
  },
  methods: {
    // 現在地の緯度、経度の取得
    getLocation(terms) {
      if (terms) {
        this.range = terms["priceRange"]
        this.genre = terms["genre"]
      }
      if (process.client) {
        if (!navigator.geolocation) {
          alert(
            "現在地情報を取得できませんでした。お使いのブラウザでは現在地情報を利用できない可能性があります。"
          )
          return
        }
        const options = {
          enableHighAccuracy: false,
          timeout: 15000,
          maximumAge: 0
        }
        navigator.geolocation.getCurrentPosition(
          this.success,
          this.error,
          options
        )
      }
    },
    // 位置情報取得：成功時の処理
    success(position) {
      this.latitude = position.coords.latitude
      this.longitude = position.coords.longitude

      this.getShops()

      if (this.alert === true) {
        this.alert = false
      }
    },
    // 位置情報取得：失敗時の処理
    error(error) {
      switch (error.code) {
        case 1: //PERMISSION_DENIED
          alert("位置情報の利用が許可されていません")
          break
        case 2: //POSITION_UNAVAILABLE
          alert("現在位置が取得できませんでした")
          break
        case 3: //TIMEOUT
          alert("タイムアウトになりました")
          break
        default:
          alert("現在位置が取得できませんでした")
          break
      }
    },
    // ホットペッパーAPIから周辺のデータを取得
    // G004 Japanese
    // G007 Chinese
    // G005 Western
    // G006 Italian
    // G001 Izakaya
    // G002 Bar
    // G017 Korean
    // G014 Sweets
    getShops() {
      var priceCode = null
      switch (this.range) {
        case 1000:
          priceCode = "B009, B010"
          break
        case 2000:
          priceCode = "B011, B001"
          break
        case 3000:
          priceCode = "B002"
          break
        case 4000:
          priceCode = "B003"
          break
        default:
          priceCode = ""
      }

      this.$axios
        .$get("/api/", {
          params: {
            key: process.env.VUE_APP_HOTPEPPER_API_KEY,
            lat: this.latitude,
            lng: this.longitude,
            count: 100,
            genre: this.genre.length ? this.genre.toString() : null,
            budget: priceCode,
            range: 4,
            format: "json"
          },
          headers: {
            "Access-Control-Allow-Origin": "*"
          }
        })
        .then(res => {
          this.shops = res.results.shop
          this.shops = this.ChooseAtRandom(this.shops)
        })
    },
    ChooseAtRandom(arrayData) {
      // 取得件数によってcountを変更
      var defaultCount = 9
      var arrayLength = arrayData["length"]
      var count = defaultCount <= arrayLength ? defaultCount : arrayLength
      var result = []
      if (!arrayLength === 0) {
        return []
      }
      for (var i = 0; i < count; i++) {
        var arrayIndex = Math.floor(Math.random() * arrayData.length)
        result[i] = arrayData[arrayIndex]
        // 1回選択された値は削除して再度選ばれないようにする
        arrayData.splice(arrayIndex, 1)
      }
      return result
    }
  }
}
</script>
