<template>
  <v-container>
    <v-row align="center" justify="space-around">
      <v-col cols="8" xs="12" md="8" sm="12">
        <v-text-field
          ref="address"
          v-model="address"
          clear-icon="close"
          clearable
          light
          data-vv-name="address"
          label="Input Address"
          single-line
        />
      </v-col>
      <v-col cols="4" xs="12" md="4" sm="12">
        <v-btn color="#000" rounded outlined @click="mapSearch">
          <v-icon>search</v-icon>
        </v-btn>
      </v-col>
    </v-row>

    <v-row justify-center align-center>
      <v-col cols="12" xs="12">
        <GmapMap
          ref="map"
          :center="center"
          :zoom="zoom"
          style="width: 100%; height: 300px;"
          @center_changed="onCenterChanged"
        >
          <GmapMarker
            v-show="marker_center"
            :position="marker_center"
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
  data() {
    return {
      center: { lat: 35.71, lng: 139.72 },
      zoom: 14,
      address: "",
      marker_center: { lat: 35.71, lng: 139.72 }
    }
  },
  methods: {
    onCenterChanged(center) {
      this.marker_center = { lat: center.lat(), lng: center.lng() }
      this.$emit("set-location", this.marker_center)
      var latlng = new google.maps.LatLng(center.lat(), center.lng())
      new google.maps.Geocoder().geocode(
        {
          location: latlng
        },
        (results, status) => {
          if (status === google.maps.GeocoderStatus.OK) {
            this.address = results[0].formatted_address
          }
        }
      )
    },
    mapSearch() {
      new google.maps.Geocoder().geocode(
        {
          address: this.address
        },
        (results, status) => {
          if (status === google.maps.GeocoderStatus.OK) {
            this.address = results[0].formatted_address
            this.marker_center = {
              lat: results[0].geometry.location.lat(),
              lng: results[0].geometry.location.lng()
            }
            this.center = {
              lat: results[0].geometry.location.lat(),
              lng: results[0].geometry.location.lng()
            }
            this.$emit("set-location", this.marker_center)
          }
        }
      )
    }
  }
}
</script>
