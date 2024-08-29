<template>
  <el-dialog
    :title="title"
    :visible.sync="dialogFormVisible"
    width="800"
    @close="close"
  >
    <iframe
      id="iframe"
      :src="t_pdfsrc"
      scrolling="auto"
      frameborder="0"
      style="width: 100%; height: 600px"
    ></iframe>
  </el-dialog>
</template>

<script>
  export default {
    name: 'ShowPdf',
    props: {
      pdfSrc: {
        type: String,
        default() {
          return 'http://117.160.199.82:7777/pdf.js/web/viewer.html?file=http://117.160.199.82:7777/Temp/0cc9bbf158c242ecb99f443e41ac282d.pdf'
        }, // 对象或数组默认值需要用函数返回
      },
    },
    data() {
      return {
        t_pdfsrc: this.pdfSrc,
        title: '',
        dialogFormVisible: false,
      }
    },
    created() {},
    methods: {
      showEdit(row) {
        this.title = '查看不符合项报告'
        this.dialogFormVisible = true
        this.t_pdfsrc = this.pdfSrc
      },
      close() {
        this.dialogFormVisible = false
      },
    },
  }
</script>
