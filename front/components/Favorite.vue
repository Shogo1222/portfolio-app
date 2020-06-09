

<template>

<div v-if="isLoggedIn">
    <v-btn v-if="!is_favorite" class="mt-2" large icon color="white" @click="favorite()">
        <v-icon>favorite</v-icon>
    </v-btn>
    <v-btn v-if="is_favorite" class="mt-2" large icon color="pink" @click="favoriteDestroy()">
        <v-icon>favorite</v-icon>
    </v-btn>
</div>

</template>

<script>

import axios from "~/plugins/axios"

export default {
    props: ['shop_id'],
    data() {
        return {
            is_favorite: false,
        };
    },
    created: function() {
        axios.get("/v1/favorite?user_id=" + this.$store.state.id + "&shop_id=" + this.shop_id + "").then((res) => {
            if (!res.data) {
                this.is_favorite = false
            } else {
                this.is_favorite = true
            }
        });
    },
    computed: {
        isLoggedIn() {
            return this.$store.state.isLoggedIn;
        }
    },
    methods: {
        favorite() {
                const favorite = {
                    user_id: this.$store.state.id,
                    shop_id: this.shop_id
                };
                axios.post("/v1/favorite", {
                    favorite
                }).then(() => {
                    this.is_favorite = true
                });
            },
            favoriteDestroy(shopId) {
                axios.delete("/v1/favorite?user_id=" + this.$store.state.id + "&shop_id=" + this.shop_id + "").then(() => {
                    this.is_favorite = false
                });
            }


    }
};

</script>
