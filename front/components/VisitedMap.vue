<template>
  <v-container>
    <v-row justify-center align-center>
      <v-col cols="12" xs="12">
        <GmapMap
          ref="map"
          :center="center"
          :zoom="zoom"
          style="width: 100%; height: 300px;"
        >
          <GmapMarker
            v-for="shop in marker"
            :key="shop.shop_id"
            :title="shop.name"
            :position="shop.position"
            :clickable="true"
            :draggable="false"
          />
        </GmapMap>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  props: {
    shops: {
      type: Array,
      required: true
    },
    action: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      center: { lat: 35.71, lng: 139.72 },
      zoom: 18,
      marker: []
    }
  },
  created() {
    this.shops.forEach(shop => {
      var lng = parseFloat(shop.lng)
      var lat = parseFloat(shop.lat)
      var name = shop.name
      var id = shop.shop_id
      var position = { lat: lat, lng: lng }
      this.center = position
      var marker = {
        name: name,
        id: id,
        position: position
      }
      this.marker.push(marker)
    })
    console.log(this.marker)
  }
}
</script>
