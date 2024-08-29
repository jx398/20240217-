<template>
  <el-dialog
    :visible.sync="dialogFormVisible"
    width="1030px"
    height="600px"
    @close="close"
  >
    <iframe
      id="iframeContain"
      name="iframeContain"
      seamless
      scrolling="yes"
      :src="filepath"
      height="1200px"
      width="1000px"
    />
  </el-dialog>
</template>
<script>
  export default {
    components: {},
    data() {
      return {
        dialogFormVisible: false,
        filepath: '',
      }
    },
    watch: {},
    mounted() {},
    methods: {
      showEdit(_url) {
        this.dialogFormVisible = true
        this.filepath = _url
      },
      close() {
        this.dialogFormVisible = false
      },
    },
  }
</script>
<style scoped>
  .page-icon {
    margin: 10px !important;
    width: 600px;
  }
  .page-turner {
    width: 900px !important;
    left: 100%;
    transform: translate(-350px);
  }
</style>
