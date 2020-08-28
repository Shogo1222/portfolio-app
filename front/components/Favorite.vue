<template>
  <!-- お気に入りボタン -->
  <div v-if="isLoggedIn">
    <v-btn
      v-if="!is_favorite"
      class="mt-2"
      large
      icon
      color="white"
      @click="favorite()"
    >
      <v-icon>
        favorite
      </v-icon>
    </v-btn>
    <v-btn
      v-if="is_favorite"
      class="mt-2"
      large
      icon
      color="pink"
      @click="favoriteDestroy()"
    >
      <v-icon>
        favorite
      </v-icon>
    </v-btn>
  </div>
</template>

<script>
import axios from "~/plugins/axios"

export default {
  props: {
    shop: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      is_favorite: false,
      action: "favorite"
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.isLoggedIn
    }
  },
  created: function() {
    this.getFavorite()
  },
  methods: {
    getFavorite() {
      axios
        .get("/v1/favorite", {
          params: {
            user_id: this.$store.state.id,
            shop_id: this.shop.shop_id
          }
        })
        .then(res => {
          if (!res.data.length) {
            this.is_favorite = false
          } else {
            this.is_favorite = true
          }
        })
    },
    favorite() {
      axios
        .post("/v1/logged_shop", {
          user_id: this.$store.state.id,
          shop_id: this.shop.shop_id,
          action_from: this.action,
          lat: this.shop.lat,
          lng: this.shop.lng,
          name: this.shop.name,
          catch: this.shop.catch,
          capacity: this.shop.capacity,
          photo: this.shop.photo,
          budget: this.shop.budget,
          budget_memo: this.shop.budget_memo,
          mobile_access: this.shop.mobile_access,
          open: this.shop.open,
          non_smoking: this.shop.non_smoking,
          address: this.shop.address
        })
        .then(res => {
          axios
            .post("/v1/favorite", {
              user_id: this.$store.state.id,
              logged_shop_id: res.data.id
            })
            .then(() => {
              this.is_favorite = true
            })
        })
    },
    favoriteDestroy() {
      axios
        .delete("/v1/favorite", {
          params: {
            user_id: this.$store.state.id,
            shop_id: this.shop.shop_id
          }
        })
        .then(() => {
          axios
            .delete("/v1/logged_shop", {
              params: {
                user_id: this.$store.state.id,
                shop_id: this.shop.shop_id,
                action_from: this.action
              }
            })
            .then(() => {
              this.is_favorite = false
            })
        })
    }
  }
}
</script>
