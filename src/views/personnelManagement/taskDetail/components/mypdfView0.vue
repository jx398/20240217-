<template>
  <el-dialog
    title="查看PDF"
    :visible.sync="dialogFormVisible"
    width="1024px"
    height="820px"
    @close="close"
  >
    <pdfView
      ref="pdfView"
      :pdfPath="filePath"
      :pdfWidth="1000"
      :pdfHeight="800"
    />
  </el-dialog>
</template>
<script>
  import pdfView from 'lz-pdf-merage'

  export default {
    components: { pdfView },

    data() {
      return {
        dialogFormVisible: false,
      }
    },
    watch: {},
    mounted() {},
    methods: {
      showEdit(_url) {
        this.dialogFormVisible = true
        this.filePath = _url
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
