<template>
  <!-- スタートボタン部分 -->
  <v-dialog v-model="dialog" max-width="900px">
    <template v-slot:activator="{ on }">
      <v-btn
        color="black"
        rounded
        outlined
        large
        class="mt-10"
        @click="dialog = true"
      >
        Start Now
      </v-btn>
    </template>

    <!-- モーダル部分 -->
    <SearchTermDialog @get-location-shops="trigger" />
  </v-dialog>
</template>

<script>
import SearchTermDialog from "./SearchTermDialog"
export default {
  components: {
    SearchTermDialog
  },
  data() {
    return {
      dialog: false,
      multiple: false,
      mandatory: false,
      centerActive: false,
      model: null
    }
  },
  methods: {
    trigger(terms) {
      this.dialog = false
      this.$emit("get-location-shops", terms)
      window.scroll({
        top: 750,
        behavior: "smooth"
      })
    }
  }
}
</script>
