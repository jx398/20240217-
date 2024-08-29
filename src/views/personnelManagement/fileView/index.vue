<template>
  <div
    v-loading="loading"
    element-loading-text="拼命压缩中"
    element-loading-spinner="el-icon-loading"
    element-loading-background="rgba(0, 0, 0, 0.2)"
    style="padding: 10px 20px"
  >
    <vxe-toolbar>
      <template #buttons>
        <el-button @click="$refs.xTree.setAllTreeExpand(true)">
          展开所有
        </el-button>
        <el-button @click="$refs.xTree.clearTreeExpand()">关闭所有</el-button>
        <el-button @click="ZipDown()">zip打包</el-button>
        <el-button v-if="zipUrl != ''">
          <el-link :href="zipUrl">zip下载</el-link>
        </el-button>
        <span style="margin-left: 10px">
          <el-form :inline="true" :model="queryForm" @submit.native.prevent>
            <el-form-item>
              <el-input
                v-model.trim="search"
                placeholder="请输入文件名称"
                clearable
              />
            </el-form-item>
            <el-form-item>
              <el-button
                icon="el-icon-search"
                type="primary"
                @click="queryData"
              >
                查询
              </el-button>
            </el-form-item>
          </el-form>
        </span>
      </template>
    </vxe-toolbar>
    <vxe-table
      ref="xTree"
      border
      :row-config="{ isCurrent: true, isHover: true }"
      :column-config="{ resizable: true }"
      :tree-config="{
        transform: true,
        rowField: 'ID',
        parentField: 'ParentId',
      }"
      :data="
        tableData.filter(
          (data) =>
            !search ||
            (data.Name.toLowerCase().includes(search.toLowerCase()) &&
              data.Type != '文件夹')
        )
      "
      :edit-config="{ trigger: 'manual', mode: 'row' }"
    >
      >
      <vxe-column field="Name" title="Name" tree-node width="800">
        <template #default="{ row }">
          <span>
            <template v-if="row.children && row.children.length">
              <i
                class="tree-node-icon"
                :class="
                  $refs.xTree.isTreeExpandByRow(row)
                    ? 'el-icon-folder-remove'
                    : 'el-icon-folder-add'
                "
              ></i>
            </template>
            <template v-else>
              <template v-if="picpanduan(row.Type)">
                <i class="tree-node-icon vxe-icon-file-image"></i>
              </template>
              <template v-else-if="docxpanduan(row.Type)">
                <i class="tree-node-icon vxe-icon-file-word"></i>
              </template>
              <template v-else-if="pdfpanduan(row.Type)">
                <i class="tree-node-icon vxe-icon-file-pdf"></i>
              </template>
              <template v-else-if="mp3panduan(row.Type)">
                <i class="tree-node-icon vxe-icon-file-voice"></i>
              </template>
              <template v-else>
                <i size="medium" class="tree-node-icon vxe-icon-file-txt"></i>
              </template>
            </template>
            <span>{{ row.Name }}</span>
          </span>
        </template>
        <template #edit="{ row }">
          <el-input
            v-model="row.Name"
            type="text"
            placeholder="请输入昵称"
          ></el-input>
        </template>
      </vxe-column>
      <vxe-column field="Size" title="Size"></vxe-column>
      <vxe-column field="Type" title="Type"></vxe-column>
      <vxe-column field="Date" title="Date"></vxe-column>
      <vxe-column title="操作" width="160">
        <template #default="{ row }">
          <template v-if="row.Type != '文件夹'">
            <el-link @click="Downlaod(row)">下载</el-link>
          </template>
          <template
            v-if="
              picpanduan(row.Type) ||
              pdfpanduan(row.Type) ||
              docxpanduan(row.Type)
            "
          >
            &nbsp;&nbsp;
            <el-link @click="View(row)">查看</el-link>
          </template>
        </template>
      </vxe-column>
    </vxe-table>
    <mypdfView ref="edit" :formData="passPdf"></mypdfView>
    <showPdf ref="picView" :pdfSrc="pic_url"></showPdf>
    <wangEditor ref="docxView" :propData="propDoc"></wangEditor>
  </div>
</template>

<script>
  const axios = require('axios').default
  import mypdfView from './components/mypdfView'
  import showPdf from './components/showPdf'
  import wangEditor from './components/wangEditor'

  export default {
    name: 'UserManagement',
    components: {
      mypdfView,
      showPdf,
      wangEditor,
    },
    data() {
      return {
        propDoc: '',
        zipUrl: '',
        loading: false,
        passPdf: '',
        picView_pan: false,
        pic_url: '',
        xTable: null,
        tableData: '',
        PS_DanWei: '',
        pdf_src: '',
        list: null,
        listLoading: true,
        layout: 'total, sizes, prev, pager, next, jumper',
        total: this.list == null ? 0 : list.length,
        selectRows: '',
        elementLoadingText: '正在加载...',
        queryForm: {
          PS_ID: this.$store.state.detail.PS_ID,
        },
        BHG_ID: '',
        BHG_Type: '',
        BHG_ShiShi: '',
        search: '',
        BHG_ZhengGai: '',
        tempTreeData: '',
        PS_ID: '',
        buhegeBaoGaoFile: '',
        passPdfsrc: '',
        treeConfig: {
          transform: true,
          iconOpen: 'vxe-icon-square-minus',
          iconClose: 'vxe-icon-square-plus',
        },
      }
    },
    computed() {
      this.PS_ID = this.$store.state.detail.PS_ID
    },
    watch: {
      '$store.state.detail.PS_ID'() {
        this.PS_ID = this.$store.state.detail.PS_ID
      },
    },
    created() {
      if (this.$store.state.detail.PS_ID == '') {
        //如果没有选择评审任务就返回到首页
        console.log(this.$route.path)
        //console.log(this.delTabsBar(this.$route.path))
        this.$router.push('/')
      }
      //this.fetchData()
      this.$nextTick(() => {
        this.fetchData()
        //this.checkNodes = this.$refs.demoTree.getCheckedNodes()
      })
    },
    methods: {
      mp3panduan(_url) {
        return ['.mp3'].includes(_url.toLowerCase())
        this.spanCount = 3
      },
      picpanduan(_url) {
        return ['.jpg', '.jpeg', '.png'].includes(_url.toLowerCase())
        this.spanCount = 3
      },

      pdfpanduan(_url) {
        return ['.pdf'].includes(_url.toLowerCase())
      },

      docxpanduan(_url) {
        return ['.doc', '.docx'].includes(_url.toLowerCase())
      },

      async fetchData() {
        const _that = this
        this.PS_ID = this.$store.state.detail.PS_ID
        console.log(this.PS_ID)
        // Send a POST request
        this.tableData = await axios({
          method: 'post',
          url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=readFiles', //请求地址
          data: JSON.stringify({ id: this.PS_ID }), //表单序列化
        }).then((response) => {
          // Handle response
          console.log('response.data')
          console.log(response.data)
          console.log('response.data')
          return response.data
        })
      },

      async ZipDown() {
        const _that = this
        _that.loading = true
        this.PS_ID = this.$store.state.detail.PS_ID
        console.log(this.PS_ID)
        // Send a POST request
        const _ZipUrl = await axios({
          method: 'post',
          url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=downLoadZipFiles', //请求地址
          data: JSON.stringify({ id: this.PS_ID }), //表单序列化
        }).then((response) => {
          // Handle response
          console.log('response.data')
          console.log(response.data)
          console.log('response.data')
          return response.data
        })
        setTimeout(() => {
          _that.loading = false
          _that.zipUrl = _ZipUrl
          _that.$message({
            type: 'success',
            message: '生成成功!',
          })
        }, 800)
      },
      queryData() {
        this.fetchData()
      },

      View(row) {
        console.log(row)
        // this.xTable = this.$refs.xTree
        // const $table = this.xTable
        // if ($table) {
        //   $table.setEditRow(row)
        // }
        if (this.docxpanduan(row.Type)) this.$refs['docxView'].docFile(row.Path)
        if (this.pdfpanduan(row.Type)) this.$refs['edit'].showEdit(row.Path)
        if (this.picpanduan(row.Type)) {
          this.picView_pan = true
          this.$refs['picView'].showEdit(row.Path)
        }
      },
      Downlaod(url) {
        console.log(url)
        const link = document.createElement('a')
        fetch(url.Path)
          .then((res) => res.blob())
          .then((blob) => {
            // 将链接地址字符内容转变成blob地址
            link.href = URL.createObjectURL(blob)
            // console.log(link.href)
            link.download = ''
            document.body.appendChild(link)
            link.click()
            document.body.removeChild(link)
          })
      },
    },
  }
</script>
<style scoped>
  .tree-node-icon {
    padding: 10px;
    font-size: 1.7rem;
  }
  .row--hover .tree-node-icon {
    color: red;
  }
</style>
