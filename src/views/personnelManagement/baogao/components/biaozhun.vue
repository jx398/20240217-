// 子组件
<template>
  <div>
    <vxe-toolbar>
      <template #buttons>
        <el-button
          icon="el-icon-circle-plus-outline"
          type="success"
          @click="insertEvent(-1)"
        >
          新增
        </el-button>
        <el-button icon="el-icon-delete" type="danger" @click="removeEvent">
          移除
        </el-button>
        <el-button icon="el-icon-message" type="info" @click="saveEvent">
          保存
        </el-button>
        <el-button
          icon="el-icon-refresh-left"
          type="warning"
          @click="revertEvent"
        >
          还原
        </el-button>
      </template>
    </vxe-toolbar>

    <vxe-table
      ref="xTable"
      border
      resizable
      show-overflow
      keep-source
      :row-config="{ isHover: true }"
      :loading="loading"
      :data="tableData"
      :edit-config="{ trigger: 'click', mode: 'row' }"
    >
      >
      <vxe-column type="checkbox" width="50"></vxe-column>
      <vxe-column type="seq" width="60"></vxe-column>
      <vxe-column field="YJ_Select" title="选中" width="90" :edit-render="{}">
        <template #default="{ row }">
          <el-switch
            v-model="row.YJ_Select"
            active-value="1"
            inactive-value="0"
            size="small"
            open-icon="vxe-icon-check"
            close-icon="vxe-icon-close"
            disabled
          ></el-switch>
        </template>
        <template #edit="{ row }">
          <el-switch
            v-model="row.YJ_Select"
            active-value="1"
            inactive-value="0"
            size="small"
            open-icon="vxe-icon-check"
            close-icon="vxe-icon-close"
          ></el-switch>
        </template>
      </vxe-column>
      <vxe-column field="YJ_BiaoZhun" title="依据标准" :edit-render="{}">
        <template #edit="{ row }">
          <vxe-input v-model="row.YJ_BiaoZhun" type="text"></vxe-input>
        </template>
      </vxe-column>
      <vxe-column title="操作" width="160">
        <template #default="{ row }">
          <template v-if="$refs.xTable.isActiveByRow(row)">
            <vxe-button @click="saveRowEvent(row)">保存</vxe-button>
            <vxe-button @click="cancelRowEvent(row)">取消</vxe-button>
          </template>
          <template v-else>
            <vxe-button
              icon="vxe-icon-edit"
              type="text"
              @click="editRowEvent(row)"
            ></vxe-button>
            <vxe-button
              type="text"
              icon="vxe-icon-delete"
              @click="removeEventRow(row)"
            ></vxe-button>
          </template>
        </template>
      </vxe-column>
    </vxe-table>
  </div>
</template>
<script>
  import VXETable from 'vxe-table'

  export default {
    props: {
      proptableData: {
        type: Array,
        default: () => [], //如果不传值，则为default的值
      },
    },
    data() {
      return {
        /// vex-table
        loading: false,
        submitLoading: false,
        tableData: this.proptableData,
        selectRow: null,
        formData: {
          YJ_BiaoZhun: null,
        },
        formRules: {
          // ZG_BiaoTi: [
          //   { required: true, message: '请输入名称' },
          //   { min: 3, max: 5, message: '长度在 3 到 5 个字符' },
          // ],
          // ZG_BeiZhu: [{ required: true, message: '请输入昵称' }],
        },
      }
    },
    mounted() {
      console.log('mounted')
      console.log(this.$store.detail)
      this.tableData = this.proptableData
      console.log('biaozhun*******this.tableData')
      console.log(this.tableData)
      console.log(this.proptableData)
    },
    created() {
      if (this.$store.state.detail.PS_ID == '') {
        this.$alert('请选择或新建评审任务', '提示', {
          confirmButtonText: '确定',
          callback: (action) => {
            //如果没有选择评审任务就返回到首页
            console.log(this.$route.path)
            //console.log(this.delTabsBar(this.$route.path))
            this.$router.push('/')
          },
        })
      }
      this.tableData = this.proptableData
      console.log('biaozhun*******this.tableData')
      console.log(this.tableData)
      console.log(this.proptableData)
    },
    methods: {
      /// vex-table所用方法
      popData() {
        return this.tableData
      },
      visibleMethod({ data }) {
        return data.flag1 === 'Y'
      },
      cellDBLClickEvent({ row }) {
        this.editEvent(row)
      },
      editRowEvent(row) {
        const $table = this.$refs.xTable
        $table.setActiveRow(row)
      },
      insertEvent(row) {
        this.formData = {
          YJ_Select: '1',
          YJ_BiaoZhun: '',
        }
        this.$refs.xTable.insert(this.formData, -1)
      },
      editEvent(row) {
        this.formData = {
          YJ_Select: row.YJ_Select,
          YJ_BiaoZhun: row.YJ_BiaoZhun,
        }
        this.selectRow = row
      },
      async removeEventRow(row) {
        const type = await VXETable.modal.confirm('您确定要删除该数据?')
        const $table = this.$refs.xTable
        if (type === 'confirm') {
          $table.remove(row)
        }
      },
      submitEvent() {
        this.submitLoading = true
        setTimeout(() => {
          const $table = this.$refs.xTable
          this.submitLoading = false
          if (this.selectRow) {
            VXETable.modal.message({ content: '保存成功', status: 'success' })
            Object.assign(this.selectRow, this.formData)
          } else {
            VXETable.modal.message({ content: '新增成功', status: 'success' })
            $table.insert(this.formData, -1)
          }
        }, 500)
      },
      async removeEvent() {
        const $table = this.$refs.xTable
        const selectRecords = $table.getCheckboxRecords()
        if (selectRecords.length) {
          const type = await VXETable.modal.confirm('您确定要删除选中的数据吗?')
          if (type === 'confirm') {
            $table.removeCheckboxRow()
          }
        } else {
          VXETable.modal.message({
            content: '请至少选择一条数据',
            status: 'error',
          })
        }
      },
      async revertEvent() {
        const type = await VXETable.modal.confirm('您确定要还原数据吗?')
        const $table = this.$refs.xTable
        if (type === 'confirm') {
          $table.revertData()
        }
      },
      saveEvent() {
        const $table = this.$refs.xTable
        const { insertRecords, removeRecords, updateRecords } =
          $table.getRecordset()
        console.log(insertRecords)
        console.log(removeRecords)
        console.log(updateRecords)
        if (insertRecords.length > 0) this.tableData.push(...insertRecords)
        let _ids = []
        if (removeRecords.length > 0) {
          removeRecords.forEach((item) => {
            _ids.push(item)
            this.tableData.map((Item, index) => {
              console.log(Item._X_ROW_KEY)
              console.log(item._X_ROW_KEY)
              if (Item._X_ROW_KEY === item._X_ROW_KEY)
                this.tableData.splice(index, 1)
            })
          })
        }
        if (updateRecords.length > 0) {
          updateRecords.forEach((item) => {
            _ids.push(item)
            this.tableData.map((Item, index) => {
              console.log(Item._X_ROW_KEY)
              console.log(item._X_ROW_KEY)
              if (Item._X_ROW_KEY === item._X_ROW_KEY)
                this.tableData.splice(index, 1, item)
            })
          })
        }

        console.log('this.tableData')
        console.log(_ids)
        console.log(this.tableData)

        VXETable.modal.message({
          content: `保存成功，插入数据${insertRecords.length} 条，删除${removeRecords.length} 条，更新${updateRecords.length}条`,
          status: 'success',
        })
      },
      saveRowEvent() {
        const $table = this.$refs.xTable
        $table.clearActived().then(() => {
          this.loading = true
          setTimeout(() => {
            this.loading = false
            VXETable.modal.message({ content: '保存成功！', status: 'success' })
          }, 300)
        })
      },
      cancelRowEvent(row) {
        const $table = this.$refs.xTable
        $table.clearActived().then(() => {
          // 还原行数据
          $table.revertData(row)
        })
      },
    },
  }
</script>
