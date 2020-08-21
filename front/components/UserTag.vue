<template>
  <!-- タグ部分 -->
  <v-container>
    <!-- タグ一覧 -->
    <v-row align="center" justify="center">
      <div v-for="tag in tags" v-if="tags.length" :key="tag.id">
        <v-icon color="red" @click="deleteTag(tag.tag)">
          close
        </v-icon>
        <v-btn outlined depressed class="ma-1"> #{{ tag.tag }} </v-btn>
      </div>
      <div v-if="!tags.length">
        <p class="font-weight-thin pl-5 pt-5 headline">
          Please add your tags that "describe" you!
        </p>
      </div>
    </v-row>
    <!-- タグ追加部分 -->
    <v-row align="center" justify="center">
      <v-dialog v-model="dialog" width="500">
        <!-- タグ追加ダイアログボタン部分 -->
        <template v-slot:activator="{ on, attrs }">
          <v-spacer />
          <v-btn
            color="teal darken-4"
            class="ma-2 mt-5"
            dark
            v-bind="attrs"
            v-on="on"
          >
            ADD TAG
          </v-btn>
        </template>

        <!-- タグ追加ダイアログ部分 -->
        <v-card>
          <v-container>
            <v-row align="center" justify="center">
              <v-col cols="10">
                <v-text-field
                  v-model="newTag"
                  label="Tag"
                  placeholder="I love sushi!"
                />
              </v-col>
            </v-row>

            <!-- 他の人がつけたタグのレコメンド部分 -->
            <v-row align="center" justify="center">
              <v-col cols="10">
                <p class="font-weight-thin subtitle-1">
                  * Others used tags
                </p>
                <div v-for="tag in recentAddedTags" :key="tag.id">
                  <v-btn
                    color="white"
                    depressed
                    class="ma-2"
                    @click="addTagInput(tag.tag)"
                  >
                    #{{ tag.tag }}
                  </v-btn>
                </div>
              </v-col>
            </v-row>
          </v-container>
          <v-card-actions>
            <v-spacer />
            <v-btn color="primary" text @click="addTag">
              Add
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-row>
  </v-container>
</template>

<script>
import axios from "~/plugins/axios"

export default {
  props: {
    userId: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      tags: [],
      recentAddedTags: [],
      newTag: "",
      dialog: false,
      searchTag: ""
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.isLoggedIn
    }
  },
  watch: {
    userId: function() {
      this.getTags()
      this.getRecentAddedTags()
    },
    newTag: function() {
      this.searchRecentAddedTags()
    }
  },
  methods: {
    getTags() {
      axios
        .get("/v1/user_tags", {
          params: {
            user_id: this.userId
          }
        })
        .then(res => {
          this.tags = res.data
        })
    },
    getRecentAddedTags() {
      axios
        .get("/v1/user_tags/recent_tag", {
          params: {
            user_id: this.userId
          }
        })
        .then(res => {
          this.recentAddedTags = res.data
        })
    },
    searchRecentAddedTags() {
      axios
        .get("/v1/user_tags/recent_tag/", {
          params: {
            user_id: this.userId,
            tag: this.newTag
          }
        })
        .then(res => {
          this.recentAddedTags = res.data
        })
    },
    addTagInput(newTag) {
      this.newTag = newTag
    },
    addTag() {
      axios
        .post("/v1/user_tags", {
          user_id: this.userId,
          tag: this.newTag
        })
        .then(
          function() {
            this.getTags()
            this.newTag = ""
            this.dialog = false
          }.bind(this)
        )
    },
    deleteTag(tag) {
      axios
        .delete("/v1/user_tags", {
          params: {
            user_id: this.userId,
            tag: tag
          }
        })
        .then(
          function() {
            this.getTags()
          }.bind(this)
        )
    }
  }
}
</script>
