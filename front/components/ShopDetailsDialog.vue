<template>
  <v-row justify="center">
    <v-dialog
      v-model="dialog"
      fullscreen
      hide-overlay
      transition="dialog-bottom-transition"
      eager
    >
      <template v-slot:activator="{ on }">
        <v-btn class="ma-2" color="black" rounded outlined v-on="on">
          Details
        </v-btn>
      </template>
      <v-card>
        <v-toolbar color="white" flat>
          <v-spacer />
          <v-btn class="mt-4" icon @click="dialog = false">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-toolbar>
        <v-container>
          <h2 class="font-weight-thin mb-4">
            {{ shop.name }}
          </h2>
          <v-img height="400" :src="shop.photo.pc.l" />
          <v-card-text>
            <div class="my-4 subtitle-1">
              {{ shop.catch }}
            </div>

            <span class="grey--text">Budget: </span>
            <br />
            <span> {{ shop.budget.average }}</span><br />
            <span> {{ shop.budget_memo }}</span><br />

            <span class="grey--text">Capacity: </span>
            <br />
            <span> {{ shop.budget.capacity }}</span><br />

            <span class="grey--text">Smoke: </span>
            <br />
            <span> {{ shop.non_smoking }}</span><br />

            <span class="grey--text">Access: </span>
            <br />
            <span>{{ shop.mobile_access }}</span><br />

            <span class="grey--text">Address: </span>
            <br />
            <span>{{ shop.address }}</span><br />

            <span class="grey--text">Open hours: </span>
            <br />
            <span>{{ shop.open }}</span>
          </v-card-text>
          <div :id="shop.id" style="height: 400px; width: 100%;" />
          <CommentArea :shop-id="shop.id" />
        </v-container>
      </v-card>
    </v-dialog>
  </v-row>
</template>

<script>
import CommentArea from "./CommentArea.vue"
export default {
  components: {
    CommentArea
  },
  props: ["shop"],
  data() {
    return {
      dialog: false,
      notifications: false,
      sound: true,
      widgets: false
    }
  },
  mounted: function() {
    this.initMap()
  },
  methods: {
    // Google map APIで住所を取得（geoLocation後に作動）
    initMap() {
      var marker
      var center = {
        lat: this.shop.lat, // 緯度
        lng: this.shop.lng // 経度
      }
      var map = new google.maps.Map(document.getElementById(this.shop.id), {
        center: { lat: this.shop.lat, lng: this.shop.lng },
        zoom: 17
      })
      marker = new google.maps.Marker({
        // マーカーの追加
        position: center, // マーカーを立てる位置を指定
        map: map // マーカーを立てる地図を指定
      })
    }
  }
}
</script>
