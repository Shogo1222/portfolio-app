<template>

  <v-app v-if="shops.length">
    <v-container>
      <v-flex xs12 sm12 md12>
        <h2 class="display-1 font-weight-thin my-5">
          {{ description }}
        </h2
        <v-row justify="center">
          <VisitedMap v-if="action ==='visited'" :shops="shops" />
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
      required: true
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
  watch: {
    userId: function() {
      this.getShops()
    }
  },
  created: function() {
    this.getShops()
  },
  mounted: function() {
    switch (this.action) {
      case "favorite":
        this.description = "Recent Favorite Bistros"
        break
      case "visited":
        this.description = "Recent Visited Bistros"
        break
      case "comment":
        this.description = "Recent Commented Bistros"
        break
      default:
    }
  },
  methods: {
    getShops() {
      axios
        .get("/v1/logged_shop/recent_shop/", {
          params: {
            user_id: this.userId,
            action_from: this.action
          }
        })
        .then(res => {
          this.shops = res.data
        })
    }
  }
}
</script>
