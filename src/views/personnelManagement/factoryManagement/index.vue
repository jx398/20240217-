<template>
  <div>
    <el-row :gutter="20">
      <el-col :xs="24" :sm="24" :md="24" :lg="24" :xl="24">
        <el-card>
          <div class="formCss">
            <el-form
              ref="form"
              :model="form"
              label-width="100px"
              label-position="right"
            >
              <table class="table">
                <caption>
                  <div
                    style="
                      display: flex;
                      align-items: center;
                      justify-content: center;
                    "
                  >
                    <div slot="header">
                      <el-tag
                        type="danger"
                        size="large"
                        class="cssShowSelected"
                      >
                        <el-link type="danger">{{ PS_ID }}</el-link>
                        -
                        <el-link type="success">{{ PS_DanWei }}</el-link>
                      </el-tag>
                      工厂基本信息
                      <div style="float: right; margin-left: 10px">
                        <el-button
                          icon="el-icon-search"
                          type="primary"
                          size="small"
                          @click="queryData"
                        >
                          重新载入
                        </el-button>
                        <el-button
                          v-if="!isEdit"
                          type="success"
                          size="small"
                          @click="showUpdate()"
                        >
                          修改
                        </el-button>
                        <el-button
                          v-if="isEdit"
                          type="success"
                          @click="submit()"
                        >
                          确定
                        </el-button>
                        <el-button
                          v-if="isEdit"
                          type="success"
                          @click="cancelUpdate()"
                        >
                          取消
                        </el-button>
                      </div>
                    </div>
                    <p></p>
                  </div>
                </caption>
                <tr>
                  <td colspan="3">
                    <el-form-item label="工厂名称：">
                      <span v-html="form.gcMingcheng"></span>
                    </el-form-item>
                  </td>
                </tr>
                <tr>
                  <td colspan="3">
                    <el-form-item label="注册地址：">
                      <span v-if="!isEdit" v-html="form.gcZhucedi"></span>
                      <el-input
                        v-if="isEdit"
                        v-model="form.gcZhucedi"
                      ></el-input>
                    </el-form-item>
                  </td>
                </tr>
                <tr>
                  <td colspan="3">
                    <el-form-item label="生产地址：">
                      <span v-if="!isEdit" v-html="form.gcShengchandi"></span>
                      <el-input
                        v-if="isEdit"
                        v-model="form.gcShengchandi"
                      ></el-input>
                    </el-form-item>
                  </td>
                </tr>
                <tr>
                  <td>
                    <el-form-item label="法定代表人：">
                      <span v-if="!isEdit" v-html="form.gcFaren"></span>
                      <el-input v-if="isEdit" v-model="form.gcFaren"></el-input>
                    </el-form-item>
                  </td>
                  <td>
                    <el-form-item label="学历：">
                      <span v-if="!isEdit" v-html="form.gcFarenXueli"></span>
                      <el-autocomplete
                        v-if="isEdit"
                        v-model="form.gcFarenXueli"
                        class="inline-input"
                        :fetch-suggestions="querySearch"
                        placeholder="请输入学历"
                        @select="handleSelect"
                      ></el-autocomplete>
                    </el-form-item>
                  </td>
                  <td>
                    <el-form-item label="电话：">
                      <span v-if="!isEdit" v-html="form.gcFarenTel"></span>
                      <el-input
                        v-if="isEdit"
                        v-model="form.gcFarenTel"
                      ></el-input>
                    </el-form-item>
                  </td>
                </tr>
                <tr>
                  <td>
                    <el-form-item label="单位负责人：">
                      <span v-if="!isEdit" v-html="form.gcDanweiFuzeren"></span>
                      <el-input
                        v-if="isEdit"
                        v-model="form.gcDanweiFuzeren"
                      ></el-input>
                    </el-form-item>
                  </td>
                  <td>
                    <el-form-item label="学历：">
                      <span
                        v-if="!isEdit"
                        v-html="form.gcDanweiFuzerenXueli"
                      ></span>
                      <el-autocomplete
                        v-if="isEdit"
                        v-model="form.gcDanweiFuzerenXueli"
                        class="inline-input"
                        :fetch-suggestions="querySearch"
                        placeholder="请输入学历"
                        @select="handleSelect"
                      ></el-autocomplete>
                    </el-form-item>
                  </td>
                  <td>
                    <el-form-item label="电话：">
                      <span
                        v-if="!isEdit"
                        v-html="form.gcDanweiFuzerenTel"
                      ></span>

                      <el-input
                        v-if="isEdit"
                        v-model="form.gcDanweiFuzerenTel"
                      ></el-input>
                    </el-form-item>
                  </td>
                </tr>
                <tr>
                  <td>
                    <el-form-item label="技术负责人：">
                      <span v-if="!isEdit" v-html="form.gcJishuFuzeren"></span>
                      <el-input
                        v-if="isEdit"
                        v-model="form.gcJishuFuzeren"
                      ></el-input>
                    </el-form-item>
                  </td>
                  <td>
                    <el-form-item label="学历：">
                      <span
                        v-if="!isEdit"
                        v-html="form.gcJishuFuzerenXueli"
                      ></span>
                      <el-autocomplete
                        v-if="isEdit"
                        v-model="form.gcJishuFuzerenXueli"
                        class="inline-input"
                        :fetch-suggestions="querySearch"
                        placeholder="请输入学历"
                        @select="handleSelect"
                      ></el-autocomplete>
                    </el-form-item>
                  </td>
                  <td>
                    <el-form-item label="电话：">
                      <span
                        v-if="!isEdit"
                        v-html="form.gcJishuFuzerenTel"
                      ></span>
                      <el-input
                        v-if="isEdit"
                        v-model="form.gcJishuFuzerenTel"
                      ></el-input>
                    </el-form-item>
                  </td>
                </tr>
                <tr>
                  <td>
                    <el-form-item label="质量负责人：">
                      <span
                        v-if="!isEdit"
                        v-html="form.gcZhiliangFuzeren"
                      ></span>
                      <el-input
                        v-if="isEdit"
                        v-model="form.gcZhiliangFuzeren"
                      ></el-input>
                    </el-form-item>
                  </td>
                  <td>
                    <el-form-item label="学历：">
                      <span
                        v-if="!isEdit"
                        v-html="form.gcZhiliangFuzerenXueli"
                      ></span>
                      <el-autocomplete
                        v-if="isEdit"
                        v-model="form.gcZhiliangFuzerenXueli"
                        class="inline-input"
                        :fetch-suggestions="querySearch"
                        placeholder="请输入学历"
                        @select="handleSelect"
                      ></el-autocomplete>
                    </el-form-item>
                  </td>
                  <td>
                    <el-form-item label="电话：">
                      <span
                        v-if="!isEdit"
                        v-html="form.gcZhiliangFuzerenTel"
                      ></span>
                      <el-input
                        v-if="isEdit"
                        v-model="form.gcZhiliangFuzerenTel"
                      ></el-input>
                    </el-form-item>
                  </td>
                </tr>
                <tr>
                  <td>
                    <el-form-item label="安标负责人：">
                      <span v-if="!isEdit" v-html="form.gcAnbiaoFuzeren"></span>
                      <el-input
                        v-if="isEdit"
                        v-model="form.gcAnbiaoFuzeren"
                      ></el-input>
                    </el-form-item>
                  </td>
                  <td>
                    <el-form-item label="学历：">
                      <span
                        v-if="!isEdit"
                        v-html="form.gcAnbiaoFuzerenXueli"
                      ></span>
                      <el-autocomplete
                        v-if="isEdit"
                        v-model="form.gcAnbiaoFuzerenXueli"
                        class="inline-input"
                        :fetch-suggestions="querySearch"
                        placeholder="请输入学历"
                        @select="handleSelect"
                      ></el-autocomplete>
                    </el-form-item>
                  </td>
                  <td>
                    <el-form-item label="电话：">
                      <span
                        v-if="!isEdit"
                        v-html="form.gcAnbiaoFuzerenTel"
                      ></span>
                      <el-input
                        v-if="isEdit"
                        v-model="form.gcAnbiaoFuzerenTel"
                      ></el-input>
                    </el-form-item>
                  </td>
                </tr>
                <tr>
                  <td>
                    <el-form-item label="安标联系人：">
                      <span
                        v-if="!isEdit"
                        v-html="form.gcAnbiaoLianxiren"
                      ></span>
                      <el-input
                        v-if="isEdit"
                        v-model="form.gcAnbiaoLianxiren"
                      ></el-input>
                    </el-form-item>
                  </td>
                  <td>
                    <el-form-item label="学历：">
                      <span
                        v-if="!isEdit"
                        v-html="form.gcAnbiaoLianxirenXueli"
                      ></span>
                      <el-autocomplete
                        v-if="isEdit"
                        v-model="form.gcAnbiaoLianxirenXueli"
                        class="inline-input"
                        :fetch-suggestions="querySearch"
                        placeholder="请输入学历"
                        @select="handleSelect"
                      ></el-autocomplete>
                    </el-form-item>
                  </td>
                  <td>
                    <el-form-item label="电话：">
                      <span
                        v-if="!isEdit"
                        v-html="form.gcAnbiaoLianxirenTel"
                      ></span>
                      <el-input
                        v-if="isEdit"
                        v-model="form.gcAnbiaoLianxirenTel"
                      ></el-input>
                    </el-form-item>
                  </td>
                </tr>
                <tr>
                  <td>
                    <el-form-item label="职工总数：">
                      <span v-if="!isEdit" v-html="form.gcZhigongCount"></span>
                      <el-input
                        v-if="isEdit"
                        v-model="form.gcZhigongCount"
                      ></el-input>
                    </el-form-item>
                  </td>
                  <td>
                    <el-form-item label="技术人员数：">
                      <span v-if="!isEdit" v-html="form.gcJishuCount"></span>
                      <el-input
                        v-if="isEdit"
                        v-model="form.gcJishuCount"
                      ></el-input>
                    </el-form-item>
                  </td>
                  <td>
                    <el-form-item label="生产设备数：">
                      <span
                        v-if="!isEdit"
                        v-html="form.gcShengchanShebei"
                      ></span>
                      <el-input
                        v-if="isEdit"
                        v-model="form.gcShengchanShebei"
                      ></el-input>
                    </el-form-item>
                  </td>
                </tr>
                <tr>
                  <td>
                    <el-form-item label="ISO9001：">
                      <span v-if="!isEdit" v-html="form.gcIsoRenzheng"></span>
                      <el-radio-group
                        v-if="isEdit"
                        v-model="form.gcIsoRenzheng"
                      >
                        <el-radio label="是"></el-radio>
                        <el-radio label="否"></el-radio>
                      </el-radio-group>
                    </el-form-item>
                  </td>
                  <td>
                    <el-form-item label="其它认证：">
                      <span v-if="!isEdit" v-html="form.gcQitaRenzheng"></span>

                      <el-radio-group
                        v-if="isEdit"
                        v-model="form.gcQitaRenzheng"
                      >
                        <el-radio label="是"></el-radio>
                        <el-radio label="否"></el-radio>
                      </el-radio-group>
                    </el-form-item>
                  </td>
                  <td>
                    <el-form-item label="生产模式：">
                      <span v-if="!isEdit" v-html="form.gcShenchanmoshi"></span>
                      <el-radio-group
                        v-if="isEdit"
                        v-model="form.gcShenchanmoshi"
                      >
                        <el-radio label="生产型"></el-radio>
                        <el-radio label="组装型"></el-radio>
                      </el-radio-group>
                    </el-form-item>
                  </td>
                </tr>
                <tr>
                  <td colspan="3">
                    <el-form-item label="认证能力：">
                      <span
                        v-if="!isEdit"
                        v-html="form.gcShengchanNengli"
                      ></span>

                      <el-input
                        v-if="isEdit"
                        v-model="form.gcShengchanNengli"
                        type="textarea"
                        :rows="3"
                      ></el-input>
                    </el-form-item>
                  </td>
                </tr>
                <tr>
                  <td colspan="3">
                    <el-form-item label="上年产量：">
                      <span
                        v-if="!isEdit"
                        v-html="form.gcShijiChanliang"
                      ></span>

                      <el-input
                        v-if="isEdit"
                        v-model="form.gcShijiChanliang"
                        type="textarea"
                        row="3"
                      ></el-input>
                    </el-form-item>
                  </td>
                </tr>
                <tr>
                  <td colspan="3">
                    <el-form-item label="备注：">
                      <span v-if="!isEdit" v-html="form.gcBeizhu"></span>

                      <el-input
                        v-if="isEdit"
                        v-model="form.gcBeizhu"
                        type="textarea"
                        row="3"
                      ></el-input>
                    </el-form-item>
                  </td>
                </tr>
              </table>
            </el-form>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  //import VabSnow from '@/components/VabSnow'
  //import VabProfile from '@/components/VabProfile'
  import { mapActions, mapGetters } from 'vuex'
  import { getList, doDelete, doEdit } from '@/api/factoryManagement'
  const PANDINGLIST = [
    'gcMingcheng',
    'gcZhucedi',
    'gcShengchandi',
    'gcFaren',
    'gcFarenTel',
    'gcFarenXueli',
    'gcDanweiFuzeren',
    'gcDanweiFuzerenXueli',
    'gcDanweiFuzerenTel',
    'gcJishuFuzeren',
    'gcJishuFuzerenXueli',
    'gcJishuFuzerenTel',
    'gcZhiliangFuzeren',
    'gcZhiliangFuzerenXueli',
    'gcZhiliangFuzerenTel',
    'gcAnbiaoFuzeren',
    'gcAnbiaoFuzerenXueli',
    'gcAnbiaoFuzerenTel',
    'gcAnbiaoLianxiren',
    'gcAnbiaoLianxirenTel',
    'gcAnbiaoLianxirenXueli',
    'gcZhigongCount',
    'gcJishuCount',
    'gcShengchanShebei',
    'gcJianyanShebei',
    'gcIsoRenzheng',
    'gcQitaRenzheng',
    'gcShenchanmoshi',
    'gcShengchanNengli',
    'gcShijiChanliang',
    'gcBeizhu',
  ]
  export default {
    name: 'FactoryManagement',
    components: {
      //VabSnow,
      //VabProfile,
      //Edit,
    },
    data() {
      return {
        //PDF预览
        isEdit: false,
        PS_ID: this.$store.state.detail.PS_ID,
        PS_DanWei: this.$store.state.detail.PS_DanWei,
        editShow: false,
        listLoading: true,
        restaurants: [],
        form: {
          gcMingcheng: '',
          gcZhucedi: '',
          gcShengchandi: '',
          gcFaren: '',
          gcFarenTel: '',
          gcFarenXueli: '',
          gcDanweiFuzeren: '',
          gcDanweiFuzerenXueli: '',
          gcDanweiFuzerenTel: '',
          gcJishuFuzeren: '',
          gcJishuFuzerenXueli: '',
          gcJishuFuzerenTel: '',
          gcZhiliangFuzeren: '',
          gcZhiliangFuzerenXueli: '',
          gcZhiliangFuzerenTel: '',
          gcAnbiaoFuzeren: '',
          gcAnbiaoFuzerenXueli: '',
          gcAnbiaoFuzerenTel: '',
          gcAnbiaoLianxiren: '',
          gcAnbiaoLianxirenTel: '',
          gcAnbiaoLianxirenXueli: '',
          gcZhigongCount: '',
          gcJishuCount: '',
          gcShengchanShebei: '',
          gcJianyanShebei: '',
          gcIsoRenzheng: '',
          gcQitaRenzheng: '',
          gcShenchanmoshi: '',
          gcShengchanNengli: '',
          gcShijiChanliang: '',
          gcBeizhu: '',
        },
      }
    },
    watch: {
      '$store.state.detail.PS_ID'() {
        this.PS_ID = this.$store.state.detail.PS_ID
        this.fetchStore()
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
      this.restaurants = this.loadAll()
      setTimeout(() => {
        this.fetchStore()
      }, 800)
    },

    methods: {
      ...mapActions({
        delTabsBar: 'tabsBar/delRoute',
      }),
      handleSelect() {},

      fetchStore() {
        this.listLoading = true
        const _that = this

        console.log('fetchStore->this.$store.state.detail')
        console.log(this.$store.state.detail)
        console.log(this.PS_ID)
        this.PS_ID = this.$store.state.detail.PS_ID
        this.form.gcMingcheng = this.$store.state.detail.PS_DanWei
        console.log(this.$store.state.detail.PS_DanWei)
        console.log(this.form.gcMingcheng)

        if (this.PS_ID != '') {
          _that.editShow = true
          $.ajax({
            type: 'post', //请求类型
            dataType: 'json', //请求数据返回类型
            url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=getDanWeiXiangQing', //请求地址，数据库中对应的是[PS_DanWeiShengChan]
            data: JSON.stringify({ PS_ID: _that.PS_ID }), //表单序列化
            success: function (result) {
              //成功
              const { cout, Data } = result

              if (Data != '') {
                for (var i = 0; i < PANDINGLIST.length; i++)
                  _that.form[PANDINGLIST[i]] = Data[PANDINGLIST[i]].toString()
                _that.form['gcMingcheng'] = _that.$store.state.detail.PS_DanWei
                console.log(_that.form)

                _that.$message({
                  type: 'success',
                  message: '导入成功!',
                })
              } else
                _that.$message({
                  type: 'success',
                  message: '无数据!',
                })
            },
            error: function (result) {
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
      //点击修改
      showUpdate() {
        console.log('edit')
        this.isEdit = true
      },
      //取消修改
      cancelUpdate() {
        this.isEdit = false
        this.$baseMessage('已取消', 'info')
      },
      querySearch(queryString, cb) {
        var restaurants = this.restaurants
        var results = queryString
          ? restaurants.filter(this.createFilter(queryString))
          : restaurants
        // 调用 callback 返回建议列表的数据
        cb(results)
      },
      createFilter(queryString) {
        return (restaurant) => {
          return (
            restaurant.value
              .toLowerCase()
              .indexOf(queryString.toLowerCase()) === 0
          )
        }
      },
      loadAll() {
        return [
          { value: '小学' },
          { value: '高中' },
          { value: '中专' },
          { value: '大专' },
          { value: '本科' },
          { value: '硕士研究生' },
          { value: '博士研究生' },
        ]
      },
      queryData() {
        this.fetchStore()
      },
      submit() {
        const _that = this
        const saveObj = {}
        console.log(this.form)
        for (var i = 0; i < PANDINGLIST.length; i++)
          saveObj[PANDINGLIST[i]] = this.form[PANDINGLIST[i]].toString()
        this.PS_ID = this.$store.state.detail.PS_ID
        console.log(this.PS_ID)
        if (this.PS_ID != '') {
          $.ajax({
            type: 'post', //请求类型
            dataType: 'json', //请求数据返回类型
            url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=updateDanWeiXiangQing', //请求地址
            data: JSON.stringify({
              PS_ID: _that.PS_ID,
              PS_DanWeiShengChan: saveObj,
            }), //表单序列化
            success: function (result) {},
            error: function (result) {
              console.log(result.responseText)
              _that.$baseMessage(result.responseText, 'success')
              _that.isEdit = false
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
      },
    },
  }
</script>

<style lang="scss" scoped>
  .el-input__inner,
  .el-input {
    border: 0px;
  }
  .small-components-container {
    ::v-deep {
      .el-card__body {
        display: flex;
        align-items: flex-start;
        /* 垂直居中 */
        justify-content: center;
        /* 水平居中 */
        height: 700px;
      }
    }
  }
  .cssShowSelected {
    margin-left: 10px;
    height: 32px;
    line-height: 32px;
  }

  .pdfupload {
    margin-left: 40px;
  }

  .css-incard {
    padding: 5px;
    width: 100%;
  }

  table {
    width: 100%;
    color: #666;
    border-collapse: collapse;
    background-color: #fff;
    caption {
      font-size: 2em;
      font-weight: bold;
      margin-bottom: 0.3em;
    }
    thead tr {
      background-color: #008c8c;
      color: #fff;
    }
    tr {
      &:nth-child(odd) {
        background: rgb(255, 255, 255);
      }
      &:nth-child(even) {
        background: #f9f9f9;
      }
      &:hover {
        background-color: #edf3e4;
      }

      td {
        border: 1px solid #e5e4e4;
        text-align: left;
        padding: 10px;
        line-height: 24px;
        text-overflow: ellipsis;
        white-space: nowrap;
        border-bottom: 1px solid #d7d7d7;
        span {
          float: left;
        }
      }
    }
  }

  .pdf-dialog-view {
    .el-dialog__headerbtn {
      z-index: 3;
      top: 18px;

      .el-dialog__close {
        color: #4a9ce4;
        font-size: 22px;
      }
    }

    .el-dialog {
      margin: auto;
      bottom: 5vh;
    }

    ::v-deep {
      .el-dialog__header {
        padding: 0;
      }

      .el-dialog__body {
        padding: 0 !important;
        background-color: #004594;
        color: white;
        height: 600px;
      }
    }
  }

  .pdf-preview-arrow {
    -moz-user-select: none;
    user-select: none;
    position: absolute;
    right: 60px;
    top: 18px;
    z-index: 3;
    line-height: 30px;

    .icon-scale,
    .turn {
      line-height: 38px;

      i {
        font-size: 22px;
        font-weight: bold;
        color: #62a6ed;
        margin: 0 8px;
        cursor: pointer;
      }
    }

    .page-number {
      display: inline-block;
      width: 40px;
      margin: 0 5px;

      ::v-deep {
        .el-input__inner {
          width: 40px;
          height: 30px;
          line-height: 30px;
          background: rgba(74, 141, 240, 0.14);
          color: rgba(5, 5, 5, 0.8);
          border: 1px solid rgba(0, 126, 255, 0.6);
          padding: 0;
          text-align: center;
        }
      }
    }
  }

  .pdf-content {
    overflow: auto;
    height: 600px;
    width: 800px;
  }
  .formCss {
    //width: 100%;
    padding: 0px 30px 30px 30px;
  }

  input {
    border-bottom: 1px solid #ddd;
  }
</style>
