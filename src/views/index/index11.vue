<template>
  <div class="goods-list-container">
    <el-col
      :xs="24"
      :sm="24"
      :md="24"
      :lg="24"
      :xl="24"
      style="margin-bottom: -10px"
    >
      <div>
        <vab-query-form>
          <vab-query-form-left-panel :span="12">
            <el-button icon="el-icon-plus" type="primary" @click="handleAdd">
              添加
            </el-button>
            <el-button
              icon="el-icon-delete"
              type="danger"
              @click="handleDelete"
            >
              批量删除
            </el-button>
            <el-button icon="el-icon-sort" type="warning" @click="importData">
              载入数据
            </el-button>
            <el-button icon="el-icon-refresh" type="success" @click="fetchData">
              重新载入
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
      </div>
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

    <div>
      <el-row :gutter="20">
        <el-col
          v-for="(item, index) in list.filter(
            (data) =>
              !search ||
              data.PS_DanWei.toLowerCase().includes(search.toLowerCase())
          )"
          :key="index"
          :xs="24"
          :sm="8"
          :md="8"
          :lg="8"
          :xl="6"
        >
          <el-card :body-style="{ padding: '0px' }" shadow="hover">
            <div class="goods-list-card-body">
              <div class="goods-list-title warning">
                {{ item.PS_ID }}-{{ item.PS_DanWei }}
              </div>
              <div class="goods-list-tag-group tip">
                <el-tag hit type="success">{{ item.PS_JieLun }}</el-tag>
                <el-tag hit type="success">{{ item.PS_RenYuan }}</el-tag>
                <el-tag hit type="success">
                  <a v-if="item.PS_File != ''" type="text" :href="item.PS_File">
                    报告下载
                    <i class="el-icon-document"></i>
                  </a>
                </el-tag>
                <el-tag hit type="success">
                  {{ item.PS_RiQiStart.substr(0, 11) }}
                </el-tag>
                <el-tag hit type="success" @click="fetchRow(item.PS_ID)">
                  载入数据
                </el-tag>
              </div>
              <div class="goods-list-image-group" @click="fetchRow(item.PS_ID)">
                <pdf :src="item.PS_RenWuShu"></pdf>
              </div>
              <!--  <div class="goods-list-description">
              {{ item.PS_DanWeiDiZhi }}
            </div>
            <div class="goods-list-price">
              <span>{{ item.PS_RiQiStart }}</span>
              -
              <span>{{ item.PS_RiQiEnd }}</span>
            </div> -->
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <el-pagination
      background
      :current-page="queryForm.pageNo"
      :layout="layout"
      :page-size="queryForm.pageSize"
      :total="total"
      @current-change="handleCurrentChange"
      @size-change="handleSizeChange"
    ></el-pagination>
  </div>
</template>

<script>
  //import { getList } from '@/api/goodsList'
  import pdf from 'jt-vue-pdf-signature'
  var icnow = new Date() // 初始化时间
  const days = ['天', '一', '二', '三', '四', '五', '六'] // 星期数组
  var interval // 定义全局定时器，用于清除定时器

  export default {
    name: 'Goods',
    components: {
      pdf,
    },
    data() {
      return {
        queryForm: {
          pageNo: 1,
          pageSize: 20,
          title: '',
        },
        list: null,
        listLoading: true,
        layout: 'total, sizes, prev, pager, next, jumper',
        total: 0,
        elementLoadingText: '正在加载...',
        search: '',
        year: icnow.getFullYear(),
        month: icnow.getMonth() + 1,
        date: icnow.getDate(),
        day: days[icnow.getDay() - 1],
        time: icnow.toTimeString().substring(0, 8),
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
      handleSizeChange(val) {
        this.queryForm.pageSize = val
        this.fetchData()
      },
      handleCurrentChange(val) {
        this.queryForm.pageNo = val
        this.fetchData()
      },
      handleQuery() {
        this.queryForm.pageNo = 1
        this.fetchData()
      },
      fetchRow(_id) {
        console.log(_id)
        const _that = this
        const importId = _id
        if (importId) {
          console.log('载入数据完成' + importId)
          this.$store.dispatch('detail/setPS_ID', importId)
          this.$baseMessage('载入数据完成', 'success')
          setTimeout(() => {
            console.log(this.$store.state.detail.PS_ID)
            console.log(this.$store.state.detail.PS_DanWei)
          }, 300)
        }
      },
      async fetchData() {
        this.listLoading = true
        const List = []
        const count = 999
        let num = 0
        let Data = ''
        const _that = this
        //const { data, totalCount } = this.queryForm
        $.ajax({
          type: 'post', //请求类型
          dataType: 'json', //请求数据返回类型
          url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=getRenwu', //请求地址
          data: JSON.stringify({ PS_ID: '' }), //表单序列化
          success: function (result) {
            //成功

            const { count, Data } = result

            if (count > 0) {
              //_that.$baseMessage('共查询到'count, 'success')
              _that.list = Data
              _that.total = count
              _that.$baseMessage('共查询到' + count + '条数据！', 'success')
            } else {
              _that.list = []
              _that.total = count
              _that.$baseMessage('未检索到数据！', 'error')
            }
            //_that.showEdit = false
            setTimeout(() => {
              _that.listLoading = false
            }, 300)
          },
          error: function (result) {
            //失败
            _that.$baseMessage(result, 'error')
            setTimeout(() => {
              _that.listLoading = false
            }, 300)
          },
        })
      },
    },
  }
</script>
<style lang="scss" scoped>
  .goods-list-container {
    .goods-list-card-body {
      position: relative;
      text-align: left;
      cursor: pointer;
      padding: 10px;

      .goods-list-tag-group {
        position: relative;
        //top: 10px;
        right: 0px;
        z-index: 9;
        text-align: center;
        padding: 5px;
        span {
          margin-left: 2px !important;
        }
        a:hover {
          color: red;
          //font-weight: bold;
        }
      }

      .goods-list-image-group {
        height: 400px;
        overflow: hidden;

        .goods-list-image {
          width: 100%;
          height: 400px;
          transition: all ease-in-out 0.3s;

          &:hover {
            transform: scale(1.1);
          }
        }
      }

      .goods-list-title {
        margin: 8px 0;
        font-size: 16px;
        font-weight: bold;
      }

      .goods-list-description {
        font-size: 14px;
        color: #808695;
      }

      .goods-list-price {
        margin: 8px 0;
        font-size: 14px;
        color: $base-color-orange;

        s {
          color: #c5c8ce;
        }
      }
    }
    .warning {
      background-color: rgb(255, 246, 247);
      padding: 8px 16px;
      border-radius: 4px;
      border-left: 5px solid rgb(254, 108, 111);
      margin: 20px 0px;
    }
    .tip {
      background-color: #f4f4f5;
      border-radius: 4px;
      border-left: 5px solid #e9e9e9;

      //margin: 20px 0px;
    }
  }
</style>
