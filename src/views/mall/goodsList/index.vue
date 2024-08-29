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
              <div class="goods-list-title">
                {{ item.PS_ID }}-{{ item.PS_DanWei }}
              </div>
              <div class="goods-list-tag-group">
                <el-tag hit type="success">{{ item.PS_JieLun }}</el-tag>
                <el-tag hit type="success">{{ item.PS_RenYuan }}</el-tag>
                <el-tag hit :type="item.PS_File != '' ? 'danger' : 'info'">
                  <el-link
                    v-if="item.PS_File != ''"
                    type="success"
                    :href="item.PS_File"
                  >
                    报告下载
                    <i class="el-icon-document"></i>
                  </el-link>
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
      }
    },
    created() {
      this.fetchData()
    },
    methods: {
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
          this.$store.dispatch('detail/setPS_ID', importId)
          this.$baseMessage('载入数据完成', 'success')
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
        top: 10px;
        right: 0px;
        z-index: 9;
        text-align: center;
        span {
          margin-left: 2px !important;
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
  }
</style>
