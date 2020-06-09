

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
      Recommended Bistro
    </h2>
            <v-row>
                <v-col cols="12">
                    <v-row>
                        <v-card v-for="shop in shops" :key="shop.id" class="mx-auto my-4" width="350">
                            <v-img height="250" :src="shop.photo.pc.l">
                              <v-card-actions class="float-right">
                                <Favorite :shop_id="shop.id" />
                              </v-card-actions>
                            </v-img>
                            <v-card-title>{{ shop.name | truncate(19, '...') }}</v-card-title>
                            <v-card-text  style="height: 250px;">
                                <div class="my-4 subtitle-1">
                                    {{ shop.catch| truncate(30, '...') }}
                                </div>

                                <span class="grey--text">・平均予算：</span>
                                <br>
                                <span> {{ shop.budget.average| truncate(15, '...')  }}</span><br />
                                <span class="grey--text">・アクセス：</span>
                                <br>
                                <span>{{ shop.mobile_access| truncate(23, '...')  }}</span><br />
                                <span class="grey--text">・営業時間：</span>
                                <br>
                                <span>{{ shop.open | truncate(30, '...') }}</span>
                            </v-card-text>
                            <v-card-actions class="mt-4">
                            <ShopDetailsDialog :shop="shop" />
                            </v-card-actions>

                        </v-card>
                    </v-row>
                </v-col>
            </v-row>
            <v-row align="center" justify="space-around">
                <v-btn class="ma-2" color="#000" rounded outlined :loading="loading" :disabled="loading" @click="loader = 'loading'">
                    Reload
                    <v-icon dark right>refresh</v-icon>
                </v-btn>
            </v-row>
        </v-flex>
    </v-container>

</v-app>

</template>

<script>

import StartBtn from "../components/StartBtn.vue";
import ShopDetailsDialog from "../components/ShopDetailsDialog.vue";
import Favorite from "../components/Favorite.vue";

export default {
    components: {
        StartBtn,
        ShopDetailsDialog,
        Favorite
    },
    data() {
        return {
            loader: null,
            loading: false,
            latitude: 0,
            longitude: 0,
            alert: false,
            shops: [],
            terms: [],
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
        },
    },
    filters: {
        truncate: function(value, length) {
            var ommision = "...";
            if (value.length <= length) {
                return value;
            }
            return value.substring(0, length) + ommision;
        }
    },
    created: function() {
        this.getLocation()
    },
    methods: {
        // 現在地の緯度、経度の取得
        getLocation(terms) {
                if (terms) {
                    this.terms = terms
                }
                if (process.client) {
                    if (!navigator.geolocation) {
                        alert(
                            "現在地情報を取得できませんでした。お使いのブラウザでは現在地情報を利用できない可能性があります。"
                        )
                        return
                    }
                    const options = {
                        enableHighAccuracy: true,
                        timeout: 5000,
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
            // G003 Italian
            // G001 Izakaya
            // G002 Bar
            // G017 Korean
            // G014 Sweets
            getShops() {
                var priceCode = null
                var genre = null
                var isTermsArray = this.terms.length === 0 ? false : true
                if (isTermsArray) {
                    var priceCode = this.terms['priceCode']
                    var genre = this.terms['genre']
                    switch (priceRange) {
                        case 1000:
                            priceCode = 'B009, B010'
                        case 2000:
                            priceCode = 'B011, B001'
                        case 3000:
                            priceCode = 'B002'
                        case 4000:
                            priceCode = 'B003'
                            break;
                        default:
                            priceCode = ''
                    }
                }
                this.$axios
                    .$get("hotpepper/gourmet/v1/", {
                        params: {
                            key: process.env.VUE_APP_HOTPEPPER_API_KEY,
                            lat: this.latitude,
                            lng: this.longitude,
                            count: 100,
                            genre: genre,
                            budget: priceCode,
                            range: 4,
                            format: "json",
                        },
                        headers: {
                            "Access-Control-Allow-Origin": "*"
                        }
                    })
                    .then(res => {
                        this.shops = res.results.shop
                        this.shops = this.ChooseAtRandom(this.shops, 6);
                        this.length = res.results.shop.length
                        if (res.results.shop.length === 0) {
                            this.alert = true
                        }
                    })
            },
            ChooseAtRandom(arrayData, count) {
                // countが設定されていない場合は1にする
                var count = count || 1;
                var arrayData = arrayData;
                var result = [];
                if (!arrayData) {
                    return;
                }
                for (var i = 0; i < count; i++) {
                    var arrayIndex = Math.floor(Math.random() * arrayData.length);
                    result[i] = arrayData[arrayIndex];
                    // 1回選択された値は削除して再度選ばれないようにする
                    arrayData.splice(arrayIndex, 1);
                }
                return result;
            },

    }
}

</script>
