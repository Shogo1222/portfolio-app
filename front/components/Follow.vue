<template>
  <!-- フォローエリア -->
  <div v-if="isOtherUser">
    <v-btn
      v-if="!isFollow"
      class="ml-3"
      outlined
      rounded
      small
      style="text-transform: none"
      @click="follow(userId)"
    >
      Follow
    </v-btn>
    <v-btn
      v-if="isFollow"
      class="ml-3"
      outlined
      dark
      small
      rounded
      color="primary"
      style="text-transform: none"
      @click="unfollow(userId)"
    >
      Followed
      <v-icon v-if="mutualFollow">
        swap_horiz
      </v-icon>
    </v-btn>
  </div>
</template>

<script>
import axios from "~/plugins/axios"

export default {
  props: {
    userId: {
      type: Number,
      required: true
    },
    isShow: {
      type: Boolean,
      required: true
    }
  },
  data() {
    return {
      isFollow: false,
      mutualFollow: false
    }
  },
  computed: {
    isOtherUser() {
      return this.$store.state.id !== this.userId
    }
  },
  watch: {
    isShow: function() {
      this.getFollowRelationship()
    }
  },
  created: function() {
    this.getFollowRelationship()
  },
  methods: {
    getFollowRelationship() {
      axios
        .get("/v1/follow_relationship", {
          params: {
            user_id: this.$store.state.id,
            following_user_id: this.userId
          }
        })
        .then(res => {
          if (!res.data) {
            this.isFollow = false
          } else {
            if (res.data.is_mutual_follow) {
              this.mutualFollow = true
            }
            this.isFollow = true
          }
        })
    },
    follow(userId) {
      axios
        .post("/v1/follow_relationship", {
          following_user_id: userId,
          user_id: this.$store.state.id
        })
        .then(() => {
          this.isFollow = true
          this.getFollowRelationship()
        })
    },
    unfollow(userId) {
      axios
        .delete("/v1/follow_relationship", {
          params: {
            following_user_id: userId,
            user_id: this.$store.state.id
          }
        })
        .then(() => {
          this.isFollow = false
          this.getFollowRelationship()
        })
    }
  }
}
</script>
