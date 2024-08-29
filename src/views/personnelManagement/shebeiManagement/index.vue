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
              placeholder="请输入设备名称"
              clearable
            />
          </el-form-item>
          <el-form-item>
            <el-button icon="el-icon-search" type="primary" @click="queryData">
              查询
            </el-button>
          </el-form-item>
        </el-form>
      </vab-query-form-right-panel>
    </vab-query-form>
    <el-divider content-position="center">
      <el-link type="danger">{{ PS_ID }}</el-link>
      -
      <el-link type="success">{{ PS_DanWei }}</el-link>
      工厂主要生产设备管理
    </el-divider>

    <el-table
      v-loading="listLoading"
      :data="
        list == null
          ? []
          : list.filter(
              (data) =>
                !search ||
                data.SB_Name.toLowerCase().includes(search.toLowerCase())
            )
      "
      :element-loading-text="elementLoadingText"
      @selection-change="setSelectRows"
    >
      <el-table-column show-overflow-tooltip type="selection"></el-table-column>
      <el-table-column type="index" width="50"></el-table-column>
      <el-table-column
        v-if="false"
        show-overflow-tooltip
        prop="SB_ID"
        label="ID"
      ></el-table-column>
      <el-table-column
        show-overflow-tooltip
        prop="SB_BianHao"
        label="设备编号"
      ></el-table-column>

      <el-table-column
        show-overflow-tooltip
        prop="SB_Name"
        label="设备名称"
      ></el-table-column>
      <el-table-column
        show-overflow-tooltip
        prop="SB_XingHao"
        label="型号规格"
      ></el-table-column>
      <el-table-column
        show-overflow-tooltip
        prop="SB_JingDu"
        label="生产精度"
      ></el-table-column>
      <el-table-column
        show-overflow-tooltip
        prop="SB_ShuLiang"
        label="设备数量"
      ></el-table-column>
      <el-table-column
        show-overflow-tooltip
        prop="SB_ZhuangTai"
        label="完好情况"
      ></el-table-column>

      <!-- <el-table-column show-overflow-tooltip label="权限">
        <template #default="{ row }">
          <el-tag v-for="(item, index) in row.permissions" :key="index">
            {{ item }}
          </el-tag>
        </template>
      </el-table-column> 

      <el-table-column
        show-overflow-tooltip
        prop="datatime"
        label="修改时间"
      ></el-table-column>-->
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
    <Edit
      ref="edit"
      :formData="SB_Pass_Row"
      :formID="SB_ID"
      :formPSID="SB_PS_ID"
      @fetch-data="fetchData"
    ></Edit>
  </div>
</template>

<script>
  import { getList, doDelete } from '@/api/shebeiManagement'
  import Edit from './components/shebeiManagementEdit'
  import { mapActions, mapGetters } from 'vuex'
  import * as XLSX from 'xlsx/xlsx.mjs'

  export default {
    name: 'JianceManagement',
    components: { Edit },
    data() {
      return {
        PS_DanWei: '',
        upload_file: '',
        lists: [],
        list: null,
        listLoading: true,
        layout: 'total, sizes, prev, pager, next, jumper',
        total: 0,
        selectRows: '',
        elementLoadingText: '正在加载...',
        queryForm: {
          pageNo: 1,
          pageSize: 10,
          username: '',
        },
        PS_ID: this.$store.state.detail.PS_ID,
        SB_ID: '',
        SB_PS_ID: this.$store.state.detail.PS_ID,
        SB_Type: '生产设备',
        SB_Name: '',
        SB_XingHao: '',
        SB_BianHao: '',
        SB_JingDu: '',
        SB_ShuLiang: '',
        SB_ZhuangTai: '',
        SB_Pass_Row: {},
        search: '',

        // 弹窗的标题
        title: '导入设备',
        // 提示信息
        tips: [
          '名称必填',
          '规格型号必填',
          '精度或试验能力限定范围必填',
          '数量必填',
          '完好情况必填',
        ],
        // 假如数据库中是`name`字段, 而Excel模板列是`名字`, 就需要写成 name: '名字'
        // ele-import 内部会抛弃非定义在fields里的列
        fields: {
          SB_ID: '序号',
          SB_BianHao: '设备编号',
          SB_Name: '名称',
          SB_XingHao: '规格型号',
          SB_JingDu: '精度或试验能力限定范围',
          SB_ShuLiang: '数量',
          SB_ZhuangTai: '完好情况',
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
          SB_AddTime: this.formatDate({}),
          SB_EditTIme: this.formatDate({}),
          SB_PS_ID: this.$store.state.detail.PS_ID,
          SB_Type: '生产设备',
          SB_DeleteFlag: '0',
        },
        // 参数校检, 和 element-ui 中 form表单中传递的rules一样, 都是使用的 async-validator 库
        // https://element.eleme.cn/#/zh-CN/component/form#biao-dan-yan-zheng
        rules: {
          // name: { type: 'string', required: true, message: '名字必填' },
          SB_ShuLiang: [
            { type: 'number', message: '数量必须为数字' },
            { required: true, message: '数量必须填写' },
          ],
        },
        // Excel模板下载地址
        // 注意, 只能是.xlsx的文件, .xls或者.cvs都会报错
        filepath: 'http://117.160.199.82:7777/AnBiao/Template/主要设备.xlsx',
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
      if (this.$store.state.detail.PS_ID == '') {
        //如果没有选择评审任务就返回到首页
        console.log(this.$route.path)
        this.delTabsBar(this.$route)
        //console.log(this.delTabsBar(this.$route.path))
        this.$router.push('/')
      }
      setTimeout(() => {
        this.fetchData()
      }, 300)
    },
    mounted() {
      this.elExport = document.getElementById('exportExcel')
    },
    methods: {
      ...mapActions({
        delTabsBar: 'tabsBar/delRoute',
      }),
      setSelectRows(val) {
        this.selectRows = val
      },
      handleAdd() {
        if (this.PS_ID != '') {
          this.SB_Pass_Row = {}
          this.SB_Pass_Row.SB_PS_ID = this.PS_ID
          this.SB_Pass_Row.SB_Type = '生产设备'
          this.$refs['edit'].showAdd()
        } else this.$baseMessage('请选择或新建评审任务', 'error')
      },

      handleEdit(row) {
        console.log(this)
        this.SB_Pass_Row = row
        console.log(this.SB_Pass_Row)
        this.$refs['edit'].showEdit(row)
      },
      handleDelete(row) {
        const _that = this
        if (row.SB_ID) {
          this.$baseConfirm(
            '你确定要删除当前项吗？ID：' + row.SB_ID,
            null,
            () => {
              $.ajax({
                url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=deleteDanWeiSheBei',
                type: 'post',
                dataType: 'json',
                data: JSON.stringify({ ids: row.SB_ID }),
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
            }
          )
        } else {
          if (this.selectRows.length > 0) {
            const ids = this.selectRows.map((item) => item.SB_ID).join()
            this.$baseConfirm(
              '你确定要删除选中项吗？ID：' + ids,
              null,
              async () => {
                $.ajax({
                  url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=deleteDanWeiSheBei',
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
              }
            )
          } else {
            this.$baseMessage('未选中任何行', 'error')
            return false
          }
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
      queryData() {
        this.queryForm.pageNo = 1
        this.fetchData()
      },
      fetchData() {
        this.listLoading = true
        const _that = this
        this.PS_ID = this.$store.state.detail.PS_ID
        this.PS_DanWei = this.$store.state.detail.PS_DanWei

        console.log(_that.PS_ID)
        console.log(this.PS_ID)
        if (this.PS_ID != '')
          //const { data, totalCount } = this.queryForm
          $.ajax({
            type: 'post', //请求类型
            dataType: 'json', //请求数据返回类型
            url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=getDanWeiSheBei', //请求地址
            data: JSON.stringify({ sb_type: '生产设备', ps_id: _that.PS_ID }), //表单序列化
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
              _that.$baseMessage(result, 'error')
              setTimeout(() => {
                _that.listLoading = false
              }, 300)
            },
          })
        else {
          _that.$alert('请选择或新建评审任务', '提示', {
            confirmButtonText: '确定',
            callback: (action) => {
              //_that.$baseMessage('请选择或新建评审任务', 'error')
            },
          }) //_that.showEdit = false
          setTimeout(() => {
            _that.listLoading = false
          }, 300)
        }
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
        data.map((item) => {
          //this.list.push(item)
          const _that = this
          const _form = item
          $.ajax({
            type: 'post', //请求类型
            dataType: 'json', //请求数据返回类型
            url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=editDanWeiSheBei', //请求地址
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

        console.log(data)
        console.log(this.list)
        this.fetchData()

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
