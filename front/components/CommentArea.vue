<template>
  <!-- コメントエリア -->
  <div v-if="isLoggedIn">
    <h2 class="display-1 font-weight-thin my-5">
      Comments
    </h2>
    <div v-if="existsComment">
      <v-card
        v-for="postedComment in comments"
        :key="postedComment.id"
        class="mx-auto my-4"
        shaped
      >
        <v-col cols="12">
          <v-btn
            v-if="postedComment.user_id === getUserId"
            class="mt-1 float-right"
            icon
            @click="destroyComment(postedComment.id)"
          >
            <v-icon>mdi-close</v-icon>
          </v-btn>
          <v-card-text>
            <v-icon>person</v-icon>
            {{ postedComment.user_name }}
          </v-card-text>
          <v-container v-if="postedComment.image.url" fluid>
            <CommentImageArea :url="postedComment.image.url" />
          </v-container>
          <v-card-text class="font-weight-medium">
            {{ postedComment.comment }}
          </v-card-text>
          <CommentFavorite
            :comment-id="postedComment.id"
            :shop-id="postedComment.shop_id"
          />
        </v-col>
      </v-card>
    </div>
    <form>
      <v-textarea
        v-model="comment"
        label="Share your comment"
        auto-grow
        outlined
        rows="3"
        row-height="25"
        shaped
        data-vv-name="comment"
      />
      <v-text-field
        v-model="imageName"
        label="Click ME! Let's upload your image"
        prepend-icon="attach_file"
        @click="pickFile"
      />
      <input
        ref="image"
        type="file"
        style="display: none"
        accept="image/*"
        @change="onFilePicked"
      />
      <v-row align="center" justify="center">
        <v-btn dark class="mr-4 mb-5 mt-5" @click="submitComment">
          submit
        </v-btn>
    </v-row>
    </form>
  </div>
</template>

<script>
import axios from "~/plugins/axios"
import CommentImageArea from "./CommentImageArea"
import CommentFavorite from "./CommentFavorite"

export default {
  components: {
    CommentImageArea,
    CommentFavorite
  },
  props: {
    shop: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      comments: [],
      comment: "",
      exists_comment: true,
      imageName: "",
      imageUrl: "",
      imageFile: "",
      action: "comment"
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.isLoggedIn
    },
    getUserId() {
      return this.$store.state.id
    },
    existsComment() {
      return this.exists_comment
    }
  },
  created: function() {
    this.getComment()
  },
  methods: {
    // 選択された画像ファイルの処理
    pickFile() {
      this.$refs.image.click()
    },
    onFilePicked(e) {
      const files = e.target.files
      if (files[0] !== undefined) {
        this.imageName = files[0].name
        if (this.imageName.lastIndexOf(".") <= 0) {
          return
        }
        const fr = new FileReader()
        fr.readAsDataURL(files[0])
        fr.addEventListener("load", () => {
          this.imageUrl = fr.result
          this.imageFile = files[0]
        })
      } else {
        this.imageName = ""
        this.imageFile = ""
        this.imageUrl = ""
      }
    },
    getComment() {
      axios.get("/v1/comment?shop_id=" + this.shop.shop_id + "").then(res => {
        if (!res.data) {
          this.exists_comment = false
        } else {
          this.comments = res.data
          this.exists_comment = true
        }
      })
    },
    submitComment() {
      if (!this.comment) {
        return
      }
      this.$store.commit("setLoading", true)

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
          let formData = new FormData()
          formData.append("user_id", this.$store.state.id)
          formData.append("user_name", this.$store.state.name)
          formData.append("logged_shop_id", res.data.id)
          formData.append("shop_id", this.shop.shop_id)
          formData.append("comment", this.comment)
          formData.append("image", this.imageFile)
          axios
            .post("/v1/comment", formData, {
              headers: {
                "Content-Type": "multipart/form-data"
              }
            })
            .then(() => {
              this.getComment()
              this.imageName = ""
              this.imageFile = ""
              this.imageUrl = ""
              this.comment = ""
              setTimeout(() => {
                this.$store.commit("setLoading", false)
              }, 500) //1秒後に隠す
            })
        })
    },
    destroyComment(id) {
      this.$store.commit("setLoading", true)
      axios
        .delete("/v1/comment", {
          params: {
            user_id: this.$store.state.id,
            shop_id: this.shop.shop_id,
            id: id
          }
        })
        .then(res => {
          if (res.data) {
            this.getComment()
            setTimeout(() => {
              this.$store.commit("setLoading", false)
            }, 500) //1秒後に隠す
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
                setTimeout(() => {
                  this.$store.commit("setLoading", false)
                }, 500) //1秒後に隠す
                this.getComment()
              })
          }
        })
    }
  }
}
</script>
