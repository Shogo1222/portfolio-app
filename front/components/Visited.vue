<template>
  <!-- 直近訪問したお店ボタン -->
  <div v-if="isLoggedIn">
    <v-btn
      v-if="!is_visited"
      class="mt-2"
      large
      icon
      color="white"
      @click="visited()"
    >
      <v-icon>
        check_circle_outline
      </v-icon>
    </v-btn>
    <v-btn
      v-if="is_visited"
      class="mt-2"
      large
      icon
      color="primary"
      @click="visitedDestroy()"
    >
      <v-icon>
        check_circle
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
      is_visited: false,
      action: "visited"
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.isLoggedIn
    }
  },
  created: function() {
    this.getVisited()
  },
  mounted() {
    this.getVisited()
  },
  methods: {
    getVisited() {
      axios
        .get("/v1/visited_shop", {
          params: {
            user_id: this.$store.state.id,
            shop_id: this.shop.shop_id
          }
        })
        .then(res => {
          if (!res.data.length) {
            this.is_visited = false
          } else {
            this.is_visited = true
          }
        })
    },
    visited() {
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
            .post("/v1/visited_shop", {
              user_id: this.$store.state.id,
              logged_shop_id: res.data.id
            })
            .then(() => {
              this.is_visited = true
            })
        })
    },
    visitedDestroy() {
      axios
        .delete("/v1/visited_shop", {
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
              this.is_visited = false
            })
        })
    }
  }
}
</script>
