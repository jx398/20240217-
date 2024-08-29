<template>
  <el-dialog
    :title="title"
    :visible.sync="dialogFormVisible"
    width="700px"
    @close="close"
  >
    <el-form ref="form" :model="form" :rules="rules" label-width="80px">
      <el-form-item label="设备ID" prop="SB_ID">
        <el-input
          v-model.trim="form.SB_ID"
          clearable
          :disabled="disable"
          class="inline"
        ></el-input>

        <el-input
          v-model.trim="form.SB_PS_ID"
          clearable
          :disabled="disable"
          class="inline"
        ></el-input>

        <el-input
          v-model.trim="form.SB_Type"
          clearable
          :disabled="disable"
          class="inline"
        ></el-input>
      </el-form-item>

      <el-form-item label="设备编号" prop="SB_BianHao">
        <el-input v-model.trim="form.SB_BianHao" clearable></el-input>
      </el-form-item>
      <el-form-item
        label="设备名称"
        prop="SB_Name
"
      >
        <el-input v-model.trim="form.SB_Name" clearable></el-input>
      </el-form-item>

      <el-form-item label="设备型号" prop="SB_XingHao">
        <el-input v-model.trim="form.SB_XingHao" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="设备精度" prop="SB_JingDu">
        <el-input v-model.trim="form.SB_JingDu" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="设备数量" prop="SB_ShuLiang">
        <el-input v-model.trim="form.SB_ShuLiang" clearable></el-input>
      </el-form-item>
      <el-form-item label="完好情况" prop="SB_ZhuangTai">
        <el-input v-model.trim="form.SB_ZhuangTai" clearable></el-input>
      </el-form-item>
    </el-form>
    <div slot="footer" class="dialog-footer">
      <el-button @click="close">取 消</el-button>
      <el-button type="primary" @click="save">确 定</el-button>
    </div>
  </el-dialog>
</template>

<script>
  import { doEdit } from '@/api/shebeiManagement'

  export default {
    name: 'ShebeiManagementEdit',
    props: {
      formData: {
        type: Object,
        default() {
          return null
        }, // 数据对象
      },
      formPSID: {
        type: String,
        default() {
          return ''
        }, // 任务单号
      },
      formID: {
        type: String,
        default() {
          return ''
        }, // 设备单独ID
      },
    },
    data() {
      return {
        PS_ID: this.formPSID,
        form:
          this.formData == null
            ? {
                SB_ID: '',
                SB_PS_ID: this.$store.state.detail.PS_ID,
                SB_Type: '生产设备',
                SB_Name: '',
                SB_BianHao: '',
                SB_XingHao: '',
                SB_BianHao: '',
                SB_JingDu: '',
                SB_ShuLiang: '',
                SB_ZhuangTai: '',
              }
            : this.formData,
        rules: {
          username: [
            { required: true, trigger: 'blur', message: '请输入用户名' },
          ],
          password: [
            { required: true, trigger: 'blur', message: '请输入密码' },
          ],
          email: [{ required: true, trigger: 'blur', message: '请输入邮箱' }],
          permissions: [
            { required: true, trigger: 'blur', message: '请选择权限' },
          ],
        },
        title: '',
        dialogFormVisible: false,
        disable: true,
      }
    },
    computed() {
      this.SB_PS_ID = this.$store.state.detail.PS_ID
    },
    watch: {
      formData: function (val) {
        this.form = val
      },
      '$store.state.detail.PS_ID'() {
        this.SB_PS_ID = this.$store.state.detail.PS_ID
      },
    },
    mounted() {
      this.formData == null ? '' : (this.form = this.formData)
    },
    created() {},
    methods: {
      showEdit(row) {
        console.log('this.formData')
        console.log(row)
        this.form = this.formData
        this.SB_Type = '生产设备'
        this.title = '编辑'
        this.dialogFormVisible = true
      },
      showAdd() {
        this.title = '添加'
        this.form = this.formData
        this.SB_PS_ID = this.formPSID
        console.log(this.formPSID)
        console.log(this.SB_PS_ID)
        console.log(this.$store.state.detail.PS_ID)
        this.dialogFormVisible = true
      },
      close() {
        // this.$refs['form'].resetFields()
        // this.form = this.$options.data().form
        this.dialogFormVisible = false
        this.$emit('fetchData')
      },
      save() {
        const _that = this
        this.form.SB_PS_ID = this.formPSID
        $.ajax({
          type: 'post', //请求类型
          dataType: 'json', //请求数据返回类型
          url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=editDanWeiSheBei', //请求地址
          data: JSON.stringify(_that.form),
          //表单序列化
          success: function (result) {
            console.log(result)
            _that.close()
          },
          error: function (result) {
            //失败
            if (result.status == 200) {
              _that.$baseMessage(result.responseText, 'success')
              _that.$emit('fetch-data')
            } else {
              _that.$baseMessage(result.responseText, 'error')
            }
            _that.close()
          },
        })
      },
    },
  }
</script>
<style scoped>
  .inline {
    width: 25%;
    margin-right: 10px;
  }
</style>
