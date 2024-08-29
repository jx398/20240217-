<template>
  <el-dialog
    :title="title"
    :visible.sync="dialogFormVisible"
    width="800px"
    @close="close"
  >
    <el-form
      ref="form"
      :model="form"
      :inline="true"
      :rules="rules"
      label-width="80px"
    >
      <el-form-item label="任务编号" prop="RY_PS_ID">
        <el-input
          v-model.trim="RY_PS_ID"
          clearable
          autocomplete="off"
          :disabled="disable"
        ></el-input>
      </el-form-item>
      <el-form-item label="用户名" prop="RY_UserName">
        <el-input
          v-model.trim="form.RY_UserName"
          clearable
          autocomplete="off"
        ></el-input>
      </el-form-item>
      <el-form-item label="性别" prop="RY_XingBie">
        <el-radio-group v-model="form.RY_XingBie">
          <el-radio label="男"></el-radio>
          <el-radio label="女"></el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="出生年月" prop="RY_Birthday">
        <el-date-picker
          v-model="form.RY_Birthday"
          type="date"
          placeholder="选择日期"
          format="yyyy-MM-dd"
          value-format="yyyy-MM-dd"
          style="width: 90%"
        ></el-date-picker>
      </el-form-item>
      <el-form-item label="学历" prop="RY_XueLi">
        <el-autocomplete
          v-model="form.RY_XueLi"
          class="inline-input"
          :fetch-suggestions="querySearch"
          placeholder="请输入学历"
          clearable
          @select="handleSelect"
        ></el-autocomplete>
      </el-form-item>
      <el-form-item label="专业" prop="RY_ZhuanYie">
        <el-input
          v-model.trim="form.RY_ZhuanYie"
          clearable
          autocomplete="off"
        ></el-input>
      </el-form-item>
      <el-form-item label="职称" prop="RY_ZhiCheng">
        <el-input
          v-model.trim="form.RY_ZhiCheng"
          clearable
          autocomplete="off"
        ></el-input>
      </el-form-item>
      <el-form-item label="职务" prop="RY_ZhiWu">
        <el-input
          v-model.trim="form.RY_ZhiWu"
          clearable
          autocomplete="off"
        ></el-input>
      </el-form-item>
      <el-form-item label="办公电话" prop="RY_Phone">
        <el-input
          v-model.trim="form.RY_Phone"
          clearable
          autocomplete="off"
        ></el-input>
      </el-form-item>
      <el-form-item label="手机" prop="RY_Tel">
        <el-input
          v-model.trim="form.RY_Tel"
          clearable
          autocomplete="off"
        ></el-input>
      </el-form-item>
      <el-form-item label="入职时间" prop="RY_RuZhiTime">
        <el-input
          v-model.trim="form.RY_RuZhiTime"
          clearable
          autocomplete="off"
        ></el-input>
      </el-form-item>
      <el-form-item label="从业年限" prop="RY_CongYeTime">
        <el-input
          v-model.trim="form.RY_CongYeTime"
          clearable
          autocomplete="off"
        ></el-input>
      </el-form-item>
      <el-form-item label="合同签定" prop="RY_HeTong">
        <el-radio-group v-model="form.RY_HeTong">
          <el-radio label="是"></el-radio>
          <el-radio label="否"></el-radio>
        </el-radio-group>
      </el-form-item>
    </el-form>
    <div slot="footer" class="dialog-footer">
      <el-button @click="close">取 消</el-button>
      <el-button type="primary" @click="save">确 定</el-button>
    </div>
  </el-dialog>
</template>

<script>
  import { doEdit } from '@/api/userManagement'

  export default {
    name: 'UserManagementEdit',
    props: {
      formData: {
        type: Object,
        default() {
          return null
        }, // 对象或数组默认值需要用函数返回
      },
      formPSID: {
        type: String,
        default() {
          return ''
        }, // 对象或数组默认值需要用函数返回
      },
      formID: {
        type: String,
        default() {
          return ''
        }, // 对象或数组默认值需要用函数返回
      },
    },
    data() {
      return {
        PS_ID: this.$store.state.detail.PS_ID,
        restaurants: [],
        form:
          this.formData == null
            ? {
                RY_PS_ID: this.PS_ID,
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
            : this.formData,
        rules: {
          RY_UserName: [
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
      this.RY_PS_ID = this.$store.state.detail.PS_ID
    },
    watch: {
      formData: function (val) {
        this.form = val
      },
      '$store.state.detail.PS_ID'() {
        this.RY_PS_ID = this.$store.state.detail.PS_ID
      },
    },
    mounted() {
      this.formData == null ? '' : (this.form = this.formData)
    },
    created() {
      this.restaurants = this.loadAll()
    },
    methods: {
      showEdit(row) {
        this.form = this.formData
        this.RY_PS_ID = this.$store.state.detail.PS_ID
        this.title = '编辑'
        this.dialogFormVisible = true
      },
      showAdd(row) {
        this.title = '添加'
        this.form = this.formData
        this.RY_PS_ID = this.$store.state.detail.PS_ID
        console.log(this.formPSID)
        console.log(this.RY_PS_ID)
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
        this.form.RY_PS_ID = this.formPSID
        console.log(_that.list)
        $.ajax({
          type: 'post', //请求类型
          dataType: 'json', //请求数据返回类型
          url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=editDanWeiRenYuan', //请求地址
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
      handleSelect() {},
    },
  }
</script>
