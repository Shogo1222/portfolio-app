<template>
  <!-- 店舗詳細モーダルボタン -->
  <v-row justify="center">
    <v-dialog
      v-model="dialog"
      fullscreen
      hide-overlay
      transition="dialog-bottom-transition"
      eager
    >
      <!-- 店舗詳細モーダル -->
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
            <div v-if="shop.budget.average && shop.budget_memo">
              <span class="grey--text">Budget: </span>
              <br />
              <span> {{ shop.budget.average }}</span><br />
              <span> {{ shop.budget_memo }}</span><br />
            </div>
            <div v-if="shop.budget.capacity">
              <span class="grey--text">Capacity: </span>
              <br />
              <span> {{ shop.budget.capacity }}</span><br />
            </div>
            <div v-if="shop.non_smoking">
              <span class="grey--text">Smoke: </span>
              <br />
              <span> {{ shop.non_smoking }}</span><br />
            </div>
            <div v-if="shop.mobile_access">
              <span class="grey--text">Access: </span>
              <br />
              <span>{{ shop.mobile_access }}</span><br />
            </div>
            <div v-if="shop.address">
              <span class="grey--text">Address: </span>
              <br />
              <span>{{ shop.address }}</span><br />
            </div>
            <div v-if="shop.open">
              <span class="grey--text">Open hours: </span>
              <br />
              <span>{{ shop.open }}</span>
            </div>
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
  props: {
    shop: {
      type: Object,
      required: true
    }
  },
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
      var center = {
        lat: this.shop.lat, // 緯度
        lng: this.shop.lng // 経度
      }
      var map = new google.maps.Map(document.getElementById(this.shop.id), {
        center: { lat: this.shop.lat, lng: this.shop.lng },
        zoom: 17
      })
      var marker = new google.maps.Marker({
        position: center,
        map: map
      })
    }
  }
}
</script>
