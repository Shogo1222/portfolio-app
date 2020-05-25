<template>
  <h1>Hello, {{ name }}</h1>
</template>

<script>
export default {
  asyncData({ $axios, params }) {
    return $axios.$get(`/api/users/${params.id}`)
      .then((res) => {
        return { name: res.name }
      })
  }
}
</script>
