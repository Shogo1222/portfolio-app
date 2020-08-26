<template>
  <!-- タグ部分 -->
  <v-container v-if="isLoggedIn">
    <h2 class="display-1 font-weight-thin my-5">
      Tags
    </h2>
    <!-- タグ一覧 -->
    <v-row align="center" justify="center">
      <div v-for="tag in tags" v-if="tags.length" :key="tag.id">
        <v-icon color="red" @click="deleteTag(tag.tag)">
          close
        </v-icon>
        <v-btn
          text
          class="ma-1"
          nuxt
          exact
          :to="{ path: `/search?search_txt=${tag.tag}&tab=tab-3` }"
        >
          #{{ tag.tag }}
        </v-btn>
      </div>
      <div v-if="!tags.length">
        <p class="font-weight-thin pl-5 pt-5 headline">
          Please add your tags that "describe" Bistro!
        </p>
      </div>
    </v-row>
    <!-- タグ追加部分 -->
    <v-row align="center" justify="center">
      <v-dialog v-model="dialog" width="500">
        <!-- タグ追加ダイアログボタン部分 -->
        <template v-slot:activator="{ on, attrs }">
          <v-spacer />
          <v-btn class="ma-2 mt-5" dark v-bind="attrs" v-on="on">
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
                  clear-icon="close"
                  clearable
                  placeholder="For Dating"
                />
              </v-col>
            </v-row>

            <!-- 他の人がつけたタグのレコメンド部分 -->
            <v-row align="center" justify="center">
              <v-col cols="10">
                <p class="font-weight-thin subtitle-1">
                  * Other bistros used tags
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
    shop: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      tags: [],
      recentAddedTags: [],
      newTag: "",
      dialog: false,
      searchTag: "",
      action: "tag"
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.isLoggedIn
    }
  },
  watch: {
    newTag: function() {
      this.searchRecentAddedTags()
    }
  },
  mounted() {
    this.getTags()
    this.getRecentAddedTags()
  },
  methods: {
    getTags() {
      axios
        .get("/v1/shop_tags", {
          params: {
            shop_id: this.shop.shop_id
          }
        })
        .then(res => {
          this.tags = res.data
        })
    },
    getRecentAddedTags() {
      axios
        .get("/v1/shop_tags/recent_tag", {
          params: {
            shop_id: this.shop.shop_id
          }
        })
        .then(res => {
          this.recentAddedTags = res.data
        })
    },
    searchRecentAddedTags() {
      axios
        .get("/v1/shop_tags/recent_tag/", {
          params: {
            shop_id: this.shop.shop_id,
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
            .post("/v1/shop_tags", {
              shop_id: this.shop.shop_id,
              logged_shop_id: res.data.id,
              tag: this.newTag
            })
            .then(
              function() {
                this.getTags()
                this.newTag = ""
                this.dialog = false
              }.bind(this)
            )
        })
    },
    deleteTag(tag) {
      axios
        .delete("/v1/shop_tags", {
          params: {
            shop_id: this.shop.shop_id,
            tag: tag
          }
        })
        .then(res => {
          if (res.data) {
            this.getTags()
          } else {
            axios
              .delete("/v1/logged_shop", {
                params: {
                  user_id: this.$store.state.id,
                  shop_id: this.shop.shop_id,
                  action_from: this.action
                }
              })
              .then(() => {
                this.getTags()
              })
          }
        })
    }
  }
}
</script>
