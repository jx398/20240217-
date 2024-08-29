<template>
  <div class="userManagement-container">
    <vab-query-form>
      <vab-query-form-left-panel :span="12">
        <span>
          <ele-import
            :fields="fields"
            :filepath="filepath"
            :append="append"
            :formatter="formatter"
            :requestFn="requestFn"
            :rules="rules"
            :tips="tips"
            :title="title"
            :visible.sync="visible"
            @close="handleCloseImport"
            @finish="handleFinishImport"
          />
          <el-button type="info" @click="handleOpen">导入数据</el-button>
        </span>
        <a id="exportExcel"></a>

        <el-button type="warning" @click="btnExportClick(list)">
          导出Excel
        </el-button>

        <el-button icon="el-icon-plus" type="primary" @click="handleAdd">
          添加
        </el-button>
        <el-button icon="el-icon-delete" type="danger" @click="handleDelete">
          批量删除
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
      技术人员
    </el-divider>

    <el-table
      v-loading="listLoading"
      :data="
        list == null
          ? []
          : list.filter(
              (data) =>
                !search ||
                data.RY_UserName.toLowerCase().includes(search.toLowerCase())
            )
      "
      :element-loading-text="elementLoadingText"
      @selection-change="setSelectRows"
    >
      <el-table-column show-overflow-tooltip type="selection"></el-table-column>
      <el-table-column type="index" width="50"></el-table-column>

      <el-table-column
        disabled="disable"
        show-overflow-tooltip
        prop="RY_ID"
        label="RY_ID"
      ></el-table-column>
      <el-table-column
        show-overflow-tooltip
        prop="RY_UserName"
        label="姓名"
      ></el-table-column>
      <el-table-column show-overflow-tooltip prop="RY_XingBie" label="性别">
        <template slot-scope="scope">
          <el-tag
            v-if="scope.row.RY_XingBie == '男'"
            size="small"
            type="success"
          >
            {{ scope.row.RY_XingBie }}
          </el-tag>
          <el-tag v-else type="danger" size="small">
            {{ scope.row.RY_XingBie }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column
        show-overflow-tooltip
        prop="RY_Birthday"
        label="出生年月"
      >
        <template slot-scope="scope">
          <el-popover trigger="hover" placement="top">
            <p>
              年龄:
              <span v-if="scope.row.RY_Birthday.toString()">
                {{
                  new Date().getFullYear() -
                  0 -
                  scope.row.RY_Birthday.toString().substr(0, 4)
                }}
              </span>
              岁
            </p>
            <div slot="reference">
              {{ scope.row.RY_Birthday }}
            </div>
          </el-popover>
        </template>
      </el-table-column>
      <el-table-column
        show-overflow-tooltip
        prop="RY_XueLi"
        label="学历"
      ></el-table-column>
      <el-table-column
        show-overflow-tooltip
        prop="RY_ZhuanYie"
        label="专业"
      ></el-table-column>
      <el-table-column
        show-overflow-tooltip
        prop="RY_ZhiCheng"
        label="职称"
      ></el-table-column>
      <el-table-column
        show-overflow-tooltip
        prop="RY_ZhiWu"
        label="职务"
      ></el-table-column>
      <el-table-column
        show-overflow-tooltip
        prop="RY_Phone"
        label="办公电话"
      ></el-table-column>
      <el-table-column
        show-overflow-tooltip
        prop="RY_Tel"
        label="手机号码"
      ></el-table-column>

      <el-table-column
        show-overflow-tooltip
        prop="RY_RuZhiTime"
        label="入职时间"
      ></el-table-column>
      <el-table-column
        show-overflow-tooltip
        prop="RY_CongYeTime"
        label="从业年限"
      ></el-table-column>
      <el-table-column show-overflow-tooltip label="合同签定">
        <template slot-scope="scope">
          <el-popover trigger="hover" placement="top">
            <span v-if="scope.row.RY_HeTong == '是'">
              <p>已签订劳动合同</p>
            </span>
            <span v-else>
              <p>未签订劳动合同！</p>
            </span>
            <div slot="reference">
              <span v-if="scope.row.RY_HeTong == '是'">
                <el-tag type="success" style="color: #4cc108">
                  {{ scope.row.RY_HeTong }}
                </el-tag>
              </span>
              <span v-else>
                <el-tag type="warning" size="medium" style="color: #f7220b">
                  {{ scope.row.RY_HeTong }}
                </el-tag>
              </span>
            </div>
          </el-popover>
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
          <el-button type="primary" @click="handleEdit(scope.row)">
            编辑
          </el-button>
          <el-button type="warning" @click="handleDelete(scope.row)">
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
    <userEdit
      ref="edit"
      :formData="RY_Pass_Row"
      :formID="RY_ID"
      :formPSID="PS_ID"
      @fetch-data="fetchData"
    ></userEdit>
  </div>
</template>

<script>
  import { getList, doDelete } from '@/api/userManagement'
  import userEdit from './components/UserManagementEdit'
  import { mapActions, mapGetters } from 'vuex'
  import * as XLSX from 'xlsx/xlsx.mjs'

  export default {
    name: 'UserManagement',
    components: { userEdit },
    data() {
      return {
        list: null,
        listLoading: true,
        layout: 'total, sizes, prev, pager, next, jumper',
        total: 0,
        selectRows: '',
        elementLoadingText: '正在加载...',
        queryForm: {
          PS_ID: this.$store.state.detail.PS_ID,
        },
        PS_ID: '',
        RY_ID: '',
        PS_DanWei: '',
        search: '',
        RY_Pass_Row: {},
        RY_PS_ID: '',

        // 弹窗的标题
        title: '导入设备',
        // 提示信息
        tips: [
          '姓名必填',
          '性别必填',
          '精度或试验能力限定范围必填',
          '数量必填',
          '完好情况必填',
        ],
        // 假如数据库中是`name`字段, 而Excel模板列是`名字`, 就需要写成 name: '名字'
        // ele-import 内部会抛弃非定义在fields里的列
        fields: {
          RY_Birthday: '出生年月',

          RY_CongYeTime: '从事本专业年限',

          RY_HeTong: '是否签署劳动合同',

          RY_ID: '序号',

          RY_Phone: '手机',

          RY_RuZhiTime: '进入本单位时间',

          RY_Tel: '办公电话',

          RY_UserName: '姓名',

          RY_XingBie: '性别',

          RY_XueLi: '学历',

          RY_ZhiCheng: '职称',

          RY_ZhiWu: '职务',

          RY_ZhuanYie: '专业',
        },
        // formatter起到替换数据的作用
        formatter: {
          // 可以是对象, 在发送请求时, '深圳' 将被替换成 1, '广州' 被替换成 2
          // city: {
          //   1: '深圳',
          //   2: '广州',
          // },
          // 可以是函数, 在发送请求时, `age` 将加1, 例如 原数据是 19 -> 20
          // age: function (value, row) {
          //   return value + 1
          // },
        },
        // 附加数据, 在每条记录上都会加这两个字段和值
        append: {
          RY_AddTime: this.formatDate({}),
          RY_EditTIme: this.formatDate({}),
          RY_PS_ID: this.$store.state.detail.PS_ID,
          RY_DeleteFlag: '0',
        },
        // 参数校检, 和 element-ui 中 form表单中传递的rules一样, 都是使用的 async-validator 库
        // https://element.eleme.cn/#/zh-CN/component/form#biao-dan-yan-zheng
        rules: {
          // name: { type: 'string', required: true, message: '名字必填' },
          // RY_UserName: [
          //   { type: 'number', message: '数量必须为数字' },
          //   { required: true, message: '数量必须填写' },
          // ],
        },
        // Excel模板下载地址
        // 注意, 只能是.xlsx的文件, .xls或者.cvs都会报错
        filepath: 'http://117.160.199.82:7777/AnBiao/Template/主要人员.xlsx',
        // 控制弹窗, 和dialog的visible一样
        // https://element.eleme.cn/#/zh-CN/component/dialog
        visible: false,
        elExport: '',
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
      //this.fetchData()
      if (this.$store.state.detail.PS_ID == '') {
        //如果没有选择评审任务就返回到首页
        console.log(this.$route.path)
        this.delTabsBar(this.$route)
        //console.log(this.delTabsBar(this.$route.path))
        this.$router.push('/')
      }
      this.fetchData()
    },
    mounted() {
      this.elExport = document.getElementById('exportExcel')
    },

    methods: {
      ...mapActions({
        delTabsBar: 'tabsBar/delRoute',
      }),
      handleAdd() {
        if (this.PS_ID != '') {
          this.RY_Pass_Row = {
            RY_ID: '',
            RY_PS_ID: '',
            RY_UserName: '',
            RY_XingBie: '',
            RY_Birthday: '',
            RY_XueLi: '',
            RY_ZhuanYie: '',
            RY_ZhiCheng: '',
            RY_ZhiWu: '',
            RY_Phone: '',
            RY_Tel: '',
            RY_RuZhiTime: '',
            RY_CongYeTime: '',
            RY_HeTong: '',
          }
          this.$refs['edit'].showAdd()
        } else this.$baseMessage('请选择或新建评审任务', 'error')
      },
      fetchData() {
        console.log('dddddd')
        const _that = this
        this.PS_ID = this.$store.state.detail.PS_ID
        this.PS_DanWei = this.$store.state.detail.PS_DanWei

        console.log(this.PS_ID)
        if (this.PS_ID != '') {
          $.ajax({
            type: 'post', //请求类型
            dataType: 'json', //请求数据返回类型
            url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=getDanWeiRenYuan', //请求地址
            data: JSON.stringify({ ids: _that.PS_ID }), //表单序列化
            success: function (result) {
              //成功
              const { cout, Data } = result
              _that.list = Data
            },
            error: function (result) {
              const { cout, Data } = result
              _that.list = Data
              _that.$baseMessage(result.responseText, 'error')
            },
          })
        } else {
          _that.$baseMessage('请选择或新建评审任务', 'error')
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
      handleDelete(row) {
        const _that = this
        if (row.RY_ID) {
          this.$baseConfirm('你确定要删除当前项吗' + row.RY_ID, null, () => {
            $.ajax({
              url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=deleteDanWeiRenYuan',
              type: 'post',
              dataType: 'json',
              data: JSON.stringify({ ids: row.RY_ID }),
              success: function (result) {
                //成功
                console.log('result.status')
                console.log(result)
                console.log(result.status)
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
          })
        } else {
          if (this.selectRows.length > 0) {
            const ids = this.selectRows.map((item) => item.RY_ID).join()
            this.$baseConfirm('你确定要删除选中项吗', null, async () => {
              $.ajax({
                url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=deleteDanWeiRenYuan',
                type: 'post',
                dataType: 'json',
                data: JSON.stringify({ ids: ids }),
                success: function (result) {
                  //成功
                  console.log('result.status')
                  console.log(result)
                  console.log(result.status)
                },
                error: function (result) {
                  //失败
                  console.log(result.status)
                  if (result.status == 200) {
                    _that.$baseMessage(result.responseText, 'success')
                    _that.fetchData()

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
      handleSizeChange(val) {
        this.fetchData()
      },
      handleCurrentChange(val) {
        this.fetchData()
      },
      queryData() {
        this.fetchData()
      },

      submit_form() {
        // 给后端发送请求，更新数据

        console.log('假装给后端发了个请求...')
      },
      readExcel(e) {
        // 读取表格文件
        let that = this
        const files = e.target.files
        const rawFile = files[0] // only use files[0]

        if (files.length <= 0) {
          return false
        } else if (!/\.(xls|xlsx)$/.test(files[0].name.toLowerCase())) {
          this.$message({
            message: '上传格式不正确，请上传xls或者xlsx格式',
            type: 'warning',
          })
          return false
        } else {
          // 更新获取文件名
          that.upload_file = files[0].name
          return new Promise((resolve, reject) => {
            const reader = new FileReader()
            reader.onload = (e) => {
              const data = e.target.result
              const workbook = XLSX.read(data, { type: 'array' })
              const firstSheetName = workbook.SheetNames[0]
              const worksheet = workbook.Sheets[firstSheetName]
              const header = 'this.getHeaderRow(worksheet)'
              const results = XLSX.utils.sheet_to_json(worksheet)
              this.generateData({ header, results })
              this.loading = false
              resolve()
            }

            reader.readAsArrayBuffer(rawFile)
          })
        }
      },
      generateData({ header, results }) {
        console.log(header)
        console.log(results)
      },
      // requestFn函数会被注入请求的数据
      // 需要返回一个Promise对象
      async requestFn(data) {
        //this.tableData = JSON.stringify(data)
        console.log('this.list')
        console.log(this.list)
        console.log('data')
        console.log(data)
        data.map((item) => {
          //this.list.push(item)
          const _that = this
          const _form = item
          $.ajax({
            type: 'post', //请求类型
            dataType: 'json', //请求数据返回类型
            url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=editDanWeiRenYuan', //请求地址
            data: JSON.stringify(_form),
            //表单序列化
            success: function (result) {
              console.log(result)
              //_that.close()
            },
            error: function (result) {
              //失败
              if (result.status == 200) {
                _that.$baseMessage(result.responseText, 'success')
                _that.$emit('fetch-data')
              } else {
                _that.$baseMessage(result.responseText, 'error')
              }
              //_that.close()
            },
          })
        })

        // 演示代码
        // 1、如果没有针对ele-import做过接口约定, 可以采用如下形式:
        // try {
        //   const res = await axios.post('/user', data)
        //   return Promise.resolve()
        // } catch (error) {
        //   // error经过一系列转化, 转为
        //   const errorData = this.getErrorMessage(error)
        //   {0:{ age: '年龄为数字', city: '城市必填'}, 2:{ age: '年龄为数字'} } // 0 和 2 分别是行号
        //   return Promise.reject(errorData)
        // }
        // 2、如果针对ele-import做过接口约定, 当校检错误时, 后端返回的 error 就是上述错误形式, 则可直接
        // return axios.post('/user', data)
        // 总结: 无论如何总要返回一个Promise对象
      },
      handleCloseImport() {
        console.log('弹窗关闭了~')
        this.fetchData()
      },
      handleFinishImport() {
        console.log('导入完毕了~')
      },
      handleOpen() {
        this.visible = true
      },
      formatDate(
        { date = new Date(), fmt = 'yyyyMMddhhmmss' } = {
          date: new Date(),
          fmt: 'yyyy-MM-dd',
        }
      ) {
        if (!(date instanceof Array)) {
          date = new Date(date)
        }
        if (/(y+)/.test(fmt)) {
          fmt = fmt.replace(
            RegExp.$1,
            (date.getFullYear() + '').substr(4 - RegExp.$1.length)
          )
        }
        const o = {
          'M+': date.getMonth() + 1,
          'd+': date.getDate(),
          'h+': date.getHours(),
          'm+': date.getMinutes(),
          's+': date.getSeconds(),
        }
        for (const k in o) {
          if (new RegExp(`(${k})`).test(fmt)) {
            const str = o[k] + ''
            fmt = fmt.replace(
              RegExp.$1,
              RegExp.$1.length === 1 ? str : this.padLeftZero(str)
            )
          }
        }
        return fmt
      },
      padLeftZero(str) {
        return ('00' + str).substr(str.length)
      },

      formatMonthDay(time) {
        return formatDate(time, 'MM月dd日')
      },

      formatMinuteSecond(time) {
        return formatDate(time, 'mm:ss')
      },

      //点击导出按钮
      btnExportClick(rs) {
        //生成列名
        let data = [{}]
        for (let k in rs[0]) {
          data[0][k] = k
        }
        data = data.concat(rs)
        console.table(data)

        this.exportExcel(data, this.SB_PS_ID + '' + this.SB_Type + '导出数据')
      },
      //导出 Excel
      exportExcel(json, downName, type) {
        //获取列名
        let keyMap = []
        for (let k in json[0]) {
          keyMap.push(k)
        }

        //用来保存转换好的json
        let tmpdata = []
        json
          .map((v, i) =>
            keyMap.map((k, j) =>
              Object.assign(
                {},
                {
                  v: v[k],
                  position:
                    (j > 25
                      ? this.getCharCol(j)
                      : String.fromCharCode(65 + j)) +
                    (i + 1),
                }
              )
            )
          )
          .reduce((prev, next) => prev.concat(next))
          .forEach(function (v) {
            tmpdata[v.position] = {
              v: v.v,
            }
          })

        let outputPos = Object.keys(tmpdata) //设置区域，比如表格从A1到D10
        let tmpWB = {
          SheetNames: ['mySheet'], // 保存的表标题
          Sheets: {
            mySheet: Object.assign(
              {},
              tmpdata, //内容
              {
                '!ref': outputPos[0] + ':' + outputPos[outputPos.length - 1], //设置填充区域
              }
            ),
          },
        }

        //创建二进制对象写入转换好的字节流
        let tmpDown = new Blob(
          [
            this.s2ab(
              XLSX.write(
                tmpWB,
                {
                  bookType: type === undefined ? 'xlsx' : type,
                  bookSST: false,
                  type: 'binary',
                } //这里的数据是用来定义导出的格式类型
              )
            ),
          ],
          {
            type: '',
          }
        )

        this.elExport.download = downName + '.xlsx' //下载名称
        this.elExport.href = URL.createObjectURL(tmpDown) //绑定a标签到新创建对象超链接
        this.elExport.click() //模拟点击实现下载

        //释放，用 URL.revokeObjectURL() 释放
        setTimeout(() => URL.revokeObjectURL(tmpDown), 100)
      },
      //字符串转字符流
      s2ab(s) {
        var buf = new ArrayBuffer(s.length)
        var view = new Uint8Array(buf)
        for (var i = 0; i !== s.length; ++i) {
          view[i] = s.charCodeAt(i) & 0xff
        }
        return buf
      },
      //将指定的自然数转换为26进制表示。映射关系：[0-25] -> [A-Z]。
      getCharCol(n) {
        let s = ''
        let m = 0
        while (n > 0) {
          m = (n % 26) + 1
          s = String.fromCharCode(m + 64) + s
          n = (n - m) / 26
        }
        return s
      },
      // 文件流转 BinaryString
      fixdata(data) {
        var o = ''
        var l = 0
        var w = 10240
        for (; l < data.byteLength / w; ++l) {
          o += String.fromCharCode.apply(
            null,
            new Uint8Array(data.slice(l * w, l * w + w))
          )
        }
        o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w)))
        return o
      },
    },
  }
</script>
