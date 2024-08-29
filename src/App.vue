<template>
  <div id="vue-admin-beautiful">
    <router-view />
  </div>
</template>

<script>
  export default {
    name: 'App',
    provide() {
      return {
        reload: this.reload,
      }
    },
    data() {
      return {
        isRouterAlive: true,
      }
    },
    mounted() {},
    methods: {
      reload() {
        this.isRouterAlive = false
        this.$nextTick(function () {
          this.isRouterAlive = true
        })
      },
    },
  }
</script>
