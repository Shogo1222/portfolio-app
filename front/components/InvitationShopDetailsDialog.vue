<template>
  <!-- 招待店舗詳細モーダルボタン -->
  <v-row justify="center">
    <v-dialog
      v-model="dialog"
      fullscreen
      hide-overlay
      transition="dialog-bottom-transition"
      eager
    >
      <!-- 招待店舗詳細モーダル -->
      <template v-slot:activator="{ on, attrs }">
        <v-list-item-content v-on="on">
          <v-list-item-title  class="wrap-text" v-text="invitation.shop_name+' from '+invitation.name" />
        </v-list-item-content>
        <v-list-item-avatar color="grey">
          <v-img :src="invitation.image.url ? invitation.image.url : ''" />
        </v-list-item-avatar>
      </template>
      <v-card>
        <v-toolbar color="white" flat>
          <v-spacer />
          <v-btn class="mt-4" icon @click="dialog = false">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-toolbar>
        <v-container>
          <v-row class="mb-4">
            <h2 class="font-weight-thin mt-2 ml-2">
              {{ invitation.shop_name }}
            </h2>
          </v-row>
          <v-img height="400" :src="invitation.photo" />
          <v-divider />
          <v-card-text>
            <div class="my-4 subtitle-1">
              {{ invitation.catch_copy }}
            </div>
            <div v-if="invitation.budget && invitation.budget_memo">
              <span class="grey--text">Budget: </span>
              <br />
              <span> {{ invitation.budget }}</span><br />
              <span> {{ invitation.budget_memo }}</span><br />
            </div>
            <div v-if="invitation.capacity">
              <span class="grey--text">Capacity: </span>
              <br />
              <span> {{ invitation.capacity }}</span><br />
            </div>
            <div v-if="invitation.non_smoking">
              <span class="grey--text">Smoke: </span>
              <br />
              <span> {{ invitation.non_smoking }}</span><br />
            </div>
            <div v-if="invitation.mobile_access">
              <span class="grey--text">Access: </span>
              <br />
              <span>{{ invitation.mobile_access }}</span><br />
            </div>
            <div v-if="invitation.address">
              <span class="grey--text">Address: </span>
              <br />
              <span>{{ invitation.address }}</span><br />
            </div>
            <div v-if="invitation.open_hour">
              <span class="grey--text">Open hours: </span>
              <br />
              <span>{{ invitation.open_hour }}</span>
            </div>
          </v-card-text>
          <div :id="invitation.shop_id" style="height: 400px; width: 100%;" />
        </v-container>
      </v-card>
    </v-dialog>
  </v-row>
</template>

<script>
import CommentArea from "./CommentArea.vue"
import ShopTag from "./ShopTag.vue"

export default {
  components: {
    CommentArea,
    ShopTag
  },
  props: {
    invitation: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      dialog: false
    }
  },
  mounted: function() {
    this.initMap()
  },
  methods: {
    // Google map APIで住所を取得（geoLocation後に作動）
    initMap() {
      var center = {
        lat: parseFloat(this.invitation.lat), // 緯度
        lng: parseFloat(this.invitation.lng) // 経度
      }
      var map = new google.maps.Map(
        document.getElementById(this.invitation.shop_id),
        {
          center: {
            lat: parseFloat(this.invitation.lat),
            lng: parseFloat(this.invitation.lng)
          },
          zoom: 17
        }
      )
      var marker = new google.maps.Marker({
        position: center,
        map: map
      })
    }
  }
}
</script>
<style scoped>
@media screen and (max-width: 380px) {
  .wrap-text {
     max-width: 300px;
}
}
</style>
