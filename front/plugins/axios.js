// export default function({ $axios, redirect }) {
//     // $axios.setToken('access_token')
//     //
//     // $axios.onResponse(config => {
//     //     $axios.setHeader('Access-Control-Allow-Origin', '*')
//     // })
//     baseURL: process.env.API_ENDPOINT
// }
import axios from "axios";

export default axios.create({
    baseURL:'https://www.bisapi.work'
    //baseURL:'http://192.168.50.10:3000'
})
//console.log(axios)
// export default function({ $axios, redirect }) {
//   $axios.setToken("access_token")
//
//   $axios.onResponse(config => {
//     $axios.setHeader("Access-Control-Allow-Origin", "*")
//   })
// }
