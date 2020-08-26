<!-- 招待ページ -->
<template>
  <v-app>
    <v-container>
      <v-row align="center" justify="center">
        <v-col cols="12">
          <v-sheet class="mt-5" height="200" width="100%">
            <v-img height="200" width="100%" src="invitation.jpg">
              <v-col>
                <v-list-item>
                  <v-list-item-content>
                    <v-list-item-title class="title">
                      <h2 class="display-1 white--text font-weight-thin">
                        Invitations
                      </h2>
                    </v-list-item-title>
                  </v-list-item-content>
                </v-list-item>
              </v-col>
            </v-img>
          </v-sheet>
        </v-col>
        <v-col cols="12">
          <v-card v-if="invitations.length" flat class="mt-5">
            <v-list>
              <v-subheader>Invitation List</v-subheader>
              <v-list-item-group color="primary">
                <v-list-item
                  v-for="invitation in invitations"
                  :key="invitation.invitation_id"
                  @click=""
                >
                  <InvitationShopDetailsDialog :invitation="invitation" />
                </v-list-item>
              </v-list-item-group>
            </v-list>
          </v-card>

          <!-- 項目が取得出来ない場合 -->
          <v-row align="center" justify="center">
            <v-card v-if="!invitations.length" class="mt-5" width="400">
              <v-list-item three-line>
                <v-list-item-content>
                  <v-list-item-title class="headline mb-1">
                    Sorry! We can't find any invitations
                  </v-list-item-title>
                  <v-list-item-subtitle>
                    Please get your invitation letter from followers
                  </v-list-item-subtitle>
                </v-list-item-content>
              </v-list-item>
            </v-card>
          </v-row>
        </v-col>
      </v-row>
    </v-container>
  </v-app>
</template>
<script>
import axios from "~/plugins/axios"
import InvitationShopDetailsDialog from "../components/InvitationShopDetailsDialog"

export default {
  middleware: "authenticated",
  components: {
    InvitationShopDetailsDialog
  },
  data() {
    return {
      invitations: []
    }
  },
  mounted() {
    this.getInvitations()
    this.updateNotifications()
  },
  methods: {
    updateNotifications() {
      axios
        .patch("/v1/notification", {
          user_id: this.$store.state.id,
          action_from: "invite"
        })
        .then(() => {
          this.$store.commit("setinviteNotice", false)
        })
    },
    getInvitations() {
      axios
        .get("/v1/invitation", {
          params: {
            user_id: this.$store.state.id
          }
        })
        .then(res => {
          this.invitations = res.data
        })
    }
  }
}
</script>
