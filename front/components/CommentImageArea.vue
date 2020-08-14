<template>
  <v-row>
    <v-col class="d-flex child-flex" cols="3">
      <v-card flat class="d-flex">
        <v-img :src="url" class="grey lighten-2" @click.stop="dialog = true" />
        <v-dialog v-model="dialog">
          <v-card>
            <v-container>
              <v-row align="center" justify="space-around">
                <v-col cols="8">
                  <v-img
                    :src="url"
                    class="grey lighten-2"
                    contain
                    @click.stop="dialog = false"
                  />
                </v-col>
              </v-row>
            </v-container>
          </v-card>
        </v-dialog>
        <template v-slot:placeholder>
          <v-row class="fill-height ma-0" align="center" justify="center">
            <v-progress-circular indeterminate color="grey lighten-5" />
          </v-row>
        </template>
      </v-card>
    </v-col>
  </v-row>
</template>

<script>
export default {
  props: {
    url: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      dialog: false
    }
  }
}
</script>
