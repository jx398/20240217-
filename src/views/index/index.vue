<template>
  <div class="index-container">
    <el-row :gutter="20">
      <el-col :xs="24" :sm="24" :md="24" :lg="24" :xl="24">
        <el-alert>
          <div
            style="display: flex; align-items: center; justify-content: center"
          >
            <a href="#">
              今天是：
              <span style="color: red; font-weigth: bold; font-size: larger">
                {{ newTime }}
              </span>
              共完成评审任务
              <span style="color: red; font-weigth: bold; font-size: 14px">
                {{ total }}
              </span>
              个！继续努力！
            </a>
          </div>
        </el-alert>
      </el-col>
      <el-col :xs="24" :sm="24" :md="24" :lg="24" :xl="24">
        <el-card>
          <div class="userManagement-container">
            <vab-query-form>
              <vab-query-form-left-panel :span="12">
                <el-button
                  icon="el-icon-plus"
                  type="primary"
                  @click="handleAdd"
                >
                  添加
                </el-button>
                <el-button
                  icon="el-icon-delete"
                  type="danger"
                  @click="handleDelete"
                >
                  批量删除
                </el-button>
                <el-button
                  icon="el-icon-sort"
                  type="warning"
                  @click="importData"
                >
                  载入数据
                </el-button>
                <el-button
                  icon="el-icon-refresh"
                  type="success"
                  @click="fetchData"
                >
                  重新载入
                </el-button>
              </vab-query-form-left-panel>
              <vab-query-form-right-panel :span="12">
                <el-form
                  :inline="true"
                  :model="queryForm"
                  @submit.native.prevent
                >
                  <el-form-item>
                    <el-input
                      v-model.trim="search"
                      placeholder="请输入用户名"
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
              </vab-query-form-right-panel>
            </vab-query-form>
            <el-divider content-position="center">安标评审任务管理</el-divider>

            <el-table
              v-loading="listLoading"
              :data="
                list == null
                  ? []
                  : list.filter(
                      (data) =>
                        !search ||
                        data.PS_DanWei.toLowerCase().includes(
                          search.toLowerCase()
                        )
                    )
              "
              border
              :element-loading-text="elementLoadingText"
              @selection-change="setSelectRows"
            >
              <el-table-column
                show-overflow-tooltip
                type="selection"
              ></el-table-column>
              <el-table-column width="50" label="导入">
                <template slot-scope="scope">
                  <i class="el-icon-download" @click="fetchRow(scope.row)"></i>
                </template>
              </el-table-column>

              <el-table-column
                show-overflow-tooltip
                prop="PS_ID"
                label="任务编号"
                style="wdth: 40px"
              >
                <template slot-scope="scope">
                  <div slot="reference">
                    <div v-if="scope.row.PS_File != ''">
                      <div slot="reference">
                        <el-tooltip
                          class="item"
                          effect="dark"
                          content="点击下载"
                          placement="right"
                          style="color: red"
                        >
                          <el-link
                            v-if="scope.row.PS_File != ''"
                            type="success"
                            :href="scope.row.PS_File"
                          >
                            {{ scope.row.PS_ID }}
                            <i class="el-icon-document"></i>
                          </el-link>
                        </el-tooltip>
                      </div>
                    </div>
                    <div v-else>
                      {{ scope.row.PS_ID }}
                    </div>
                  </div>
                </template>
              </el-table-column>
              <el-table-column
                show-overflow-tooltip
                prop="PS_DanWei"
                label="评审单位"
              >
                <template slot-scope="scope">
                  <el-popover trigger="hover" placement="top">
                    <span>
                      <p v-html="scope.row.PS_DanWeiJianJie">
                        {{ scope.row.PS_DanWeiJianJie.replace(/|/g, '"') }}
                      </p>
                    </span>
                    <div slot="reference">
                      {{ scope.row.PS_DanWei }}
                    </div>
                  </el-popover>
                </template>
              </el-table-column>
              <el-table-column
                show-overflow-tooltip
                prop="PS_DanWeiDiZhi"
                label="单位地址"
              ></el-table-column>
              <el-table-column
                show-overflow-tooltip
                prop="PS_RenYuan"
                label="评审人员"
              ></el-table-column>
              <el-table-column
                show-overflow-tooltip
                prop="PS_RiQiStart"
                label="评审日起"
              ></el-table-column>
              <el-table-column
                show-overflow-tooltip
                prop="PS_RiQiEnd"
                label="评审日止"
              ></el-table-column>
              <el-table-column show-overflow-tooltip label="评审结论">
                <template slot-scope="scope">
                  <div slot="reference">
                    <span v-if="scope.row.PS_JieLun.indexOf('不') != -1">
                      <el-tag type="danger" style="color: #fff" effect="dark">
                        <span v-if="scope.row.PS_BuHegeBaoGao != ''">
                          <el-link
                            :href="scope.row.PS_BuHegeBaoGao"
                            :underline="false"
                            style="color: #fff; background-color: red"
                          >
                            {{ scope.row.PS_JieLun }}
                            <i class="el-icon-view el-icon--right"></i>
                          </el-link>
                        </span>
                        <span v-else>
                          {{ scope.row.PS_JieLun }}
                        </span>
                      </el-tag>
                    </span>
                    <span v-else>
                      <el-tag type="primary" size="medium" effect="dark">
                        <a
                          style="color: white; font-size: 10pt"
                          :href="
                            scope.row.PS_BuHegeBaoGao == ''
                              ? '#'
                              : scope.row.PS_BuHegeBaoGao
                          "
                        >
                          {{ scope.row.PS_JieLun }}
                        </a>
                      </el-tag>
                    </span>
                  </div>
                </template>
              </el-table-column>
              <el-table-column show-overflow-tooltip label="操作" width="200">
                <template #default="{ row }">
                  <el-button type="primary" @click="handleEdit(row)">
                    编辑
                  </el-button>

                  <el-button type="warning" @click="handleDelete(row)">
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
            <edit ref="edit" :formData="passRow" @fetch-data="fetchData"></edit>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  //import { getList, doDelete } from '@/api/jianceManagement'
  import Edit from './components/jianceManagementEdit'
  const days = ['天', '一', '二', '三', '四', '五', '六'] // 星期数组
  var icnow = new Date() // 初始化时间
  var interval // 定义全局定时器，用于清除定时器
  // 用promise对象封装
  const jqPromiseAjax = (params) => {
    $.ajax({
      url: params.url,
      type: params.type || 'get',
      dataType: 'json',
      headers: params.headers || {},
      data: JSON.stringify(params.data) || {},
      success(result) {
        console.log(result)
        this.$baseMessage('dddd' + responseText, 'success')
        this.fetchData()
      },
      error(err) {},
    })
  }
  export default {
    name: 'Index',
    components: {
      Edit,
    },
    data() {
      return {
        year: icnow.getFullYear(),
        month: icnow.getMonth() + 1,
        date: icnow.getDate(),
        day: days[icnow.getDay() - 1],
        time: icnow.toTimeString().substring(0, 8),
        passRow: null,
        list: null,
        listLoading: true,
        layout: 'total, sizes, prev, pager, next, jumper',
        total: 0,
        selectRows: '',
        elementLoadingText: '正在加载...',
        queryForm: {
          PS_ID: '',
        },
        search: '',
      }
    },

    computed: {
      // 当前时间
      newTime: function () {
        return (
          this.year +
          '年' +
          this.month +
          '月' +
          this.date +
          '日 星期' +
          this.day +
          ' ' +
          this.time
        )
      },
    },
    created() {
      this.fetchData()
      interval = setInterval(() => {
        let icnow = new Date()
        this.year = icnow.getFullYear()
        this.month = icnow.getMonth() + 1
        this.date = icnow.getDate()
        this.day = days[icnow.getDay()]
        this.time = icnow.toTimeString().substring(0, 8)
      }, 1000)
    },
    beforeDestroy() {
      clearInterval(interval)
    },
    methods: {
      setSelectRows(val) {
        this.selectRows = val
      },
      handleEdit(row) {
        //console.log(row)

        this.passRow = row
        this.$refs['edit'].showEdit()
      },
      handleAdd() {
        this.passRow = {
          PS_ID: '',
          PS_DanWei: '',
          PS_DanWeiDiZhi: '',
          PS_RiQiStart: '',
          PS_RiQiEnd: '',
          PS_JieLun: '',
          PS_RenYuan: '',
        }
        this.$refs['edit'].showEdit()
      },

      handleDelete(row) {
        const _that = this
        if (row.PS_ID) {
          this.$baseConfirm(
            '你确定要删除当前项吗？编号ID:' + row.PS_ID,
            null,
            () => {
              $.ajax({
                url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=delete',
                type: 'post',
                dataType: 'json',
                data: JSON.stringify({ ids: row.PS_ID }),
                success: function (result) {
                  //成功
                  console.log('result.status')
                  console.log(result)
                  console.log(result.status)
                  this.$router.go(0)
                },
                error: function (result) {
                  //失败
                  console.log(result.status)
                  if (result.status == 200) {
                    _that.$baseMessage(result.responseText, 'success')
                    setTimeout(() => {
                      this.listLoading = true
                      _that.fetchData()
                    }, 300)

                    //_that.showEdit = false
                  } else {
                    _that.$baseMessage(result.responseText, 'error')
                  }
                },
              })
            }
          )
        } else {
          if (this.selectRows.length > 0) {
            const ids = this.selectRows.map((item) => item.PS_ID).join()
            this.$baseConfirm('你确定要删除选中项吗', null, async () => {
              $.ajax({
                url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=delete',
                type: 'post',
                dataType: 'json',
                data: JSON.stringify({ ids: ids }),
                success: function (result) {
                  //成功
                  console.log('result.status')
                  console.log(result)
                  console.log(result.status)
                  this.$router.go(0)
                },
                error: function (result) {
                  //失败
                  console.log(result.status)
                  if (result.status == 200) {
                    _that.fetchData()
                    _that.$baseMessage(result.responseText, 'success')

                    //_that.showEdit = false
                  } else {
                    _that.$baseMessage(result.responseText, 'error')
                  }
                },
              })
            })
          } else {
            this.$baseMessage('未选中任何行', 'error')
            return false
          }
        }
      },
      importData() {
        if (this.selectRows.length > 0) {
          const importRow = this.selectRows[this.selectRows.length - 1]
          const importId = importRow.PS_ID
          this.$store.dispatch('detail/setPS_ID', importId)
          this.$baseMessage('载入数据完成', 'success')
        } else {
          this.$baseMessage('未选中任何行', 'error')
        }
      },
      fetchRow(row) {
        const _that = this
        const importId = row.PS_ID
        if (importId) {
          this.$store.dispatch('detail/setPS_ID', importId)
          this.$baseMessage('载入数据完成', 'success')
        }
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
      fetchData() {
        this.listLoading = true
        const _that = this
        let cout = 0
        let Data = ''
        //const { data, totalCount } = this.queryForm
        $.ajax({
          type: 'post', //请求类型
          dataType: 'json', //请求数据返回类型
          url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=getRenwu', //请求地址
          data: JSON.stringify(this.queryForm), //表单序列化
          success: function (result) {
            //成功

            const { count, Data } = result
            //_that.$baseMessage('共查询到'count, 'success')
            _that.list = Data
            _that.total = count
            //_that.showEdit = false
          },
          error: function (result) {
            //失败
            console.log(result.status)
            if (result.status == 200) {
              const { count, Data } = JSON.parse(result.responseText)
              _that.$baseMessage('dddd' + count, 'success')
              _that.list = Data
              _that.total = count
              //_that.showEdit = false
            } else {
              _that.$baseMessage(result.responseText, 'error')
            }
          },
        })

        setTimeout(() => {
          this.listLoading = false
        }, 300)
      },
    },
  }
</script>
<style>
  .el-input__inner,
  .el-textarea__inner,
  .input {
    color: blue !important;
    font-weight: bold;
  }
  .el-form-item {
    margin-bottom: 0px !important;
  }
</style>
<style scoped>
  .el-icon-download {
    size: 30px;
    border: 1px solid #f0ddd0;
    padding: 5px;
    color: red;
    background-color: beige;
  }
  .el-icon-download:hover {
    border: 1px solid #f0ddd0;
    padding: 5px;
    color: red;
    background-color: rgb(229, 229, 12);
    cursor: pointer;
  }
</style>
