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
      :data="tableData"
      :edit-config="{ trigger: 'click', mode: 'cell' }"
      @cell-dblclick="cellDBLClickEvent"
    >
      <vxe-column type="checkbox" width="50"></vxe-column>
      <vxe-column type="seq" width="60"></vxe-column>
      <vxe-column
        field="ZG_BiaoTi"
        :title="item1"
        width="100"
        :sort-by="sortNameMethod2"
        sortable
      ></vxe-column>
      <vxe-column field="ZG_YaoQiu" :title="item2" show-overflow>
        <template #edit="{ row }">
          <vxe-input v-model="row.ZG_YaoQiu" type="text"></vxe-input>
        </template>
      </vxe-column>
      <vxe-column field="ZG_LuoShi" :title="item3" show-overflow></vxe-column>
      <vxe-column field="ZG_BeiZhu" :title="item4" show-overflow></vxe-column>
      <vxe-column title="操作" width="100" show-overflow>
        <template #default="{ row }">
          <vxe-button
            type="text"
            icon="vxe-icon-edit"
            @click="editEvent(row)"
          ></vxe-button>
          <vxe-button
            type="text"
            icon="vxe-icon-delete"
            @click="removeEventRow(row)"
          ></vxe-button>
        </template>
      </vxe-column>
    </vxe-table>

    <vxe-modal
      v-model="showEdit_4"
      :title="selectRow ? '编辑&保存' : '新增&保存'"
      width="800"
      min-width="600"
      min-height="300"
      :loading="submitLoading"
      resize
      destroy-on-close
    >
      <template #default>
        <vxe-form
          :data="formData"
          :rules="formRules"
          title-align="right"
          title-width="90"
          @submit="submitEvent"
        >
          <vxe-form-item
            field="ZG_BiaoTi"
            :title="item1"
            :span="24"
            :item-render="{}"
          >
            <template #default="{ data }">
              <vxe-input
                v-model="data.ZG_BiaoTi"
                placeholder="请输入名称"
              ></vxe-input>
            </template>
          </vxe-form-item>
          <vxe-form-item
            field="ZG_YaoQiu"
            :title="item2"
            :span="24"
            :item-render="{}"
          >
            <template #default="{ data }">
              <vxe-textarea
                v-model="data.ZG_YaoQiu"
                placeholder="请输入整改要求"
                row="2"
              ></vxe-textarea>
            </template>
          </vxe-form-item>
          <vxe-form-item
            field="ZG_LuoShi"
            :title="item3"
            :span="24"
            :item-render="{}"
          >
            <template #default="{ data }">
              <vxe-textarea
                v-model="data.ZG_LuoShi"
                placeholder="请输入落实情况"
                row="2"
              ></vxe-textarea>
            </template>
          </vxe-form-item>
          <vxe-form-item
            field="ZG_BeiZhu"
            :title="item4"
            :span="24"
            :item-render="{}"
          >
            <template #default="{ data }">
              <vxe-textarea
                v-model="data.ZG_BeiZhu"
                placeholder="请输入备注"
                row="2"
              ></vxe-textarea>
            </template>
          </vxe-form-item>
          <vxe-form-item align="center" title-align="left" :span="24">
            <template #default>
              <vxe-button type="submit">提交</vxe-button>
              <vxe-button type="reset">重置</vxe-button>
            </template>
          </vxe-form-item>
        </vxe-form>
      </template>
    </vxe-modal>
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
      typeData: {
        type: String,
        default: 'buhege',
      },
    },
    data() {
      return {
        /// vex-table
        item1: this.typeData == 'buhege' ? '不合格项' : '条款编号1',
        item2: this.typeData == 'buhege' ? '不合格类型' : '整改要求',
        item3: this.typeData == 'buhege' ? '不合格事实' : '落实情况',
        item4: this.typeData == 'buhege' ? '整改要求' : '备注',
        loading: false,
        submitLoading: false,
        tableData: this.proptableData,
        selectRow: null,
        /// vex-table
        showEdit_4: false,
        formData: {
          ZG_BiaoTi: null,
          ZG_YaoQiu: null,
          ZG_LuoShi: null,
          ZG_BeiZhu: null,
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
    methods: {
      /// vex-table所用方法
      popData() {
        return this.tableData
      },
      sortNameMethod2({ row }) {
        // 按名称长度进行排序
        return row.ZG_BiaoTi.slice(0, row.ZG_BiaoTi.indexOf('.'))
      },
      visibleMethod({ data }) {
        return data.flag1 === 'Y'
      },
      cellDBLClickEvent({ row }) {
        this.editEvent(row)
      },
      insertEvent(row) {
        this.formData = {
          ZG_BiaoTi: '',
          ZG_YaoQiu: '',
          ZG_LuoShi: '',
          ZG_BeiZhu: '',
        }
        this.selectRow = null
        this.showEdit_4 = true
      },
      editEvent(row) {
        this.formData = {
          ZG_BiaoTi: row.ZG_BiaoTi,
          ZG_YaoQiu: row.ZG_YaoQiu,
          ZG_LuoShi: row.ZG_LuoShi,
          ZG_BeiZhu: row.ZG_BeiZhu,
        }
        this.selectRow = row
        this.showEdit_4 = true
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
          this.showEdit_4 = false
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
    },
  }
</script>
