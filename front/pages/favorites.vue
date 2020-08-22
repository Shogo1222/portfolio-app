<!-- お気に入りリストページ -->
<template>
  <v-app>
    <v-container>
      <v-flex xs12 sm12 md12>
        <h2 class="display-1 font-weight-thin my-5">
          Your Favorite Bistros
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
                      please go back home and add favorite your bistros
                    </v-list-item-subtitle>
                  </v-list-item-content>
                </v-list-item>
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
import Visited from "../components/Visited.vue"

export default {
  middleware: "authenticated",
  components: {
    ShopDetailsDialog,
    Favorite,
    Visited
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
      shops: [],
      action: "favorite"
    }
  },
  created: function() {
    this.getShops()
  },
  methods: {
  getShops() {
    axios.get("/v1/logged_shop", {
        params: {
          user_id: this.$store.state.id,
          action_from: this.action
        }
      })
      .then(res => {
        console.log(res.data)
        this.shops = res.data
      })
  }
}
}
</script>
