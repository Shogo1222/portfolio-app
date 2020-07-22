<template>
  <div v-if="isLoggedIn">
    <h2 class="display-1 font-weight-thin my-5">
      Comment
    </h2>
    <v-card
      v-for="comment in comments"
      v-if="existsComment"
      :key="comment.id"
      class="mx-auto my-4"
    >
      <v-card-title>{{ comment.user_name }}</v-card-title>
      <v-card-text>
        {{ comment.comment }}
      </v-card-text>
    </v-card>

    <form>
      <v-textarea
        v-model="comment"
        label="Your Comment"
        auto-grow
        outlined
        rows="3"
        row-height="25"
        shaped
        data-vv-name="comment"
      />
      <v-btn dark class="mr-4" @click="submitComment">
        submit
      </v-btn>
    </form>
  </div>
</template>

<script>
import axios from "~/plugins/axios"

export default {
  props: ["shop_id"],
  data() {
    return {
      comments: [],
      comment: "",
      exists_comment: true
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.isLoggedIn
    },
    existsComment() {
      return this.exists_comment
    }
  },
  created: function() {
    axios.get("/v1/comment?shop_id=" + this.shop_id + "").then(res => {
      if (!res.data) {
        console.log("aa")
        this.exists_comment = false
      } else {
        console.log(res.data)
        this.comments = res.data
        this.exists_comment = true
      }
    })
  },
  methods: {
    submitComment() {
      const comment = {
        user_id: this.$store.state.id,
        user_name: this.$store.state.name,
        shop_id: this.shop_id,
        comment: this.comment
      }
      axios
        .post("/v1/comment", {
          comment
        })
        .then(() => {
          this.comments.push(comment)
          this.comment = null
          this.exists_comment = true
        })
    }
  }
}
</script>
