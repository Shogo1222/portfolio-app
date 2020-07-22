<template>
  <div v-if="isLoggedIn">
    <v-btn v-if="!is_favorite" class="mt-2" large icon color="white">
      <v-icon @click="favorite()">
        favorite
      </v-icon>
    </v-btn>
    <v-btn v-if="is_favorite" class="mt-2" large icon color="pink">
      <v-icon @click="favoriteDestroy()">
        favorite
      </v-icon>
    </v-btn>
  </div>
</template>

<script>
import axios from "~/plugins/axios"

export default {
  props: {
    shopId: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      is_favorite: false
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.isLoggedIn
    }
  },
  created: function() {
    axios
      .get(
        "/v1/favorite?user_id=" +
          this.$store.state.id +
          "&shop_id=" +
          this.shopId +
          ""
      )
      .then(res => {
        if (!res.data) {
          this.is_favorite = false
        } else {
          this.is_favorite = true
        }
      })
  },
  methods: {
    favorite() {
      const favorite = {
        user_id: this.$store.state.id,
        shop_id: this.shopId
      }
      axios
        .post("/v1/favorite", {
          favorite
        })
        .then(() => {
          this.is_favorite = true
        })
    },
    favoriteDestroy() {
      axios
        .delete(
          "/v1/favorite?user_id=" +
            this.$store.state.id +
            "&shop_id=" +
            this.shopId +
            ""
        )
        .then(() => {
          this.is_favorite = false
        })
    }
  }
}
</script>
