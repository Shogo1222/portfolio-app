<template>
  <!-- コメントお気に入りエリア -->
  <div v-if="isLoggedIn">
    <v-row>
      <v-col cols="12">
        <p class="mt-5 float-right">
          {{ favorite_num }}
        </p>
        <v-btn
          v-if="!is_favorite"
          class="mt-2 float-right"
          large
          icon
          color="gray"
        >
          <v-icon @click="favorite()">
            favorite
          </v-icon>
        </v-btn>
        <v-btn
          v-if="is_favorite"
          class="mt-2 float-right"
          large
          icon
          color="pink"
        >
          <v-icon @click="favoriteDestroy()">
            favorite
          </v-icon>
        </v-btn>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import axios from "~/plugins/axios"

export default {
  props: {
    commentId: {
      type: Number,
      required: true
    },
    shopId: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      is_favorite: false,
      favorite_num: 0
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
  mounted() {
    this.$store.watch(() => {
      this.getFavorite()
    })
  },
  methods: {
    getFavorite() {
      axios
        .get("/v1/comment_favorite?comment_id=" + this.commentId)
        .then(res => {
          if (!res.data.length) {
            this.is_favorite = false
            this.favorite_num = res.data.length
          } else {
            if (this.isLoggedInUserFavorite(res.data)) {
              this.is_favorite = true
            }
            this.favorite_num = res.data.length
          }
        })
    },
    isLoggedInUserFavorite(commentFavorites) {
      return commentFavorites.find(
        commentFavorite => commentFavorite.user_id === this.$store.state.id
      )
    },
    favorite() {
      axios
        .post("/v1/comment_favorite", {
          user_id: this.$store.state.id,
          shop_id: this.shopId,
          comment_id: this.commentId
        })
        .then(() => {
          this.getFavorite()
        })
    },
    favoriteDestroy() {
      axios
        .delete(
          "/v1/comment_favorite?user_id=" +
            this.$store.state.id +
            "&comment_id=" +
            this.commentId +
            ""
        )
        .then(() => {
          this.is_favorite = false
          this.getFavorite()
        })
    }
  }
}
</script>
