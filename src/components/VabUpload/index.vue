<template>
  <el-dialog
    :before-close="handleClose"
    :close-on-click-modal="false"
    :title="title"
    :visible.sync="dialogFormVisible"
    width="609px"
  >
    <div class="upload">
      <el-alert
        :closable="false"
        :title="`支持${accept}格式，单次可最多选择${limit}个文件，每个文件不可大于${size}M，如果大于${size}M会自动为您过滤`"
        type="info"
      ></el-alert>
      <br />
      <el-upload
        ref="upload"
        :action="action"
        :auto-upload="false"
        :close-on-click-modal="false"
        :data="data"
        :file-list="fileList"
        :headers="headers"
        :limit="limit"
        :multiple="true"
        :name="name"
        :on-change="handleChange"
        :on-error="handleError"
        :on-exceed="handleExceed"
        :on-preview="handlePreview"
        :on-progress="handleProgress"
        :on-remove="handleRemove"
        :on-success="handleSuccess"
        :accept="accept"
        class="upload-content"
        list-type="picture-card"
      >
        <i slot="trigger" class="el-icon-plus"></i>
        <el-dialog
          :visible.sync="dialogVisible"
          append-to-body
          title="查看大图"
        >
          <div>
            <img :src="dialogImageUrl" alt="" width="100%" />
          </div>
        </el-dialog>
      </el-upload>
    </div>
    <div
      slot="footer"
      class="dialog-footer"
      style="position: relative; padding-right: 15px; text-align: right"
    >
      <div
        v-if="show"
        style="position: absolute; top: 10px; left: 15px; color: #999"
      >
        正在上传中... 当前上传成功数:{{
          imgSuccessNum
        }}个文件，当前上传失败数:{{ imgErrorNum }}
      </div>
      <el-button type="primary" @click="handleClose">关闭</el-button>
      <el-button
        :loading="loading"
        size="small"
        style="margin-left: 10px"
        type="success"
        @click="submitUpload"
      >
        开始上传
      </el-button>
    </div>
  </el-dialog>
</template>

<script>
  import { baseURL, tokenName } from '@/config'

  export default {
    name: 'VabUpload',
    props: {
      url: {
        type: String,
        default: '/upload',
        required: true,
      },
      name: {
        type: String,
        default: 'file',
        required: true,
      },
      limit: {
        type: Number,
        default: 50,
        required: true,
      },
      size: {
        type: Number,
        default: 1,
        required: true,
      },
      filefenlei: {
        type: String,
        default: 'PS_RenWuShu',
        required: true,
      },
      accept: {
        type: String,
        default: 'image/png, image/jpeg',
        required: true,
      },
    },
    data() {
      return {
        show: false,
        loading: false,
        dialogVisible: false,
        dialogImageUrl: 'http://117.160.199.82:7777/img/pdf.gif',
        action: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=upload',
        headers: {},
        fileList: [],
        picture: 'picture',
        imgNum: 0,
        imgSuccessNum: 0,
        imgErrorNum: 0,
        typeList: null,
        title: '上传',
        dialogFormVisible: false,
        data: {},
      }
    },
    computed: {
      percentage() {
        if (this.allImgNum == 0) return 0
        return this.$baseLodash.round(this.imgNum / this.allImgNum, 2) * 100
      },
    },
    methods: {
      // 选取图片后自动回调，里面可以获取到文件
      imgSaveToUrl(event) {
        // 也可以用file
        this.localFile = event.raw // 或者 this.localFile=file.raw
        console.log('reader.result')

        // 转换操作可以不放到这个函数里面，
        // 因为这个函数会被多次触发，上传时触发，上传成功也触发
        let reader = new FileReader()
        reader.readAsDataURL(this.localFile) // 这里也可以直接写参数event.raw
        this.fileList.push(this.localFile)

        // 转换成功后的操作，reader.result即为转换后的DataURL ，
        // 它不需要自己定义，你可以console.log(reader.result)看一下
        reader.onload = () => {
          console.log(reader.result)
        }

        /* 另外一种本地预览方法 */
        let URL = window.URL || window.webkitURL
        this.model.icon = URL.createObjectURL(this.localFile)
        // 转换后的地址为 blob:http://xxx/7bf54338-74bb-47b9-9a7f-7a7093c716b5
      },
      submitUpload() {
        if (this.fileList.length <= 0) {
          this.$message.error('请先选择上传文件')
          this.submitLoading = false
          return
        }
        console.log('this.action')

        //触发 el-upload上传
        this.$refs.upload.submit() //如果:http-request=""指定了回调函数,则会覆盖默认的上传,会流入到http-request的回调中
        // console.log('this.action')

        // // 请求加的参数this.uploadData
        // let promiseArr = []
        // console.log(this.action)
        // console.log(this.fileList)

        // // 看看这个时候的请求地址是否正确上面的action
        // //this.$refs.upload.submit()
        // for (let i = 0; i < this.fileList.length; i++) {
        //   const file = this.fileList[i]
        //   console.log(file)
        //   let formData = new FormData()
        //   formData.append('file', file) //图片
        //   let params = {
        //     contentId: 'this.pictureId',
        //     description: 'this.detailForm.desc',
        //   } //其他数据
        //   formData.append('contentId', params.contentId) //json格式上传
        //   formData.append('description', params.description)
        //   console.log(formData)
        //   // console.log('******************')
        //   // let p = $.ajax(

        //   //   'http://117.160.199.82:7777/anbiao_bg.ashx?type=upload',
        //   //   formData,
        //   //   {
        //   //     headers: {
        //   //       'Content-Type': 'application/json',
        //   //     },
        //   //   }
        //   // ).then((respose) => {
        //   //   console.log(respose)
        //   //   if (respose.data.status == '1') {
        //   //     console.log('ddddddddddd')
        //   //     //this.myFiles.push(file)
        //   //     let newFile = {
        //   //       source: 'http://localhost:8888/api/File/' + respose.data.name,
        //   //       name: respose.data.name,
        //   //       options: {
        //   //         type: 'local',
        //   //       },
        //   //     }
        //   //     this.myFiles.splice(index, 1, newFile) //将myFiles数组中的bolb数据替换成newFile形式
        //   //     this.originFiles.push(newFile) //原文件数组中增加一项
        //   //   } else {
        //   //     this.$dialog.message.error('添加失败', {
        //   //       position: 'top',
        //   //     })
        //   //     error('LIMIT_FILE_SIZE')
        //   //   }
        //   // })
        //   let p = $.ajax({
        //     type: 'post', //请求类型
        //     contentType: false,
        //     url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=upload', //请求地址
        //     data: formData, //表单序列化
        //     success: function (result) {
        //       //成功
        //       console.log(result)
        //       console.log(result.status)
        //       if (result.status == 200) {
        //         console.log(result)
        //         console.log('成功')
        //       } else {
        //         console.log(result)
        //         console.log('失败')
        //       }
        //     },
        //     error: function (result) {
        //       //失败
        //       console.log(result.status)

        //       console.log(result)
        //       console.log('异常')
        //     },
        //   })
        //   promiseArr.push(p)
        // }
        // // allbooks - list which will contain all friends' books +
        // // additional list contained in initialValue
        // //等所有promise任务执行完毕后再执行 返回0 1 2 [0,1,2]
        // Promise.all(promiseArr).then((res) => {
        //   console.log('allbooks')
        // })
      },
      handleProgress(event, file, fileList) {
        this.loading = true
        this.show = true
      },

      /**
       * 选择文件时回调
       */
      handleChange(file, fileList) {
        console.log('this.file')
        console.log(file)
        console.log(fileList)

        if (file.size > 1048576 * this.size) {
          fileList.map((item, index) => {
            if (item === file) {
              fileList.splice(index, 1)
            }
          })
        } else {
          this.allImgNum = fileList.length
        }
        this.fileList = fileList
      },
      handleSuccess(response, file, fileList) {
        console.log('file')
        console.log(file)
        this.$store.dispatch('detail/setPS_RenWuShu', file.response)
        this.imgNum = this.imgNum + 1
        this.imgSuccessNum = this.imgSuccessNum + 1
        if (fileList.length === this.imgNum) {
          setTimeout(() => {
            this.$baseMessage(
              `上传完成! 共上传${fileList.length}个文件`,
              'success'
            )
          }, 1000)
        }

        setTimeout(() => {
          this.loading = false
          this.show = false
        }, 1000)
      },
      handleError(err, file, fileList) {
        this.imgNum = this.imgNum + 1
        this.imgErrorNum = this.imgErrorNum + 1
        this.$baseMessage(
          `文件[${file.raw.name}]上传失败,文件大小为${this.$baseLodash.round(
            file.raw.size / 1024,
            0
          )}KB`,
          'error'
        )
        setTimeout(() => {
          this.loading = false
          this.show = false
        }, 1000)
      },
      /**
       * 文件删除回调
       */ handleRemove(file, fileList) {
        this.imgNum = this.imgNum - 1
        this.allNum = this.allNum - 1
      },
      handlePreview(file) {
        console.log(file)
        //this.dialogImageUrl = file.url
        this.dialogVisible = true
      },
      handleExceed(files, fileList) {
        this.$baseMessage(
          `当前限制选择 ${this.limit} 个文件，本次选择了
             ${files.length}
             个文件`,
          'error'
        )
      },
      handleShow(data) {
        console.log(data)
        this.title = '上传'
        this.data = data
        this.dialogFormVisible = true
      },
      handleClose() {
        this.fileList = []
        this.picture = 'picture'
        this.allImgNum = 0
        this.imgNum = 0
        this.imgSuccessNum = 0
        this.imgErrorNum = 0
        this.dialogFormVisible = false
        this.$emit('changePS_RenWuShu', this.$store.state.detail.PS_RenWuShu)
      },
    },
  }
</script>

<style lang="scss" scoped>
  .upload {
    height: 200px;

    .upload-content {
      .el-upload__tip {
        display: block;
        height: 30px;
        line-height: 30px;
      }

      ::v-deep {
        .el-upload--picture-card {
          width: 128px;
          height: 128px;
          margin: 3px 8px 8px 8px;
          border: 2px dashed #c0ccda;
        }

        .el-upload-list--picture {
          margin-bottom: 20px;
        }

        .el-upload-list--picture-card {
          .el-upload-list__item {
            width: 128px;
            height: 128px;
            margin: 3px 8px 8px 8px;
          }
        }
      }
    }
  }
</style>
