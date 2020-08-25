<template>
  <v-row>
    <v-dialog v-model="dialog" scrollable max-width="350px">
      <template v-slot:activator="{ on, attrs }">
        <v-list-item-avatar color="grey">
          <v-img :src="imageUrl"></v-img>
        </v-list-item-avatar>
        <v-list-item-content v-bind="attrs" height="50" v-on="on">
          <v-list-item-title v-text="name"></v-list-item-title>
        </v-list-item-content>
      </template>
      <v-card>
        <v-card-title>
          <Avatar :image-url="imageUrl" />
          {{ name }}
          <Follow :user-id="userId" :is-show="dialog" />
        </v-card-title>
        <v-divider />
        <UserTag :user-id="userId" :is-profile-page="isProfilePage" />
        <v-divider />
        <v-card-actions>
          <v-btn color="blue darken-1" text @click="dialog = false">
            Close
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>

<script>
import axios from "~/plugins/axios"
import Avatar from "./Avatar"
import Follow from "./Follow"
import UserTag from "./UserTag"

export default {
  components: {
    Avatar,
    Follow,
    UserTag
  },
  props: {
    userId: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      dialog: false,
      name: "",
      imageUrl: "",
      isProfilePage: false
    }
  },
  watch: {
    userId: function() {
      this.getUser()
    }
  },
  created: function() {
    this.getUser()
  },
  methods: {
    getUser() {
      axios
        .get("/v1/users", {
          params: {
            id: this.userId
          }
        })
        .then(res => {
          this.name = res.data.name
          this.imageUrl = res.data.image.url ? res.data.image.url : ""
        })
    }
  }
}
</script>
