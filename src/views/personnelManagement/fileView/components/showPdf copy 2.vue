<template>
  <el-dialog
    title="查看图片"
    :visible.sync="dialogFormVisible"
    width="1030px"
    height="600px"
    @close="close"
  >
    <el-image class="image" :src="t_pdfsrc"></el-image>
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
        console.log(this.pdfSrc)
        this.t_pdfsrc = row
      },
      close() {
        this.dialogFormVisible = false
      },
    },
  }
</script>
