<template>
  <!-- アバターエリア -->
  <v-avatar class="profile mr-2" color="grey" size="50">
    <v-img :src="imageUrl" />
  </v-avatar>
</template>

<script>
export default {
  props: {
    imageUrl: {
      type: String,
      required: true
    }
  }
}
</script>
