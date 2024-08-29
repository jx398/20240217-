<template>
  <div>
    <div class="small-components-container">
      <el-row :gutter="20">
        <el-col :xs="24" :md="12">
          <el-card shadow="hover">
            <div slot="header">
              <span>评审任务简介</span>
            </div>
            <div class="css-incard">
              <table class="table">
                <tr>
                  <td>评审任务书编号：</td>
                  <td>
                    <span v-if="!showEdit">{{ PS_ID }}</span>
                    <el-input v-if="showEdit" v-model="PS_ID"></el-input>
                  </td>
                </tr>
                <tr>
                  <td>评审类型：</td>
                  <td>
                    <el-checkbox-group v-model="PS_Type" :disabled="!showEdit">
                      <el-checkbox label="申办评审"></el-checkbox>
                      <el-checkbox label="监督评审"></el-checkbox>
                    </el-checkbox-group>
                  </td>
                </tr>
                <tr>
                  <td>申请人/持证人名称：</td>
                  <td>
                    <span v-if="!showEdit">{{ PS_DanWei }}</span>
                    <el-input v-if="showEdit" v-model="PS_DanWei"></el-input>
                  </td>
                </tr>
                <tr>
                  <td>评审人员：</td>
                  <td>
                    <span v-if="!showEdit">{{ PS_RenYuan }}</span>
                    <el-input v-if="showEdit" v-model="PS_RenYuan"></el-input>
                  </td>
                </tr>
                <tr>
                  <td>OEM：</td>
                  <td>
                    <el-radio-group v-model="OEM" :disabled="!showEdit">
                      <el-radio label="是"></el-radio>
                      <el-radio label="否"></el-radio>
                    </el-radio-group>
                  </td>
                </tr>
                <tr v-if="showEdit">
                  <td>日期选择</td>
                  <td>
                    <el-date-picker
                      v-model="value2"
                      type="datetimerange"
                      :picker-options="pickerOptions"
                      range-separator="至"
                      start-placeholder="开始日期"
                      end-placeholder="结束日期"
                      placeholder="选择开始日期"
                      format="yyyy年MM月dd日HH时mm分"
                      value-format="yyyy年MM月dd日HH时mm分"
                      :default-time="['8:30:00', '12:00:00']"
                      @change="dataChange"
                    ></el-date-picker>
                  </td>
                </tr>
                <tr>
                  <td>评审开始时间：</td>
                  <td>
                    <span>{{ PS_RiQiStart }}</span>
                  </td>
                </tr>
                <tr>
                  <td>评审结束时间：</td>
                  <td>
                    <span>{{ PS_RiQiEnd }}</span>
                  </td>
                </tr>
                <tr>
                  <td>企业简介</td>
                  <td>
                    <!-- eslint-disable vue/no-v-html -->

                    <span
                      v-if="!showEdit"
                      class="jianjieSpan"
                      v-html="PS_DanWeiJianJie"
                    ></span>
                    <!--eslint-enable-->

                    <vab-quill
                      v-if="showEdit"
                      v-model="PS_DanWeiJianJie"
                      :options="options"
                    ></vab-quill>
                  </td>
                </tr>
                <tr>
                  <td></td>
                  <td
                    colspan="3"
                    style="background-color: white; border-bottom: 0px"
                  >
                    <el-button
                      v-if="!showEdit"
                      type="success"
                      @click="showUpdate()"
                    >
                      修改
                    </el-button>
                    <el-button v-if="showEdit" type="success" @click="submit()">
                      确定
                    </el-button>
                    <el-button
                      v-if="showEdit"
                      type="success"
                      @click="cancelUpdate()"
                    >
                      取消
                    </el-button>
                  </td>
                </tr>
              </table>
            </div>

            <!-- <vab-snow></vab-snow> -->
          </el-card>
        </el-col>
        <el-col :xs="24" :md="12">
          <el-card shadow="hover">
            <div slot="header">
              <span>评审任务书</span>
              <vab-upload
                ref="vabUpload"
                url="/upload"
                filefenlei="PS_RenWuShu"
                accept=".pdf"
                name="file"
                :limit="1"
                :size="200"
              ></vab-upload>
              <el-button
                class="pdfupload"
                @click="
                  handleShow({
                    key: 'value',
                    PS_ID: PS_ID,
                    fileFenlei: 'PS_RenWuShu',
                  })
                "
                @changePS_RenWuShu="changePS_RenWuShu_top"
              >
                上传
                <i class="el-icon-upload el-icon--right"></i>
              </el-button>
            </div>

            <template slot-scope="scope">
              <div>
                <div class="pdf-preview-arrow fx-row" :style="scope">
                  <span class="icon-scale">
                    <span @click="scaleD">
                      <i class="el-icon-zoom-in"></i>
                    </span>
                    <span @click="scaleX">
                      <i class="el-icon-zoom-out"></i>
                    </span>
                  </span>
                  <span class="fx-row ml10">
                    <span
                      class="turn"
                      :class="{ grey: currentPage === 1 }"
                      @click="changePdfPage(0)"
                    >
                      <i class="el-icon-caret-left"></i>
                    </span>
                    <span>
                      <el-input
                        v-model="pageNumber"
                        class="page-number"
                        @input="pageChange"
                      ></el-input>
                    </span>
                    <span
                      class="turn"
                      :class="{ grey: currentPage === pageCount }"
                      @click="changePdfPage(1)"
                    >
                      <i class="el-icon-caret-right"></i>
                    </span>
                    <span>{{ currentPage }} / {{ pageCount }}</span>
                  </span>
                </div>
                <div class="pdf-content">
                  <pdf
                    ref="pdfWrapper"
                    :src="PS_RenWuShu"
                    :page="currentPage"
                    @num-pages="pageCount = $event"
                    @page-loaded="currentPage = $event"
                    @loaded="loadPdfHandler"
                  ></pdf>
                </div>
              </div>
            </template>
          </el-card>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
  //import VabSnow from '@/components/VabSnow'000
  //import VabProfile from '@/components/VabProfile'
  import { mapActions, mapGetters } from 'vuex'
  import { getList, doDelete, doEdit } from '@/api/taskManagement'
  import pdf from 'vue-pdf'

  import VabUpload from '@/components/VabUpload'
  import { getTreeList } from '@/api/tree'
  import vabQuill from '@/plugins/vabQuill'

  export default {
    name: 'TaskManagement',
    components: {
      //VabSnow,
      //VabProfile,
      //Edit,
      VabUpload,
      vabQuill,
      pdf,
    },
    data() {
      return {
        options: {
          theme: 'snow',
          bounds: document.body,
          debug: 'warn',
          modules: {
            toolbar: [
              ['bold', 'italic', 'underline', 'strike'],
              [{ header: [1, 2, 3, 4, 5, 6, false] }],
              [{ size: ['small', false, 'large', 'huge'] }],
              [{ color: [] }, { background: [] }],
              ['blockquote', 'code-block'],
              [{ list: 'ordered' }, { list: 'bullet' }],
              [{ script: 'sub' }, { script: 'super' }],
              [{ indent: '-1' }, { indent: '+1' }],
              [{ align: [] }],
              [{ direction: 'rtl' }],
              [{ font: [] }],
              ['clean'],
              ['link', 'image'],
            ],
          },
          placeholder: '内容...',
          readOnly: false,
        },
        pickerOptions: {
          shortcuts: [
            {
              text: '最近一周',
              onClick(picker) {
                const end = new Date()
                const start = new Date()
                start.setTime(start.getTime() - 3600 * 1000 * 24 * 7)
                picker.$emit('pick', [start, end])
                this.PS_RiQiStart = start
                this.PS_RiQiEnd = end
              },
            },
            {
              text: '最近一个月',
              onClick(picker) {
                const end = new Date()
                const start = new Date()
                start.setTime(start.getTime() - 3600 * 1000 * 24 * 30)
                picker.$emit('pick', [start, end])
                this.PS_RiQiStart = start
                this.PS_RiQiEnd = end
              },
            },
            {
              text: '最近三个月',
              onClick(picker) {
                const end = new Date()
                const start = new Date()
                start.setTime(start.getTime() - 3600 * 1000 * 24 * 90)
                picker.$emit('pick', [start, end])
                this.PS_RiQiStart = start
                this.PS_RiQiEnd = end
              },
            },
          ],
        },
        value1: [
          new Date(2000, 10, 10, 10, 10),
          new Date(2000, 10, 11, 10, 10),
        ],

        // 开始时间限制范围
        startNoTime: {
          disabledDate(date) {
            // 可选当天以及当天之前的日期
            return date.getTime() > Date.now()
          },
        },
        PS_Type: [], //评审类型
        // 结束时间限制范围
        endNoTime: {},

        /* 单选树-多选树---------结束 */
        viewVisible: true,
        src: '',
        currentPage: 0,
        pageCount: 0,
        pageNumber: 1,
        scale: 1, //放大系数
        showEdit: false,
        startTime: '',
        // 获取公共目录路径
        publicPath: process.env.BASE_URL,
        endTime: '',
        //pdfSrc: 'http://117.160.199.82:7777/11.pdf',
        pageNum: 1,
        pageTotalNum: 1, //# 总页数
        loadedRatio: 0, //# 当前页面的加载进度，范围是0-1 ，等于1的时候代表当前页已经完全加载完成了
        //评审任务相关信息
        PS_ID: '', //评审ID编号，唯一性标识
        PS_DanWei: '', //评审单位名称
        PS_RenYuan: '', //评审组成员
        PS_RiQiStart: '', //评审开始时间
        PS_RiQiEnd: '', //评审结束时间
        value2: '',
        PS_DanWeiJianJie: '',
        PS_RenWuShu: '', //评审任务书pdf文件

        OEM: '否',
        profileShow: true,
        faultTextShow: true,
        solidTextShow: true,
        startVal: 0,
        endVal: 20,
        timeInterval: null,
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
      }
    },
    computed() {
      this.value2 = [this.PS_RiQiStart, this.PS_RiQiEnd]
    },
    watch: {
      filterText(val) {
        this.$refs.demoTree.filter(val)
      },
      '$store.state.detail.PS_RenWuShu'() {
        console.log('this.pdfSrc')
        console.log(this.$store.state)
        this.pdfSrc = this.$store.state.PS_RenWuShu
        this.PS_RenWuShu = this.$store.state.PS_RenWuShu
        console.log(this.pdfSrc)
      },
      '$store.state.detail.PS_ID'() {
        this.pdfSrc = this.$store.state.PS_RenWuShu
        this.PS_RenWuShu = this.$store.state.PS_RenWuShu
        this.fetchStore()
      },
    },
    mounted() {
      this.$nextTick(() => {
        //this.getTreeListFuc(1)
        //this.setCheckedKeys()
        // 初始化单选树
        // 初始化多选树
      })

      this.handleProfile()
      this.handleSolidText()
      this.timeInterval = setInterval(() => {
        if (this.endVal < 100) {
          this.startVal = this.endVal
          this.endVal++
        }
      }, 5000)
      if (this.$store.state.detail.PS_ID == '') {
        //如果没有选择评审任务就返回到首页
        console.log(this.$route.path)
        this.delTabsBar(this.$route)
        //console.log(this.delTabsBar(this.$route.path))
        this.$router.push('/')
      }
    },

    beforeDestroy() {
      if (this.clearInterval) {
        clearInterval(this.timeInterval)
      }
    },
    created() {
      this.fetchStore()
    },

    methods: {
      dataChange() {
        console.log('this.PS_RiQiEnd')
        console.log(this.value2)
        this.PS_RiQiStart = this.value2[0]
        this.PS_RiQiEnd = this.value2[1]
        console.log(this.PS_RiQiStart)
        console.log(this.PS_RiQiEnd)
      },
      ...mapActions({
        delTabsBar: 'tabsBar/delRoute',
      }),
      fetchStore() {
        const _that = this
        this.PS_ID = this.$store.state.detail.PS_ID
        console.log(this.PS_ID)
        if (this.PS_ID != '') {
          $.ajax({
            type: 'post', //请求类型
            dataType: 'json', //请求数据返回类型
            url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=getRenwu', //请求地址
            data: JSON.stringify({ PS_ID: _that.PS_ID }), //表单序列化
            success: function (result) {
              //成功
              console.log('result')
              console.log(result)
              var re = /\|/gi

              let jianjie = result.Data[0].PS_DanWeiJianJie.replace(re, '"')
              console.log(result.Data[0])
              console.log(result.Data[0].PS_ID)
              _that.PS_ID = result.Data[0].PS_ID
              _that.PS_DanWei = result.Data[0].PS_DanWei
              _that.PS_RenYuan = result.Data[0].PS_RenYuan
              _that.PS_RiQiStart = result.Data[0].PS_RiQiStart
              _that.PS_RiQiEnd = result.Data[0].PS_RiQiEnd
              _that.PS_DanWeiJianJie = jianjie
              _that.PS_RenWuShu = result.Data[0].PS_RenWuShu
              _that.src = result.Data[0].PS_RenWuShu
              _that.value2 = [_that.PS_RiQiStart, _that.PS_RiQiEnd]
              _that.PS_Type = result.Data[0].PS_Type.split(',')

              console.log('_that.PS_RenWuShu')
              console.log(_that.PS_RenWuShu)
              // console.log(result.Data[0])
              _that.$baseMessage('任务管理信息载入完成', 'success')
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
          console.log(_that.$route.path)

          //_that.$router.push('/')
        }
        setTimeout(() => {
          _that.listLoading = false
        }, 300)
      },
      changePS_RenWuShu_top(params) {
        this.PS_RenWuShu = params
      },
      handleShow(data) {
        let _temp = this.$refs['vabUpload'].handleShow(data)
        console.log('_temp')
        console.log(_temp)
      },
      //PDF预览
      previewPDF() {
        this.PS_RenWuShu = pdf.createLoadingTask(this.PS_RenWuShu)
        this.viewVisible = true
      },

      //关闭窗口初始化PDF页码
      closeDialog() {
        this.viewVisible = false
        this.PS_RenWuShu = ''
      },

      loadPdfHandler() {
        // 加载的时候先加载第一页
        this.currentPage = 1
        this.pageNumber = 1
      },
      changePdfPage(val) {
        if (val === 0 && this.currentPage > 1) {
          this.currentPage--
          this.pageNumber = this.currentPage
        }
        if (val === 1 && this.currentPage < this.pageCount) {
          this.currentPage++
          this.pageNumber = this.currentPage
        }
      },
      //跳转页面
      pageChange() {
        if (
          Number(this.pageNumber) > 0 &&
          Number(this.pageNumber) <= this.pageCount
        ) {
          this.currentPage = Number(this.pageNumber)
        } else {
          this.currentPage = 1
          this.pageNumber = 1
        }
      },
      //放大
      scaleD() {
        this.scale += 0.1
        this.$refs.pdfWrapper.$el.style.transform = 'scale(' + this.scale + ')'
        this.$refs.pdfWrapper.$el.style.transformOrigin = 'top center'
      },

      //缩小
      scaleX() {
        if (this.scale === 1) {
          return
        }
        this.scale += -0.1
        this.$refs.pdfWrapper.$el.style.transform = 'scale(' + this.scale + ')'
      },
      // 上一页
      prePage() {
        let page = this.pageNum
        page = page > 1 ? page - 1 : this.pageTotalNum
        this.pageNum = page
      },

      // 下一页
      nextPage() {
        let page = this.pageNum
        page = page < this.pageTotalNum ? page + 1 : 1
        this.pageNum = page
      },
      //点击修改
      showUpdate() {
        console.log('edit')
        this.showEdit = true
      },
      //取消修改
      cancelUpdate() {
        this.showEdit = false
        this.$baseMessage('已取消删除', 'info')
      },
      //取消修改
      alertSucess() {
        this.showEdit = false
        this.$baseMessage('已成功删除', 'success')
      },
      //提交修改
      submit() {
        const _that = this
        let data = {}
        var re = /"/gi

        let jianjie = this.PS_DanWeiJianJie.replace(re, '|')
        ;(data['PS_ID'] = this.PS_ID), //评审ID编号，唯一性标识
          (data['PS_DanWei'] = this.PS_DanWei), //评审ID编号，唯一性标识
          (data['PS_RenYuan'] = this.PS_RenYuan), //评审ID编号，唯一性标识
          (data['PS_RiQiStart'] = this.PS_RiQiStart), //评审ID编号，唯一性标识
          (data['PS_RiQiEnd'] = this.PS_RiQiEnd), //评审ID编号，唯一性标识
          (data['PS_DanWeiJianJie'] = jianjie), //评审ID编号，唯一性标识
          (data['PS_Type'] = this.PS_Type.join(','))
        console.log('this.PS_Type')
        console.log(this.PS_Type)
        $.ajax({
          type: 'post', //请求类型
          dataType: 'json', //请求数据返回类型
          url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=edit', //请求地址
          data: JSON.stringify(data), //表单序列化
          success: function (result) {
            //成功
            console.log(result)
            console.log(result.status)
            if (result.status == 200) {
              console.log(result)
              console.log('成功')
            } else {
              console.log(result)
              console.log('失败')
            }
            _that.showEdit = false
          },
          error: function (result) {
            //失败
            if (result.status == 200) {
              _that.$baseMessage(result.responseText, 'success')
              // _that.showEdit = false
            } else {
              _that.$baseMessage(result.responseText, 'error')
            }
            _that.showEdit = false
          },
        })
      },
      handleProfile() {
        this.profileShow = false
        setTimeout(() => {
          this.profileShow = true
        })
      },
      handleSolidText() {
        this.solidTextShow = false
        setTimeout(() => {
          this.solidTextShow = true
        })
      },
      setSelectRows(val) {
        this.selectRows = val
      },
      handleEdit(row) {
        if (row.id) {
          this.$refs['edit'].showEdit(row)
        } else {
          this.$refs['edit'].showEdit()
        }
      },
      handleDelete(row) {
        if (row.id) {
          this.$baseConfirm('你确定要删除当前项吗', null, async () => {
            const { msg } = await doDelete({
              ids: row.id,
            })
            this.$baseMessage(msg, 'success')
            this.fetchData()
          })
        } else {
          if (this.selectRows.length > 0) {
            const ids = this.selectRows.map((item) => item.id).join()
            this.$baseConfirm('你确定要删除选中项吗', null, async () => {
              const { msg } = await doDelete({
                ids,
              })
              this.$baseMessage(msg, 'success')
              this.fetchData()
            })
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
      async fetchData() {
        this.listLoading = true
        const { data, totalCount } = await getList(this.queryForm)
        this.list = data
        this.total = totalCount
        setTimeout(() => {
          this.listLoading = false
        }, 300)
      },
      //树形组件全选与反选
      checkedAll() {
        console.log('all checked')

        if (this.checked) {
          console.log('all checked')
          //全选
          this.$refs.demoTree.setCheckedNodes(this.$refs.demoTree)
        } else {
          console.log('all unchecked')
          //取消选中
          // this.$refs.demoTree.setCheckedKeys([])
        }
      },
      // 树level小于n级展开方法
      openTree(treeData, n) {
        const each = (data) => {
          data.forEach((e) => {
            if (e.rank <= n) {
              this.defaultExpendedKeys.push(e.id)
            }
            if (e.children.length > 0) {
              each(e.children)
            }
          })
        }

        each(treeData)
      },
      // 获取tree数据
      async getTreeListFuc(flag) {
        const { data } = await getTreeList()
        this.data2 = data
        if (flag) {
          this.openTree(this.data2, 2)
        }
      },
      // 节点过滤操作
      filterNode(value, data) {
        if (!value) return true
        return data.name.indexOf(value) !== -1
      },

      async loadNode(node, resolve) {
        if (node.level === 0) {
          const { data } = await getTreeList()
          this.loading = false
          return resolve(data)
        } else {
          const { data } = await getTreeList()
          return resolve(res.data)
        }
      },

      /* 单选/多选树方法-------------------开始 */
      // 初始化单选树的值

      // 清除单选树选中

      /* 清空选中样式 */
      clearSelected() {
        const allNode = document.querySelectorAll(
          '#singleSelectTree .el-tree-node'
        )
        allNode.forEach((element) => element.classList.remove('is-current'))
      },
      // select多选时移除某项操作
      removeSelectTreeTag(val) {
        const stack = JSON.parse(JSON.stringify(this.selectTreeData))
        while (stack.length) {
          const curr = stack.shift()
          if (curr.name == val) {
            return this.$refs.multipleSelectTree.setChecked(curr.id, false)
          }
          if (curr.children && curr.children.length) {
            stack.unshift(...curr.children)
          }
        }
      },
      changeMultipleSelectTreeHandle(val) {},
      // 点击叶子节点
      selectTreeNodeClick(data, node, el) {
        if (data.rank >= this.selectLevel) {
          this.singleSelectTreeVal = data.name
          this.singleSelectTreeKey = data.id
          this.$refs.singleTree.blur()
        }
      },
      // 节点选中操作
      multipleSelectTreeCheckNode(data, node, el) {
        const checkedNodes = this.$refs.multipleSelectTree.getCheckedNodes()
        const keyArr = []
        const valueArr = []
        checkedNodes.forEach((item) => {
          if (item.rank >= this.selectLevel) {
            keyArr.push(item.id)
            valueArr.push(item.name)
          }
        })
        this.multipleSelectTreeVal = valueArr
        this.multipleSelectTreeKey = keyArr.join(',')
      },
      /* 单选/多选树方法-------------------结束 */
    },
  }
</script>

<style lang="scss" scoped>
  .small-components-container {
    ::v-deep {
      .el-card__body {
        display: block;
        align-items: flex-start;
        /* 垂直居中 */
        justify-content: center;
        /* 水平居中 */
      }
    }
  }
  .pdfupload {
    margin-left: 40px;
  }
  .css-incard {
    padding: 5px;
    width: 100%;
  }

  .table {
    width: 100%;
    color: #666;
    border-collapse: collapse;
    background-color: #fff;

    td {
      position: relative;
      padding: 9px 15px;
      overflow: hidden;
      font-size: 14px;
      line-height: 20px;
      text-overflow: ellipsis;
      white-space: nowrap;
      border-bottom: 1px solid #d7d7d7;

      &:nth-child(odd) {
        width: 10%;
        text-align: right;
        background-color: #e7e7e776;
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
  .pdf-preview-arrow .fx-row span {
    display: block;
    float: left;
  }
  .ql-container .ql-snow {
    min-height: 200px !important;
  }
  .jianjieSpan {
    width: 100% !important;
    float: left !important;
    overflow: hidden !important;
    text-overflow: ellipsis !important;
    white-space: normal !important;
  }
  .icon-scale span {
    display: none;
  }
  table {
    overflow: auto;
    display: block;
    margin-right: auto;
    margin-left: auto;
  }
  tr {
    border-bottom: 1px solid #ddd;
  }
  td {
    white-space: nowrap;
  }
  input {
    border-bottom: 1px solid #ddd;
  }
  .el-form-item--small.el-form-item {
    padding: 0px;
  }
  .el-form-item {
    border-bottom: 1px solid #f2f2f2;
  }
  .el-input__inner,
  .el-input {
    border: 0px;
    width: 50% !important;
  }
  .el-range-input {
    width: 120px !important;
  }
</style>
