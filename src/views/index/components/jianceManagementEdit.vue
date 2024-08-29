<template>
  <el-dialog
    :title="title"
    :visible.sync="dialogFormVisible"
    width="800px"
    @close="close"
  >
    <el-form ref="form" :model="form" :rules="rules" label-width="80px">
      <el-form-item label="评审编号" prop="PS_ID">
        <el-input v-model.trim="form.PS_ID" autocomplete="off"></el-input>
      </el-form-item>

      <el-form-item label="评审单位" prop="PS_DanWei">
        <el-input
          v-model.trim="form.PS_DanWei"
          type="xinghao"
          autocomplete="off"
        ></el-input>
      </el-form-item>
      <el-form-item label="单位地址" prop="PS_DanWeiDiZhi">
        <el-input
          v-model.trim="form.PS_DanWeiDiZhi"
          autocomplete="off"
        ></el-input>
      </el-form-item>
      <el-form-item label="评审日起" prop="PS_RiQiStart">
        <el-date-picker
          v-if="showEdit"
          v-model="form.PS_RiQiStart"
          type="datetime"
          placeholder="选择开始日期"
          format="yyyy年MM月dd日HH时mm分"
          value-format="yyyy年MM月dd日HH时mm分"
          :default-time="'8:30:00'"
          :picker-options="startNoTime"
          style="width: 60%"
        ></el-date-picker>
      </el-form-item>
      <el-form-item label="评审日止" prop="PS_RiQiEnd">
        <el-date-picker
          v-if="showEdit"
          v-model="form.PS_RiQiEnd"
          format="yyyy年MM月dd日HH时mm分"
          value-format="yyyy年MM月dd日HH时mm分"
          type="datetime"
          placeholder="选择开始日期"
          :default-time="'17:30:00'"
          :picker-options="endNoTime"
          style="width: 60%"
        ></el-date-picker>
      </el-form-item>
      <el-form-item label="评审人员" prop="PS_RenYuan">
        <el-input v-model.trim="form.PS_RenYuan" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="评审结论" prop="PS_JieLun">
        <el-select v-model="form.PS_JieLun" placeholder="请选择">
          <el-option-group
            v-for="group in options"
            :key="group.label"
            :label="group.label"
          >
            <el-option
              v-for="item in group.options"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            ></el-option>
          </el-option-group>
        </el-select>
      </el-form-item>
    </el-form>
    <div slot="footer" class="dialog-footer">
      <el-button @click="close">取 消</el-button>
      <el-button type="primary" @click="save">确 定</el-button>
    </div>
  </el-dialog>
</template>

<script>
  import { doEdit } from '@/api/jianceManagement'

  export default {
    name: 'JianceManagementEdit',
    props: {
      formData: {
        type: Object,
        default() {
          return null
        }, // 对象或数组默认值需要用函数返回
      },
    },
    data() {
      return {
        // 接受父组件的值

        form:
          this.formData == null
            ? {
                PS_ID: '',
                PS_DanWei: '',
                PS_DanWeiDiZhi: '',
                PS_RiQiStart: '',
                PS_RiQiEnd: '',
                PS_JieLun: '',
                PS_RenYuan: '',
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
        // 开始时间限制范围
        startNoTime: {
          disabledDate(date) {
            // 可选当天以及当天之前的日期
            return date.getTime() > Date.now()
          },
        },
        // 结束时间限制范围
        endNoTime: {},
        options: [
          {
            label: '----合格----',
            options: [
              {
                value: 'A级合格',
                label: 'A级合格',
              },
              {
                value: 'B级合格',
                label: 'B级合格',
              },
              {
                value: 'C级合格',
                label: 'C级合格',
              },
            ],
          },
          {
            label: '----不格----',
            options: [
              {
                value: 'D级不合格',
                label: 'D级不合格',
              },
            ],
          },
        ],
      }
    },
    watch: {
      'form.PS_RiQiStart': {
        handler(val) {
          this.endNoTime = {
            disabledDate(time) {
              const _tempVal = val
                .toString()
                .slice(0, 10)
                .replace('年', '-')
                .replace('月', '-')
              const time1 = new Date(_tempVal).getTime() - 8.64e7
              console.log(
                new Date(_tempVal),
                _tempVal,
                val,
                time1,
                time.getTime() > Date.now()
              )
              // 结束时间禁止选择当天以后日期并且不能选择开始时间之前的
              return (
                time.getTime() < time1 || time.getTime() > new Date().getTime()
              )
            },
          }
        },
      },
      formData: function (val) {
        this.form = val
      },
    },
    created() {},
    mounted() {
      this.formData == null ? '' : (this.form = this.formData)
    },
    methods: {
      showEdit(row) {
        if (this.formData.PS_ID == '') {
          this.title = '添加'
        } else {
          this.form = this.formData
          this.title = '编辑'
        }
        this.dialogFormVisible = true
      },
      close() {
        // this.$refs['form'].resetFields()
        // this.form = this.$options.data().form
        this.dialogFormVisible = false
      },
      save() {
        const _that = this
        this.$refs['form'].validate(async (valid) => {
          if (valid) {
            $.ajax({
              type: 'post', //请求类型
              dataType: 'json', //请求数据返回类型
              url: 'http://117.160.199.82:7777/anbiao_bg.ashx?type=edit', //请求地址
              data: JSON.stringify(this.form), //表单序列化
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
              },
              error: function (result) {
                //失败
                if (result.status == 200) {
                  _that.$baseMessage(result.responseText, 'success')

                  _that.$emit('fetch-data')
                } else {
                  _that.$baseMessage(result.responseText, 'error')
                }
              },
            })
            this.close()
          } else {
            return false
          }
        })
      },
    },
  }
</script>
