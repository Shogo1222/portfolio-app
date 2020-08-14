<template>
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
      <v-btn dark class="mr-4 mb-5 mt-5" @click="submitComment">
        submit
      </v-btn>
    </form>
  </div>
</template>

<script>
import axios from "~/plugins/axios"
import CommentImageArea from "./CommentImageArea"

export default {
  components: {
    CommentImageArea
  },
  props: {
    shopId: {
      type: String,
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
      imageFile: ""
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
      axios.get("/v1/comment?shop_id=" + this.shopId + "").then(res => {
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
      let formData = new FormData()
      formData.append("user_id", this.$store.state.id)
      formData.append("user_name", this.$store.state.name)
      formData.append("shop_id", this.shopId)
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
        })
    },
    destroyComment(id) {
      axios.delete("/v1/comment?id=" + id).then(() => {
        this.getComment()
      })
    }
  }
}
</script>
