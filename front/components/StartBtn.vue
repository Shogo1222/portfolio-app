<template>
  <!-- ボタン部分 -->
  <v-dialog v-model="dialog" max-width="900px">
    <template v-slot:activator="{ on }">
      <v-btn
      color="#fff"
      dark
      rounded
      outlined
      large
      class="ma-2"
      @click="dialog = true"
      >
      Start Now
    </v-btn>
    </template>

    <!-- モーダル部分 -->
<SearchTermDialog @get-location-shops="trigger"/>
</v-dialog>
</template>

<script>
import SearchTermDialog from "./SearchTermDialog"
export default {
  components: {
    SearchTermDialog,
  },
  data() {
    return {
      dialog: false,
       multiple: false,
       mandatory: false,
       centerActive: false,
       model: null,
    }
  },
  methods :{
    trigger(terms){
      this.dialog = false
      this.$emit('get-location-shops', terms)
      window.scroll({
        top: 750,
        behavior: "smooth"
      })
    }
  }
}
</script>
