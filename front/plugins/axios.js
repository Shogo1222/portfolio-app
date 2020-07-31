import axios from "axios"

export default axios.create({
  //baseURL:'https://www.bisapi.work'
  baseURL: process.env.BASE_URL
})
