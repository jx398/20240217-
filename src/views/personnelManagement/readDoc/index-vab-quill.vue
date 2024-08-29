<template>
  <div class="userManagement-container">
    <vab-query-form>
      <vab-query-form-left-panel :span="12">
        <el-button
          class="pdfupload"
          @click="
            handleShow({
              key: 'value',
              PS_ID: PS_ID,
              fileFenlei: PIC_Type,
            })
          "
        >
          上传
          <i class="el-icon-upload el-icon--right"></i>
        </el-button>

        <el-tag type="danger" size="medium" effect="plain">
          <el-checkbox
            v-model="checkAll"
            :indeterminate="isIndeterminate"
            @change="handleCheckAllChange"
          >
            全选
          </el-checkbox>
        </el-tag>
        <el-button @click="PIC_deleteAll">批量删除</el-button>

        <vab-upload
          ref="vabUpload"
          url="/upload"
          :filefenlei="PIC_Type"
          accept="application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/msword"
          name="file"
          :limit="1"
          :size="20"
          @changePS_Pics="changePS_Pics"
        ></vab-upload>
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
      -
      <el-link type="info">{{ PIC_Type }}</el-link>
      照片
    </el-divider>
    <el-tag v-if="message_show">
      {{ message }}
    </el-tag>
    <el-checkbox-group v-model="checkList" @change="handleCheckedCitiesChange">
      <draggable v-model="picsData" @start="drag = true" @end="onDragEnd">
        <div
          v-for="(object, index) in picsData == null
            ? []
            : picsData.filter(
                (data) =>
                  !search ||
                  data.PIC_Name.toLowerCase().includes(search.toLowerCase())
              )"
          :key="object.PIC_ID"
          :span="spanCount"
          :offset="1"
          :class="[index == selectIndex ? 'rolesOut' : 'rolesIn']"
          style="display: inline; float: left"
        >
          <el-card
            :body-style="{ padding: '0px' }"
            shadow="always"
            :style="stylepanduan(object.PIC_Url)"
          >
            <template v-if="mp3panduan(object.PIC_Url)">
              <span>
                {{ object.PIC_Name }}
              </span>
              <div style="height: 100%">
                <mini-audio :audio-source="object.PIC_Url"></mini-audio>
              </div>
            </template>
            <template v-else-if="pdfpanduan(object.PIC_Url)">
              <div @click="handleAdd(object.PIC_Url)">
                <pdfView
                  ref="pdfView"
                  :pdfPath="object.PIC_Url"
                  :pdfHeight="400"
                  :pdfWidth="310"
                />
              </div>
            </template>
            <template v-else-if="docxpanduan(object.PIC_Url)">
              <vab-quill
                ref="vabQuil"
                v-model="vabquill"
                content-type="html"
                :options="options"
              ></vab-quill>
            </template>

            <template v-else>
              <el-image
                v-if="picView"
                class="image"
                :src="object.PIC_Url"
                :preview-src-list="allPics(object.PIC_Url)"
              ></el-image>
            </template>

            <div style="padding: 14px">
              <el-input
                v-if="showEdit"
                ref="picsArray"
                v-model="object.PIC_Name"
              ></el-input>
              <div
                v-if="!showEdit"
                style="
                  border-bottom: 1px silver solid;
                  height: 30px;
                  line-height: 15px;
                "
              >
                <el-link :href="object.PIC_Url" target="_blank">
                  {{ object.PIC_Name }}
                </el-link>
              </div>
              <div class="bottom clearfix">
                <el-checkbox :label="index - 0 > 9 ? index : '0' + index" />

                <el-button
                  v-if="!showEdit"
                  type="text"
                  class="button"
                  @click="PIC_delete(object.PIC_Url)"
                >
                  删除
                </el-button>

                <el-button
                  v-if="!showEdit"
                  type="text"
                  class="button"
                  @click="PIC_Edit(index, object)"
                >
                  重命名
                </el-button>

                <el-button
                  v-if="showEdit"
                  type="text"
                  class="button"
                  @click="PIC_Rename(index, object)"
                >
                  确定
                </el-button>
                <el-button
                  v-if="showEdit"
                  type="text"
                  class="button"
                  @click="cancelUpdate()"
                >
                  取消
                </el-button>
              </div>
            </div>
          </el-card>
        </div>
      </draggable>
    </el-checkbox-group>
    <mypdfView ref="edit" :formData="passPdf"></mypdfView>
  </div>
</template>

<script>
  import { getList, doDelete } from '@/api/userManagement'
  import { getTreeList } from '@/api/tree'
  import vabQuill from '@/plugins/vabQuill'
  import mammoth from 'mammoth'
  //import VueOfficePdf from '@vue-office/pdf'
  import pdfView from 'lz-pdf-merage'
  import mypdfView from './components/mypdfView'
  import draggable from 'vuedraggable'

  const axios = require('axios').default
  import VabUpload from '@/components/VabUploadImage'
  import { mapActions, mapGetters } from 'vuex'
  export default {
    name: 'UserManagement',
    components: {
      //VabSnow,
      //VabProfile,
      //Edit,
      vabQuill,
      VabUpload,
      mypdfView,
      pdfView,
      draggable,

      //VueOfficePdf,
    },
    data() {
      return {
        PS_DanWei: '',
        currentDate: new Date(),
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
        PS_ID: this.$store.state.detail.PS_ID,
        buhegeBaoGaoFile: '',
        picView: true,
        PIC_Type: this.$route.name,
        picsData: [],
        message_show: false,
        message: '',
        showEdit: false,
        className: 'rolesIn',
        selectIndex: -1,
        checkList: [],
        checkAll: false,
        isIndeterminate: true,
        picOptions: [],
        picTemp: [],
        showMp3: true,
        currentAudioName: '',
        audioList: [
          {
            name: 'audio1',
            url: 'http://117.160.199.82:7777/AnBiao/22SP2051/qiandao/5540ca557c794088a76a4c85c3baea30.mp3',
          },
          {
            name: 'audio2',
            url: 'http://117.160.199.82:7777/AnBiao/22SP2051/qiandao/5540ca557c794088a76a4c85c3baea30.mp3',
          },
        ],
        passPdf: '',
        spanCount: 4,
        options: {
          theme: 'snow',
          modules: {
            toolbar: {
              container: [
                ['bold', 'italic', 'underline', 'strike'],
                [{ header: 1 }, { header: 2 }],
                [{ list: 'ordered' }, { list: 'bullet' }],
                [{ indent: '-1' }, { indent: '+1' }],
                [{ color: [] }, { background: [] }],
                [{ font: [] }],
                [{ align: [] }],
                ['clean'],
              ],
            },
          },
        },
        vabquill: '',
      }
    },

    watch: {
      '$store.state.detail.PS_ID'() {
        this.PS_ID = this.$store.state.detail.PS_ID
        this.fetchData()
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
      onDragEnd(evt) {
        //const newOrder = evt.to.children
        //console.log(newOrder)
        //console.log(this.picsData)
        let _that = this
        $.ajax({
          type: 'post', //请求类型
          dataType: 'json', //请求数据返回类型
          url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=updateImage', //请求地址
          data: JSON.stringify({
            PIC_PS_ID: _that.PS_ID,
            PIC_Type: _that.PIC_Type,
            PIC_Urls: _that.picsData,
          }), //表单序列化
          success: function (result) {
            _that.$message({
              type: 'success',
              message: '调整顺序成功！',
            })
          },
          error: function (result) {
            _that.$message({
              type: 'success',
              message: '调整顺序成功！',
            })
          },
        })
        // 保存新顺序
        //api.saveOrder(newOrder)
      },
      handleAdd(_url) {
        console.log('passed_url')
        console.log(_url)
        this.passPdf = _url
        this.$refs['edit'].showEdit(_url)
      },
      ...mapActions({
        delTabsBar: 'tabsBar/delRoute',
      }),
      mp3panduan(_url) {
        return _url.indexOf('mp3') != -1
        this.spanCount = 3
      },
      picpanduan(_url) {
        return _url.indexOf('jpg') != -1
        this.spanCount = 3
      },

      pdfpanduan(_url) {
        return _url.indexOf('pdf') != -1
      },

      docxpanduan(_url) {
        return _url.indexOf('docx') != -1
      },
      async docFile(_url) {
        console.log('_url')
        console.log(_url)
        console.log(_url.indexOf('docx') != -1)
        let _that = this
        fetch(_url)
          .then((response) => response.arrayBuffer())
          .then((data) => {
            // 获取到数据
            console.log('data')
            console.log(data)
            mammoth
              .convertToHtml({
                arrayBuffer: data,
              })
              .then((result) => {
                // result.value 就是生成的 HTML 内容
                console.log(result.value)
                console.log(_that)
                console.log(_that.$refs['vabQuil'])
                console.log(_that.$refs['vabQuil'][0].Quill)

                _that.vabquill = result.value
              })
          })
      },
      stylepanduan(_url) {
        return _url.indexOf('mp3') != -1 ? '  width:510px;' : ' width:310px;'
      },

      // Something to do before playing
      handleBeforePlay(next) {
        // There are a few things you can do here...
        this.currentAudioName =
          this.audioList[this.$refs.audioPlayer.currentPlayIndex].name

        next() // Start playing
      },
      handleShow(data) {
        if (this.PS_ID != '') {
          let _temp = this.$refs['vabUpload'].handleShow(data)
          console.log('_temp')
          console.log(_temp)
        } else {
          this.$baseMessage('请选择或新建评审任务', 'error')
        }
      },
      PIC_Edit() {
        this.showEdit = true
      },
      cancelUpdate() {
        this.showEdit = false
      },
      handleCheckAllChange(val) {
        this.picOptions = []
        this.picTemp = []
        for (let i = 0; i < this.picsData.length; i++) {
          this.picOptions.push(i < 10 ? '0' + i : i + '')
        }
        this.checkList = val ? this.picOptions : []
        this.isIndeterminate = false
      },
      handleCheckedCitiesChange(value) {
        let checkedCount = value.length
        this.checkAll = checkedCount === this.picsData.length
        this.isIndeterminate =
          checkedCount > 0 && checkedCount < this.picsData.length
      },
      PIC_delete(viewPIC_ID) {
        if (this.PS_ID != '') {
          this.$confirm('确定要删除这条记录吗？', '删除提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning',
            center: true,
          })
            .then(() => {
              var _that = this
              _that.picsData.map((val, i) => {
                if (val.PIC_Url == viewPIC_ID) {
                  _that.picsData.splice(i, 1)
                }
              })
              console.log(_that.picsData)
              $.ajax({
                type: 'post', //请求类型
                dataType: 'json', //请求数据返回类型
                url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=updateImage', //请求地址
                data: JSON.stringify({
                  PIC_PS_ID: _that.PS_ID,
                  PIC_Type: _that.PIC_Type,
                  PIC_Urls: _that.picsData,
                }), //表单序列化
                success: function (result) {
                  _that.$message({
                    type: 'success',
                    message: result,
                  })
                },
                error: function (result) {
                  _that.$baseMessage('删除成功！', 'error')
                },
              })

              setTimeout(function () {
                _that.listLoading = false
              }, 500)
            })
            .catch(() => {
              this.$message({
                type: 'info',
                message: '已取消操作',
              })
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
      PIC_deleteAll() {
        if (this.PS_ID != '') {
          console.log('this.checkList')
          console.log(this.checkList)
          if (this.checkList.length > 0) {
            this.$confirm(
              '确定要删除' + this.checkList.length + '图片吗？',
              '删除提示',
              {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning',
                center: true,
              }
            )
              .then(() => {
                var _that = this
                _that.picTemp = [] //要删除文件数组
                _that.checkList.map((val) => {
                  let _val = val - 0
                  _that.picTemp.push(_that.picsData[_val])
                })
                console.log('_that.picTemp')
                console.log(_that.picTemp)
                console.log('_that.picsData')
                console.log(_that.picsData)
                let _TempPics = [] //保留的数组
                for (let j = 0; j < _that.picTemp.length; j++) {
                  console.log('j==========删除第几个' + j)
                  console.log(_that.picTemp[j].PIC_ID)
                  for (let t = 0; t < _that.picsData.length; t++) {
                    console.log('t==========' + t)
                    console.log(_that.picsData[t].PIC_ID)

                    if (_that.picsData[t].PIC_ID == _that.picTemp[j].PIC_ID) {
                      _that.picsData.splice(t, 1)
                      console.log('删除')
                      console.log(_that.picsData.length)
                    } else console.log('保留！')
                  }
                }

                console.log('_TempPics')
                console.log(_TempPics)
                console.log('picsData')
                console.log(_that.picsData)

                $.ajax({
                  type: 'post', //请求类型
                  dataType: 'json', //请求数据返回类型
                  url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=updateImage', //请求地址
                  data: JSON.stringify({
                    PIC_PS_ID: _that.PS_ID,
                    PIC_Type: _that.PIC_Type,
                    PIC_Urls: _that.picsData,
                  }), //表单序列化
                  success: function (result) {
                    _that.$message({
                      type: 'success',
                      message: result,
                    })
                  },
                  error: function (result) {
                    _that.$baseMessage('删除成功！', 'error')
                    _that.fetchData()
                  },
                })
                setTimeout(function () {
                  _that.listLoading = false
                }, 500)
              })
              .catch(() => {
                this.$message({
                  type: 'info',
                  message: '已取消操作',
                })
              })
          } else {
            this.$alert('未选中任何图片', '提示', {
              confirmButtonText: '确定',
              callback: (action) => {
                //_that.$baseMessage('请选择或新建评审任务', 'error')
              },
            })
          }
        } else {
          this.$alert('请选择或新建评审任务', '提示', {
            confirmButtonText: '确定',
            callback: (action) => {
              //_that.$baseMessage('请选择或新建评审任务', 'error')
            },
          })
        }
      },
      PIC_Rename(index, object) {
        this.showEdit = true
        console.log('index')
        console.log(index)
        console.log(this.picsData)
        console.log(this.picsData[index])
        let _tempUrl = this.picsData[index].PIC_Url

        let _tempID = _tempUrl.substring(
          _tempUrl.lastIndexOf('/') + 1,
          _tempUrl.lastIndexOf('.')
        )

        let _name = this.$refs.picsArray[index].value
        let _tempPic = {
          PIC_ID: _tempID,
          PIC_Name: _name,
          PIC_Type: this.picsData[index].PIC_Type,
          PIC_Url: _tempUrl,
        }
        this.picsData.splice(index, 1, _tempPic)
        const _that = this
        $.ajax({
          type: 'post', //请求类型
          dataType: 'json', //请求数据返回类型
          url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=updateImage', //请求地址
          data: JSON.stringify({
            PIC_PS_ID: _that.PS_ID,
            PIC_Type: _that.PIC_Type,
            PIC_Urls: _that.picsData,
          }), //表单序列化
          success: function (result) {
            _that.$message({
              type: 'success',
              message: result,
            })
          },
          error: function (result) {
            _that.$baseMessage(result.responseText, 'success')
          },
        })
      },
      allPics(text) {
        let pics = []
        this.picsData.forEach((item) => {
          pics.push(item.PIC_Url)
        })
        // text就是所传参数
        return pics
        // if (text && text.trim != '')
        //   return text.split(',').map((item) => item)
      },
      changePS_Pics(params) {
        console.log('params')
        console.log(params)
        let { type, urls } = params
        urls.forEach((item) => {
          let _tempID = item.response.substring(
            item.response.lastIndexOf('/') + 1,
            item.response.lastIndexOf('.')
          )
          console.log(_tempID)
          let _tempPic = {
            PIC_ID: _tempID,
            PIC_Name: item.name,
            PIC_Type: type,
            PIC_Url: item.response,
          }
          if (
            this.picsData.findIndex((element, index, array) => {
              return element.PIC_Url == _tempPic.PIC_Url
            }) == -1
          ) {
            this.picsData.push(_tempPic)
          }
        })
        const _that = this
        $.ajax({
          type: 'post', //请求类型
          contentType: 'multipart/form-data',
          dataType: 'json', //请求数据返回类型
          url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=updateImage', //请求地址
          data: JSON.stringify({
            PIC_PS_ID: _that.PS_ID,
            PIC_Type: _that.PIC_Type,
            PIC_Urls: _that.picsData,
          }), //表单序列化
          success: function (result) {
            _that.$message({
              type: 'success',
              message: result,
            })
          },
          error: function (result) {
            _that.$baseMessage(result.responseText, 'success')
          },
        })
      },

      // 获取tree数据
      sortChange(a, b) {
        let _a = a.BHG_ID.split('.')[0] + '.' + a.BHG_ID.split('.')[1]
        let _b = b.BHG_ID.split('.')[0] + '.' + b.BHG_ID.split('.')[1]
        return _a - _b
      },
      async fetchData() {
        const _that = this
        this.PS_ID = this.$store.state.detail.PS_ID
        this.PS_DanWei = this.$store.state.detail.PS_DanWei

        console.log(this.PS_ID)
        if (this.PS_ID != '') {
          $.ajax({
            type: 'post', //请求类型
            dataType: 'json', //请求数据返回类型
            url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=getImage', //请求地址
            data: JSON.stringify({
              PIC_PS_ID: _that.PS_ID,
              PIC_Type: _that.PIC_Type,
              PIC_Urls: [],
            }), //表单序列化
            success: function (result) {
              //成功
              _that.picsData.splice(0)
              const { count, Data } = result
              let _count = 0
              if (count == '0' || Data == '') {
                _that.message_show = true
                _that.message = '暂无相关照片'
              } else {
                Data.forEach((item) => {
                  _count++
                  let _temp = {
                    PIC_ID: item.PIC_ID,
                    PIC_Name: item.PIC_Name,
                    PIC_Type: item.PIC_Type,
                    PIC_Url: item.PIC_Url,
                  }
                  if (_that.docxpanduan(item.PIC_Url))
                    _that.docFile(item.PIC_Url)
                  _that.picsData.push(_temp)
                })

                _that.$baseMessage('共载入' + _count + '条图片', 'success')
              }
            },
            error: function (result) {
              const { count, Data } = result
              _that.$baseMessage(Data, 'error')
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
<style>
  .time {
    font-size: 13px;
    color: #999;
  }

  .bottom {
    margin-top: 13px;
    line-height: 12px;
  }

  .button {
    padding: 0;
    float: right;
  }

  .image {
    width: 100%;
    height: 300px;
    display: block;
  }

  .clearfix:before,
  .clearfix:after {
    display: table;
    content: '';
  }

  .clearfix:after {
    clear: both;
  }
  .checkImg {
    margin-right: 10px;
  }
  .page-icon {
    display: inline-block;
    vertical-align: middle;
    width: 25px;
    height: 32px;
    margin: 0px !important;
  }
  .page-turner {
    height: 30px;
    position: absolute;
    bottom: 0px;
    width: 386px;
    left: 100%;
    transform: translate(-350px);
    opacity: 0.6;
    background: #000000;
    border-radius: 4px 4px 0px 0px;
    z-index: 11;
  }
</style>
