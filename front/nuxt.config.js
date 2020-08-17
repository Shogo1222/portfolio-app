require("dotenv").config()
import colors from "vuetify/es5/util/colors"
export default {
  watchers: {
    webpack: {
      poll: true
    }
  },
  mode: "spa",
  /*
   ** Headers of the page
   */
  head: {
    titleTemplate: "%s - " + process.env.npm_package_name,
    title: process.env.npm_package_name || "",
    meta: [
      { charset: "utf-8" },
      { name: "viewport", content: "width=device-width, initial-scale=1" },
      {
        hid: "description",
        name: "description",
        content: process.env.npm_package_description || ""
      }
    ],
    link: [{ rel: "icon", type: "image/x-icon", href: "/favicon.ico" }],
    //google maps apiのソースファイル
    script: [
      {
        src: "https://maps.google.com/maps/api/js?key=" + process.env.API_KEY
      }
    ]
  },
  /*
   ** Customize the progress-bar color
   */
  loading: { color: "#fff" },
  /*
   ** Global CSS
   */
  css: [],
  /*
   ** Nuxt.js dev-modules
   */
  buildModules: ["@nuxtjs/vuetify"],
  plugins: [
    "@/plugins/axios",
    "@/plugins/vuetify",
    "@/plugins/auth-check",
    "@/plugins/vee-validate.js"
  ],
  modules: ["@nuxtjs/axios", "@nuxtjs/proxy", "@nuxtjs/auth", "@nuxtjs/dotenv"],
  axios: {
    proxy: true
  },
  proxy: {
    "/api/": {
      target: "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/",
      pathRewrite: { "^/api/": "/" }
    }
  },
  auth: {
    redirect: {
      login: "/login",
      logout: "/login",
      callback: false,
      home: "/"
    },
    strategies: {
      local: {
        endpoints: {
          login: { url: "/auth/sign_in", method: "post", propertyName: false },
          logout: false,
          user: false
        }
      }
    }
  },
  /*
   ** vuetify module configuration
   ** https://github.com/nuxt-community/vuetify-module
   */
  vuetify: {
    customVariables: ["~/assets/variables.scss"],
    theme: {
      dark: false,
      themes: {
        dark: {
          primary: colors.blue.darken2,
          accent: colors.grey.darken3,
          secondary: colors.amber.darken3,
          info: colors.teal.lighten1,
          warning: colors.amber.base,
          error: colors.deepOrange.accent4,
          success: colors.green.accent3
        }
      }
    }
  },
  /*
   ** Build configuration
   */
  build: {
    extend(config, ctx) {}
  }
}
