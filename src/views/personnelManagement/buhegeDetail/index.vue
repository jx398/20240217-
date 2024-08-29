<template>
  <div class="userManagement-container">
    <vab-query-form>
      <vab-query-form-left-panel :span="12">
        <el-button type="primary" @click="add">
          <i class="el-icon-plus"></i>
          新增
        </el-button>
        <el-button type="primary" @click="baogao">
          <i class="el-icon-tickets"></i>
          生成报告
        </el-button>
        <el-button type="primary" @click="handle_Edit()">
          <i class="el-icon-view"></i>
          报告查看
        </el-button>

        <pdfshow ref="pdf_show" :pdfSrc="passPdfsrc"></pdfshow>

        <el-button type="danger" @click="baogaoDownload">
          <i class="el-icon-download"></i>
          报告下载
        </el-button>
      </vab-query-form-left-panel>
      <vab-query-form-right-panel :span="12">
        <el-form :inline="true" :model="queryForm" @submit.native.prevent>
          <el-form-item>
            <el-input
              v-model.trim="search"
              placeholder="请输入用户名"
              clearable
            />
          </el-form-item>
          <el-form-item>
            <el-button icon="el-icon-search" type="primary" @click="queryData">
              重新载入
            </el-button>
          </el-form-item>
        </el-form>
      </vab-query-form-right-panel>
    </vab-query-form>
    <el-divider content-position="center">
      <el-link type="danger">{{ PS_ID }}</el-link>
      -
      <el-link type="success">{{ PS_DanWei }}</el-link>
      不合格项
    </el-divider>

    <el-table
      v-loading="listLoading"
      :data="
        list == null
          ? []
          : list.filter(
              (data) =>
                !search ||
                data.BHG_ID.toLowerCase().includes(search.toLowerCase())
            )
      "
      :element-loading-text="elementLoadingText"
      @selection-change="setSelectRows"
    >
      <el-table-column show-overflow-tooltip type="selection"></el-table-column>
      <el-table-column type="index" width="50"></el-table-column>

      <el-table-column
        show-overflow-tooltip
        prop="BHG_ID"
        label="不合格项目"
        sortable
        :sort-method="sortChange"
        width="200"
      >
        <template slot-scope="scope">
          <span v-if="scope.row.isEdit">
            <el-select v-model="scope.row.BHG_ID" placeholder="请选择">
              <el-option
                v-for="item in tempTreeData"
                :key="item"
                :label="item"
                :value="item"
              ></el-option>
            </el-select>
          </span>
          <span v-else>{{ scope.row.BHG_ID }}</span>
        </template>
      </el-table-column>
      <el-table-column
        show-overflow-tooltip
        prop="BHG_Type"
        label="不合格类型"
        width="100"
      >
        <template slot-scope="scope">
          <div v-if="scope.row.isEdit">
            <el-select v-model="scope.row.BHG_Type" placeholder="请选择">
              <el-option
                v-for="item in [
                  {
                    value: '基本',
                    label: '基本符合',
                  },
                  {
                    value: '不符',
                    label: '不符合',
                  },
                ]"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              ></el-option>
            </el-select>
          </div>
          <div v-else>
            <span
              :style="
                scope.row.BHG_Type == '不符'
                  ? { color: '#f00' }
                  : scope.row.BHG_Type == '基本'
                  ? { color: 'green' }
                  : { color: '#FFF' }
              "
            >
              {{ scope.row.BHG_Type }}
            </span>
          </div>
        </template>
      </el-table-column>
      <el-table-column
        show-overflow-tooltip
        prop="BHG_ShiShi"
        label="不符合事实"
      >
        <template slot-scope="scope">
          <el-input
            v-if="scope.row.isEdit"
            v-model="scope.row.BHG_ShiShi"
            type="textarea"
            placeholder="请输入内容"
          ></el-input>
          <span v-else>{{ scope.row.BHG_ShiShi }}</span>
        </template>
      </el-table-column>

      <el-table-column show-overflow-tooltip label="整改措施">
        <template slot-scope="scope">
          <el-input
            v-if="scope.row.isEdit"
            v-model="scope.row.BHG_ZhengGai"
            type="textarea"
            placeholder="请输入内容"
          ></el-input>
          <span v-else>{{ scope.row.BHG_ZhengGai }}</span>
        </template>
      </el-table-column>

      <!-- <el-table-column show-overflow-tooltip label="权限">
        <template #default="{ row }">
          <el-tag v-for="(item, index) in row.permissions" :key="index">
            {{ item }}
          </el-tag>
        </template>
      </el-table-column> -->
      <!--eslint-disable vue/no-lone-template-->

      <!--eslint-enable-->
      <el-table-column show-overflow-tooltip label="操作" width="200">
        <template slot-scope="scope">
          <el-button
            v-if="!scope.row.isEdit"
            type="text"
            size="mini"
            @click="edit(scope.row)"
          >
            编辑
          </el-button>
          <el-button
            v-if="scope.row.isEdit"
            type="text"
            size="small"
            @click="save(scope.row)"
          >
            保存
          </el-button>
          <el-button
            v-if="scope.row.isEdit"
            type="text"
            size="small"
            @click="cancel(scope.row, scope.$index)"
          >
            取消
          </el-button>
          <el-button
            v-if="!scope.row.isEdit"
            size="mini"
            type="text"
            style="color: red"
            @click="handleDelete(scope.$index)"
          >
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      background
      :current-page="queryForm.pageNo"
      :page-size="queryForm.pageSize"
      :layout="layout"
      :total="total"
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
    ></el-pagination>
  </div>
</template>

<script>
  import { getList, doDelete } from '@/api/userManagement'
  import { getTreeList } from '@/api/tree'
  import pdfshow from './components/showPdf.vue'
  import { mapActions, mapGetters } from 'vuex'

  const axios = require('axios').default

  export default {
    name: 'UserManagement',
    components: { pdfshow },

    data() {
      return {
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
        this.delTabsBar(this.$route)
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
      ...mapActions({
        delTabsBar: 'tabsBar/delRoute',
      }),
      getDoucument() {
        // setTimeout(() => {
        //   this.$preview({
        //     //url: 'https://testimg.tiangongy.com/100601/a024b86760bb1ff3b38f25ae2e0b9bdf', //图片
        //     //url: 'https://testimg.tiangongy.com/100601/9958ff80d202f91b347b14b5c56f14e8', // xlsx
        //     //url: 'https://testimg.tiangongy.com/100601/12d7e6a9b0b9169b800fbb29061212c2', //pptx
        //     //url: 'https://testimg.tiangongy.com/100601/ce44c69f3075334e6c624b8180a42804', //doc,
        //     //url: 'https://testimg.tiangongy.com/100601/3b85b4f1c3accdb4bb9f7e42e1f9070e',
        //     url: this.buhegeBaoGaoFile,
        //     fid: '12121212',
        //   })
        // // }, 2000)
        // this.$dialog.open(this.buhegeBaoGaoFile)
        // window.open(this.buhegeBaoGaoFile, '_blank') // 在新窗口打开外链接
        console.log(this.$refs)
        console.log(this.$refs['pdf_show'])
        this.$refs['pdf_show'].showEdit()
      },
      handle_Edit() {
        console.log('passPdfsrc')
        console.log(this.passPdfsrc)
        this.passPdfsrc = this.pdf_src
        this.$refs['pdf_show'].showEdit()
      },
      // 获取tree数据
      sortChange(a, b) {
        let _a = a.BHG_ID.split('.')[0] + '.' + a.BHG_ID.split('.')[1]
        let _b = b.BHG_ID.split('.')[0] + '.' + b.BHG_ID.split('.')[1]
        return _a - _b
      },
      async fetchData() {
        console.log('dddddd')
        const { data } = await getTreeList()
        console.log(data)
        let optinArray = []
        data.forEach((item) => {
          item.children.forEach((subItem) => {
            if (subItem.children.length == 0) optinArray.push(subItem.name)
            else
              subItem.children.forEach((thirdItem) => {
                if (thirdItem.children.length == 0)
                  optinArray.push(thirdItem.name)
              })
          })
        })
        this.tempTreeData = optinArray

        console.log('dddddd')
        const _that = this
        this.PS_ID = this.$store.state.detail.PS_ID
        this.PS_DanWei = this.$store.state.detail.PS_DanWei
        console.log(this.PS_ID)
        if (this.PS_ID != '') {
          $.ajax({
            type: 'post', //请求类型
            dataType: 'json', //请求数据返回类型
            url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=getBuHeGe', //请求地址
            data: JSON.stringify({ ids: _that.PS_ID }), //表单序列化
            success: function (result) {
              //成功
              const { cout, Data, PS_BuHegeBaoGao } = result
              console.log('Data')
              console.log(Data)
              _that.list = Data.PS_BuHege
              _that.total = _that.list.length
              _that.total = _that.list.length
              _that.buhegeBaoGaoFile = PS_BuHegeBaoGao
              console.log('passPdfsrc')
              console.log(_that.passPdfsrc)
              _that.passPdfsrc = PS_BuHegeBaoGao.replace('doc', 'pdf')
              _that.pdf_src = PS_BuHegeBaoGao.replace('doc', 'pdf')
            },
            error: function (result) {
              const { cout, Data, PS_BuHegeBaoGao } = result
              console.log('Data----error')
              console.log(Data)
              console.log(eval(result.responseText))
              _that.list = Data.PS_BuHege
              _that.total = _that.list.length
              _that.buhegeBaoGaoFile = PS_BuHegeBaoGao
              _that.passPdfsrc = PS_BuHegeBaoGao.replace('doc', 'pdf')
              _that.pdf_src = PS_BuHegeBaoGao.replace('doc', 'pdf')
              _that.$baseMessage(result.responseText, 'error')
            },
          })
        } else {
          _that.$alert('请选择或新建评审任务', '提示', {
            confirmButtonText: '确定',
            callback: (action) => {
              //_that.$baseMessage('请选择或新建评审任务', 'error')
            },
          })
        }
        setTimeout(() => {
          _that.listLoading = false
        }, 300)
      },
      setSelectRows(val) {
        this.selectRows = val
      },
      handleEdit(row) {
        console.log(this)
        this.RY_Pass_Row = row
        console.log(this.RY_Pass_Row)
        this.$refs['edit'].showEdit(row)
      },
      add() {
        console.log(this.list == null)
        this.list = this.list == null ? [] : this.list
        this.list.push({
          BHG_ID: '',
          BHG_Type: '',
          BHG_ShiShi: '',
          BHG_ZhengGai: '',
          isEdit: true,
          isAdd: true,
        })
      },
      async baogao() {
        const loading = this.$loading({
          lock: false,
          text: '拼命生成不合格项报告中。。。。。',
          spinner: 'el-icon-loading',
          background: 'rgba(0, 0, 0, 0.7)',
        })
        const response = await axios({
          method: 'post',
          url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=baogaoBuhege', //请求地址
          responseType: 'stream',
          data: JSON.stringify({ ids: this.PS_ID }), //表单序列化
        })
        if (response != '') {
          setTimeout(() => {
            console.log(response)
            console.log(response.data)
            const { doc, pdf } = response.data
            console.log('=================')
            console.log(doc)
            console.log(pdf)

            setTimeout(() => loading.close(), 1000)
            this.pdf_src = pdf
            this.passPdfsrc = pdf
            //window.location.href = this.buhegeBaoGaoFile
            this.$baseMessage('不合格报告生成完成', 'success')
          }, 600)
        }
      },
      edit(row) {
        console.log(row)
        row.isEdit = true
        // 备份原始数据
        //row['oldRow'] = JSON.parse(JSON.stringify(row))
      },
      save(row) {
        row.isEdit = false
        var _that = this
        _that.listLoading = true
        if (this.PS_ID != '') {
          $.ajax({
            type: 'post', //请求类型
            dataType: 'json', //请求数据返回类型
            url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=updateBuHeGe', //请求地址
            data: JSON.stringify({
              PS_ID: _that.$store.state.detail.PS_ID,
              PS_BuHege: _that.list,
            }), //表单序列化
            success: function (result) {
              _that.$message({
                type: 'success',
                message: '保存成功!',
              })
            },
            error: function (result) {
              _that.$baseMessage(result.responseText, 'success')
            },
          })
        } else {
          _that.$alert('请选择或新建评审任务', '提示', {
            confirmButtonText: '确定',
            callback: (action) => {
              //_that.$baseMessage('请选择或新建评审任务', 'error')
            },
          })
        }

        setTimeout(function () {
          _that.listLoading = false
        }, 500)
      },
      // 取消
      cancel(row, index) {
        // 如果是新增的数据
        // if (row.isAdd) {
        //   this.list.splice(index, 1)
        // } else {
        //   // 不是新增的数据  还原数据
        //   for (const i in row.oldRow) {
        //     row[i] = row.oldRow[i]
        //   }
        // }
        row.isEdit = false
      },
      baogaoDownload() {
        window.location.href = this.buhegeBaoGaoFile
      },

      handleDelete(id) {
        this.$confirm('确定要删除这条记录吗？', '删除提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
          center: true,
        })
          .then(() => {
            var that = this
            that.list.splice(id, 1)
            that.listLoading = true
            that.$message({
              type: 'success',
              message: '删除成功!',
            })
            setTimeout(function () {
              that.listLoading = false
            }, 500)
          })
          .catch(() => {
            this.$message({
              type: 'info',
              message: '已取消操作',
            })
          })
      },

      handleSizeChange(val) {
        this.fetchData()
      },
      handleCurrentChange(val) {
        this.fetchData()
      },
      queryData() {
        this.fetchData()
      },
    },
  }
</script>
