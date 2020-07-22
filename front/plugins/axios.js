import axios from "axios"

export default axios.create({
  //baseURL:'https://www.bisapi.work'
  baseURL: "http://192.168.50.10:3000"
})
